/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderItem;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
public class OrderDAO extends DBConnect {

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getLong("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setTotalAmount(rs.getBigDecimal("total_amount"));
                    o.setStatus(rs.getString("status"));
                    java.sql.Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        o.setCreatedAt(ts.toLocalDateTime());
                    }
                    list.add(o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// get order items
    public List<OrderItem> getOrderItems(long orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.type_name FROM order_items oi JOIN card_products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem it = new OrderItem();
                    it.setItemId(rs.getLong("item_id"));
                    it.setProductId(rs.getInt("product_id"));
                    it.setQuantity(rs.getInt("quantity"));
                    it.setUnitPrice(rs.getBigDecimal("unit_price"));
                    it.setFinalPrice(rs.getBigDecimal("final_price"));
                    it.setProductName(rs.getString("type_name"));
                    items.add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

}



