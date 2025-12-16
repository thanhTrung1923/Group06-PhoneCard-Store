package controller.admin;

import dao.admin.InventoryDAO;
import model.Card;
import model.CardProductDTO;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;


public class CreateCardController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        InventoryDAO dao = new InventoryDAO();
        
        List<CardProductDTO> products = dao.getAllProductNames();

        List<Supplier> suppliers = dao.getAllSuppliers();
        
        req.setAttribute("listProducts", products);
        req.setAttribute("listSuppliers", suppliers);
        
        req.getRequestDispatcher("/views/admin/create-card.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String productIdStr = req.getParameter("product_id");
            String supplierIdStr = req.getParameter("supplier_id");
            String serial = req.getParameter("serial");
            String code = req.getParameter("code");
            String status = req.getParameter("status");

            if (serial == null || serial.trim().isEmpty() || code == null || code.trim().isEmpty()) {
                throw new Exception("Serial và Mã thẻ không được để trống!");
            }

            if (serial.trim().length() < 5 || code.trim().length() < 5) {
                throw new Exception("Serial hoặc Mã thẻ quá ngắn (Yêu cầu > 5 ký tự)!");
            }

            if (!code.trim().matches("^[0-9]+$")) {
                throw new Exception("Mã thẻ không hợp lệ! (Chỉ được chứa số)");
            }

            boolean hasLetter = serial.matches(".*[a-zA-Z].*");
            boolean hasDigit = serial.matches(".*[0-9].*");
            
            if (!hasLetter || !hasDigit) {
                throw new Exception("Serial không hợp lệ! (Phải chứa cả CHỮ và SỐ, ví dụ: VT-12345)");
            }
            
            int productId = Integer.parseInt(productIdStr);
            int supplierId = Integer.parseInt(supplierIdStr);
            
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