/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CustomerFeedback;

/**
 *
 * @author trung
 */
public class CustomerFeedbackDAO {

    public static void main(String[] args) {
        CustomerFeedbackDAO dao = new CustomerFeedbackDAO();
        System.out.println(dao.countFeedbacksForProduct(4));
    }

    public List<CustomerFeedback> getListFeedbackForHomepage(int limit, int offset) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<CustomerFeedback> cfList = new ArrayList<>();
        String sql = """
                     SELECT 
                         cf.*,
                         u.full_name as customer_fullname
                     FROM
                         card_store.customer_feedback cf
                             JOIN
                         users u ON u.user_id = cf.user_id
                     WHERE
                         is_public = 1
                     LIMIT ? OFFSET ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            rs = ps.executeQuery();

            while (rs.next()) {
                CustomerFeedback cf = new CustomerFeedback();
                cf.setFeedbackId(rs.getLong("feedback_id"));
                cf.setUserId(rs.getInt("user_id"));
                cf.setOrderId(rs.getLong("order_id"));
                cf.setRating(rs.getInt("rating"));
                cf.setCategory(rs.getString("category"));
                cf.setSubject(rs.getString("subject"));
                cf.setContent(rs.getString("content"));
                cf.setIsPublic(rs.getBoolean("is_public"));
                cf.setIsResponded(rs.getBoolean("is_responded"));
                cf.setAdminResponse(rs.getString("admin_response"));
                cf.setRespondedBy(rs.getInt("responded_by"));
                cf.setRespondedAt(rs.getTimestamp("responded_at") != null ? rs.getTimestamp("responded_at").toLocalDateTime() : null);
                cf.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
                cf.setCustomerName(rs.getString("customer_fullname"));

                cfList.add(cf);
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

        return cfList;
    }

    public List<CustomerFeedback> getListFeedbacksForProduct(int limit, int offset, int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<CustomerFeedback> cfList = new ArrayList<>();
        String sql = """
                     SELECT 
                         cf.*, 
                         u.full_name AS customer_fullname
                     FROM 
                         card_store.customer_feedback cf
                     JOIN 
                         users u 
                             ON u.user_id = cf.user_id
                     JOIN 
                         order_items oi 
                             ON oi.order_id = cf.order_id
                             AND oi.product_id = ?
                     WHERE 
                         cf.is_public = 1
                     LIMIT ? OFFSET ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, productId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);

            rs = ps.executeQuery();

            while (rs.next()) {
                CustomerFeedback cf = new CustomerFeedback();
                cf.setFeedbackId(rs.getLong("feedback_id"));
                cf.setUserId(rs.getInt("user_id"));
                cf.setOrderId(rs.getLong("order_id"));
                cf.setRating(rs.getInt("rating"));
                cf.setCategory(rs.getString("category"));
                cf.setSubject(rs.getString("subject"));
                cf.setContent(rs.getString("content"));
                cf.setIsPublic(rs.getBoolean("is_public"));
                cf.setIsResponded(rs.getBoolean("is_responded"));
                cf.setAdminResponse(rs.getString("admin_response"));
                cf.setRespondedBy(rs.getInt("responded_by"));
                cf.setRespondedAt(rs.getTimestamp("responded_at") != null ? rs.getTimestamp("responded_at").toLocalDateTime() : null);
                cf.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
                cf.setCustomerName(rs.getString("customer_fullname"));

                cfList.add(cf);
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

        return cfList;
    }

    public int countFeedbacksForProduct(int productId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     SELECT 
                         COUNT(*)
                     FROM 
                         card_store.customer_feedback cf
                     JOIN 
                         order_items oi 
                             ON oi.order_id = cf.order_id
                             AND oi.product_id = ?
                     WHERE 
                         cf.is_public = 1;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, productId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
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

        return 0;
    }

}
