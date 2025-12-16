package controller.admin;

import dao.admin.InventoryDAO;
import model.Card;
import model.ImportBatch;
import service.ExcelService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, 
    maxFileSize = 1024 * 1024 * 10,      
    maxRequestSize = 1024 * 1024 * 100   
)
public class ImportController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        try {
            // 1. Lấy dữ liệu từ Form Modal
            String supplierIdStr = req.getParameter("supplier_id");
            Part filePart = req.getPart("file_excel");

            if (supplierIdStr == null || filePart == null || filePart.getSize() <= 0) {
                throw new Exception("Vui lòng chọn nhà cung cấp và file dữ liệu!");
            }

            int supplierId = Integer.parseInt(supplierIdStr);

            // 2. Xử lý file Excel qua Service
            ExcelService excelService = new ExcelService();
            List<Card> listCards = excelService.parseExcel(filePart.getInputStream());

            if (listCards.isEmpty()) {
                throw new Exception("File Excel rỗng hoặc sai định dạng!");
            }

            // Gán Supplier ID cho list card
            for (Card c : listCards) {
                c.setSupplierId(supplierId);
            }
            
            // 3. Tạo đối tượng Batch info (Theo Model của Member 1)
            ImportBatch batch = new ImportBatch();
            batch.setSupplierId(supplierId);
            // Lưu ý: Member 1 đặt tên getter/setter là FileName (chữ N hoa)
            batch.setFileName(filePart.getSubmittedFileName()); 
            batch.setTotalCards(listCards.size());
            
            // Model dùng double, ta set tạm 0.0 (hoặc tính tổng giá nhập nếu có logic)
            batch.setTotalAmount(0.0); 
            
            // Lấy ID Admin từ Session (Giả sử session tên "acc")
            // model.User admin = (model.User) req.getSession().getAttribute("acc");
            // if (admin != null) batch.setImportedBy(admin.getId()); else 
            batch.setImportedBy(1); // Tạm fix cứng ID = 1 nếu chưa login
            
            batch.setNote("Imported via Web Admin");

            // 4. Gọi DAO lưu vào DB (Transaction)
            InventoryDAO dao = new InventoryDAO();
            boolean success = dao.importBatchTransaction(batch, listCards);

            if (success) {
                String msg = "Nhập kho thành công " + listCards.size() + " thẻ!";
                resp.sendRedirect(req.getContextPath() + "/admin/inventory?message=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            } else {
                throw new Exception("Lỗi Database: Không thể lưu lô hàng.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String error = "Lỗi: " + e.getMessage();
            resp.sendRedirect(req.getContextPath() + "/admin/inventory?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8));
        }
    }
}