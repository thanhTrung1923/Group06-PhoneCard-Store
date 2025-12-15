/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dtos.CardProductDTO;
import dtos.CardProductDetailDTO;
import model.CardProduct; // Lưu ý: Hãy chắc chắn bạn đã tạo package model và class CardProduct
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CardProductDAO {

    public static void main(String[] args) {
        //Hàm để test thôi, không quá quan trọng
        CardProductDAO dao = new CardProductDAO();
        System.out.println(dao.getCardProductDetail(1));
    }

    public List<CardProduct> getAllCardProducts() {
        List<CardProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM card_products ORDER BY product_id DESC";

        // Sử dụng try-with-resources để tự động đóng Connection, PreparedStatement, ResultSet
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            // Nếu kết nối null (do lỗi bên DBConnect), dừng luôn
            if (conn == null) {
                return list;
            }

            while (rs.next()) {
                CardProduct product = new CardProduct();

                // Mapping dữ liệu từ ResultSet vào Object
                product.setProductId(rs.getInt("product_id"));

                // Thông tin loại thẻ
                product.setTypeCode(rs.getString("type_code"));
                product.setTypeName(rs.getString("type_name"));
                product.setValue(rs.getLong("value"));

                // Kho và cảnh báo
                product.setQuantity(rs.getInt("quantity"));
                product.setMinStockAlert(rs.getInt("min_stock_alert"));

                // Giá cả (Dùng BigDecimal)
                product.setBuyPrice(rs.getBigDecimal("buy_price"));
                product.setSellPrice(rs.getBigDecimal("sell_price"));

                // Hình ảnh và mô tả
                product.setImgUrl(rs.getString("img_url"));
                product.setThumbnailUrl(rs.getString("thumbnail_url"));
                product.setDescription(rs.getString("description"));

                // Trạng thái (TINYINT trong DB -> boolean trong Java)
                product.setIsActive(rs.getBoolean("is_active"));
                product.setAllowDiscount(rs.getBoolean("allow_discount"));

                // Thời gian
                product.setCreatedAt(rs.getTimestamp("created_at"));
                product.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Thêm vào danh sách
                list.add(product);
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách CardProduct:");
            e.printStackTrace();
        }

        return list;
    }

    public List<CardProductDTO> getCardProductsMostBuyed(int limit, int offset) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<CardProductDTO> cpList = new ArrayList<>();
        String sql = """
                     SELECT 
                         cp.product_id,
                         cp.type_code,
                         cp.type_name,
                         cp.value,
                         cp.sell_price,
                         cp.quantity AS stock_quantity,
                         cp.thumbnail_url,
                         
                         COALESCE(pd.discount_percent, 0) AS discount_percent,
                         ROUND(cp.sell_price * (1 - COALESCE(pd.discount_percent, 0) / 100), 2) AS final_price,
                         
                         COALESCE(ROUND(AVG(cf.rating), 1), 0) AS avg_rating,
                         COUNT(DISTINCT cf.feedback_id) AS review_count,
                         
                         COALESCE(SUM(oi.quantity), 0) AS total_sold
                         
                     FROM card_products cp
                     LEFT JOIN order_items oi ON cp.product_id = oi.product_id
                     LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status = 'PAID'
                     LEFT JOIN promotion_details pd ON cp.product_id = pd.product_id
                     LEFT JOIN promotions p ON pd.promotion_id = p.promotion_id 
                         AND p.is_active = 1 AND NOW() BETWEEN p.start_at AND p.end_at
                     LEFT JOIN customer_feedback cf ON oi.order_id = cf.order_id
                         
                     WHERE cp.is_active = 1
                     GROUP BY cp.product_id, cp.type_code, cp.type_name, cp.value, 
                              cp.sell_price, cp.quantity, pd.discount_percent
                     ORDER BY total_sold DESC, avg_rating DESC
                     LIMIT ? OFFSET ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            rs = ps.executeQuery();

            while (rs.next()) {
                CardProductDTO cp = new CardProductDTO();
                cp.setProduct_id(rs.getInt("product_id"));
                cp.setType_code(rs.getString("type_code"));
                cp.setType_name(rs.getString("type_name"));
                cp.setValue(rs.getLong("value"));
                cp.setSell_price(rs.getBigDecimal("sell_price"));
                cp.setStock_quantity(rs.getInt("stock_quantity"));
                cp.setDiscount_percent(rs.getFloat("discount_percent"));
                cp.setFinal_price(rs.getBigDecimal("final_price"));
                cp.setAvg_rating(rs.getFloat("avg_rating"));
                cp.setReview_count(rs.getInt("review_count"));
                cp.setTotal_sold(rs.getInt("total_sold"));
                cp.setThumbnail_url(rs.getString("thumbnail_url"));

                cpList.add(cp);
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return cpList;
    }

    public List<CardProductDTO> getCardProductsBestFeedback(int limit, int offset) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<CardProductDTO> cpList = new ArrayList<>();
        String sql = """
                     SELECT 
                             cp.product_id,
                             cp.type_code,
                             cp.type_name,
                             cp.value,
                             cp.sell_price,
                             cp.quantity AS stock_quantity,
                             cp.thumbnail_url,
                             
                             COALESCE(pd.discount_percent, 0) AS discount_percent,
                             ROUND(cp.sell_price * (1 - COALESCE(pd.discount_percent, 0) / 100), 2) AS final_price,
                             
                             COALESCE(ROUND(AVG(cf.rating), 1), 0) AS avg_rating,
                             COUNT(DISTINCT cf.feedback_id) AS review_count,
                             
                             COALESCE(SUM(oi.quantity), 0) AS total_sold
                             
                         FROM card_products cp
                         LEFT JOIN order_items oi ON cp.product_id = oi.product_id
                         LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status = 'PAID'
                         LEFT JOIN promotion_details pd ON cp.product_id = pd.product_id
                         LEFT JOIN promotions p ON pd.promotion_id = p.promotion_id 
                             AND p.is_active = 1 AND NOW() BETWEEN p.start_at AND p.end_at
                         LEFT JOIN customer_feedback cf ON oi.order_id = cf.order_id
                             AND cf.rating IS NOT NULL  
                             
                         WHERE cp.is_active = 1
                         GROUP BY cp.product_id, cp.type_code, cp.type_name, cp.value, 
                                  cp.sell_price, cp.quantity, pd.discount_percent
                         
                         HAVING review_count > 0  
                         
                         ORDER BY 
                             avg_rating DESC,      
                             review_count DESC,    
                             total_sold DESC       
                             
                         LIMIT ? OFFSET ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            rs = ps.executeQuery();

            while (rs.next()) {
                CardProductDTO cp = new CardProductDTO();
                cp.setProduct_id(rs.getInt("product_id"));
                cp.setType_code(rs.getString("type_code"));
                cp.setType_name(rs.getString("type_name"));
                cp.setValue(rs.getLong("value"));
                cp.setSell_price(rs.getBigDecimal("sell_price"));
                cp.setStock_quantity(rs.getInt("stock_quantity"));
                cp.setDiscount_percent(rs.getFloat("discount_percent"));
                cp.setFinal_price(rs.getBigDecimal("final_price"));
                cp.setAvg_rating(rs.getFloat("avg_rating"));
                cp.setReview_count(rs.getInt("review_count"));
                cp.setTotal_sold(rs.getInt("total_sold"));
                cp.setThumbnail_url(rs.getString("thumbnail_url"));

                cpList.add(cp);
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return cpList;
    }

    public List<CardProductDTO> getCardProductsList(int limit, int offset, String typeName, long value, String typeCode, String description, String orderBy, String typeOrder) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<CardProductDTO> cpList = new ArrayList<>();

        StringBuilder whereClause = new StringBuilder("WHERE cp.is_active = 1");
        List<Object> params = new ArrayList<>();

        if (typeName != null && !typeName.trim().isEmpty()) {
            whereClause.append(" AND cp.type_name LIKE ?");
            params.add("%" + typeName.trim() + "%");
        }

        if (value > 0) {
            whereClause.append(" AND cp.value = ?");
            params.add(value);
        }

        if (typeCode != null && !typeCode.trim().isEmpty()) {
            whereClause.append(" AND cp.type_code LIKE ?");
            params.add("%" + typeCode.trim() + "%");
        }

        if (description != null && !description.trim().isEmpty()) {
            whereClause.append(" AND cp.description LIKE ?");
            params.add("%" + description.trim() + "%");
        }

        String orderByClause = "ORDER BY ";
        if (orderBy != null && !orderBy.trim().isEmpty()) {
            switch (orderBy.toLowerCase()) {
                case "price" ->
                    orderByClause += "final_price";
                case "name" ->
                    orderByClause += "cp.type_name";
                case "sold" ->
                    orderByClause += "total_sold";
                case "rating" ->
                    orderByClause += "avg_rating";
                default ->
                    orderByClause += "total_sold";
            }

            if (typeOrder != null && typeOrder.equalsIgnoreCase("desc")) {
                orderByClause += " DESC";
            } else {
                orderByClause += " ASC";
            }

            orderByClause += ", avg_rating DESC";
        } else {
            orderByClause += "total_sold DESC, avg_rating DESC";
        }

        String sql = """
                 SELECT 
                     cp.product_id,
                     cp.type_code,
                     cp.type_name,
                     cp.value,
                     cp.sell_price,
                     cp.quantity AS stock_quantity,
                     cp.thumbnail_url,
                     
                     COALESCE(pd.discount_percent, 0) AS discount_percent,
                     ROUND(cp.sell_price * (1 - COALESCE(pd.discount_percent, 0) / 100), 2) AS final_price,
                     
                     COALESCE(ROUND(AVG(cf.rating), 1), 0) AS avg_rating,
                     COUNT(DISTINCT cf.feedback_id) AS review_count,
                     
                     COALESCE(SUM(oi.quantity), 0) AS total_sold
                     
                 FROM card_products cp
                 LEFT JOIN order_items oi ON cp.product_id = oi.product_id
                 LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status = 'PAID'
                 LEFT JOIN promotion_details pd ON cp.product_id = pd.product_id
                 LEFT JOIN promotions p ON pd.promotion_id = p.promotion_id 
                     AND p.is_active = 1 AND NOW() BETWEEN p.start_at AND p.end_at
                 LEFT JOIN customer_feedback cf ON oi.order_id = cf.order_id
                     
                 """ + whereClause.toString() + """
                 
                 GROUP BY cp.product_id, cp.type_code, cp.type_name, cp.value, 
                          cp.sell_price, cp.quantity, pd.discount_percent, cp.thumbnail_url
                 """ + orderByClause + """
                 
                 LIMIT ? OFFSET ?
                 """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            int paramIndex = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    ps.setString(paramIndex++, (String) param);
                } else if (param instanceof Long) {
                    ps.setLong(paramIndex++, (Long) param);
                }
            }

            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);

            rs = ps.executeQuery();
            while (rs.next()) {
                CardProductDTO cp = new CardProductDTO();
                cp.setProduct_id(rs.getInt("product_id"));
                cp.setType_code(rs.getString("type_code"));
                cp.setType_name(rs.getString("type_name"));
                cp.setValue(rs.getLong("value"));
                cp.setSell_price(rs.getBigDecimal("sell_price"));
                cp.setStock_quantity(rs.getInt("stock_quantity"));
                cp.setDiscount_percent(rs.getFloat("discount_percent"));
                cp.setFinal_price(rs.getBigDecimal("final_price"));
                cp.setAvg_rating(rs.getFloat("avg_rating"));
                cp.setReview_count(rs.getInt("review_count"));
                cp.setTotal_sold(rs.getInt("total_sold"));
                cp.setThumbnail_url(rs.getString("thumbnail_url"));
                cpList.add(cp);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }
        return cpList;
    }

    public int countCardProducts(String typeName, long value, String typeCode, String description) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        int total = 0;

        StringBuilder whereClause = new StringBuilder("WHERE cp.is_active = 1");
        List<Object> params = new ArrayList<>();

        if (typeName != null && !typeName.trim().isEmpty()) {
            whereClause.append(" AND cp.type_name LIKE ?");
            params.add("%" + typeName.trim() + "%");
        }

        if (value > 0) {
            whereClause.append(" AND cp.value = ?");
            params.add(value);
        }

        if (typeCode != null && !typeCode.trim().isEmpty()) {
            whereClause.append(" AND cp.type_code LIKE ?");
            params.add("%" + typeCode.trim() + "%");
        }

        if (description != null && !description.trim().isEmpty()) {
            whereClause.append(" AND cp.description LIKE ?");
            params.add("%" + description.trim() + "%");
        }

        String sql = """
            SELECT COUNT(DISTINCT cp.product_id) AS total
            FROM card_products cp
            LEFT JOIN promotion_details pd ON cp.product_id = pd.product_id
            LEFT JOIN promotions p ON pd.promotion_id = p.promotion_id
                AND p.is_active = 1 AND NOW() BETWEEN p.start_at AND p.end_at
            LEFT JOIN order_items oi ON cp.product_id = oi.product_id
            LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status = 'PAID'
            LEFT JOIN customer_feedback cf ON oi.order_id = cf.order_id
            """ + whereClause.toString();
        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            int paramIndex = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    ps.setString(paramIndex++, (String) param);
                } else if (param instanceof Long) {
                    ps.setLong(paramIndex++, (Long) param);
                }
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return total;
    }

    public CardProductDetailDTO getCardProductDetail(int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        CardProductDetailDTO cp = null;

        String sql = """
                 SELECT 
                     cp.product_id,
                     cp.type_code,
                     cp.type_name,
                     cp.value,
                     cp.description,
                     cp.buy_price AS original_price,
                     cp.sell_price,
                     CASE 
                         WHEN p.promotion_id IS NOT NULL THEN pd.discount_percent
                         ELSE 0
                     END AS discount_percent,
                     ROUND(cp.sell_price * (1 - CASE 
                         WHEN p.promotion_id IS NOT NULL THEN pd.discount_percent
                         ELSE 0
                     END / 100), 2) AS final_price,
                     
                     cp.quantity AS stock_quantity,
                     cp.is_active,
                     CASE 
                         WHEN cp.quantity > 0 THEN 'IN_STOCK'
                         ELSE 'OUT_OF_STOCK'
                     END AS stock_status,
                     
                     cp.img_url,
                     cp.thumbnail_url,
                     
                     COALESCE(ROUND(AVG(cf.rating), 1), 0) AS avg_rating,
                     COUNT(DISTINCT cf.feedback_id) AS review_count,
                     
                     COALESCE(SUM(oi.quantity), 0) AS total_sold,
                     
                     50 AS max_quantity_per_order,
                     
                     p.promotion_id,
                     p.promotion_name,
                     p.description AS promotion_description,
                     p.start_at AS promotion_start,
                     p.end_at AS promotion_end
                     
                 FROM card_products cp
                 LEFT JOIN promotion_details pd ON cp.product_id = pd.product_id
                 LEFT JOIN promotions p ON pd.promotion_id = p.promotion_id 
                     AND p.is_active = 1 
                     AND NOW() BETWEEN p.start_at AND p.end_at
                 LEFT JOIN order_items oi ON cp.product_id = oi.product_id
                 LEFT JOIN orders o ON oi.order_id = o.order_id 
                     AND o.status = 'PAID'
                 LEFT JOIN customer_feedback cf ON o.order_id = cf.order_id 
                     AND cf.is_public = 1
                 
                 WHERE cp.product_id = ?
                 
                 GROUP BY 
                     cp.product_id, 
                     cp.type_code, 
                     cp.type_name, 
                     cp.value,
                     cp.description,
                     cp.buy_price,
                     cp.sell_price, 
                     cp.quantity,
                     cp.img_url,
                     cp.thumbnail_url,
                     cp.is_active,
                     pd.discount_percent,
                     p.promotion_id,
                     p.promotion_name,
                     p.description,
                     p.start_at,
                     p.end_at;
                 """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, productId);

            rs = ps.executeQuery();

            if (rs.next()) {
                cp = new CardProductDetailDTO();

                cp.setProduct_id(rs.getInt("product_id"));
                cp.setType_code(rs.getString("type_code"));
                cp.setType_name(rs.getString("type_name"));
                cp.setValue(rs.getLong("value"));
                cp.setDescription(rs.getString("description"));

                cp.setOriginal_price(rs.getBigDecimal("original_price"));
                cp.setSell_price(rs.getBigDecimal("sell_price"));

                cp.setDiscount_percent(rs.getFloat("discount_percent"));
                cp.setFinal_price(rs.getBigDecimal("final_price"));

                cp.setStock_quantity(rs.getInt("stock_quantity"));
                cp.setIs_active(rs.getBoolean("is_active"));
                cp.setStock_status(rs.getString("stock_status"));

                cp.setImg_url(rs.getString("img_url"));
                cp.setThumbnail_url(rs.getString("thumbnail_url"));

                cp.setAvg_rating(rs.getFloat("avg_rating"));
                cp.setReview_count(rs.getInt("review_count"));

                cp.setTotal_sold(rs.getInt("total_sold"));
                cp.setMax_quantity_per_order(rs.getInt("max_quantity_per_order"));
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return cp;
    }

    public CardProduct getProductById(int id) {
        String sql = "SELECT * FROM card_products WHERE product_id = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CardProduct p = new CardProduct();
                // Map dữ liệu (Copy lại đoạn set bên getAll để đỡ gõ lại)
                p.setProductId(rs.getInt("product_id"));
                p.setTypeCode(rs.getString("type_code"));
                p.setTypeName(rs.getString("type_name"));
                p.setValue(rs.getLong("value"));
                p.setQuantity(rs.getInt("quantity"));
                p.setMinStockAlert(rs.getInt("min_stock_alert"));
                p.setBuyPrice(rs.getBigDecimal("buy_price"));
                p.setSellPrice(rs.getBigDecimal("sell_price"));
                p.setImgUrl(rs.getString("img_url"));
                p.setThumbnailUrl(rs.getString("thumbnail_url"));
                p.setDescription(rs.getString("description"));
                p.setIsActive(rs.getBoolean("is_active"));
                p.setAllowDiscount(rs.getBoolean("allow_discount"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertProduct(CardProduct p) {
        String sql = "INSERT INTO card_products (type_code, type_name, value, quantity, min_stock_alert, "
                + "buy_price, sell_price, img_url, thumbnail_url, description, is_active, allow_discount) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getTypeCode());
            ps.setString(2, p.getTypeName());
            ps.setLong(3, p.getValue());
            ps.setInt(4, p.getQuantity());
            ps.setInt(5, p.getMinStockAlert());
            ps.setBigDecimal(6, p.getBuyPrice());
            ps.setBigDecimal(7, p.getSellPrice());
            ps.setString(8, p.getImgUrl());
            ps.setString(9, p.getThumbnailUrl());
            ps.setString(10, p.getDescription());
            ps.setBoolean(11, p.isIsActive());
            ps.setBoolean(12, p.isAllowDiscount());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Cập nhật sản phẩm
    public void updateProduct(CardProduct p) {
        String sql = "UPDATE card_products SET type_code=?, type_name=?, value=?, quantity=?, min_stock_alert=?, "
                + "buy_price=?, sell_price=?, img_url=?, thumbnail_url=?, description=?, is_active=?, allow_discount=?, updated_at=NOW() "
                + "WHERE product_id=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getTypeCode());
            ps.setString(2, p.getTypeName());
            ps.setLong(3, p.getValue());
            ps.setInt(4, p.getQuantity());
            ps.setInt(5, p.getMinStockAlert());
            ps.setBigDecimal(6, p.getBuyPrice());
            ps.setBigDecimal(7, p.getSellPrice());
            ps.setString(8, p.getImgUrl());
            ps.setString(9, p.getThumbnailUrl());
            ps.setString(10, p.getDescription());
            ps.setBoolean(11, p.isIsActive());
            ps.setBoolean(12, p.isAllowDiscount());
            ps.setInt(13, p.getProductId()); // ID nằm cuối câu lệnh WHERE

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Xóa sản phẩm
    public void deleteProduct(int id) {
        String sql = "DELETE FROM card_products WHERE product_id = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

 public List<CardProduct> findAll() {
        List<CardProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM card_products ORDER BY product_id ASC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CardProduct> search(
            String typeCode,
            Long value,
            String order
    ) {
        List<CardProduct> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT *
            FROM card_products
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (typeCode != null && !typeCode.isBlank()) {
            sql.append(" AND type_code LIKE ?");
            params.add("%" + typeCode.trim() + "%");
        }

        if (value != null && value > 0) {
            sql.append(" AND value = ?");
            params.add(value);
        }

        sql.append(" ORDER BY sell_price ")
           .append("asc".equalsIgnoreCase(order) ? "ASC" : "DESC");

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            for (Object p : params) {
                if (p instanceof String) {
                    ps.setString(idx++, (String) p);
                } else if (p instanceof Long) {
                    ps.setLong(idx++, (Long) p);
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy danh sách mệnh giá cho combobox
    public List<Long> getDistinctValues() {
        List<Long> values = new ArrayList<>();
        String sql = "SELECT DISTINCT value FROM card_products ORDER BY value ASC";

        try (Connection con = DBConnect.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                values.add(rs.getLong("value"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return values;
    }

    // Map chung
    private CardProduct mapRow(ResultSet rs) throws SQLException {
        CardProduct p = new CardProduct();
        p.setProductId(rs.getInt("product_id"));
        p.setTypeCode(rs.getString("type_code"));
        p.setTypeName(rs.getString("type_name"));
        p.setValue(rs.getLong("value"));
        p.setQuantity(rs.getInt("quantity"));
        p.setMinStockAlert(rs.getInt("min_stock_alert"));
        p.setBuyPrice(rs.getBigDecimal("buy_price"));
        p.setSellPrice(rs.getBigDecimal("sell_price"));
        p.setImgUrl(rs.getString("img_url"));
        p.setThumbnailUrl(rs.getString("thumbnail_url"));
        p.setDescription(rs.getString("description"));
        p.setIsActive(rs.getBoolean("is_active"));
        p.setAllowDiscount(rs.getBoolean("allow_discount"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }
}
