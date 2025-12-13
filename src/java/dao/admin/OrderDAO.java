/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.admin;

import dtos.OrderListDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dao.DBConnect;


public class OrderDAO {

    // TODO: đổi theo dự án của bạn (DBContext/DBConnection/DBUtil...)
    private Connection getConnection() throws SQLException {
    Connection con = DBConnect.getConnection();
    if (con == null) {
        throw new SQLException("Cannot get DB connection. Please check DBConnect settings.");
    }
    return con;
}


    public List<OrderListDTO> searchOrders(String status, String keyword,
                                           Date fromDate, Date toDate,
                                           int offset, int limit) throws SQLException {

        List<OrderListDTO> list = new ArrayList<>();

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
            params.add(status);
        }

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (CAST(o.order_id AS CHAR) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_email, u.email) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_phone, u.phone) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_full_name, u.full_name) LIKE ?) ");
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

        sql.append("GROUP BY o.order_id, customer_full_name, customer_email, customer_phone, o.total_amount, o.status, o.created_at ");
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
        sql.append("SELECT COUNT(*) AS total ");
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
            sql.append("      OR COALESCE(o.customer_email, u.email) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_phone, u.phone) LIKE ? ");
            sql.append("      OR COALESCE(o.customer_full_name, u.full_name) LIKE ?) ");
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
}
