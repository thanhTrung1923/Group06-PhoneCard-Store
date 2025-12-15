package controller;

import dao.OrderDAO;
import model.Order;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "OrderHistoryController", urlPatterns = "/order-history")
public class OrderHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
         
        
        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getOrdersByUserId(u.getUserId());
   
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("order-history.jsp").forward(req, resp);
    }
}
