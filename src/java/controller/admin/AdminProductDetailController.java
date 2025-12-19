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

            String status = req.getParameter("status");
            String sort = req.getParameter("sort");   
            
            int page = 1;
            int pageSize = 10;
            if (req.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (NumberFormatException e) { page = 1; }
            }

            CardProductDTO product = dao.getProductDetail(productId);
            if (product == null) {
                req.setAttribute("error", "Sản phẩm không tồn tại!");
                req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
                return;
            }

            int totalCards = dao.countCardsByProductId(productId, status);
            int totalPages = (int) Math.ceil((double) totalCards / pageSize);
            List<Card> cardList = dao.getCardsByProductId(productId, status, sort, page, pageSize);

            req.setAttribute("p", product);   
            req.setAttribute("cards", cardList);
            
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            
            req.setAttribute("filterStatus", status);
            req.setAttribute("filterSort", sort);

            req.getRequestDispatcher("/views/admin/product-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
        }
    }

}
