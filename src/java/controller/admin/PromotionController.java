package controller.admin;

import dtos.PromotionListDTO;
import service.PromotionAdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DiscountController", urlPatterns = {"/admin/discounts"})
public class PromotionController extends HttpServlet {

    private final PromotionAdminService service = new PromotionAdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) action = "list";

        try {
            if ("list".equalsIgnoreCase(action)) {
                handleList(request, response);
                return;
            }
            handleList(request, response);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/discounts/list.jsp").forward(request, response);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String keyword = request.getParameter("keyword");
        String timeStatus = request.getParameter("timeStatus"); // ALL/UPCOMING/RUNNING/EXPIRED
        String isActive = request.getParameter("isActive");     // ALL/1/0
        int page = parseInt(request.getParameter("page"), 1);
        int pageSize = 10;

        List<PromotionListDTO> list = service.search(keyword, timeStatus, isActive, page, pageSize);
        int total = service.count(keyword, timeStatus, isActive);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("promotions", list);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("keyword", keyword);
        request.setAttribute("timeStatus", timeStatus == null ? "ALL" : timeStatus);
        request.setAttribute("isActive", isActive == null ? "ALL" : isActive);

        request.getRequestDispatcher("/views/admin/discounts/list.jsp").forward(request, response);
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
