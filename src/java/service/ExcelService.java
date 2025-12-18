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

    public List<Card> parseExcel(InputStream is, int targetProductId) throws Exception {
        List<Card> list = new ArrayList<>();
        Workbook workbook = new XSSFWorkbook(is);
        Sheet sheet = workbook.getSheetAt(0);

        // ---------------------------------------------------------
        // BƯỚC 1: ĐỌC HEADER ĐỂ TÌM VỊ TRÍ CỘT
        // ---------------------------------------------------------
        Row headerRow = sheet.getRow(0); // Giả sử dòng 1 là tiêu đề
        if (headerRow == null) throw new Exception("File Excel rỗng (thiếu dòng tiêu đề)!");

        Map<String, Integer> colMap = new HashMap<>();
        for (Cell cell : headerRow) {
            // Đưa về chữ thường, xóa khoảng trắng thừa để dễ so sánh
            // Ví dụ: "  Serial Number " -> "serial number"
            String header = cell.getStringCellValue().trim().toLowerCase();
            colMap.put(header, cell.getColumnIndex());
        }

        // Tìm index của cột Serial (Hỗ trợ nhiều tên gọi khác nhau)
        Integer idxSerial = findColumnIndex(colMap, "serial", "seri", "số seri", "serial number");
        
        // Tìm index của cột Code (Hỗ trợ nhiều tên gọi)
        Integer idxCode = findColumnIndex(colMap, "code", "mã thẻ", "card code", "mã nạp");

        // VALIDATE: Nếu không tìm thấy cột cần thiết -> Báo lỗi ngay
        if (idxSerial == null) {
            throw new Exception("Không tìm thấy cột 'Serial'. Vui lòng đặt tên cột là 'Serial' hoặc 'Seri'.");
        }
        if (idxCode == null) {
            throw new Exception("Không tìm thấy cột 'Code'. Vui lòng đặt tên cột là 'Code' hoặc 'Mã thẻ'.");
        }

        // ---------------------------------------------------------
        // BƯỚC 2: DUYỆT DỮ LIỆU TỪ DÒNG 2 (Index 1)
        // ---------------------------------------------------------
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            // Lấy ô Serial dựa trên Index tìm được
            Cell cellSerial = row.getCell(idxSerial);
            
            // Nếu ô Serial rỗng -> Coi như dòng rác, bỏ qua
            if (cellSerial == null || cellSerial.getCellType() == CellType.BLANK) continue;

            Card c = new Card();
            c.setProductId(targetProductId);

            // --- XỬ LÝ SERIAL ---
            DataFormatter fmt = new DataFormatter();
            String serial = fmt.formatCellValue(cellSerial).trim();
            if (serial.length() < 3) continue; // Bỏ qua nếu quá ngắn
            c.setSerial(serial);

            // --- XỬ LÝ CODE ---
            Cell cellCode = row.getCell(idxCode);
            String code = (cellCode != null) ? fmt.formatCellValue(cellCode).trim() : "";
            
            // Validate Code (Chỉ chứa số)
            if (!code.matches("^[0-9]+$")) {
                throw new Exception("Lỗi dòng " + (i + 1) + ": Mã thẻ '" + code + "' chứa ký tự không hợp lệ (chỉ được là số).");
            }
            c.setCode(code);

            // Trạng thái mặc định
            c.setStatus("IN_STOCK");
            
            list.add(c);
        }
        workbook.close();
        
        if (list.isEmpty()) {
            throw new Exception("Không đọc được dữ liệu nào! Vui lòng kiểm tra lại tên cột trong file Excel.");
        }
        
        return list;
    }

    // Hàm phụ trợ: Tìm vị trí cột dựa trên 1 danh sách các từ khóa
    private Integer findColumnIndex(Map<String, Integer> map, String... keywords) {
        for (String key : keywords) {
            if (map.containsKey(key)) {
                return map.get(key);
            }
        }
        return null; // Không tìm thấy
    }
}