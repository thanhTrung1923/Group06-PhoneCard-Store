/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Cart;
import model.CartItem;

/**
 *
 * @author trung
 */
public class CartDAO {

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

                c.setCartId(rs.getLong("cart_id"));
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

    public List<CartItem> getCartItemsByCartId(long cartId) {
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

            ps.setLong(1, cartId);

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

    public CartItem getCartItemByCartIdAndProductId(long cartId, int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        CartItem ci = null;
        String sql = """
                     SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setLong(1, cartId);
            ps.setInt(2, productId);

            rs = ps.executeQuery();

            while (rs.next()) {
                ci = new CartItem();

                ci.setCartId(rs.getInt("cart_id"));
                ci.setProductId(rs.getInt("product_id"));
                ci.setItemId(rs.getInt("item_id"));
                ci.setQuantity(rs.getInt("quantity"));
                ci.setUnitPrice(rs.getBigDecimal("unit_price"));
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

        return ci;
    }

    public boolean isItemExistedInCart(long cartId, int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     SELECT COUNT(*) FROM cart_items WHERE cart_id = ? AND product_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setLong(1, cartId);
            ps.setInt(2, productId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
            return false;
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
    }

//    public boolean updateCartItemQuatity(long cartId, int productId, int quantityUpdate) {
//        Connection con = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//
//        String sql = """
//                     UPDATE cart_items
//                     SET
//                     quantity = ?
//                     WHERE cart_id = ? AND product_id = ?;
//                     """;
//
//        try {
//            con = DBConnect.getConnection();
//            ps = con.prepareStatement(sql);
//
//            ps.setInt(1, quantityUpdate);
//            ps.setLong(2, cartId);
//            ps.setInt(3, productId);
//
//            return ps.executeUpdate() > 0;
//
//        } catch (SQLException e) {
//            System.err.println(e.getMessage());
//            e.printStackTrace();
//            return false;
//        } finally {
//            try {
//                if (con != null) {
//                    con.close();
//                }
//                if (ps != null) {
//                    ps.close();
//                }
//                if (rs != null) {
//                    rs.close();
//                }
//            } catch (SQLException e) {
//                System.err.println(e.getMessage());
//                e.printStackTrace();
//            }
//        }
//    }
    public boolean increaseCartItemQuatity(long cartId, int productId, int quantityIncrease) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     UPDATE cart_items
                     SET
                     quantity = quantity + ?
                     WHERE cart_id = ? AND product_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, quantityIncrease);
            ps.setLong(2, cartId);
            ps.setInt(3, productId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
            return false;
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
    }

    public boolean decreaseCartItemQuatity(long cartId, int productId, int quantityDecrease) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     UPDATE cart_items
                     SET
                     quantity = quantity - ?
                     WHERE cart_id = ? AND product_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, quantityDecrease);
            ps.setLong(2, cartId);
            ps.setInt(3, productId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
            return false;
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
    }

    public boolean isCartExisted(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     SELECT COUNT(*) FROM carts WHERE user_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
            return false;
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
    }

    public boolean createCartForUserId(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     INSERT INTO carts(user_id) VALUES (?);
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
            return false;
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
    }

    public boolean createItemForCart(long cartId, int productId, int quantity, BigDecimal unit_price) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     INSERT INTO `card_store`.`cart_items`
                     (`cart_id`,
                     `product_id`,
                     `quantity`,
                     `unit_price`)
                     VALUES
                     (?, ?, ?, ?);
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setLong(1, cartId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, unit_price);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
            return false;
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
    }

    public Map<Integer, Map<String, Object>> getProductInfoForCart(List<CartItem> items) {

        Map<Integer, Map<String, Object>> result = new HashMap<>();
        if (items.isEmpty()) {
            return result;
        }

        StringBuilder ids = new StringBuilder();
        for (CartItem i : items) {
            ids.append(i.getProductId()).append(",");
        }
        ids.deleteCharAt(ids.length() - 1);

        String sql = """
        SELECT 
            product_id,
            type_name,
            type_code,
            thumbnail_url
        FROM card_products
        WHERE product_id IN (""" + ids + ")";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> info = new HashMap<>();
                info.put("typeName", rs.getString("type_name"));
                info.put("typeCode", rs.getString("type_code"));
                info.put("thumbnail", rs.getString("thumbnail_url"));

                result.put(rs.getInt("product_id"), info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean deleteCartItem(long cartId, int productId) {
        String sql = """
        DELETE FROM cart_items
        WHERE cart_id = ? AND product_id = ?
    """;

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, cartId);
            ps.setInt(2, productId);

            int affected = ps.executeUpdate();

            System.out.println("deleteCartItem affected rows = " + affected);

            return affected > 0;

        } catch (SQLException e) {
            System.err.println("deleteCartItem ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalQuantityByUserId(int userId) {
        String sql = """
        SELECT IFNULL(SUM(ci.quantity), 0)
        FROM carts c
        JOIN cart_items ci ON c.cart_id = ci.cart_id
        WHERE c.user_id = ?
    """;

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal getProductFinalPrice(int productId) {
        String sql = """
        SELECT
            CASE
                WHEN pd.discount_percent > 0
                THEN cp.sell_price * (100 - pd.discount_percent) / 100
                ELSE cp.sell_price
            END AS final_price
        FROM card_products cp
        LEFT JOIN promotion_details pd ON cp.product_id = pd.product_id
        WHERE cp.product_id = ?
    """;

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("final_price");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public void clearCart(Connection con, long cartId) throws Exception {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            ps.executeUpdate();
        }
    }
}
