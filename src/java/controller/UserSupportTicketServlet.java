/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import dao.SupportTicketDAO;
import dao.TicketReplyDAO;
import model.SupportTicket;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/support")
public class UserSupportTicketServlet extends HttpServlet {

    private SupportTicketDAO dao = new SupportTicketDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private TicketReplyDAO replyDAO = new TicketReplyDAO(); // ✅ THÊM

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "history";

        User user = (User) session.getAttribute("account");

        switch (action) {

            case "create":
                request.setAttribute(
                        "orders",
                        orderDAO.getOrdersByUser(user.getUserId())
                );
                request.getRequestDispatcher("/create-ticket.jsp")
                        .forward(request, response);
                break;

            case "detail":
                long ticketId = Long.parseLong(request.getParameter("ticketId"));

                SupportTicket ticket = dao.getTicketById(ticketId, user.getUserId());
                if (ticket == null) {
                    response.sendRedirect(request.getContextPath() + "/support?action=history");
                    return;
                }

                request.setAttribute("ticket", ticket);
                request.setAttribute(
                        "replies",
                        replyDAO.getRepliesByTicket(ticketId)
                );

                request.getRequestDispatcher("/ticket-detail.jsp")
                        .forward(request, response);
                break;

            case "history":
            default:
                List<SupportTicket> tickets = dao.getTicketsByUser(user.getUserId());
                request.setAttribute("tickets", tickets);
                request.getRequestDispatcher("/ticket-history.jsp")
                        .forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");

        SupportTicket t = new SupportTicket();
        t.setUserId(user.getUserId());
        t.setSubject(request.getParameter("subject"));
        t.setContent(request.getParameter("content"));
        t.setPriority(request.getParameter("priority"));

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            t.setOrderId(Long.parseLong(orderIdStr));
        }

        dao.createTicket(t);

        session.setAttribute("supportSuccess", true);
        response.sendRedirect(request.getContextPath() + "/support?action=history");
    }
}
