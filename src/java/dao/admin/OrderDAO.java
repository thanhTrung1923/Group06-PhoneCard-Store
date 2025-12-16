package dao.admin;

import dao.DBConnect;
import dtos.OrderDetailDTO;
import dtos.OrderItemDTO;
import dtos.OrderListDTO;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private Connection getConnection() throws SQLException {
        Connection con = DBConnect.getConnection();
        if (con == null) {
            throw new SQLException("Cannot get DB connection. Please check DBConnect settings.");
        }
        return con;
    }

    // ==============================
    // 1) LIST + FILTER + SORT + PAGE
    // ==============================
    public List<OrderListDTO> searchOrders(
            String status,
            String keyword,
            Date fromDate,
            Date toDate,
            String sort,
            String dir,
            int offset,
            int limit
    ) throws SQLException {

        List<OrderListDTO> list = new ArrayList<>();

        String orderBy = buildOrderBy(sort, dir);

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.order_id, ");
        sql.append("       COALESCE(o.customer_full_name, u.full_name) AS customer_full_name, ");
        sql.append("       COALESCE(o.customer_email, u.email) AS customer_email, ");
        sql.append("       COALESCE(o.customer_phone, u.phone) AS customer_phone, ");
        sql.append("       o.total_amount, o.status, o.created_at, ");
        sql.append("       COUNT(oi.item_id) AS item_count ");
        sql.append("FROM orders o ");
        sql.append("JOIN users u ON u.user_id = o.user_id ");
        sql.append("LEFT JOIN order_items oi ON oi.order_id = o.order_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank()) {
            sql.append(" AND o.status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (CAST(o.order_id AS CHAR) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_email, u.email) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_phone, u.phone) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_full_name, u.full_name) LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
        }

        if (fromDate != null) {
            sql.append(" AND DATE(o.created_at) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND DATE(o.created_at) <= ? ");
            params.add(toDate);
        }

        sql.append("GROUP BY o.order_id, customer_full_name, customer_email, customer_phone, o.total_amount, o.status, o.created_at ");
        sql.append(orderBy);
        sql.append(" LIMIT ? OFFSET ? ");

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

    // ==============================
    // 2) COUNT (for pagination)
    // ==============================
    public int countOrders(String status, String keyword, Date fromDate, Date toDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) AS total ");
        sql.append("FROM orders o ");
        sql.append("JOIN users u ON u.user_id = o.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank()) {
            sql.append(" AND o.status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (CAST(o.order_id AS CHAR) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_email, u.email) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_phone, u.phone) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_full_name, u.full_name) LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
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

    // ==============================
    // 3) DETAIL
    // ==============================
   public OrderDetailDTO getOrderDetail(long orderId) throws SQLException {

    String sql = """
        SELECT o.order_id, o.user_id, o.status, o.total_amount, o.created_at, o.paid_at, o.cancelled_at,
               COALESCE(o.customer_full_name, u.full_name) AS customer_full_name,
               COALESCE(o.customer_email, u.email)         AS customer_email,
               COALESCE(o.customer_phone, u.phone)         AS customer_phone
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


    // ==============================
    // 4) ITEMS in ORDER
    // ==============================
    public List<OrderItemDTO> getOrderItems(long orderId) throws SQLException {
        List<OrderItemDTO> items = new ArrayList<>();

        String sql = """
            SELECT oi.item_id, oi.product_id, oi.quantity,
                   oi.unit_price, oi.final_price, oi.buy_price_at_sale, oi.profit,
                   oi.assigned_card_id,
                   COALESCE(oi.product_type_name, p.type_name) AS type_name,
                   COALESCE(oi.product_value, p.value) AS product_value,
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
                    it.setBuyPriceAtSale(rs.getBigDecimal("buy_price_at_sale"));
                    it.setProfit(rs.getBigDecimal("profit"));

                    long v = rs.getLong("product_value");
                    it.setProductValue(v);

                    String typeName = rs.getString("type_name");
                    it.setProductName(typeName + " " + v);

                    long cardId = rs.getLong("assigned_card_id");
                    it.setAssignedCardId(rs.wasNull() ? null : cardId);

                    it.setAssignedSerial(rs.getString("assigned_serial"));

                    items.add(it);
                }
            }
        }

        return items;
    }

    // ==============================
    // 5) UPDATE STATUS (Admin update)
    // ==============================
    public boolean updateOrderStatus(long orderId, String newStatus) throws SQLException {

        if (newStatus == null) return false;
        newStatus = newStatus.trim().toUpperCase();

        // Only allow these values
        if (!("PAID".equals(newStatus) || "CANCELLED".equals(newStatus) || "REFUNDED".equals(newStatus))) {
            return false;
        }

        String selectSql = "SELECT status FROM orders WHERE order_id = ?";

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            String currentStatus = null;

            // Get current status
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setLong(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) currentStatus = rs.getString("status");
                }
            }

            if (currentStatus == null) {
                con.rollback();
                return false; // not found
            }

            // Business rule (safe):
            // If already CANCELLED or REFUNDED => final, cannot change
            if ("CANCELLED".equalsIgnoreCase(currentStatus) || "REFUNDED".equalsIgnoreCase(currentStatus)) {
                con.rollback();
                return false;
            }

            // Build update SQL
            String updateSql;
            if ("CANCELLED".equals(newStatus)) {
                updateSql = "UPDATE orders SET status=?, cancelled_at=NOW() WHERE order_id=?";
            } else if ("PAID".equals(newStatus)) {
                updateSql = "UPDATE orders SET status=?, paid_at=COALESCE(paid_at, NOW()) WHERE order_id=?";
            } else { // REFUNDED
                updateSql = "UPDATE orders SET status=? WHERE order_id=?";
            }

            int updated;
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, newStatus);
                ps.setLong(2, orderId);
                updated = ps.executeUpdate();
            }

            con.commit();
            return updated > 0;
        }
    }

    // ==============================
    // Helper: whitelist sort columns
    // ==============================
    private String buildOrderBy(String sort, String dir) {

        String d = "DESC";
        if (dir != null && dir.equalsIgnoreCase("asc")) d = "ASC";

        // Default: newest first, then highest id
        if (sort == null || sort.isBlank()) {
            return " ORDER BY o.created_at DESC, o.order_id DESC ";
        }

        String s = sort.trim();

        // Map UI sort key -> SQL column/expression (SAFE)
        return switch (s) {
            case "orderId", "order_id" -> " ORDER BY o.order_id " + d + " ";
            case "customer" -> " ORDER BY COALESCE(o.customer_full_name, u.full_name) " + d + ", o.order_id DESC ";
            case "email" -> " ORDER BY COALESCE(o.customer_email, u.email) " + d + ", o.order_id DESC ";
            case "phone" -> " ORDER BY COALESCE(o.customer_phone, u.phone) " + d + ", o.order_id DESC ";
            case "total" -> " ORDER BY o.total_amount " + d + ", o.order_id DESC ";
            case "status" -> " ORDER BY o.status " + d + ", o.order_id DESC ";
            case "items" -> " ORDER BY item_count " + d + ", o.order_id DESC ";
            case "created" -> " ORDER BY o.created_at " + d + ", o.order_id DESC ";
            default -> " ORDER BY o.created_at DESC, o.order_id DESC ";
        };
    }
}
