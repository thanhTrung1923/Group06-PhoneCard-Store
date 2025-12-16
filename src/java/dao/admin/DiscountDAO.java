package dao.admin;

import dao.DBConnect;
import dtos.PromotionListDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountDAO {

    private Connection getConnection() throws SQLException {
        Connection con = DBConnect.getConnection();
        if (con == null) throw new SQLException("Cannot get DB connection. Check DBConnect settings.");
        return con;
    }

    // Allow-list sort keys -> SQL order by
    private String resolveSortColumn(String sortKey) {
        if (sortKey == null) return "p.promotion_id";
        return switch (sortKey) {
            case "id" -> "p.promotion_id";
            case "name" -> "p.promotion_name";
            case "start" -> "p.start_at";
            case "end" -> "p.end_at";
            case "time" -> "time_status_sort";     // alias in SELECT
            case "active" -> "p.is_active";
            case "products" -> "product_count";     // alias
            case "createdBy" -> "created_by_name";  // alias
            case "discount" -> "max_discount_percent"; // alias
            default -> "p.promotion_id";
        };
    }

    private String resolveDir(String dir) {
        if (dir == null) return "DESC";
        return "asc".equalsIgnoreCase(dir) ? "ASC" : "DESC";
    }

    public List<PromotionListDTO> searchPromotions(
            String keyword,
            String timeStatus,   // UPCOMING/ONGOING/EXPIRED or null
            String activeFlag,   // "1"/"0" or null
            String sort, String dir,
            int offset, int limit
    ) throws SQLException {

        List<PromotionListDTO> list = new ArrayList<>();

        String orderBy = resolveSortColumn(sort) + " " + resolveDir(dir);

        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT
              p.promotion_id,
              p.promotion_name,
              p.start_at,
              p.end_at,
              p.is_active,
              COALESCE(u.full_name, 'Unknown') AS created_by_name,
              COALESCE(u.email, '') AS created_by_email,
              COUNT(DISTINCT pd.product_id) AS product_count,
              MIN(pd.discount_percent) AS min_discount_percent,
              MAX(pd.discount_percent) AS max_discount_percent,
              CASE
                WHEN NOW() < p.start_at THEN 'UPCOMING'
                WHEN NOW() BETWEEN p.start_at AND p.end_at THEN 'ONGOING'
                ELSE 'EXPIRED'
              END AS time_status,
              CASE
                WHEN NOW() < p.start_at THEN 1
                WHEN NOW() BETWEEN p.start_at AND p.end_at THEN 2
                ELSE 3
              END AS time_status_sort
            FROM promotions p
            LEFT JOIN promotion_details pd ON pd.promotion_id = p.promotion_id
            LEFT JOIN users u ON u.user_id = p.created_by
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (p.promotion_name LIKE ? OR CAST(p.promotion_id AS CHAR) LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
        }

        if (activeFlag != null && !activeFlag.isBlank()) {
            // expected "1" or "0"
            sql.append(" AND p.is_active = ? ");
            params.add(Integer.parseInt(activeFlag));
        }

        if (timeStatus != null && !timeStatus.isBlank()) {
            // filter by computed time_status
            sql.append("""
                AND (
                  CASE
                    WHEN NOW() < p.start_at THEN 'UPCOMING'
                    WHEN NOW() BETWEEN p.start_at AND p.end_at THEN 'ONGOING'
                    ELSE 'EXPIRED'
                  END
                ) = ?
            """);
            params.add(timeStatus.trim().toUpperCase());
        }

        sql.append("""
            GROUP BY
              p.promotion_id, p.promotion_name, p.start_at, p.end_at, p.is_active,
              created_by_name, created_by_email, time_status, time_status_sort
        """);

        sql.append(" ORDER BY ").append(orderBy).append(" ");
        sql.append(" LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PromotionListDTO dto = new PromotionListDTO();
                    dto.setPromotionId(rs.getInt("promotion_id"));
                    dto.setPromotionName(rs.getString("promotion_name"));
                    dto.setStartAt(rs.getTimestamp("start_at"));
                    dto.setEndAt(rs.getTimestamp("end_at"));
                    dto.setActive(rs.getInt("is_active") == 1);

                    dto.setCreatedByName(rs.getString("created_by_name"));
                    dto.setCreatedByEmail(rs.getString("created_by_email"));

                    dto.setProductCount(rs.getInt("product_count"));
                    dto.setMinDiscountPercent(rs.getBigDecimal("min_discount_percent"));
                    dto.setMaxDiscountPercent(rs.getBigDecimal("max_discount_percent"));

                    dto.setTimeStatus(rs.getString("time_status"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    public int countPromotions(String keyword, String timeStatus, String activeFlag) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT COUNT(*) AS total
            FROM promotions p
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (p.promotion_name LIKE ? OR CAST(p.promotion_id AS CHAR) LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
        }

        if (activeFlag != null && !activeFlag.isBlank()) {
            sql.append(" AND p.is_active = ? ");
            params.add(Integer.parseInt(activeFlag));
        }

        if (timeStatus != null && !timeStatus.isBlank()) {
            sql.append("""
                AND (
                  CASE
                    WHEN NOW() < p.start_at THEN 'UPCOMING'
                    WHEN NOW() BETWEEN p.start_at AND p.end_at THEN 'ONGOING'
                    ELSE 'EXPIRED'
                  END
                ) = ?
            """);
            params.add(timeStatus.trim().toUpperCase());
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
