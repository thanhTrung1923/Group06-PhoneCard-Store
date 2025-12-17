package service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import model.Card;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelService {

    // [THAY ĐỔI] Thêm tham số targetProductId vào hàm
    public List<Card> parseExcel(InputStream is, int targetProductId) throws Exception {
        List<Card> list = new ArrayList<>();
        Workbook workbook = new XSSFWorkbook(is);
        Sheet sheet = workbook.getSheetAt(0);

        // Bỏ qua dòng tiêu đề (Header row index = 0)
        // Bắt đầu duyệt từ dòng 1
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            // Kiểm tra ô Serial (Cột 0) có dữ liệu không, nếu rỗng thì bỏ qua dòng này
            Cell cellSerial = row.getCell(0);
            if (cellSerial == null || cellSerial.getCellType() == CellType.BLANK) continue;

            Card c = new Card();

            // 1. GÁN PRODUCT ID (Lấy từ tham số người dùng chọn)
            c.setProductId(targetProductId);

            // 2. LẤY SERIAL (Cột A - Index 0)
            DataFormatter fmt = new DataFormatter();
            String serial = fmt.formatCellValue(cellSerial).trim();
            
            // Validate Serial
            if (serial.length() < 5) {
                // throw new Exception("Lỗi dòng " + (i + 1) + ": Serial quá ngắn.");
                // Hoặc bỏ qua dòng lỗi tùy nghiệp vụ
                continue; 
            }
            c.setSerial(serial);

            // 3. LẤY CODE (Cột B - Index 1)
            Cell cellCode = row.getCell(1);
            String code = (cellCode != null) ? fmt.formatCellValue(cellCode).trim() : "";
            
            // Validate Code (Chỉ số)
            if (!code.matches("^[0-9]+$")) {
                 throw new Exception("Lỗi dòng " + (i + 1) + ": Mã thẻ '" + code + "' sai định dạng (chỉ được chứa số).");
            }
            c.setCode(code);

            // Trạng thái mặc định
            c.setStatus("IN_STOCK"); // Dùng String trực tiếp hoặc Constant từ Model
            
            list.add(c);
        }
        workbook.close();
        
        return list;
    }
}