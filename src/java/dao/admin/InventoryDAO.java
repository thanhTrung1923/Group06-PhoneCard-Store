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

        // 1. Filter Keyword (Tên hoặc ID)
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (p.type_name LIKE ? OR p.product_id LIKE ?) ");
        }
        // 2. Filter Type (Viettel, Vina...)
        if (type != null && !type.isEmpty()) {
            sql.append("AND p.type_name = ? "); // Lưu ý: DB bạn dùng type_name hay type_code thì sửa lại cho khớp
        }
        
        // 3. [FIX] Filter Status (Logic phức tạp)
        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "OUT": // Hết hàng
                    sql.append("AND p.quantity = 0 ");
                    break;
                case "LOW": // Sắp hết (Còn hàng nhưng dưới mức báo động)
                    sql.append("AND p.quantity > 0 AND p.quantity <= p.min_stock_alert ");
                    break;
                case "OK": // Sẵn sàng (Trên mức báo động)
                    sql.append("AND p.quantity > p.min_stock_alert ");
                    break;
            }
        }
        
        sql.append("ORDER BY p.type_name, p.value");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%"); // Set 2 lần cho 2 dấu ? của OR
            }
            if (type != null && !type.isEmpty()) {
                ps.setString(index++, type);
            }
            // Status không dùng tham số ? mà nối chuỗi trực tiếp nên không cần setString ở đây

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
            String sqlCard = "INSERT INTO cards (product_id, supplier_id, serial, code, status, created_at) VALUES (?, ?, ?, ?, ?, ?)";
            psCard = conn.prepareStatement(sqlCard);
            
            psCard.setInt(1, card.getProductId());
            psCard.setInt(2, card.getSupplierId());
            psCard.setString(3, card.getSerial());
            psCard.setString(4, card.getCode());
            psCard.setString(5, card.getStatus()); // Thường là 'IN_STOCK'
            psCard.setObject(6, card.getCreatedAt());
            
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
    
    // ... (Giữ nguyên hàm getProductDetail đã viết ở bước trước) ...
// [ĐÃ SỬA LỖI] Lấy chi tiết sản phẩm
    public CardProductDTO getProductDetail(int productId) {
        CardProductDTO dto = null;
        
        // Sửa lại SQL: Không join quá phức tạp để đảm bảo luôn lấy được Product Info dù chưa có thẻ
        String sql = "SELECT p.product_id, p.type_name, p.value, p.quantity, p.min_stock_alert, " +
                     
                     // Đếm Reserved (An toàn với IFNULL)
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'RESERVED') as reserved_count, " +
                     
                     // Đếm Sold
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'SOLD') as sold_count, " +
                     
                     // Lấy ngày bán gần nhất
                     "(SELECT MAX(sold_at) FROM cards c WHERE c.product_id = p.product_id) as last_sold_date, " +
                     
                     // Lấy ngày nhập gần nhất (Dựa trên bảng cards cho đơn giản và chính xác)
                     "(SELECT MAX(created_at) FROM cards c WHERE c.product_id = p.product_id) as last_import_date " +
                     
                     "FROM card_products p " +
                     "WHERE p.product_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = new CardProductDTO();
                    dto.setProductId(rs.getInt("product_id"));
                    dto.setTypeName(rs.getString("type_name"));
                    dto.setValue(rs.getBigDecimal("value"));
                    dto.setQuantity(rs.getInt("quantity"));
                    dto.setMinStockAlert(rs.getInt("min_stock_alert"));
                    
                    dto.setReservedCount(rs.getInt("reserved_count"));
                    dto.setSoldCount(rs.getInt("sold_count"));
                    dto.setLastSoldDate(rs.getTimestamp("last_sold_date"));
                    dto.setLastImportDate(rs.getTimestamp("last_import_date"));
                    
                    dto.setLastImportQuantity(0); // Tạm để 0
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

    // [MỚI] Lấy danh sách thẻ cụ thể của 1 sản phẩm (Kèm thông tin Lô hàng để hiển thị chi tiết)
    public List<Card> getCardsByProductId(int productId) {
        List<Card> list = new ArrayList<>();
        // Join bảng import_batches để lấy ngày nhập nếu cần, ở đây ta lấy cơ bản từ bảng cards
        String sql = "SELECT * FROM cards WHERE product_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Card c = new Card();
                    c.setCardId(rs.getLong("card_id"));
                    c.setProductId(rs.getInt("product_id"));
                    c.setBatchId(rs.getLong("batch_id"));
                    c.setSerial(rs.getString("serial"));
                    c.setCode(rs.getString("code"));
                    c.setStatus(rs.getString("status"));
                    c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime()); // Chuyển Timestamp -> LocalDateTime
                    
                    // Nếu có sold_at
                    if (rs.getTimestamp("sold_at") != null) {
                        c.setSoldAt(rs.getTimestamp("sold_at").toLocalDateTime());
                    }
                    
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
}