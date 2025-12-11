/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dtos.CardProductDTO;
import java.math.BigDecimal;
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
        System.out.println(dao.getCardProductsBestFeedback(10, 0));
        System.out.println(dao.getCardProductsMostBuyed(10, 0));
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
}
