package dao.admin;

import dao.DBConnect;
import dtos.ProductOptionDTO;
import dtos.PromotionDTO;
import dtos.PromotionDetailDTO;
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
            case "time" -> "time_status_sort";
            case "active" -> "p.is_active";
            case "discount" -> "max_discount_percent";
            case "createdBy" -> "created_by_name";
            default -> "p.promotion_id";
        };
    }

    private String resolveDir(String dir) {
        if (dir == null) return "DESC";
        return "asc".equalsIgnoreCase(dir) ? "ASC" : "DESC";
    }

    // ========================= LIST =========================
    public List<PromotionListDTO> searchPromotions(
            String keyword,
            String timeStatus,
            String activeFlag,
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

    // ========================= DETAIL =========================
    public PromotionDTO getPromotion(int id) throws SQLException {
        String sql = """
            SELECT
              p.promotion_id,
              p.promotion_name,
              p.start_at,
              p.end_at,
              p.is_active,
              COALESCE(u.full_name, 'Unknown') AS created_by_name,
              COALESCE(u.email, '') AS created_by_email,
              CASE
                WHEN NOW() < p.start_at THEN 'UPCOMING'
                WHEN NOW() BETWEEN p.start_at AND p.end_at THEN 'ONGOING'
                ELSE 'EXPIRED'
              END AS time_status
            FROM promotions p
            LEFT JOIN users u ON u.user_id = p.created_by
            WHERE p.promotion_id = ?
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                PromotionDTO dto = new PromotionDTO();
                dto.setPromotionId(rs.getInt("promotion_id"));
                dto.setPromotionName(rs.getString("promotion_name"));
                dto.setStartAt(rs.getTimestamp("start_at"));
                dto.setEndAt(rs.getTimestamp("end_at"));
                dto.setActive(rs.getInt("is_active") == 1);
                dto.setCreatedByName(rs.getString("created_by_name"));
                dto.setCreatedByEmail(rs.getString("created_by_email"));
                dto.setTimeStatus(rs.getString("time_status"));
                return dto;
            }
        }
    }

    public List<PromotionDetailDTO> getPromotionDetails(int promotionId) throws SQLException {
        List<PromotionDetailDTO> list = new ArrayList<>();

        String sql = """
            SELECT
              pd.promotion_id,
              pd.product_id,
              pd.discount_percent,
              cp.type_name,
              cp.value
            FROM promotion_details pd
            JOIN card_products cp ON cp.product_id = pd.product_id
            WHERE pd.promotion_id = ?
            ORDER BY pd.product_id ASC
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, promotionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PromotionDetailDTO d = new PromotionDetailDTO();
                    d.setPromotionId(rs.getInt("promotion_id"));
                    d.setProductId(rs.getInt("product_id"));
                    d.setDiscountPercent(rs.getBigDecimal("discount_percent"));

                    String name = rs.getString("type_name") + " " + rs.getLong("value");
                    d.setProductName(name);

                    list.add(d);
                }
            }
        }
        return list;
    }

    public List<ProductOptionDTO> getProductOptions() throws SQLException {
        List<ProductOptionDTO> list = new ArrayList<>();
        String sql = """
            SELECT product_id, type_name, value
            FROM card_products
            ORDER BY type_name ASC, value ASC
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProductOptionDTO o = new ProductOptionDTO();
                o.setProductId(rs.getInt("product_id"));
                o.setLabel(rs.getString("type_name") + " " + rs.getLong("value"));
                list.add(o);
            }
        }
        return list;
    }

    // ========================= CRUD =========================
    public boolean updatePromotion(int id, String name, Timestamp startAt, Timestamp endAt, boolean active) throws SQLException {
        String sql = """
            UPDATE promotions
            SET promotion_name = ?,
                start_at = ?,
                end_at = ?,
                is_active = ?
            WHERE promotion_id = ?
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setTimestamp(2, startAt);
            ps.setTimestamp(3, endAt);
            ps.setInt(4, active ? 1 : 0);
            ps.setInt(5, id);

            return ps.executeUpdate() > 0;
        }
    }

    // Insert nếu chưa có, nếu có rồi thì update percent
    public boolean upsertPromotionDetail(int promotionId, int productId, double percent) throws SQLException {
        String sql = """
            INSERT INTO promotion_details(promotion_id, product_id, discount_percent)
            VALUES(?,?,?)
            ON DUPLICATE KEY UPDATE discount_percent = VALUES(discount_percent)
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, promotionId);
            ps.setInt(2, productId);
            ps.setDouble(3, percent);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletePromotionDetail(int promotionId, int productId) throws SQLException {
        String sql = "DELETE FROM promotion_details WHERE promotion_id = ? AND product_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, promotionId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletePromotion(int promotionId) throws SQLException {
        String delDetails = "DELETE FROM promotion_details WHERE promotion_id = ?";
        String delPromo = "DELETE FROM promotions WHERE promotion_id = ?";

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(delDetails);
                 PreparedStatement ps2 = con.prepareStatement(delPromo)) {

                ps1.setInt(1, promotionId);
                ps1.executeUpdate();

                ps2.setInt(1, promotionId);
                int affected = ps2.executeUpdate();

                con.commit();
                return affected > 0;
            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}
