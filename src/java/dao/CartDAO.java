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
        System.out.println(dao.isItemExistedInCart(1, 4));
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
    
    public boolean updateCartItemQuatity(long cartId, int productId, int quantityUpdate) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        String sql = """
                     UPDATE cart_items
                     SET
                     quantity = ?
                     WHERE cart_id = ? AND product_id = ?;
                     """;
        
        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);
            
            ps.setInt(1, quantityUpdate);
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
}
