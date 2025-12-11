package dao.admin;

import dao.DBConnect; // Dùng chung connection của nhóm
import model.CardProductDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

public class InventoryDAO {

    // Giải thích: Hàm trả về List để Controller đẩy sang JSP
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE is_active = 1";

        // Try-with-resources: Tự động đóng connection sau khi dùng xong (Rất quan trọng)
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier();
                // Map từng cột trong DB vào object Java
                s.setSupplierId(rs.getInt("supplier_id"));
                s.setSupplierName(rs.getString("supplier_name"));
                
                
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để debug
        }
        return list;
    }
    // 1. Hàm lấy số liệu thống kê (4 ô màu trên cùng)
    public Map<String, Integer> getInventoryStats() {
        Map<String, Integer> stats = new HashMap<>();
        // Query đếm tổng hợp từ bảng card_products
        // Logic: 
        // - In Stock: SUM(quantity)
        // - Sold: (Cần query bảng orders hoặc cards where status='SOLD') - Ở đây tạm tính qua cards
        // - Low Stock: COUNT where quantity <= min_stock_alert
        // - Out Stock: COUNT where quantity = 0
        
        String sql = "SELECT " +
                     "  SUM(quantity) as total_instock, " +
                     "  (SELECT COUNT(*) FROM cards WHERE status = 'SOLD') as total_sold, " +
                     "  COUNT(CASE WHEN quantity <= min_stock_alert AND quantity > 0 THEN 1 END) as total_low, " +
                     "  COUNT(CASE WHEN quantity = 0 THEN 1 END) as total_out " +
                     "FROM card_products WHERE is_active = 1";
                     
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                stats.put("totalInStock", rs.getInt("total_instock"));
                stats.put("totalSold", rs.getInt("total_sold"));
                stats.put("totalLowStock", rs.getInt("total_low"));
                stats.put("totalOutStock", rs.getInt("total_out"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    // 2. Hàm lấy danh sách hiển thị bảng (Kèm bộ lọc)
    public List<CardProductDTO> getProductList(String keyword, String type, String status) {
        List<CardProductDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.product_id, p.type_name, p.value, p.quantity, p.min_stock_alert, " +
            "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'SOLD') as sold_count " +
            "FROM card_products p WHERE p.is_active = 1 ");

        // Xử lý Filter động
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND p.type_name LIKE ? ");
        }
        if (type != null && !type.isEmpty()) {
            sql.append("AND p.type_code = ? ");
        }
        // ... Logic filter status hơi phức tạp (Low/Out), bạn có thể xử lý sau hoặc filter bằng Java
        
        sql.append("ORDER BY p.type_name, p.value");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (type != null && !type.isEmpty()) {
                ps.setString(index++, type);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CardProductDTO dto = new CardProductDTO();
                    dto.setProductId(rs.getInt("product_id"));
                    dto.setTypeName(rs.getString("type_name"));
                    dto.setValue(rs.getBigDecimal("value"));
                    dto.setQuantity(rs.getInt("quantity"));
                    dto.setMinStockAlert(rs.getInt("min_stock_alert"));
                    dto.setSoldCount(rs.getInt("sold_count"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}