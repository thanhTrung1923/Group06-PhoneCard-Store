package controller.admin;

import dtos.ProductOptionDTO;
import dtos.PromotionDTO;
import dtos.PromotionDetailDTO;
import dtos.PromotionListDTO;
import service.DiscountAdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
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
                case "detail" -> handleDetail(request, response);
                default -> handleList(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/discounts/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "updatePromotion" -> postUpdatePromotion(request, response);
                case "upsertDetail" -> postUpsertDetail(request, response);
                case "deleteDetail" -> postDeleteDetail(request, response);
                case "deletePromotion" -> postDeletePromotion(request, response);
                default -> response.sendRedirect(request.getContextPath() + "/admin/discounts?action=list");
            }
        } catch (Exception e) {
            // nếu lỗi: quay lại detail kèm error
            String id = request.getParameter("id");
            if (id != null && !id.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/admin/discounts?action=detail&id=" + id + "&msg=error");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/discounts?action=list&msg=error");
            }
        }
    }

    // ================= LIST =================
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

    // ================= DETAIL =================
    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int id = parseInt(request.getParameter("id"), -1);
        if (id <= 0) throw new IllegalArgumentException("Thiếu id khuyến mãi!");

        PromotionDTO p = service.getPromotion(id);
        if (p == null) throw new IllegalArgumentException("Không tìm thấy khuyến mãi: " + id);

        List<PromotionDetailDTO> items = service.getPromotionDetails(id);
        List<ProductOptionDTO> products = service.getProductOptions();

        request.setAttribute("p", p);
        request.setAttribute("items", items);
        request.setAttribute("products", products);
        request.setAttribute("msg", request.getParameter("msg"));

        request.getRequestDispatcher("/views/admin/discounts/detail.jsp").forward(request, response);
    }

    // ================= POST =================
    private void postUpdatePromotion(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = parseInt(request.getParameter("id"), -1);
        String name = trim(request.getParameter("name"));
        String startStr = trim(request.getParameter("startAt"));
        String endStr = trim(request.getParameter("endAt"));
        String activeStr = trim(request.getParameter("active"));

        if (id <= 0) throw new IllegalArgumentException("Invalid id");
        if (name == null || name.isBlank()) throw new IllegalArgumentException("Name required");

        Timestamp startAt = parseTs(startStr);
        Timestamp endAt = parseTs(endStr);
        boolean active = "1".equals(activeStr) || "true".equalsIgnoreCase(activeStr);

        if (startAt == null || endAt == null) throw new IllegalArgumentException("Start/End required");
        if (startAt.after(endAt)) throw new IllegalArgumentException("Start phải <= End");

        boolean ok = service.updatePromotion(id, name, startAt, endAt, active);
        response.sendRedirect(request.getContextPath() + "/admin/discounts?action=detail&id=" + id + "&msg=" + (ok ? "updated" : "failed"));
    }

    private void postUpsertDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = parseInt(request.getParameter("id"), -1);
        int productId = parseInt(request.getParameter("productId"), -1);
        double percent = parseDouble(request.getParameter("discountPercent"), -1);

        if (id <= 0 || productId <= 0) throw new IllegalArgumentException("Invalid id/product");
        if (percent <= 0 || percent > 100) throw new IllegalArgumentException("Percent 0..100");

        boolean ok = service.upsertPromotionDetail(id, productId, percent);
        response.sendRedirect(request.getContextPath() + "/admin/discounts?action=detail&id=" + id + "&msg=" + (ok ? "saved" : "failed"));
    }

    private void postDeleteDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = parseInt(request.getParameter("id"), -1);
        int productId = parseInt(request.getParameter("productId"), -1);

        boolean ok = service.deletePromotionDetail(id, productId);
        response.sendRedirect(request.getContextPath() + "/admin/discounts?action=detail&id=" + id + "&msg=" + (ok ? "deleted" : "failed"));
    }

    private void postDeletePromotion(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = parseInt(request.getParameter("id"), -1);

        boolean ok = service.deletePromotion(id);
        response.sendRedirect(request.getContextPath() + "/admin/discounts?action=list&msg=" + (ok ? "deleted" : "failed"));
    }

    // ================= helpers =================
    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private double parseDouble(String s, double def) {
        try { return Double.parseDouble(s); } catch (Exception e) { return def; }
    }

    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    // input datetime-local: yyyy-MM-ddTHH:mm  => Timestamp yyyy-MM-dd HH:mm:ss
    private Timestamp parseTs(String s) {
        if (s == null || s.isBlank()) return null;
        String v = s.trim();
        if (v.contains("T")) v = v.replace("T", " ") + ":00";
        return Timestamp.valueOf(v);
    }
}
