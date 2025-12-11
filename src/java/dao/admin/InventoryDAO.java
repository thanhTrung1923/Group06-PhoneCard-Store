package dao.admin;

import dao.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Card;
import model.CardProductDTO;
import model.ImportBatch;
import model.Supplier;

public class InventoryDAO {

    // --- CÁC HÀM GET DỮ LIỆU (Giữ nguyên) ---
    
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE is_active = 1";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierId(rs.getInt("supplier_id"));
                s.setSupplierName(rs.getString("supplier_name"));
                // Map thêm các trường khác nếu cần
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Map<String, Integer> getInventoryStats() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT COALESCE(SUM(quantity), 0) as total_instock, " +
                     "(SELECT COUNT(*) FROM cards WHERE status = 'SOLD') as total_sold, " +
                     "COUNT(CASE WHEN quantity <= min_stock_alert AND quantity > 0 THEN 1 END) as total_low, " +
                     "COUNT(CASE WHEN quantity = 0 THEN 1 END) as total_out " +
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
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    public List<CardProductDTO> getProductList(String keyword, String type, String status) {
        List<CardProductDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.product_id, p.type_name, p.value, p.quantity, p.min_stock_alert, " +
            "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'SOLD') as sold_count " +
            "FROM card_products p WHERE p.is_active = 1 ");

        if (keyword != null && !keyword.isEmpty()) sql.append("AND p.type_name LIKE ? ");
        if (type != null && !type.isEmpty()) sql.append("AND p.type_code = ? ");
        
        sql.append("ORDER BY p.type_name, p.value");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) ps.setString(index++, "%" + keyword + "%");
            if (type != null && !type.isEmpty()) ps.setString(index++, type);

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
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // --- [HÀM ĐÃ SỬA] IMPORT TRANSACTION ---
    public boolean importBatchTransaction(ImportBatch batch, List<Card> cards) {
        Connection conn = DBConnect.getConnection();
        PreparedStatement psBatch = null;
        PreparedStatement psCard = null;
        PreparedStatement psUpdateProduct = null;
        boolean isSuccess = false;

        try {
            if (conn == null) return false;
            
            // 1. Tắt Auto Commit để chạy Transaction
            conn.setAutoCommit(false);

            // 2. Insert Batch
            String sqlBatch = "INSERT INTO import_batches (supplier_id, filename, total_cards, total_amount, imported_by, note) VALUES (?, ?, ?, ?, ?, ?)";
            psBatch = conn.prepareStatement(sqlBatch, Statement.RETURN_GENERATED_KEYS);
            
            // Xử lý tham số an toàn (tránh null)
            if (batch.getSupplierId() != null) psBatch.setInt(1, batch.getSupplierId()); 
            else psBatch.setNull(1, java.sql.Types.INTEGER);
            
            // [SỬA LỖI] Dùng getFilename() (chữ n thường) khớp với Model
            psBatch.setString(2, batch.getFilename()); 
            
            psBatch.setInt(3, batch.getTotalCards());
            psBatch.setDouble(4, batch.getTotalAmount()); // Model dùng Double, SQL DECIMAL
            
            // Kiểm tra imported_by (Admin ID), nếu null set về 1 (hoặc ID admin mặc định)
            if (batch.getImportedBy() != null) psBatch.setInt(5, batch.getImportedBy());
            else psBatch.setInt(5, 1); // Fallback về ID 1
            
            psBatch.setString(6, batch.getNote());
            
            int affectedRows = psBatch.executeUpdate();
            if (affectedRows == 0) throw new SQLException("Creating batch failed, no rows affected.");

            // Lấy ID Batch vừa tạo
            long batchId = 0;
            try (ResultSet generatedKeys = psBatch.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    batchId = generatedKeys.getLong(1);
                } else {
                    throw new SQLException("Creating batch failed, no ID obtained.");
                }
            }

            // 3. Insert Cards & Update Product Quantity
            String sqlCard = "INSERT INTO cards (product_id, batch_id, supplier_id, serial, code, status) VALUES (?, ?, ?, ?, ?, 'IN_STOCK')";
            psCard = conn.prepareStatement(sqlCard);

            String sqlUpdateQty = "UPDATE card_products SET quantity = quantity + 1 WHERE product_id = ?";
            psUpdateProduct = conn.prepareStatement(sqlUpdateQty);

            for (Card c : cards) {
                // Insert Card
                psCard.setInt(1, c.getProductId());
                psCard.setLong(2, batchId);
                
                if (batch.getSupplierId() != null) psCard.setInt(3, batch.getSupplierId());
                else psCard.setNull(3, java.sql.Types.INTEGER);
                
                psCard.setString(4, c.getSerial());
                psCard.setString(5, c.getCode());
                psCard.addBatch(); // Gom lệnh

                // Update Qty
                psUpdateProduct.setInt(1, c.getProductId());
                psUpdateProduct.addBatch(); // Gom lệnh
            }

            // Thực thi hàng loạt
            psCard.executeBatch();
            psUpdateProduct.executeBatch();

            // 4. Commit (Lưu)
            conn.commit();
            isSuccess = true;

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback(); // Lỗi -> Hoàn tác
            } catch (SQLException ex) { ex.printStackTrace(); }
            
            e.printStackTrace(); // In lỗi ra Server Log (xem Output Netbeans)
            // Có thể throw e để Controller bắt được thông báo cụ thể
        } finally {
            try {
                if (psBatch != null) psBatch.close();
                if (psCard != null) psCard.close();
                if (psUpdateProduct != null) psUpdateProduct.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Trả lại trạng thái mặc định
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return isSuccess;
    }
    

    // 1. [MỚI] Lấy danh sách sản phẩm (Dropdown) cho form tạo thẻ
    public List<CardProductDTO> getAllProductNames() {
        List<CardProductDTO> list = new ArrayList<>();
        String sql = "SELECT product_id, type_name, value FROM card_products WHERE is_active = 1 ORDER BY type_name, value";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                CardProductDTO dto = new CardProductDTO();
                dto.setProductId(rs.getInt("product_id"));
                dto.setTypeName(rs.getString("type_name"));
                dto.setValue(rs.getBigDecimal("value"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. [MỚI] Tạo thẻ thủ công (Transaction: Insert Card + Update Qty)
    public boolean createCardManual(Card card) {
        Connection conn = DBConnect.getConnection();
        PreparedStatement psCard = null;
        PreparedStatement psUpdateProduct = null;
        boolean isSuccess = false;

        try {
            if (conn == null) return false;
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // Bước 1: Insert vào bảng cards
            // Lưu ý: batch_id để null vì tạo thủ công
            String sqlCard = "INSERT INTO cards (product_id, supplier_id, serial, code, status, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
            psCard = conn.prepareStatement(sqlCard);
            
            psCard.setInt(1, card.getProductId());
            psCard.setInt(2, card.getSupplierId());
            psCard.setString(3, card.getSerial());
            psCard.setString(4, card.getCode());
            psCard.setString(5, card.getStatus()); // Thường là 'IN_STOCK'
            
            int rows = psCard.executeUpdate();
            if (rows == 0) throw new SQLException("Insert card failed.");

            // Bước 2: Cộng số lượng trong card_products
            String sqlUpdate = "UPDATE card_products SET quantity = quantity + 1 WHERE product_id = ?";
            psUpdateProduct = conn.prepareStatement(sqlUpdate);
            psUpdateProduct.setInt(1, card.getProductId());
            psUpdateProduct.executeUpdate();

            // Bước 3: Chốt đơn
            conn.commit();
            isSuccess = true;

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            try {
                if (psCard != null) psCard.close();
                if (psUpdateProduct != null) psUpdateProduct.close();
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (SQLException e) {}
        }
        return isSuccess;
    }
}