package controller;

import com.google.gson.Gson;
import dao.SupportTicketDAO;
import dao.TicketReplyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.SupportTicket;
import model.TicketReply;
import model.User;

/**
 * Servlet để trả về dữ liệu ticket dưới dạng JSON cho AJAX request
 */
@WebServlet("/staff/support/api")
public class StaffSupportTicketAPIController extends HttpServlet {

    private SupportTicketDAO ticketDAO = new SupportTicketDAO();
    private TicketReplyDAO replyDAO = new TicketReplyDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User staff = (User) session.getAttribute("account");

        // Kiểm tra quyền
        if (staff == null || !staff.getRoles().contains("STAFF")) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String ticketIdParam = request.getParameter("ticketId");
        if (ticketIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        long ticketId = Long.parseLong(ticketIdParam);

        // Lấy thông tin ticket
        SupportTicket ticket = ticketDAO.getTicketByIdForStaff(ticketId);
        if (ticket == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Lấy danh sách replies
        List<TicketReply> replies = replyDAO.getRepliesByTicket(ticketId);

        // Tạo response JSON
        Map<String, Object> data = new HashMap<>();
        
        // Ticket info
        Map<String, Object> ticketInfo = new HashMap<>();
        ticketInfo.put("ticketId", ticket.getTicketId());
        ticketInfo.put("customerName", ticket.getUserName());
        ticketInfo.put("subject", ticket.getSubject());
        ticketInfo.put("content", ticket.getContent());
        ticketInfo.put("priority", ticket.getPriority());
        ticketInfo.put("status", ticket.getStatus());
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        ticketInfo.put("createdAt", sdf.format(ticket.getCreatedAt()));
        
        data.put("ticket", ticketInfo);
        
        // Replies
        data.put("replies", replies);

        // Trả về JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
}
