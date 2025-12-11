package service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import model.Card;
import org.apache.poi.ss.usermodel.*; // Import của Apache POI
import org.apache.poi.xssf.usermodel.XSSFWorkbook; // Dùng cho file .xlsx

public class ExcelService {

    public List<Card> parseExcel(InputStream is) throws Exception {
        List<Card> list = new ArrayList<>();
        
        // Mở file Excel từ luồng input
        Workbook workbook = new XSSFWorkbook(is);
        Sheet sheet = workbook.getSheetAt(0); // Lấy sheet 1

        // Duyệt từ dòng thứ 1 (bỏ dòng tiêu đề index 0)
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            Card c = new Card();
            
            // Giả sử Excel cột A: ProductID, B: Serial, C: Code
            // Lưu ý: Cần xử lý ngoại lệ nếu ô trống hoặc sai định dạng
            
            // Lấy Product ID (Số nguyên)
            // getNumericCellValue trả về double -> ép kiểu về int
            c.setProductId((int) row.getCell(0).getNumericCellValue()); 
            
            // Lấy Serial (Chuỗi) - Dùng DataFormatter để an toàn (tránh lỗi số khoa học 1.2E9)
            DataFormatter fmt = new DataFormatter();
            c.setSerial(fmt.formatCellValue(row.getCell(1)));
            
            // Lấy Code (Chuỗi)
            c.setCode(fmt.formatCellValue(row.getCell(2)));
            
            c.setStatus("IN_STOCK"); // Mặc định là hàng trong kho
            
            list.add(c);
        }
        
        workbook.close();
        return list;
    }
}