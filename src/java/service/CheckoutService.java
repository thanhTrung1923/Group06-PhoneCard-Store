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
    private final OrderDAO orderDAO = new OrderDAO();

    public void checkout(int userId) throws Exception {
        orderDAO.checkoutFromCart(userId);
    }
    
}


