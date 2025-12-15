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
            if ("create".equalsIgnoreCase(action)) { 
                handleCreate(request, response); 
                return; 
            }
             
            if ("edit".equalsIgnoreCase(action))   { 
                handleEdit(request, response); 
                return; }

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
    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws Exception {
    request.setAttribute("products", service.listProducts());
    request.getRequestDispatcher("/views/admin/discounts/create.jsp").forward(request, response);
}

private void handleEdit(HttpServletRequest request, HttpServletResponse response) throws Exception {
    int id = Integer.parseInt(request.getParameter("id"));
    var promo = service.getPromotion(id);
    if (promo == null) throw new IllegalArgumentException("Promotion not found: " + id);

    request.setAttribute("promo", promo);
    request.setAttribute("products", service.listProducts());
    request.setAttribute("discountMap", service.getPromotionDiscountMap(id));

    request.getRequestDispatcher("/views/admin/discounts/edit.jsp").forward(request, response);
}

private void handleCreateSubmit(HttpServletRequest request, HttpServletResponse response) throws Exception {
    var form = readPromotionForm(request, 0);
    var details = readDetails(request);

    // demo: lấy user_id admin = 1, bạn thay bằng session login sau
    int createdBy = 1;

    int newId = service.createPromotion(form, createdBy, details);
    response.sendRedirect(request.getContextPath() + "/admin/discounts?action=edit&id=" + newId + "&msg=created");
}

private void handleEditSubmit(HttpServletRequest request, HttpServletResponse response) throws Exception {
    int id = Integer.parseInt(request.getParameter("id"));
    var form = readPromotionForm(request, id);
    var details = readDetails(request);

    service.updatePromotion(form, details);
    response.sendRedirect(request.getContextPath() + "/admin/discounts?action=edit&id=" + id + "&msg=updated");
}

private dtos.PromotionFormDTO readPromotionForm(HttpServletRequest request, int id) {
    String name = request.getParameter("promotionName");
    String desc = request.getParameter("description");
    String start = request.getParameter("startAt"); // yyyy-MM-ddTHH:mm
    String end   = request.getParameter("endAt");
    boolean active = request.getParameter("isActive") != null;

    dtos.PromotionFormDTO f = new dtos.PromotionFormDTO();
    f.setPromotionId(id);
    f.setPromotionName(name);
    f.setDescription(desc);
    f.setActive(active);

    // parse datetime-local -> Timestamp
    f.setStartAt(java.sql.Timestamp.valueOf(start.replace("T", " ") + ":00"));
    f.setEndAt(java.sql.Timestamp.valueOf(end.replace("T", " ") + ":00"));

    return f;
}

private java.util.Map<Integer, java.math.BigDecimal> readDetails(HttpServletRequest request) {
    String[] pids = request.getParameterValues("pid"); // checkbox selected
    java.util.Map<Integer, java.math.BigDecimal> map = new java.util.HashMap<>();
    if (pids == null) return map;

    for (String s : pids) {
        int pid = Integer.parseInt(s);
        String discStr = request.getParameter("disc_" + pid);
        java.math.BigDecimal disc = new java.math.BigDecimal(discStr);
        map.put(pid, disc);
    }
    return map;
}


    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    
    //
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");
    if (action == null) action = "";

    try {
        if ("createSubmit".equalsIgnoreCase(action)) {
            handleCreateSubmit(request, response);
            return;
        }
        if ("editSubmit".equalsIgnoreCase(action)) {
            handleEditSubmit(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/discounts?action=list");
    } catch (Exception e) {
        request.setAttribute("error", e.getMessage());
        try {
            // reload create/edit page with error
            String back = request.getParameter("back");
            if ("edit".equals(back)) {
                handleEdit(request, response);
            } else {
                handleCreate(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
    
}

}
