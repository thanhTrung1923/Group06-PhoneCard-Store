package dao.admin;

import dao.DBConnect;
import dtos.OrderDetailDTO;
import dtos.OrderItemDTO;
import dtos.OrderListDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private Connection getConnection() throws SQLException {
        Connection con = DBConnect.getConnection();
        if (con == null) throw new SQLException("Cannot get DB connection. Please check DBConnect settings.");
        return con;
    }

    // ===== LIST =====
    public List<OrderListDTO> searchOrders(String status, String keyword,
                                           Date fromDate, Date toDate,
                                           int offset, int limit) throws SQLException {

        List<OrderListDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.order_id, u.full_name AS customer_full_name, u.email AS customer_email, u.phone AS customer_phone, ");
        sql.append("       o.total_amount, o.status, o.created_at, ");
        sql.append("       COUNT(oi.item_id) AS item_count ");
        sql.append("FROM orders o ");
        sql.append("JOIN users u ON u.user_id = o.user_id ");
        sql.append("LEFT JOIN order_items oi ON oi.order_id = o.order_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank()) {
            sql.append(" AND o.status = ? ");
            params.add(status);
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (CAST(o.order_id AS CHAR) LIKE ? ");
            sql.append("      OR u.email LIKE ? ");
            sql.append("      OR u.phone LIKE ? ");
            sql.append("      OR u.full_name LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k); params.add(k); params.add(k);
        }

        if (fromDate != null) {
            sql.append(" AND DATE(o.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND DATE(o.created_at) <= ? ");
            params.add(toDate);
        }

        sql.append("GROUP BY o.order_id, u.full_name, u.email, u.phone, o.total_amount, o.status, o.created_at ");
        sql.append("ORDER BY o.created_at DESC ");
        sql.append("LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderListDTO dto = new OrderListDTO();
                    dto.setOrderId(rs.getLong("order_id"));
                    dto.setCustomerFullName(rs.getString("customer_full_name"));
                    dto.setCustomerEmail(rs.getString("customer_email"));
                    dto.setCustomerPhone(rs.getString("customer_phone"));
                    dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                    dto.setStatus(rs.getString("status"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    dto.setItemCount(rs.getInt("item_count"));
                    list.add(dto);
                }
            }
        }

        return list;
    }

    public int countOrders(String status, String keyword, Date fromDate, Date toDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT o.order_id) AS total ");
        sql.append("FROM orders o ");
        sql.append("JOIN users u ON u.user_id = o.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank()) {
            sql.append(" AND o.status = ? ");
            params.add(status);
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (CAST(o.order_id AS CHAR) LIKE ? ");
            sql.append("      OR u.email LIKE ? ");
            sql.append("      OR u.phone LIKE ? ");
            sql.append("      OR u.full_name LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k); params.add(k); params.add(k);
        }

        if (fromDate != null) {
            sql.append(" AND DATE(o.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND DATE(o.created_at) <= ? ");
            params.add(toDate);
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        }
        return 0;
    }

    // ===== DETAIL =====
    public OrderDetailDTO getOrderDetail(long orderId) throws SQLException {
        String sql = """
            SELECT o.order_id, o.user_id, o.status, o.total_amount, o.created_at, o.paid_at, o.cancelled_at,
                   u.full_name AS customer_full_name, u.email AS customer_email, u.phone AS customer_phone
            FROM orders o
            JOIN users u ON u.user_id = o.user_id
            WHERE o.order_id = ?
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                OrderDetailDTO dto = new OrderDetailDTO();
                dto.setOrderId(rs.getLong("order_id"));
                dto.setUserId(rs.getInt("user_id"));
                dto.setStatus(rs.getString("status"));
                dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setPaidAt(rs.getTimestamp("paid_at"));
                dto.setCancelledAt(rs.getTimestamp("cancelled_at"));
                dto.setCustomerFullName(rs.getString("customer_full_name"));
                dto.setCustomerEmail(rs.getString("customer_email"));
                dto.setCustomerPhone(rs.getString("customer_phone"));
                return dto;
            }
        }
    }

    // ===== ITEMS =====
    public List<OrderItemDTO> getOrderItems(long orderId) throws SQLException {
        List<OrderItemDTO> items = new ArrayList<>();

        String sql = """
            SELECT oi.item_id, oi.product_id, oi.quantity,
                   oi.unit_price, oi.final_price, oi.profit,
                   oi.assigned_card_id,
                   p.type_name, p.value AS product_value,
                   c.serial AS assigned_serial
            FROM order_items oi
            JOIN card_products p ON p.product_id = oi.product_id
            LEFT JOIN cards c ON c.card_id = oi.assigned_card_id
            WHERE oi.order_id = ?
            ORDER BY oi.item_id ASC
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItemDTO it = new OrderItemDTO();
                    it.setItemId(rs.getLong("item_id"));
                    it.setProductId(rs.getInt("product_id"));
                    it.setQuantity(rs.getInt("quantity"));
                    it.setUnitPrice(rs.getBigDecimal("unit_price"));
                    it.setFinalPrice(rs.getBigDecimal("final_price"));
                    it.setProfit(rs.getBigDecimal("profit"));

                    long v = rs.getLong("product_value");
                    it.setProductValue(v);
                    it.setProductName(rs.getString("type_name") + " " + v);

                    long cardId = rs.getLong("assigned_card_id");
                    it.setAssignedCardId(rs.wasNull() ? null : cardId);

                    it.setAssignedSerial(rs.getString("assigned_serial"));

                    items.add(it);
                }
            }
        }
        return items;
    }

    // ===== UPDATE STATUS =====
    public boolean updateOrderStatus(long orderId, String newStatus) throws SQLException {
        String sql;
        if ("CANCELLED".equalsIgnoreCase(newStatus)) {
            sql = "UPDATE orders SET status=?, cancelled_at=NOW() WHERE order_id=?";
        } else if ("PAID".equalsIgnoreCase(newStatus)) {
            sql = "UPDATE orders SET status=?, paid_at=COALESCE(paid_at, NOW()) WHERE order_id=?";
        } else if ("REFUNDED".equalsIgnoreCase(newStatus)) {
            sql = "UPDATE orders SET status=? WHERE order_id=?";
        } else {
            sql = "UPDATE orders SET status=? WHERE order_id=?";
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<OrderListDTO> searchOrders(String status, String keyword,
                                       Date fromDate, Date toDate,
                                       String sort, String dir,
                                       int offset, int limit) throws SQLException {

    List<OrderListDTO> list = new ArrayList<>();

    // ✅ Whitelist cột sort để tránh SQL injection
    String orderCol;
    if (sort == null) sort = "created";

    switch (sort) {
        case "orderId" -> orderCol = "o.order_id";
        case "customer" -> orderCol = "u.full_name";
        case "email" -> orderCol = "u.email";
        case "phone" -> orderCol = "u.phone";
        case "total" -> orderCol = "o.total_amount";
        case "status" -> orderCol = "o.status";
        case "items" -> orderCol = "item_count";
        case "created" -> orderCol = "o.created_at";
        default -> orderCol = "o.created_at";
    }

    String orderDir = "asc".equalsIgnoreCase(dir) ? "ASC" : "DESC";

    StringBuilder sql = new StringBuilder();
    sql.append("SELECT o.order_id, u.full_name AS customer_full_name, u.email AS customer_email, u.phone AS customer_phone, ");
    sql.append("       o.total_amount, o.status, o.created_at, ");
    sql.append("       COUNT(oi.item_id) AS item_count ");
    sql.append("FROM orders o ");
    sql.append("JOIN users u ON u.user_id = o.user_id ");
    sql.append("LEFT JOIN order_items oi ON oi.order_id = o.order_id ");
    sql.append("WHERE 1=1 ");

    List<Object> params = new ArrayList<>();

    if (status != null && !status.isBlank()) {
        sql.append(" AND o.status = ? ");
        params.add(status);
    }

    if (keyword != null && !keyword.isBlank()) {
        sql.append(" AND (CAST(o.order_id AS CHAR) LIKE ? ");
        sql.append("      OR u.email LIKE ? ");
        sql.append("      OR u.phone LIKE ? ");
        sql.append("      OR u.full_name LIKE ?) ");
        String k = "%" + keyword.trim() + "%";
        params.add(k); params.add(k); params.add(k); params.add(k);
    }

    if (fromDate != null) {
        sql.append(" AND DATE(o.created_at) >= ? ");
        params.add(fromDate);
    }
    if (toDate != null) {
        sql.append(" AND DATE(o.created_at) <= ? ");
        params.add(toDate);
    }

    sql.append("GROUP BY o.order_id, u.full_name, u.email, u.phone, o.total_amount, o.status, o.created_at ");

    // ✅ ORDER BY theo cột chọn + tie-breaker
    sql.append("ORDER BY ").append(orderCol).append(" ").append(orderDir).append(", o.order_id DESC ");

    sql.append("LIMIT ? OFFSET ? ");
    params.add(limit);
    params.add(offset);

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OrderListDTO dto = new OrderListDTO();
                dto.setOrderId(rs.getLong("order_id"));
                dto.setCustomerFullName(rs.getString("customer_full_name"));
                dto.setCustomerEmail(rs.getString("customer_email"));
                dto.setCustomerPhone(rs.getString("customer_phone"));
                dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                dto.setStatus(rs.getString("status"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setItemCount(rs.getInt("item_count"));
                list.add(dto);
            }
        }
    }

    return list;
}

}
