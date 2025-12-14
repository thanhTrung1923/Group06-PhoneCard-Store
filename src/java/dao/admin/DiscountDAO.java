package dao.admin;

import dao.DBConnect;
import dtos.DiscountListDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountDAO {

    private Connection getConnection() throws SQLException {
        Connection con = DBConnect.getConnection();
        if (con == null) throw new SQLException("Cannot get DB connection (DBConnect returned null).");
        return con;
    }

    public List<DiscountListDTO> searchPromotions(String keyword,
                                                   String timeStatus,  // UPCOMING/RUNNING/EXPIRED/ALL
                                                   String isActive,    // 1/0/ALL
                                                   int offset, int limit) throws SQLException {

        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT p.promotion_id, p.promotion_name, p.start_at, p.end_at, p.is_active,
                   u.full_name AS created_by_name, u.email AS created_by_email,
                   COUNT(pd.detail_id) AS product_count
            FROM promotions p
            LEFT JOIN users u ON u.user_id = p.created_by
            LEFT JOIN promotion_details pd ON pd.promotion_id = p.promotion_id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (p.promotion_name LIKE ? OR CAST(p.promotion_id AS CHAR) LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
        }

        if (isActive != null && !isActive.isBlank() && !"ALL".equalsIgnoreCase(isActive)) {
            sql.append(" AND p.is_active = ? ");
            params.add(Integer.parseInt(isActive));
        }

        if (timeStatus != null && !timeStatus.isBlank() && !"ALL".equalsIgnoreCase(timeStatus)) {
            // dựa theo NOW() so với start_at/end_at
            switch (timeStatus.toUpperCase()) {
                case "UPCOMING" -> sql.append(" AND NOW() < p.start_at ");
                case "RUNNING"  -> sql.append(" AND NOW() BETWEEN p.start_at AND p.end_at ");
                case "EXPIRED"  -> sql.append(" AND NOW() > p.end_at ");
            }
        }

        sql.append("""
            GROUP BY p.promotion_id, p.promotion_name, p.start_at, p.end_at, p.is_active, created_by_name, created_by_email
            ORDER BY p.created_at DESC, p.promotion_id DESC
            LIMIT ? OFFSET ?
        """);
        params.add(limit);
        params.add(offset);

        List<DiscountListDTO> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DiscountListDTO dto = new DiscountListDTO();
                    dto.setPromotionId(rs.getInt("promotion_id"));
                    dto.setPromotionName(rs.getString("promotion_name"));
                    dto.setStartAt(rs.getTimestamp("start_at"));
                    dto.setEndAt(rs.getTimestamp("end_at"));
                    dto.setActiveFlag(rs.getInt("is_active") == 1);
                    dto.setCreatedByName(rs.getString("created_by_name"));
                    dto.setCreatedByEmail(rs.getString("created_by_email"));
                    dto.setProductCount(rs.getInt("product_count"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    public int countPromotions(String keyword, String timeStatus, String isActive) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT COUNT(DISTINCT p.promotion_id) AS total
            FROM promotions p
            LEFT JOIN promotion_details pd ON pd.promotion_id = p.promotion_id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (p.promotion_name LIKE ? OR CAST(p.promotion_id AS CHAR) LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
        }

        if (isActive != null && !isActive.isBlank() && !"ALL".equalsIgnoreCase(isActive)) {
            sql.append(" AND p.is_active = ? ");
            params.add(Integer.parseInt(isActive));
        }

        if (timeStatus != null && !timeStatus.isBlank() && !"ALL".equalsIgnoreCase(timeStatus)) {
            switch (timeStatus.toUpperCase()) {
                case "UPCOMING" -> sql.append(" AND NOW() < p.start_at ");
                case "RUNNING"  -> sql.append(" AND NOW() BETWEEN p.start_at AND p.end_at ");
                case "EXPIRED"  -> sql.append(" AND NOW() > p.end_at ");
            }
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        }
        return 0;
    }
}
