/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
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
import model.CartItem;

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

    public long createOrder(Connection con, int userId, BigDecimal total) throws Exception {
        String sql = """
        INSERT INTO orders(user_id, total_amount, status, created_at, paid_at)
        VALUES (?, ?, 'PAID', NOW(), NOW())
    """;

        try (PreparedStatement ps
                = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setBigDecimal(2, total);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        throw new Exception("Không tạo được order");
    }

    public void createOrderItem(Connection con, long orderId,
            CartItem ci, long cardId) throws Exception {

        BigDecimal buyPrice = BigDecimal.ZERO;
        String sqlBuy = "SELECT buy_price FROM card_products WHERE product_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sqlBuy)) {
            ps.setInt(1, ci.getProductId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                buyPrice = rs.getBigDecimal("buy_price");
            }
        }
        BigDecimal finalPrice = ci.getUnitPrice();

        BigDecimal profit = finalPrice.subtract(buyPrice);

        String sql = """
        INSERT INTO order_items
        (order_id, product_id, quantity, unit_price, final_price, profit, assigned_card_id)
        VALUES (?, ?, 1, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setInt(2, ci.getProductId());
            ps.setBigDecimal(3, finalPrice);
            ps.setBigDecimal(4, finalPrice);
            ps.setBigDecimal(5, profit);
            ps.setLong(6, cardId);
            ps.executeUpdate();
        }
    }
    public Order getOrderById(long orderId) {
    String sql = "SELECT * FROM orders WHERE order_id = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setLong(1, orderId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Order o = new Order();
            o.setOrderId(rs.getLong("order_id"));
            o.setUserId(rs.getInt("user_id"));
            o.setTotalAmount(rs.getBigDecimal("total_amount"));
            o.setStatus(rs.getString("status"));

            java.sql.Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) {
                o.setCreatedAt(ts.toLocalDateTime());
            }
            return o;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}


}
