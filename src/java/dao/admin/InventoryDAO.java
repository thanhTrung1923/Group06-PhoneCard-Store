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

    // 1. Hàm lấy số liệu thống kê Header (ĐÃ SỬA: Tính toán dựa trên số lượng thực tế)
    public Map<String, Integer> getInventoryStats() {
        Map<String, Integer> stats = new HashMap<>();
        
        // Khởi tạo biến đếm
        int totalInStock = 0;
        int totalSold = 0;
        int totalLow = 0;
        int totalOut = 0;

        Connection conn = DBConnect.getConnection();
        
        try {
            // -----------------------------------------------------------
            // BƯỚC 1: Tính tổng số thẻ ĐÃ BÁN (Total Sold)
            // -----------------------------------------------------------
            String sqlSold = "SELECT COUNT(*) FROM cards WHERE status = 'SOLD'";
            try (PreparedStatement ps = conn.prepareStatement(sqlSold);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalSold = rs.getInt(1);
                }
            }

            // -----------------------------------------------------------
            // BƯỚC 2: Tính Tồn kho, Sắp hết, Hết hàng
            // (Phải Group By theo sản phẩm để so sánh với min_stock_alert của từng loại)
            // -----------------------------------------------------------
            String sqlStock = "SELECT p.min_stock_alert, " +
                              "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') as real_qty " +
                              "FROM card_products p " +
                              "WHERE p.is_active = 1"; // Chỉ tính sản phẩm đang kinh doanh

            try (PreparedStatement ps = conn.prepareStatement(sqlStock);
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    int realQty = rs.getInt("real_qty");
                    int minAlert = rs.getInt("min_stock_alert");

                    // Cộng dồn vào tổng tồn kho
                    totalInStock += realQty;

                    // Phân loại trạng thái
                    if (realQty == 0) {
                        totalOut++; // Hết hàng
                    } else if (realQty <= minAlert) {
                        totalLow++; // Sắp hết (Còn hàng nhưng ít)
                    }
                    // Ngược lại là OK, không cần đếm
                }
            }

            // Đóng kết nối
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Put vào Map để trả về Controller
        stats.put("totalInStock", totalInStock);
        stats.put("totalSold", totalSold);
        stats.put("totalLowStock", totalLow);
        stats.put("totalOutStock", totalOut);
        
        return stats;
    }

    // Hàm lấy danh sách hiển thị bảng (Đã sửa để đếm số lượng thực tế)
    public List<CardProductDTO> getProductList(String keyword, String type, String status) {
        List<CardProductDTO> list = new ArrayList<>();
        
        // [CẬP NHẬT SQL]
        // Thay "p.quantity" bằng sub-query đếm trực tiếp từ bảng cards với alias là "real_quantity"
        StringBuilder sql = new StringBuilder(
            "SELECT p.product_id, p.type_name, p.value, p.min_stock_alert, " +
            
            // 1. Đếm số lượng thực tế (In Stock)
            "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') as real_quantity, " +
            
            // 2. Đếm số lượng đã bán
            "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'SOLD') as sold_count " +
            
            "FROM card_products p WHERE p.is_active = 1 ");

        // Xử lý Filter (Giữ nguyên logic filter)
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (p.type_name LIKE ? OR p.product_id LIKE ?) ");
        }
        if (type != null && !type.isEmpty()) {
            sql.append("AND p.type_name = ? ");
        }
        
        // [LƯU Ý] Logic filter Status vẫn đang dựa vào cột p.quantity cũ trong DB để so sánh cho nhanh.
        // Nếu muốn filter chính xác tuyệt đối thì cần logic phức tạp hơn (HAVING), 
        // nhưng hiện tại ta ưu tiên hiển thị đúng số lượng trước.
        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "OUT": // Hết hàng
                    sql.append("AND p.quantity = 0 ");
                    break;
                case "LOW": // Sắp hết
                    sql.append("AND p.quantity > 0 AND p.quantity <= p.min_stock_alert ");
                    break;
                case "OK": // Sẵn sàng
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
                    
                    // [QUAN TRỌNG] Lấy cột real_quantity vừa đếm được thay vì cột quantity cũ
                    dto.setQuantity(rs.getInt("real_quantity"));
                    
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
        
        // [CẬP NHẬT] Thay p.quantity bằng câu sub-query đếm trực tiếp (COUNT)
        String sql = "SELECT p.product_id, p.type_name, p.value, p.min_stock_alert, " +
                     
                     // 1. Đếm thực tế số thẻ đang IN_STOCK
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') as real_quantity, " +
                     
                     // 2. Đếm Reserved
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'RESERVED') as reserved_count, " +
                     
                     // 3. Đếm Sold
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'SOLD') as sold_count, " +
                     
                     // 4. Các thông tin khác
                     "(SELECT MAX(sold_at) FROM cards c WHERE c.product_id = p.product_id) as last_sold_date, " +
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
                    
                    // [SỬA] Lấy cột real_quantity thay vì quantity
                    dto.setQuantity(rs.getInt("real_quantity")); 
                    
                    dto.setMinStockAlert(rs.getInt("min_stock_alert"));
                    dto.setReservedCount(rs.getInt("reserved_count"));
                    dto.setSoldCount(rs.getInt("sold_count"));
                    dto.setLastSoldDate(rs.getTimestamp("last_sold_date"));
                    dto.setLastImportDate(rs.getTimestamp("last_import_date"));
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
    
    // 1. [MỚI] Cập nhật trạng thái hàng loạt (Change Status / Mark Defective)
    public boolean bulkUpdateStatus(String[] cardIds, String newStatus) {
        String sql = "UPDATE cards SET status = ? WHERE card_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false); // Transaction
            
            for (String id : cardIds) {
                ps.setString(1, newStatus);
                ps.setLong(2, Long.parseLong(id));
                ps.addBatch(); // Gom lệnh
            }
            
            ps.executeBatch(); // Chạy 1 lần
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. [MỚI] Xóa hàng loạt (Delete Selected)
    public boolean bulkDeleteCards(String[] cardIds) {
        // Lưu ý: Cần trừ số lượng trong card_products trước khi xóa (hoặc dùng Trigger trong DB)
        // Ở đây ta làm đơn giản là xóa cards, bạn cần chạy lại query đồng bộ số lượng sau.
        String sql = "DELETE FROM cards WHERE card_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            
            for (String id : cardIds) {
                ps.setLong(1, Long.parseLong(id));
                ps.addBatch();
            }
            
            ps.executeBatch();
            conn.commit();
            
            // [Quan trọng] Nên gọi hàm cập nhật lại quantity bảng product ở đây
            // updateProductQuantity(productId); 
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. [MỚI] Di chuyển sang sản phẩm khác (Move Product)
    public boolean bulkMoveProduct(String[] cardIds, int newProductId) {
        String sql = "UPDATE cards SET product_id = ? WHERE card_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            
            for (String id : cardIds) {
                ps.setInt(1, newProductId);
                ps.setLong(2, Long.parseLong(id));
                ps.addBatch();
            }
            
            ps.executeBatch();
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
}