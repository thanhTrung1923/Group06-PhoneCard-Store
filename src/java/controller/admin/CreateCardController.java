package controller.admin;

import dao.admin.InventoryDAO;
import model.Card;
import model.CardProductDTO;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/admin/inventory/create")
public class CreateCardController extends HttpServlet {
    // GET: Hiển thị form tạo mới
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        InventoryDAO dao = new InventoryDAO();
        
        // Lấy danh sách Sản phẩm (Để chọn loại thẻ)
        List<CardProductDTO> products = dao.getAllProductNames();
        
        // Lấy danh sách Nhà cung cấp
        List<Supplier> suppliers = dao.getAllSuppliers();
        
        req.setAttribute("listProducts", products);
        req.setAttribute("listSuppliers", suppliers);
        
        req.getRequestDispatcher("/views/admin/create-card.jsp").forward(req, resp);
    }

    // POST: Xử lý lưu thẻ
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // 1. Lấy dữ liệu từ Form
            int productId = Integer.parseInt(req.getParameter("product_id"));
            int supplierId = Integer.parseInt(req.getParameter("supplier_id"));
            String serial = req.getParameter("serial");
            String code = req.getParameter("code");
            String status = req.getParameter("status"); // IN_STOCK, RESERVED...
            
            // 2. Tạo đối tượng Card
            Card c = new Card(productId, supplierId, serial, code, status);
            
            // 3. Gọi DAO
            InventoryDAO dao = new InventoryDAO();
            boolean success = dao.createCardManual(c);
            
            if (success) {
                String msg = "Tạo mới thẻ thành công!";
                resp.sendRedirect(req.getContextPath() + "/admin/inventory?message=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            } else {
                req.setAttribute("error", "Lỗi: Không thể lưu vào Database.");
                // Nếu lỗi thì giữ lại trang hiện tại và load lại list để không bị trắng trang
                doGet(req, resp); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Quay lại trang form và báo lỗi
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(req, resp);
        }
    }
}