package service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import model.Card;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelService {

    public List<Card> parseExcel(InputStream is) throws Exception {
        List<Card> list = new ArrayList<>();
        Workbook workbook = new XSSFWorkbook(is);
        Sheet sheet = workbook.getSheetAt(0);

        // [FIX] Bắt đầu từ dòng 1 (Dòng 0 là tiêu đề: Product ID | Serial | Code)
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue; // Bỏ qua dòng trống

            // Kiểm tra nếu ô đầu tiên trống -> Coi như hết dữ liệu
            Cell cellId = row.getCell(0);
            if (cellId == null || cellId.getCellType() == CellType.BLANK) continue;

            Card c = new Card();
            
            // 1. Cột A: Product ID (Bắt buộc phải là SỐ)
            if (cellId.getCellType() == CellType.NUMERIC) {
                c.setProductId((int) cellId.getNumericCellValue());
            } else {
                // Nếu người dùng nhập chữ vào cột ID -> Báo lỗi dòng cụ thể
                throw new Exception("Lỗi dòng " + (i + 1) + ": Cột Product ID phải là số nguyên!");
            }

            // 2. Cột B: Serial (Chuyển mọi format sang String)
            DataFormatter fmt = new DataFormatter();
            String serial = fmt.formatCellValue(row.getCell(1)).trim();
            if (serial.length() < 5) { // Validate độ dài tối thiểu
                throw new Exception("Lỗi dòng " + (i + 1) + ": Serial quá ngắn (tối thiểu 5 ký tự).");
            }
            c.setSerial(serial);

            // 3. Cột C: Code
            String code = fmt.formatCellValue(row.getCell(2)).trim();
            if (code.length() < 5) {
                throw new Exception("Lỗi dòng " + (i + 1) + ": Mã thẻ quá ngắn.");
            }
            c.setCode(code);
            
            c.setStatus(Card.STATUS_IN_STOCK);
            list.add(c);
        }
        workbook.close();
        return list;
    }
}