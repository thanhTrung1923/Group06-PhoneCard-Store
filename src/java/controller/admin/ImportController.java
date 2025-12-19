//package controller.admin;
//
//import dao.admin.InventoryDAO;
//import model.Card;
//import model.ImportBatch;
//import service.ExcelService;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import java.net.URLEncoder;
//import java.nio.charset.StandardCharsets;
//import java.util.List;
//
//@MultipartConfig(
//    fileSizeThreshold = 1024 * 1024 * 1, 
//    maxFileSize = 1024 * 1024 * 10,      
//    maxRequestSize = 1024 * 1024 * 100   
//)
//public class ImportController extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
//            throws ServletException, IOException {
//        try {
//            // 1. [THAY ĐỔI] Lấy Product ID từ Form (Thay vì Supplier)
//            String targetProductIdStr = req.getParameter("target_product_id");
//            Part filePart = req.getPart("file_excel");
//
//            if (targetProductIdStr == null || filePart == null || filePart.getSize() <= 0) {
//                throw new Exception("Vui lòng chọn Sản phẩm và file dữ liệu!");
//            }
//
//            int targetProductId = Integer.parseInt(targetProductIdStr);
//
//            // 2. Xử lý file Excel qua Service (Truyền thêm targetProductId)
//            ExcelService excelService = new ExcelService();
//            List<Card> listCards = excelService.parseExcel(filePart.getInputStream(), targetProductId);
//
//            if (listCards.isEmpty()) {
//                throw new Exception("File Excel rỗng hoặc không có dữ liệu hợp lệ!");
//            }
//
//            // Gán Supplier ID là NULL cho list card (Vì user không chọn nữa)
//            for (Card c : listCards) {
//                c.setSupplierId(null); 
//            }
//            
//            // 3. Tạo đối tượng Batch info
//            ImportBatch batch = new ImportBatch();
//            
//            // [QUAN TRỌNG] Set Supplier là NULL
//            batch.setSupplierId(null);
//            
//            batch.setFileName(filePart.getSubmittedFileName()); 
//            batch.setTotalCards(listCards.size());
//            batch.setTotalAmount(0.0); 
//            
//            // Lấy ID Admin (Giữ nguyên logic cũ)
//            batch.setImportedBy(1); 
//            
//            // Update Note để biết nhập cho SP nào
//            batch.setNote("Import Direct for Product ID: " + targetProductId);
//
//            // 4. Gọi DAO lưu vào DB
//            InventoryDAO dao = new InventoryDAO();
//            boolean success = dao.importBatchTransaction(batch, listCards);
//
//            if (success) {
//                String msg = "Nhập kho thành công " + listCards.size() + " thẻ!";
//                resp.sendRedirect(req.getContextPath() + "/admin/inventory?message=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
//            } else {
//                throw new Exception("Lỗi Database: Không thể lưu lô hàng.");
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            String error = "Lỗi: " + e.getMessage();
//            resp.sendRedirect(req.getContextPath() + "/admin/inventory?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8));
//        }
//    }
//}