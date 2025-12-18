/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dao.DBConnect;
import model.SupportTicket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Order;

public class SupportTicketDAO {

    public List<SupportTicket> getAllTickets() {
        List<SupportTicket> list = new ArrayList<>();

        String sql
                = "SELECT t.*, u.full_name "
                + "FROM support_tickets t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "ORDER BY FIELD(t.status,'NEW','PROCESSING','RESOLVED','CLOSED'), t.created_at DESC";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SupportTicket t = new SupportTicket();
                t.setTicketId(rs.getLong("ticket_id"));
                t.setUserId(rs.getInt("user_id"));
                t.setSubject(rs.getString("subject"));
                t.setContent(rs.getString("content"));
                t.setPriority(rs.getString("priority"));
                t.setStatus(rs.getString("status"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                t.setUserName(rs.getString("full_name"));
                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean createTicket(SupportTicket t) {

        String sql = "INSERT INTO support_tickets "
                + "(user_id, subject, content, priority, status) "
                + "VALUES (?, ?, ?, 'MEDIUM', 'NEW')";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getUserId());
            ps.setString(2, t.getSubject());
            ps.setString(3, t.getContent());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<SupportTicket> getTicketsByUser(int userId) {
        List<SupportTicket> list = new ArrayList<>();

        String sql
                = "SELECT t.* "
                + "FROM support_tickets t "
                + "WHERE t.user_id = ? "
                + "ORDER BY t.created_at DESC";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SupportTicket t = new SupportTicket();
                t.setTicketId(rs.getLong("ticket_id"));
                t.setUserId(rs.getInt("user_id"));
                t.setSubject(rs.getString("subject"));
                t.setContent(rs.getString("content"));
                t.setPriority(rs.getString("priority"));
                t.setStatus(rs.getString("status"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public SupportTicket getTicketById(long ticketId, int userId) {

        String sql = "SELECT * FROM support_tickets "
                + "WHERE ticket_id = ? AND user_id = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, ticketId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SupportTicket t = new SupportTicket();
                    t.setTicketId(rs.getLong("ticket_id"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setSubject(rs.getString("subject"));
                    t.setContent(rs.getString("content"));
                    t.setPriority(rs.getString("priority"));
                    t.setStatus(rs.getString("status"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));

                    return t;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Lấy chi tiết ticket cho Staff (không giới hạn theo user_id)
     * Staff được xem tất cả các ticket trong hệ thống
     */
    public SupportTicket getTicketByIdForStaff(long ticketId) {

        String sql = "SELECT t.*, u.full_name "
                + "FROM support_tickets t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "WHERE t.ticket_id = ?";

        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, ticketId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SupportTicket t = new SupportTicket();
                    t.setTicketId(rs.getLong("ticket_id"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setSubject(rs.getString("subject"));
                    t.setContent(rs.getString("content"));
                    t.setPriority(rs.getString("priority"));
                    t.setStatus(rs.getString("status"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));
                    t.setUserName(rs.getString("full_name"));

                    return t;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void updateStatus(long ticketId, String status, int staffId) {

        String sql = "UPDATE support_tickets "
                + "SET status = ?, processed_by = ?, updated_at = NOW() "
                + "WHERE ticket_id = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, staffId);
            ps.setLong(3, ticketId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
