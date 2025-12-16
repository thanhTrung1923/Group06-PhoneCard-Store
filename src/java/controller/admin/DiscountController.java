package controller.admin;

import dtos.PromotionListDTO;
import service.DiscountAdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDiscountController", urlPatterns = {"/admin/discounts"})
public class DiscountController extends HttpServlet {

    private final DiscountAdminService service = new DiscountAdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) action = "list";

        try {
            switch (action) {
                case "list" -> handleList(request, response);
                default -> handleList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/discounts/list.jsp").forward(request, response);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String keyword = trim(request.getParameter("keyword"));
        String timeStatus = trim(request.getParameter("timeStatus")); // UPCOMING/ONGOING/EXPIRED
        String activeFlag = trim(request.getParameter("active"));     // "", "1", "0"

        String sort = trim(request.getParameter("sort"));
        String dir = trim(request.getParameter("dir"));
        if (sort == null || sort.isBlank()) sort = "id";
        if (dir == null || dir.isBlank()) dir = "desc";

        int page = parseInt(request.getParameter("page"), 1);
        int size = parseInt(request.getParameter("size"), 10);

        List<PromotionListDTO> rows = service.searchPromotions(
                keyword, timeStatus, activeFlag, sort, dir, page, size
        );
        int total = service.countPromotions(keyword, timeStatus, activeFlag);
        int totalPages = (int) Math.ceil((double) total / size);

        request.setAttribute("rows", rows);
        request.setAttribute("total", total);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("keyword", keyword);
        request.setAttribute("timeStatus", timeStatus);
        request.setAttribute("active", activeFlag);

        request.setAttribute("sort", sort);
        request.setAttribute("dir", dir);

        request.getRequestDispatcher("/views/admin/discounts/list.jsp").forward(request, response);
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
