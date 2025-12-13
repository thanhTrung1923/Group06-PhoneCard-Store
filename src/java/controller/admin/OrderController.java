package controller.admin;

import dtos.OrderListDTO;
import service.OrderAdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders"})
public class OrderController extends HttpServlet {

    private final OrderAdminService orderService = new OrderAdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) action = "list";

        try {
            switch (action) {
                case "list" -> handleList(request, response);
                // case "detail" -> handleDetail(...); // step sau
                default -> handleList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/orders/list.jsp").forward(request, response);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");

        Date fromDate = parseDate(request.getParameter("fromDate"));
        Date toDate = parseDate(request.getParameter("toDate"));

        int page = parseInt(request.getParameter("page"), 1);
        int pageSize = 10;

        List<OrderListDTO> orders = orderService.searchOrders(status, keyword, fromDate, toDate, page, pageSize);
        int total = orderService.countOrders(status, keyword, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("orders", orders);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        // giữ lại filter trên form
        request.setAttribute("status", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("fromDate", request.getParameter("fromDate"));
        request.setAttribute("toDate", request.getParameter("toDate"));

        request.getRequestDispatcher("/views/admin/orders/list.jsp").forward(request, response);
    }

    private Date parseDate(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Date.valueOf(s.trim()); } catch (Exception e) { return null; }
    }

    private int parseInt(String s, int defaultVal) {
        try { return Integer.parseInt(s); } catch (Exception e) { return defaultVal; }
    }
}
