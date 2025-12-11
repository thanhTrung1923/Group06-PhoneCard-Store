package model;

import java.sql.Timestamp;

public class Card {
    
    // Hằng số trạng thái (Mapping với ENUM trong Database)
    // Giúp bạn code không bị sai chính tả: Card.STATUS_IN_STOCK
    public static final String STATUS_IN_STOCK = "IN_STOCK";
    public static final String STATUS_SOLD = "SOLD";
    public static final String STATUS_RESERVED = "RESERVED";

    // Attributes (Khớp 1-1 với bảng 'cards')
    private Long cardId;        // PK: BIGINT
    private Integer productId;  // FK: INT (NOT NULL)
    private Long batchId;       // FK: BIGINT (Nullable - có thể null nếu nhập lẻ)
    
    private String serial;      // VARCHAR(200)
    private String code;        // TEXT
    private Integer supplierId; // FK: INT
    
    private String status;      // ENUM -> String
    
    private Timestamp createdAt; // DATETIME
    private Timestamp soldAt;    // DATETIME (Nullable)

    // 1. Constructor rỗng (Bắt buộc phải có)
    public Card() {
    }

    // 2. Constructor dùng để tạo nhanh object khi đọc từ Excel (Chưa có ID)
    public Card(Integer productId, String serial, String code, Integer supplierId, String status) {
        this.productId = productId;
        this.serial = serial;
        this.code = code;
        this.supplierId = supplierId;
        this.status = status;
    }

    // 3. Constructor đầy đủ (Dùng khi SELECT từ DB lên)
    public Card(Long cardId, Integer productId, Long batchId, String serial, String code, 
                Integer supplierId, String status, Timestamp createdAt, Timestamp soldAt) {
        this.cardId = cardId;
        this.productId = productId;
        this.batchId = batchId;
        this.serial = serial;
        this.code = code;
        this.supplierId = supplierId;
        this.status = status;
        this.createdAt = createdAt;
        this.soldAt = soldAt;
    }

    // 4. Getters and Setters (Bắt buộc)
    public Long getCardId() {
        return cardId;
    }

    public void setCardId(Long cardId) {
        this.cardId = cardId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Long getBatchId() {
        return batchId;
    }

    public void setBatchId(Long batchId) {
        this.batchId = batchId;
    }

    public String getSerial() {
        return serial;
    }

    public void setSerial(String serial) {
        this.serial = serial;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getSoldAt() {
        return soldAt;
    }

    public void setSoldAt(Timestamp soldAt) {
        this.soldAt = soldAt;
    }

    // 5. toString() (Rất quan trọng để Debug, in ra log xem dữ liệu có đúng không)
    @Override
    public String toString() {
        return "Card{" + "cardId=" + cardId + ", productId=" + productId + ", serial=" + serial + ", status=" + status + '}';
    }
}