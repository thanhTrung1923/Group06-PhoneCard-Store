package controller.admin;

import dao.admin.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.CardProductDTO;

public class InventoryListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        InventoryDAO dao = new InventoryDAO();

        String keyword = req.getParameter("keyword");
        String type = req.getParameter("type");
        String status = req.getParameter("status");
        
        // --- XỬ LÝ PHÂN TRANG ---
        int page = 1;
        int pageSize = 5; // Ví dụ: 5 sản phẩm mỗi trang
        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) { page = 1; }
        }

        // 1. Đếm tổng số bản ghi thỏa mãn điều kiện tìm kiếm
        int totalRecords = dao.countProducts(keyword, type, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // 2. Lấy danh sách cho trang hiện tại
        List<CardProductDTO> list = dao.getProductList(keyword, type, status, page, pageSize);
        
        // ... (Các phần lấy stats, listProductsForImport giữ nguyên) ...
        Map<String, Integer> stats = dao.getInventoryStats();
        List<CardProductDTO> allProducts = dao.getAllProductNames();
        req.setAttribute("listProductsForImport", allProducts);

        // Gửi dữ liệu phân trang sang JSP
        req.setAttribute("inventoryList", list);
        req.setAttribute("stats", stats);
        
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        
        // Gửi lại các bộ lọc để giữ trạng thái khi chuyển trang
        req.setAttribute("filterKeyword", keyword);
        req.setAttribute("filterType", type);
        req.setAttribute("filterStatus", status);
        
        // ... (Phần message/error giữ nguyên) ...
        String message = req.getParameter("message");
        String error = req.getParameter("error");
        req.setAttribute("message", message);
        req.setAttribute("error", error);
        
        req.setAttribute("activePage", "inventory");

        req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}