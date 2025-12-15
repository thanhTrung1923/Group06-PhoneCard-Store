package controller.admin;

import dtos.OrderDetailDTO;
import dtos.OrderItemDTO;
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
                case "detail" -> handleDetail(request, response);
                case "edit" -> handleEdit(request, response);
                default -> handleList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.toString());
            request.getRequestDispatcher("/views/admin/orders/list.jsp").forward(request, response);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String status = trimOrNull(request.getParameter("status"));
        String keyword = trimOrNull(request.getParameter("keyword"));

        String fromRaw = request.getParameter("fromDate");
        String toRaw   = request.getParameter("toDate");

        Date fromDate = parseDate(fromRaw);
        Date toDate   = parseDate(toRaw);

        // ✅ validate From <= To
        if (fromDate != null && toDate != null && fromDate.after(toDate)) {
            request.setAttribute("dateError", "Ngày From không được lớn hơn ngày To.");

            request.setAttribute("orders", List.of());
            request.setAttribute("total", 0);
            request.setAttribute("page", 1);
            request.setAttribute("totalPages", 0);

            request.setAttribute("status", status);
            request.setAttribute("keyword", keyword);
            request.setAttribute("fromDate", fromRaw);
            request.setAttribute("toDate", toRaw);

            // sort defaults
            request.setAttribute("sort", "created");
            request.setAttribute("dir", "desc");

            request.getRequestDispatcher("/views/admin/orders/list.jsp").forward(request, response);
            return;
        }

        // ✅ sorting
        String sort = request.getParameter("sort");
        String dir  = request.getParameter("dir");
        if (sort == null || sort.isBlank()) sort = "created";
        if (dir == null || dir.isBlank()) dir = "desc";
        dir = dir.equalsIgnoreCase("asc") ? "asc" : "desc";

        int page = parseInt(request.getParameter("page"), 1);
        int pageSize = 10;

        List<OrderListDTO> orders = orderService.searchOrders(status, keyword, fromDate, toDate, sort, dir, page, pageSize);
        int total = orderService.countOrders(status, keyword, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("orders", orders);
        request.setAttribute("total", total);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("status", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("fromDate", fromRaw);
        request.setAttribute("toDate", toRaw);

        request.setAttribute("sort", sort);
        request.setAttribute("dir", dir);

        request.getRequestDispatcher("/views/admin/orders/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            if ("updateStatus".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                String status = request.getParameter("status");

                boolean ok = orderService.updateOrderStatus(id, status);
                String msg = ok ? "updated" : "failed";

                response.sendRedirect(request.getContextPath()
                        + "/admin/orders?action=detail&id=" + id + "&msg=" + msg);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders?action=list");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        long id = Long.parseLong(request.getParameter("id"));
        OrderDetailDTO detail = orderService.getOrderDetail(id);

        if (detail == null) {
            request.setAttribute("error", "Order not found: " + id);
            request.getRequestDispatcher("/views/admin/orders/list.jsp").forward(request, response);
            return;
        }

        List<OrderItemDTO> items = orderService.getOrderItems(id);

        request.setAttribute("order", detail);
        request.setAttribute("items", items);
        request.setAttribute("msg", request.getParameter("msg"));
        request.getRequestDispatcher("/views/admin/orders/detail.jsp").forward(request, response);
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        long id = Long.parseLong(request.getParameter("id"));
        OrderDetailDTO detail = orderService.getOrderDetail(id);

        if (detail == null) {
            request.setAttribute("error", "Order not found: " + id);
            request.getRequestDispatcher("/views/admin/orders/list.jsp").forward(request, response);
            return;
        }

        List<OrderItemDTO> items = orderService.getOrderItems(id);

        request.setAttribute("order", detail);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/views/admin/orders/edit.jsp").forward(request, response);
    }

    // ===== Helpers =====
    private Date parseDate(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Date.valueOf(s.trim()); } catch (Exception e) { return null; }
    }

    private int parseInt(String s, int defaultVal) {
        try { return Integer.parseInt(s); } catch (Exception e) { return defaultVal; }
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
