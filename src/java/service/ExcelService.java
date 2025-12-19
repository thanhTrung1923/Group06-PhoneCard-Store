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

        Row headerRow = sheet.getRow(0); 
        if (headerRow == null) throw new Exception("File Excel rỗng (thiếu dòng tiêu đề)!");

        Map<String, Integer> colMap = new HashMap<>();
        for (Cell cell : headerRow) {
            String header = cell.getStringCellValue().trim().toLowerCase();
            colMap.put(header, cell.getColumnIndex());
        }

        Integer idxSerial = findColumnIndex(colMap, "serial", "seri", "số seri", "serial number");

        Integer idxCode = findColumnIndex(colMap, "code", "mã thẻ", "card code", "mã nạp");

        if (idxSerial == null) {
            throw new Exception("Không tìm thấy cột 'Serial'. Vui lòng đặt tên cột là 'Serial' hoặc 'Seri'.");
        }
        if (idxCode == null) {
            throw new Exception("Không tìm thấy cột 'Code'. Vui lòng đặt tên cột là 'Code' hoặc 'Mã thẻ'.");
        }

        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            Cell cellSerial = row.getCell(idxSerial);

            if (cellSerial == null || cellSerial.getCellType() == CellType.BLANK) continue;

            Card c = new Card();
            c.setProductId(targetProductId);

            DataFormatter fmt = new DataFormatter();
            String serial = fmt.formatCellValue(cellSerial).trim();
            if (serial.length() < 3) continue; // Bỏ qua nếu quá ngắn
            c.setSerial(serial);

            Cell cellCode = row.getCell(idxCode);
            String code = (cellCode != null) ? fmt.formatCellValue(cellCode).trim() : "";
            
            if (!code.matches("^[0-9]+$")) {
                throw new Exception("Lỗi dòng " + (i + 1) + ": Mã thẻ '" + code + "' chứa ký tự không hợp lệ (chỉ được là số).");
            }
            c.setCode(code);
            c.setStatus("IN_STOCK");
            
            list.add(c);
        }
        workbook.close();
        
        if (list.isEmpty()) {
            throw new Exception("Không đọc được dữ liệu nào! Vui lòng kiểm tra lại tên cột trong file Excel.");
        }
        
        return list;
    }

    private Integer findColumnIndex(Map<String, Integer> map, String... keywords) {
        for (String key : keywords) {
            if (map.containsKey(key)) {
                return map.get(key);
            }
        }
        return null; 
    }
}