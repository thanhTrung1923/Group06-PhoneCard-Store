package controller.admin;

import dao.admin.InventoryDAO;
import model.Card;
import model.CardProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Đổi đường dẫn thành trang xem chi tiết

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

            // 1. Lấy thông tin chung của Sản phẩm (Header trang)
            CardProductDTO product = dao.getProductDetail(productId);
            
            // 2. Lấy danh sách các thẻ con (Bảng bên dưới)
            List<Card> cardList = dao.getCardsByProductId(productId);

            if (product == null) {
                req.setAttribute("error", "Sản phẩm không tồn tại!");
                req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
                return;
            }

            // 3. Đẩy sang JSP
            req.setAttribute("p", product);      // Product Info
            req.setAttribute("cards", cardList); // List Cards
            
            req.getRequestDispatcher("/views/admin/product-detail.jsp").forward(req, resp);
            

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
        }
    }
}