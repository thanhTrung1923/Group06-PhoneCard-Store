/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Order;
import model.OrderItem;
import model.User;
import java.sql.Timestamp;


/**
 *
 * @author ADMIN
 */
@WebServlet(name = "OrderDetailController", urlPatterns = {"/order-detail"})
public class OrderDetailController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OrderDetailController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderDetailController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 🔐 Check login
        HttpSession session = req.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null) {
            resp.sendRedirect("login");
            return;
        }

        // 🔐 Check orderId param
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect("order-history");
            return;
        }

        long orderId;
        try {
            orderId = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect("order-history");
            return;
        }

        OrderDAO dao = new OrderDAO();

        Order order = dao.getOrderById(orderId);
        if (order == null) {
            resp.sendRedirect("order-history");
            return;
        }

        // 🔒 Chỉ xem đơn của chính mình
        if (!order.getUserId().equals(u.getUserId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        Timestamp createdAtTs = null;
        if (order.getCreatedAt() != null) {
            createdAtTs = Timestamp.valueOf(order.getCreatedAt());
        }
        List<OrderItem> items = dao.getOrderItems(orderId);

        req.setAttribute("order", order);
        req.setAttribute("items", items);
        req.setAttribute("createdAtTs", createdAtTs);

        req.getRequestDispatcher("order-detail.jsp").forward(req, resp);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
