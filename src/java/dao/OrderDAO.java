/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderItem;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import model.Cart;
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

        String sql = """
        SELECT 
            oi.item_id,
            oi.order_id,
            oi.product_id,
            oi.quantity,
            oi.unit_price,
            oi.final_price,
            oi.profit,
            oi.assigned_card_id,
            p.type_name,
            p.value
        FROM order_items oi
        JOIN card_products p ON oi.product_id = p.product_id
        WHERE oi.order_id = ?
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem it = new OrderItem();
                it.setItemId(rs.getLong("item_id"));
                it.setOrderId(rs.getLong("order_id"));
                it.setProductId(rs.getInt("product_id"));
                it.setQuantity(rs.getInt("quantity"));
                it.setUnitPrice(rs.getBigDecimal("unit_price"));
                it.setFinalPrice(rs.getBigDecimal("final_price"));
                it.setProfit(rs.getBigDecimal("profit"));
                it.setAssignedCardId(rs.getLong("assigned_card_id"));

                it.setProductName(rs.getString("type_name"));
                it.setProductValue(rs.getLong("value"));

                items.add(it);
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
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

    public List<Order> filterOrders(
            int userId,
            String status,
            String fromDate,
            String toDate) {

        List<Order> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM orders WHERE user_id = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ? ");
            params.add(status);
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND DATE(created_at) >= ? ");
            params.add(fromDate);
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND DATE(created_at) <= ? ");
            params.add(toDate);
        }

        sql.append(" ORDER BY created_at DESC");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getLong("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setStatus(rs.getString("status"));

                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    o.setCreatedAt(ts.toLocalDateTime());
                }
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void checkoutFromCart(int userId) throws Exception {
        Connection con = null;

        try {
            con = DBConnect.getConnection();
            con.setAutoCommit(false);

            CartDAO cartDAO = new CartDAO();
            WalletDAO walletDAO = new WalletDAO();
            CardDAO cardDAO = new CardDAO();

            Cart cart = cartDAO.getCartByUserId(userId);
            if (cart == null) {
                throw new Exception("Giỏ hàng trống");
            }

            List<CartItem> items = cartDAO.getCartItemsByCartId(cart.getCartId());
            if (items.isEmpty()) {
                throw new Exception("Giỏ hàng trống");
            }

            // 1️⃣ Tính tổng tiền
            BigDecimal total = BigDecimal.ZERO;
            for (CartItem i : items) {
                total = total.add(
                        i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQuantity()))
                );
            }

            // 2️⃣ Check ví
            BigDecimal balance = walletDAO.getBalance(con, userId);
            if (balance.compareTo(total) < 0) {
                throw new Exception("Số dư ví không đủ, vui lòng nạp thêm");
            }

            // 3️⃣ Trừ ví
            walletDAO.deduct(con, userId, total);

            // 4️⃣ Tạo order
            long orderId = createOrder(con, userId, total);

            // 5️⃣ Order items + xuất thẻ
            for (CartItem ci : items) {
                for (int i = 0; i < ci.getQuantity(); i++) {
                    long cardId = cardDAO.assignCard(con, ci.getProductId());
                    createOrderItem(con, orderId, ci, cardId);
                }
            }

            // 6️⃣ Clear cart
            cartDAO.clearCart(con, cart.getCartId());

            con.commit();

        } catch (Exception e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (con != null) {
                con.close();
            }
        }
    }

    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT order_id, total_amount, created_at "
                + "FROM orders WHERE user_id = ? "
                + "ORDER BY created_at DESC";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getLong("order_id"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    o.setCreatedAt(ts.toLocalDateTime());
                }
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
