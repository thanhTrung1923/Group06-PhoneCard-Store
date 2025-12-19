/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupportTicketDAO;
import dao.TicketReplyDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.SupportTicket;
import model.User;

@WebServlet("/staff/support")
public class StaffSupportTicketController extends HttpServlet {

    private SupportTicketDAO ticketDAO = new SupportTicketDAO();
    private TicketReplyDAO replyDAO = new TicketReplyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User staff = (User) session.getAttribute("account");
        List<String> roles = staff.getRoles();

        if (!roles.contains("STAFF")) {
            String mess = "Bạn không thể vào trang này";
            request.setAttribute("errorMessage", mess);
            request.getRequestDispatcher("/home").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            long ticketId = Long.parseLong(request.getParameter("ticketId"));

            SupportTicket ticket = ticketDAO.getTicketByIdForStaff(ticketId);
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/staff/support");
                return;
            }

            request.setAttribute("ticket", ticket);
            request.setAttribute(
                    "replies",
                    replyDAO.getRepliesByTicket(ticketId)
            );

            request.getRequestDispatcher("/ticket-detail-staff.jsp")
                    .forward(request, response);
            return;
        }

        List<SupportTicket> tickets = ticketDAO.getAllTickets();
        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("/ticket-list-staff.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User staff = (User) session.getAttribute("account");
        
        if (staff == null || !staff.getRoles().contains("STAFF")) {
            response.sendRedirect(request.getContextPath() + "/logout");
            return;
        }

        long ticketId = Long.parseLong(request.getParameter("ticketId"));
        String reply = request.getParameter("reply");
        String status = request.getParameter("status");

        replyDAO.addStaffReply(ticketId, staff.getUserId(), reply);
        ticketDAO.updateStatus(ticketId, status, staff.getUserId());

        response.sendRedirect(request.getContextPath() + "/staff/support");
    }
}
