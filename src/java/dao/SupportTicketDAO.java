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

public class SupportTicketDAO {

    public List<SupportTicket> getAllTickets() {
        List<SupportTicket> list = new ArrayList<>();
        // JOIN bảng tickets với users để lấy tên người gửi
        String sql = "SELECT t.*, u.full_name " +
                     "FROM support_tickets t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "ORDER BY CASE t.status " + // Sắp xếp ưu tiên: NEW -> PROCESSING -> RESOLVED
                     "WHEN 'NEW' THEN 1 WHEN 'PROCESSING' THEN 2 ELSE 3 END, " +
                     "t.created_at DESC"; // Mới nhất lên đầu

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SupportTicket t = new SupportTicket();
                t.setTicketId(rs.getLong("ticket_id"));
                t.setUserId(rs.getInt("user_id"));
                t.setSubject(rs.getString("subject"));
                t.setContent(rs.getString("content"));
                t.setPriority(rs.getString("priority"));
                t.setStatus(rs.getString("status"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Lấy tên user từ kết quả JOIN
                t.setUserName(rs.getString("full_name"));
                
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}