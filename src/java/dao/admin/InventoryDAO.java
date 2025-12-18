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
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Map<String, Integer> getInventoryStats() {
        Map<String, Integer> stats = new HashMap<>();

        int totalInStock = 0;
        int totalSold = 0;
        int totalLow = 0;
        int totalOut = 0;

        Connection conn = DBConnect.getConnection();
        
        try {
            String sqlSold = "SELECT COUNT(*) FROM cards WHERE status = 'SOLD'";
            try (PreparedStatement ps = conn.prepareStatement(sqlSold);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalSold = rs.getInt(1);
                }
            }

            String sqlStock = "SELECT p.min_stock_alert, " +
                              "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') as real_qty " +
                              "FROM card_products p " +
                              "WHERE p.is_active = 1"; 

            try (PreparedStatement ps = conn.prepareStatement(sqlStock);
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    int realQty = rs.getInt("real_qty");
                    int minAlert = rs.getInt("min_stock_alert");

                    totalInStock += realQty;

                    if (realQty == 0) {
                        totalOut++; 
                    } else if (realQty <= minAlert) {
                        totalLow++;
                    }
                }
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        stats.put("totalInStock", totalInStock);
        stats.put("totalSold", totalSold);
        stats.put("totalLowStock", totalLow);
        stats.put("totalOutStock", totalOut);
        
        return stats;
    }
    
    // 1.1. Hàm đếm tổng số sản phẩm theo bộ lọc (Để tính tổng số trang)
    public int countProducts(String keyword, String type, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM card_products p WHERE p.is_active = 1 ");
        
        // [MỚI] Định nghĩa câu truy vấn đếm số lượng thực tế để dùng cho bộ lọc
        String realQtySql = "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK')";

        if (keyword != null && !keyword.isEmpty()) sql.append("AND (p.type_name LIKE ? OR p.product_id LIKE ?) ");
        if (type != null && !type.isEmpty()) sql.append("AND p.type_name = ? ");
        
        // [SỬA LỖI FILTER] Thay p.quantity bằng realQtySql
        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "OUT": 
                    // Hết hàng: Số lượng thực tế = 0
                    sql.append("AND ").append(realQtySql).append(" = 0 ");
                    break;
                case "LOW": 
                    // Sắp hết: 0 < Số lượng thực tế <= Min Stock
                    sql.append("AND ").append(realQtySql).append(" > 0 ");
                    sql.append("AND ").append(realQtySql).append(" <= p.min_stock_alert ");
                    break;
                case "OK": 
                    // Sẵn sàng: Số lượng thực tế > Min Stock
                    sql.append("AND ").append(realQtySql).append(" > p.min_stock_alert ");
                    break;
            }
        }
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (type != null && !type.isEmpty()) ps.setString(index++, type);
             
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<CardProductDTO> getProductList(String keyword, String type, String status, int pageIndex, int pageSize) {
        List<CardProductDTO> list = new ArrayList<>();
        
        // Câu SELECT hiển thị (Giữ nguyên phần real_quantity đã sửa trước đó)
        StringBuilder sql = new StringBuilder(
            "SELECT p.product_id, p.type_name, p.value, p.min_stock_alert, " +
            "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') as real_quantity, " +
            "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'SOLD') as sold_count " +          
            "FROM card_products p WHERE p.is_active = 1 ");

        // [MỚI] Định nghĩa câu truy vấn con để dùng cho WHERE
        String realQtySql = "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK')";

        if (keyword != null && !keyword.isEmpty()) sql.append("AND (p.type_name LIKE ? OR p.product_id LIKE ?) ");
        if (type != null && !type.isEmpty()) sql.append("AND p.type_name = ? ");
        
        // [SỬA LỖI FILTER] Thay p.quantity bằng realQtySql
        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "OUT": 
                    sql.append("AND ").append(realQtySql).append(" = 0 ");
                    break;
                case "LOW": 
                    sql.append("AND ").append(realQtySql).append(" > 0 ");
                    sql.append("AND ").append(realQtySql).append(" <= p.min_stock_alert ");
                    break;
                case "OK": 
                    sql.append("AND ").append(realQtySql).append(" > p.min_stock_alert ");
                    break;
            }
        }
        
        sql.append("ORDER BY p.type_name, p.value LIMIT ? OFFSET ?");

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (type != null && !type.isEmpty()) ps.setString(index++, type);

            // Tham số phân trang
            ps.setInt(index++, pageSize);
            ps.setInt(index++, (pageIndex - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CardProductDTO dto = new CardProductDTO();
                    dto.setProductId(rs.getInt("product_id"));
                    dto.setTypeName(rs.getString("type_name"));
                    dto.setValue(rs.getBigDecimal("value"));
                    
                    // Lấy số lượng thực tế
                    dto.setQuantity(rs.getInt("real_quantity"));
                    
                    dto.setMinStockAlert(rs.getInt("min_stock_alert"));
                    dto.setSoldCount(rs.getInt("sold_count"));
                    list.add(dto);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean importBatchTransaction(ImportBatch batch, List<Card> cards) {
        Connection conn = DBConnect.getConnection();
        PreparedStatement psBatch = null;
        PreparedStatement psCard = null;
        PreparedStatement psUpdateProduct = null;
        boolean isSuccess = false;

        try {
            if (conn == null) return false;

            conn.setAutoCommit(false);

            String sqlBatch = "INSERT INTO import_batches (supplier_id, filename, total_cards, total_amount, imported_by, note) VALUES (?, ?, ?, ?, ?, ?)";
            psBatch = conn.prepareStatement(sqlBatch, Statement.RETURN_GENERATED_KEYS);

            if (batch.getSupplierId() != null) psBatch.setInt(1, batch.getSupplierId()); 
            else psBatch.setNull(1, java.sql.Types.INTEGER);
            psBatch.setString(2, batch.getFilename()); 
            
            psBatch.setInt(3, batch.getTotalCards());
            psBatch.setDouble(4, batch.getTotalAmount()); 

            if (batch.getImportedBy() != null) psBatch.setInt(5, batch.getImportedBy());
            else psBatch.setInt(5, 1); // Fallback về ID 1
            
            psBatch.setString(6, batch.getNote());
            
            int affectedRows = psBatch.executeUpdate();
            if (affectedRows == 0) throw new SQLException("Creating batch failed, no rows affected.");

            long batchId = 0;
            try (ResultSet generatedKeys = psBatch.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    batchId = generatedKeys.getLong(1);
                } else {
                    throw new SQLException("Creating batch failed, no ID obtained.");
                }
            }

            String sqlCard = "INSERT INTO cards (product_id, batch_id, supplier_id, serial, code, status) VALUES (?, ?, ?, ?, ?, 'IN_STOCK')";
            psCard = conn.prepareStatement(sqlCard);

            String sqlUpdateQty = "UPDATE card_products SET quantity = quantity + 1 WHERE product_id = ?";
            psUpdateProduct = conn.prepareStatement(sqlUpdateQty);

            for (Card c : cards) {
                psCard.setInt(1, c.getProductId());
                psCard.setLong(2, batchId);
                
                if (batch.getSupplierId() != null) psCard.setInt(3, batch.getSupplierId());
                else psCard.setNull(3, java.sql.Types.INTEGER);
                
                psCard.setString(4, c.getSerial());
                psCard.setString(5, c.getCode());
                psCard.addBatch();

                psUpdateProduct.setInt(1, c.getProductId());
                psUpdateProduct.addBatch(); 
            }

            psCard.executeBatch();
            psUpdateProduct.executeBatch();

            conn.commit();
            isSuccess = true;

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback(); 
            } catch (SQLException ex) { ex.printStackTrace(); }
            
            e.printStackTrace();
        } finally {
            try {
                if (psBatch != null) psBatch.close();
                if (psCard != null) psCard.close();
                if (psUpdateProduct != null) psUpdateProduct.close();
                if (conn != null) {
                    conn.setAutoCommit(true); 
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return isSuccess;
    }

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

    public boolean createCardManual(Card card) {
        Connection conn = DBConnect.getConnection();
        PreparedStatement psCard = null;
        PreparedStatement psUpdateProduct = null;
        boolean isSuccess = false;

        try {
            if (conn == null) return false;
            conn.setAutoCommit(false); 

            String sqlCard = "INSERT INTO cards (product_id, supplier_id, serial, code, status, created_at) VALUES (?, ?, ?, ?, ?, ?)";
            psCard = conn.prepareStatement(sqlCard);
            
            psCard.setInt(1, card.getProductId());
            psCard.setInt(2, card.getSupplierId());
            psCard.setString(3, card.getSerial());
            psCard.setString(4, card.getCode());
            psCard.setString(5, card.getStatus()); 
            psCard.setObject(6, card.getCreatedAt());
            
            int rows = psCard.executeUpdate();
            if (rows == 0) throw new SQLException("Insert card failed.");

            String sqlUpdate = "UPDATE card_products SET quantity = quantity + 1 WHERE product_id = ?";
            psUpdateProduct = conn.prepareStatement(sqlUpdate);
            psUpdateProduct.setInt(1, card.getProductId());
            psUpdateProduct.executeUpdate();

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

    public CardProductDTO getProductDetail(int productId) {
        CardProductDTO dto = null;
        
        String sql = "SELECT p.product_id, p.type_name, p.value, p.min_stock_alert, " +                   
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') as real_quantity, " +
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'RESERVED') as reserved_count, " +
                     "(SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'SOLD') as sold_count, " +
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
    public List<Card> getCardsByProductId(int productId) {
        List<Card> list = new ArrayList<>();
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

    // 2.1. Đếm tổng số thẻ của 1 sản phẩm
    public int countCardsByProductId(int productId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM cards WHERE product_id = ? ");
        
        if (status != null && !status.isEmpty()) {
            sql.append("AND status = ? ");
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            ps.setInt(1, productId);
            if (status != null && !status.isEmpty()) {
                ps.setString(2, status);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }


    // 2.2. Cập nhật hàm lấy thẻ có phân trang
    public List<Card> getCardsByProductId(int productId, String status, String sortOrder, int pageIndex, int pageSize) {
        List<Card> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM cards WHERE product_id = ? ");

        // 1. Filter Status
        if (status != null && !status.isEmpty()) {
            sql.append("AND status = ? ");
        }

        // 2. Sort Order (Mặc định là DESC - Mới nhất)
        if ("asc".equalsIgnoreCase(sortOrder)) {
            sql.append("ORDER BY created_at ASC "); // Cũ nhất
        } else {
            sql.append("ORDER BY created_at DESC "); // Mới nhất
        }

        // 3. Pagination
        sql.append("LIMIT ? OFFSET ?");
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            ps.setInt(index++, productId);
            
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            
            ps.setInt(index++, pageSize);
            ps.setInt(index++, (pageIndex - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Card c = new Card();
                    c.setCardId(rs.getLong("card_id"));
                    c.setProductId(rs.getInt("product_id"));
                    c.setBatchId(rs.getLong("batch_id"));
                    c.setSerial(rs.getString("serial"));
                    c.setCode(rs.getString("code"));
                    c.setStatus(rs.getString("status"));
                    c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime()); 
                    if (rs.getTimestamp("sold_at") != null) {
                        c.setSoldAt(rs.getTimestamp("sold_at").toLocalDateTime());
                    }
                    list.add(c);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    
}