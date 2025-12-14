package dao.admin;

import dao.DBConnect;
import dtos.PromotionListDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dtos.ProductOptionDTO;
import dtos.PromotionFormDTO;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;


public class PromotionDAO {

    private Connection getConnection() throws SQLException {
        Connection con = DBConnect.getConnection();
        if (con == null) throw new SQLException("Cannot get DB connection (DBConnect returned null).");
        return con;
    }

    public List<PromotionListDTO> searchPromotions(String keyword,
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

        List<PromotionListDTO> list = new ArrayList<>();

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
    
    // List sản phẩm để chọn
    public List<ProductOptionDTO> listProducts() throws SQLException {
    String sql = """
        SELECT product_id, type_code, type_name, value, sell_price
        FROM card_products
        WHERE is_active = 1
        ORDER BY type_code, value
    """;

    List<ProductOptionDTO> list = new ArrayList<>();
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            ProductOptionDTO p = new ProductOptionDTO();
            p.setProductId(rs.getInt("product_id"));
            p.setTypeCode(rs.getString("type_code"));
            p.setTypeName(rs.getString("type_name"));
            p.setValue(rs.getLong("value"));
            p.setSellPrice(rs.getBigDecimal("sell_price"));
            list.add(p);
        }
    }
    return list;
}
//Lấy promotion theo id
    
    public PromotionFormDTO getPromotion(int id) throws SQLException {
    String sql = """
        SELECT promotion_id, promotion_name, description, start_at, end_at, is_active
        FROM promotions
        WHERE promotion_id = ?
    """;
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return null;
            PromotionFormDTO f = new PromotionFormDTO();
            f.setPromotionId(rs.getInt("promotion_id"));
            f.setPromotionName(rs.getString("promotion_name"));
            f.setDescription(rs.getString("description"));
            f.setStartAt(rs.getTimestamp("start_at"));
            f.setEndAt(rs.getTimestamp("end_at"));
            f.setActive(rs.getInt("is_active") == 1);
            return f;
        }
    }
}
// Lấy map discount theo product
    
    public Map<Integer, BigDecimal> getPromotionDiscountMap(int promotionId) throws SQLException {
    String sql = """
        SELECT product_id, discount_percent
        FROM promotion_details
        WHERE promotion_id = ?
    """;
    Map<Integer, BigDecimal> map = new HashMap<>();
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, promotionId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("product_id"), rs.getBigDecimal("discount_percent"));
            }
        }
    }
    return map;
}
// Insert promotion + details (transaction)
    
    public int insertPromotion(PromotionFormDTO form, int createdBy,
                           Map<Integer, BigDecimal> details) throws SQLException {

    String sqlPromo = """
        INSERT INTO promotions(promotion_name, description, start_at, end_at, is_active, created_by)
        VALUES(?,?,?,?,?,?)
    """;
    String sqlDetail = """
        INSERT INTO promotion_details(promotion_id, product_id, discount_percent)
        VALUES(?,?,?)
    """;

    try (Connection con = getConnection()) {
        con.setAutoCommit(false);

        try (PreparedStatement ps = con.prepareStatement(sqlPromo, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, form.getPromotionName());
            ps.setString(2, form.getDescription());
            ps.setTimestamp(3, form.getStartAt());
            ps.setTimestamp(4, form.getEndAt());
            ps.setInt(5, form.isActive() ? 1 : 0);
            ps.setInt(6, createdBy);
            ps.executeUpdate();

            int promoId;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                promoId = keys.getInt(1);
            }

            if (details != null && !details.isEmpty()) {
                try (PreparedStatement pd = con.prepareStatement(sqlDetail)) {
                    for (var e : details.entrySet()) {
                        pd.setInt(1, promoId);
                        pd.setInt(2, e.getKey());
                        pd.setBigDecimal(3, e.getValue());
                        pd.addBatch();
                    }
                    pd.executeBatch();
                }
            }

            con.commit();
            return promoId;
        } catch (Exception ex) {
            con.rollback();
            throw ex;
        } finally {
            con.setAutoCommit(true);
        }
    }
}
// Update promotion + replace details (transaction)
    
    public boolean updatePromotion(PromotionFormDTO form,
                               Map<Integer, BigDecimal> details) throws SQLException {

    String sqlPromo = """
        UPDATE promotions
        SET promotion_name=?, description=?, start_at=?, end_at=?, is_active=?
        WHERE promotion_id=?
    """;
    String delDetails = "DELETE FROM promotion_details WHERE promotion_id=?";
    String insDetail = """
        INSERT INTO promotion_details(promotion_id, product_id, discount_percent)
        VALUES(?,?,?)
    """;

    try (Connection con = getConnection()) {
        con.setAutoCommit(false);

        try {
            try (PreparedStatement ps = con.prepareStatement(sqlPromo)) {
                ps.setString(1, form.getPromotionName());
                ps.setString(2, form.getDescription());
                ps.setTimestamp(3, form.getStartAt());
                ps.setTimestamp(4, form.getEndAt());
                ps.setInt(5, form.isActive() ? 1 : 0);
                ps.setInt(6, form.getPromotionId());
                if (ps.executeUpdate() == 0) {
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps = con.prepareStatement(delDetails)) {
                ps.setInt(1, form.getPromotionId());
                ps.executeUpdate();
            }

            if (details != null && !details.isEmpty()) {
                try (PreparedStatement pd = con.prepareStatement(insDetail)) {
                    for (var e : details.entrySet()) {
                        pd.setInt(1, form.getPromotionId());
                        pd.setInt(2, e.getKey());
                        pd.setBigDecimal(3, e.getValue());
                        pd.addBatch();
                    }
                    pd.executeBatch();
                }
            }

            con.commit();
            return true;
        } catch (Exception ex) {
            con.rollback();
            throw ex;
        } finally {
            con.setAutoCommit(true);
        }
    }
}

}
