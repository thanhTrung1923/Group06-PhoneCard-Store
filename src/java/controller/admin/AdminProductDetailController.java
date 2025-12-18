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
import java.util.List;


public class AdminProductDetailController extends HttpServlet {

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

            // --- LẤY THAM SỐ FILTER & SORT ---
            String status = req.getParameter("status"); // Lọc theo trạng thái
            String sort = req.getParameter("sort");     // asc (Cũ nhất) hoặc desc (Mới nhất)
            
            int page = 1;
            int pageSize = 10;
            if (req.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (NumberFormatException e) { page = 1; }
            }

            // 1. Lấy thông tin Header
            CardProductDTO product = dao.getProductDetail(productId);
            if (product == null) {
                req.setAttribute("error", "Sản phẩm không tồn tại!");
                req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
                return;
            }

            // 2. Lấy danh sách thẻ (Có Filter + Sort + Paging)
            int totalCards = dao.countCardsByProductId(productId, status);
            int totalPages = (int) Math.ceil((double) totalCards / pageSize);
            List<Card> cardList = dao.getCardsByProductId(productId, status, sort, page, pageSize);

            // 3. Đẩy dữ liệu sang JSP
            req.setAttribute("p", product);   
            req.setAttribute("cards", cardList);
            
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            
            // Giữ trạng thái filter để hiển thị lại trên UI
            req.setAttribute("filterStatus", status);
            req.setAttribute("filterSort", sort);

            req.getRequestDispatcher("/views/admin/product-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
        }
    }
    
    // Đã XÓA hàm doPost vì không còn chức năng Edit/Delete hàng loạt
}
