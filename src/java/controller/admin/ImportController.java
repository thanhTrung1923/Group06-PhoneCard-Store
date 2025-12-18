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
            String targetProductIdStr = req.getParameter("target_product_id");
            Part filePart = req.getPart("file_excel");

            if (targetProductIdStr == null || filePart == null || filePart.getSize() <= 0) {
                throw new Exception("Vui lòng chọn Sản phẩm và file dữ liệu!");
            }

            int targetProductId = Integer.parseInt(targetProductIdStr);

            ExcelService excelService = new ExcelService();
            List<Card> listCards = excelService.parseExcel(filePart.getInputStream(), targetProductId);

            if (listCards.isEmpty()) {
                throw new Exception("File Excel rỗng hoặc không có dữ liệu hợp lệ!");
            }

            for (Card c : listCards) {
                c.setSupplierId(null); 
            }
            
            ImportBatch batch = new ImportBatch();
            
            batch.setSupplierId(null);
            
            batch.setFileName(filePart.getSubmittedFileName()); 
            batch.setTotalCards(listCards.size());
            batch.setTotalAmount(0.0); 
            
            batch.setImportedBy(1); 
            
            batch.setNote("Import Direct for Product ID: " + targetProductId);

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