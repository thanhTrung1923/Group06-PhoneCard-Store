/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.SupportTicketDAO;
import model.SupportTicket;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminTicketController", urlPatterns = {"/admin-tickets"})
public class AdminTicketController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        SupportTicketDAO dao = new SupportTicketDAO();
        List<SupportTicket> list = dao.getAllTickets();
        
        request.setAttribute("ticketList", list);
        request.getRequestDispatcher("admin-ticket-list.jsp").forward(request, response);
    }
}
