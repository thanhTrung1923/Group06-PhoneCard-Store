/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.CardProduct; // Lưu ý: Hãy chắc chắn bạn đã tạo package model và class CardProduct
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CardProductDAO {

    public List<CardProduct> getAllCardProducts() {
        List<CardProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM card_products ORDER BY product_id DESC";

        // Sử dụng try-with-resources để tự động đóng Connection, PreparedStatement, ResultSet
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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

}