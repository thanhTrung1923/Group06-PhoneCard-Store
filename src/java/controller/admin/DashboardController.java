package controller.admin;

import dao.admin.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

// Đường dẫn trang chủ Admin

public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        DashboardDAO dao = new DashboardDAO();
        Map<String, Object> metrics = dao.getDashboardMetrics();
        
        req.setAttribute("metrics", metrics);
        
        // Forward sang trang JSP giao diện
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}