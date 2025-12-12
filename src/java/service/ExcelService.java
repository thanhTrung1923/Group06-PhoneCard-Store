package service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Card;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelService {

    public List<Card> parseExcel(InputStream is) throws Exception {
        List<Card> list = new ArrayList<>();
        Workbook workbook = new XSSFWorkbook(is);
        Sheet sheet = workbook.getSheetAt(0);

        // 1. ĐỌC HEADER ĐỂ TÌM VỊ TRÍ CỘT (SMART MAPPING)
        Row headerRow = sheet.getRow(0);
        if (headerRow == null) throw new Exception("File Excel rỗng (thiếu dòng tiêu đề)!");

        Map<String, Integer> colMap = new HashMap<>();
        for (Cell cell : headerRow) {
            // Đọc tên cột, xóa dấu cách, chuyển về chữ thường để so sánh
            String header = cell.getStringCellValue().trim().toLowerCase();
            colMap.put(header, cell.getColumnIndex());
        }

        // Kiểm tra xem file có đủ các cột bắt buộc không
        // Chấp nhận các tên cột: "product id", "id", "serial", "code", "mã thẻ"...
        Integer idxId = colMap.getOrDefault("product id", colMap.get("id"));
        Integer idxSerial = colMap.get("serial");
        Integer idxCode = colMap.getOrDefault("code", colMap.get("mã thẻ"));

        if (idxId == null || idxSerial == null || idxCode == null) {
            throw new Exception("File Excel thiếu cột bắt buộc! (Yêu cầu: Product ID, Serial, Code)");
        }

        // 2. DUYỆT DỮ LIỆU TỪ DÒNG 1
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            // Kiểm tra ô ID có dữ liệu không
            Cell cellId = row.getCell(idxId);
            if (cellId == null || cellId.getCellType() == CellType.BLANK) continue;

            Card c = new Card();

            // --- LẤY PRODUCT ID ---
            if (cellId.getCellType() == CellType.NUMERIC) {
                c.setProductId((int) cellId.getNumericCellValue());
            } else {
                throw new Exception("Lỗi dòng " + (i + 1) + ": Product ID phải là số!");
            }

            // --- LẤY SERIAL (Dựa theo index tìm được) ---
            Cell cellSerial = row.getCell(idxSerial);
            String serial = (cellSerial != null) ? new DataFormatter().formatCellValue(cellSerial).trim() : "";
            
            // Validate Serial (Chữ + Số)
            if (!serial.matches(".*[a-zA-Z].*") || !serial.matches(".*[0-9].*")) {
                throw new Exception("Lỗi dòng " + (i + 1) + ": Serial '" + serial + "' phải chứa cả Chữ và Số.");
            }
            c.setSerial(serial);

            // --- LẤY CODE (Dựa theo index tìm được) ---
            Cell cellCode = row.getCell(idxCode);
            String code = (cellCode != null) ? new DataFormatter().formatCellValue(cellCode).trim() : "";
            
            // Validate Code (Chỉ số)
            if (!code.matches("^[0-9]+$")) {
                throw new Exception("Lỗi dòng " + (i + 1) + ": Mã thẻ '" + code + "' chỉ được chứa số.");
            }
            c.setCode(code);

            c.setStatus(Card.STATUS_IN_STOCK);
            list.add(c);
        }
        workbook.close();
        return list;
    }
}