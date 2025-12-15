package controller.admin;

import dao.admin.InventoryDAO;
import model.Card;
import model.CardProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // [MỚI] Import annotation
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder; // [MỚI] Dùng cho doPost
import java.nio.charset.StandardCharsets; // [MỚI] Dùng cho doPost
import java.util.List;
import java.util.Arrays; // Có thể bỏ nếu không dùng trực tiếp Arrays.asList trong code này


public class ProductDetailController extends HttpServlet {

    // --- XỬ LÝ GET: HIỂN THỊ TRANG CHI TIẾT ---
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

            // 1. Lấy thông tin chung của Sản phẩm (Header trang)
            CardProductDTO product = dao.getProductDetail(productId);
            
            // 2. Lấy danh sách các thẻ con (Bảng bên dưới)
            List<Card> cardList = dao.getCardsByProductId(productId);

            if (product == null) {
                req.setAttribute("error", "Sản phẩm không tồn tại!");
                req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
                return;
            }

            // [MỚI] 3. Lấy danh sách tất cả sản phẩm để dùng cho Modal "Move to Another Product"
            // (Hàm này cần trả về danh sách rút gọn id và name để hiển thị trong thẻ <select>)
            req.setAttribute("allProducts", new InventoryDAO().getAllProductNames());

            // 4. Đẩy dữ liệu sang JSP
            req.setAttribute("p", product);      // Product Info
            req.setAttribute("cards", cardList); // List Cards
            
            req.getRequestDispatcher("/views/admin/product-detail.jsp").forward(req, resp);
            

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
        }
    }

    // --- [MỚI] XỬ LÝ POST: BULK ACTIONS (Move, Delete, Change Status) ---
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String currentProductId = req.getParameter("currentProductId");
        String action = req.getParameter("bulkAction"); // status, move, delete
        String[] selectedIds = req.getParameterValues("selectedCards"); // Mảng ID các thẻ đã chọn
        
        // Kiểm tra nếu chưa chọn thẻ nào
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
            
            // (Optional) Cập nhật lại số lượng tồn kho nếu cần thiết logic DB không tự trigger
            // dao.syncProductQuantity(Integer.parseInt(currentProductId)); 

        } catch (Exception e) {
            e.printStackTrace();
            success = false;
            msg = "Đã xảy ra lỗi hệ thống: " + e.getMessage();
        }

        // Tạo URL redirect kèm thông báo
        String redirectUrl = req.getContextPath() + "/admin/inventory/detail?id=" + currentProductId;
        if (success) {
            redirectUrl += "&message=" + URLEncoder.encode(msg, StandardCharsets.UTF_8);
        } else {
            redirectUrl += "&error=" + URLEncoder.encode("Thao tác thất bại hoặc lỗi server.", StandardCharsets.UTF_8);
        }
        
        resp.sendRedirect(redirectUrl);
    }
}