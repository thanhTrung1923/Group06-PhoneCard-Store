package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.TicketReply;

public class TicketReplyDAO {

    public List<TicketReply> getRepliesByTicket(long ticketId) {
        List<TicketReply> list = new ArrayList<>();

        String sql = "SELECT r.*, u.full_name "
                   + "FROM ticket_replies r "
                   + "JOIN users u ON r.user_id = u.user_id "
                   + "WHERE r.ticket_id = ? "
                   + "ORDER BY r.created_at ASC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, ticketId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TicketReply r = new TicketReply();
                r.setReplyId(rs.getLong("reply_id"));
                r.setTicketId(rs.getLong("ticket_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setContent(rs.getString("content"));
                r.setStaffReply(rs.getBoolean("is_staff_reply"));

                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    r.setCreatedAt(ts.toLocalDateTime());
                }

                r.setUserName(rs.getString("full_name"));
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public boolean addStaffReply(long ticketId, int staffId, String content) {

    String sql = "INSERT INTO ticket_replies "
               + "(ticket_id, user_id, content, is_staff_reply, created_at) "
               + "VALUES (?, ?, ?, 1, NOW())";

    try (Connection conn = DBConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setLong(1, ticketId);
        ps.setInt(2, staffId);
        ps.setString(3, content);

        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

}
