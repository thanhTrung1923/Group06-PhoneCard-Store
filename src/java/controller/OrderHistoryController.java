package controller;

import dao.OrderDAO;
import model.Order;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "OrderHistoryController", urlPatterns = "/order-history")
public class OrderHistoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User u = (User) session.getAttribute("account");

        if (u == null) {
            resp.sendRedirect("login");
            return;
        }

        String status = req.getParameter("status");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");

        int page = 1;
        int pageSize = 5;

        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        OrderDAO dao = new OrderDAO();

        List<Order> orders = dao.filterOrdersPaging(
                u.getUserId(),
                status,
                fromDate,
                toDate,
                page,
                pageSize
        );

        int totalOrders = dao.countOrders(
                u.getUserId(),
                status,
                fromDate,
                toDate
        );

        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        req.setAttribute("orders", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalOrders", totalOrders);

        req.getRequestDispatcher("order-history.jsp").forward(req, resp);
    }
}
