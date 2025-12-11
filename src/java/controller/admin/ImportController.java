package controller.admin;

import dao.admin.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // Quan trọng để upload file
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Card;
import model.Supplier;
import service.ExcelService;

@WebServlet("/admin/import")
@MultipartConfig // BẮT BUỘC PHẢI CÓ DÒNG NÀY MỚI NHẬN ĐƯỢC FILE
public class ImportController extends HttpServlet {

    // Xử lý GET: Hiển thị trang nhập hàng (cần list nhà cung cấp để chọn)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        InventoryDAO dao = new InventoryDAO();
        List<Supplier> suppliers = dao.getAllSuppliers();
        
        req.setAttribute("listSupplier", suppliers); // Đẩy dữ liệu sang JSP
        req.getRequestDispatcher("/views/admin/import.jsp").forward(req, resp);
    }

    // Xử lý POST: Khi bấm nút "Upload"
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        try {
            // 1. Lấy thông tin từ Form
            int supplierId = Integer.parseInt(req.getParameter("supplier_id"));
            Part filePart = req.getPart("file_excel"); // Lấy file từ input name="file_excel"
            
            // 2. Gọi Service đọc file Excel -> List Card
            ExcelService excelService = new ExcelService();
            List<Card> listCards = excelService.parseExcel(filePart.getInputStream());
            
            // Gán supplier ID cho tất cả các thẻ vừa đọc được
            for(Card c : listCards) {
                c.setSupplierId(supplierId);
            }
            
            // 3. Gọi DAO lưu vào Database (Bước này ta sẽ làm kỹ ở DAO sau - Transaction)
            // InventoryDAO dao = new InventoryDAO();
            // boolean result = dao.importBatchTransaction(..., listCards);
            
            req.setAttribute("message", "Đã đọc được " + listCards.size() + " thẻ từ file!");
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi nhập hàng: " + e.getMessage());
        }
        // Quay lại trang import để báo kết quả
        doGet(req, resp);
    }
}