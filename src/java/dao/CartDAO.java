/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.CartItem;

/**
 *
 * @author trung
 */
public class CartDAO {

    public static void main(String[] args) {
        CartDAO dao = new CartDAO();
        System.out.println(dao.getCartItemsByCartId(1));
    }

    public Cart getCartByUserId(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Cart c = null;
        String sql = """
                     SELECT * FROM carts WHERE user_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            while (rs.next()) {
                c = new Cart();

                c.setCartId(rs.getInt("cart_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
                c.setUpdatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
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

        return c;
    }

    public List<CartItem> getCartItemsByCartId(int cartId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<CartItem> ciList = new ArrayList<>();
        String sql = """
                     SELECT * FROM cart_items WHERE cart_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, cartId);

            rs = ps.executeQuery();

            while (rs.next()) {
                CartItem ci = new CartItem();

                ci.setCartId(rs.getInt("cart_id"));
                ci.setProductId(rs.getInt("product_id"));
                ci.setItemId(rs.getInt("item_id"));
                ci.setQuantity(rs.getInt("quantity"));
                ci.setUnitPrice(rs.getBigDecimal("unit_price"));

                ciList.add(ci);
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

        return ciList;
    }
    
    public boolean isItemExistedInCart(){
        
    }
}
