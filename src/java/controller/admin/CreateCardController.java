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
            // 1. Lấy dữ liệu
            String productIdStr = req.getParameter("product_id");
            String supplierIdStr = req.getParameter("supplier_id");
            String serial = req.getParameter("serial");
            String code = req.getParameter("code");
            String status = req.getParameter("status");

            // --- [FIX] VALIDATE DỮ LIỆU ĐẦU VÀO ---
            
            // Check rỗng
            if (serial == null || serial.trim().isEmpty() || code == null || code.trim().isEmpty()) {
                throw new Exception("Serial và Mã thẻ không được để trống!");
            }
            
            // Check độ dài (Ví dụ: Serial phải > 5 ký tự)
            if (serial.trim().length() < 5 || code.trim().length() < 5) {
                throw new Exception("Serial hoặc Mã thẻ quá ngắn (Yêu cầu > 5 ký tự)!");
            }
            
            // Check số (Product ID và Supplier ID phải là số)
            int productId = Integer.parseInt(productIdStr);
            int supplierId = Integer.parseInt(supplierIdStr);

            // --- HẾT PHẦN VALIDATE ---

            Card c = new Card(productId, supplierId, serial.trim(), code.trim(), status);
            
            InventoryDAO dao = new InventoryDAO();
            boolean success = dao.createCardManual(c);
            
            if (success) {
                String msg = "Tạo thẻ thành công!";
                resp.sendRedirect(req.getContextPath() + "/admin/inventory?message=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            } else {
                req.setAttribute("error", "Lỗi: Không thể lưu vào Database (Có thể trùng Serial).");
                doGet(req, resp); 
            }
            
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Lỗi: Vui lòng chọn Sản phẩm và Nhà cung cấp hợp lệ.");
            doGet(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(req, resp);
        }
    }
}