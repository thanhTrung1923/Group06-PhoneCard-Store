package controller.admin;

import dao.admin.InventoryDAO;
import model.Card;
import model.CardProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; 
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder; 
import java.nio.charset.StandardCharsets; 
import java.util.List;
import java.util.Arrays; 


public class ProductDetailController extends HttpServlet {

   @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/inventory");
                return;
            }

            int productId = Integer.parseInt(idStr);
            InventoryDAO dao = new InventoryDAO();

            // --- XỬ LÝ PHÂN TRANG CARD ---
            int page = 1;
            int pageSize = 10; // Yêu cầu: 10 card mỗi trang
            if (req.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (NumberFormatException e) { page = 1; }
            }

            // 1. Lấy thông tin sản phẩm
            CardProductDTO product = dao.getProductDetail(productId);
            
            if (product == null) {
                req.setAttribute("error", "Sản phẩm không tồn tại!");
                req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
                return;
            }

            // 2. Tính toán phân trang thẻ
            int totalCards = dao.countCardsByProductId(productId);
            int totalPages = (int) Math.ceil((double) totalCards / pageSize);

            // 3. Lấy danh sách thẻ theo trang
            List<Card> cardList = dao.getCardsByProductId(productId, page, pageSize);

            req.setAttribute("allProducts", dao.getAllProductNames());
            req.setAttribute("p", product);   
            req.setAttribute("cards", cardList);
            
            // Gửi thông tin phân trang sang JSP
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            
            req.getRequestDispatcher("/views/admin/product-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String currentProductId = req.getParameter("currentProductId");
        String action = req.getParameter("bulkAction"); 
        String[] selectedIds = req.getParameterValues("selectedCards"); 
        
        if (selectedIds == null || selectedIds.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/inventory/detail?id=" + currentProductId + "&error=NoSelection");
            return;
        }

        InventoryDAO dao = new InventoryDAO();
        boolean success = false;
        String msg = "";

        try {
            switch (action) {
                case "change_status":
                    String newStatus = req.getParameter("targetStatus");
                    success = dao.bulkUpdateStatus(selectedIds, newStatus);
                    msg = "Đã cập nhật trạng thái " + selectedIds.length + " thẻ.";
                    break;
                    
                case "mark_defective":
                    success = dao.bulkUpdateStatus(selectedIds, "DEFECTIVE");
                    msg = "Đã đánh dấu lỗi " + selectedIds.length + " thẻ.";
                    break;
                    
                case "move_product":
                    int targetProductId = Integer.parseInt(req.getParameter("targetProductId"));
                    success = dao.bulkMoveProduct(selectedIds, targetProductId);
                    msg = "Đã di chuyển " + selectedIds.length + " thẻ sang sản phẩm mới.";
                    break;
                    
                case "delete":
                    success = dao.bulkDeleteCards(selectedIds);
                    msg = "Đã xóa vĩnh viễn " + selectedIds.length + " thẻ.";
                    break;
                
                default:
                    msg = "Hành động không hợp lệ.";
                    success = false;
            }
            

        } catch (Exception e) {
            e.printStackTrace();
            success = false;
            msg = "Đã xảy ra lỗi hệ thống: " + e.getMessage();
        }

        String redirectUrl = req.getContextPath() + "/admin/inventory/detail?id=" + currentProductId;
        if (success) {
            redirectUrl += "&message=" + URLEncoder.encode(msg, StandardCharsets.UTF_8);
        } else {
            redirectUrl += "&error=" + URLEncoder.encode("Thao tác thất bại hoặc lỗi server.", StandardCharsets.UTF_8);
        }
        
        resp.sendRedirect(redirectUrl);
    }
}