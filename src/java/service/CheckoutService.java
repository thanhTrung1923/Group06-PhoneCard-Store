/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.*;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.List;
import model.Cart;
import model.CartItem;

public class CheckoutService {

    public void checkout(int userId) throws Exception {
        Connection con = null;

        try {
            con = DBConnect.getConnection();
            con.setAutoCommit(false); // 🔴 TRANSACTION

            CartDAO cartDAO = new CartDAO();
            WalletDAO walletDAO = new WalletDAO();
            OrderDAO orderDAO = new OrderDAO();
            CardDAO cardDAO = new CardDAO();

            Cart cart = cartDAO.getCartByUserId(userId);
            if (cart == null) {
                throw new Exception("Giỏ hàng trống");
            }

            List<CartItem> items = cartDAO.getCartItemsByCartId(cart.getCartId());
            if (items.isEmpty()) {
                throw new Exception("Giỏ hàng trống");
            }

            BigDecimal total = BigDecimal.ZERO;
            for (CartItem i : items) {
                total = total.add(
                        i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQuantity()))
                );
            }

            BigDecimal balance = walletDAO.getBalance(con, userId);
            if (balance.compareTo(total) < 0) {
                throw new Exception("Số dư ví không đủ, vui lòng nạp thêm");
            }

            // 1. Trừ ví
            walletDAO.deduct(con, userId, total);

            // 2. Tạo order
            long orderId = orderDAO.createOrder(con, userId, total);

            // 3. Order items + xuất thẻ
            for (CartItem ci : items) {
                for (int i = 0; i < ci.getQuantity(); i++) {
                    long cardId = cardDAO.assignCard(con, ci.getProductId());
                    orderDAO.createOrderItem(con, orderId, ci, cardId);
                }
            }

            // 4. Xoá giỏ
            cartDAO.clearCart(con, cart.getCartId());

            con.commit();

        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (con != null) con.close();
        }
    }
}


