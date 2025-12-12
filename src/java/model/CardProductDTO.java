package model;

import java.math.BigDecimal;

public class CardProductDTO {
    private int productId;
    private String typeName;    // Viettel, Vina...
    private BigDecimal value;   // 10000, 20000...
    private int quantity;       // Tồn kho (lấy từ card_products)
    private int soldCount;      // Đã bán (lấy từ COUNT bảng cards hoặc orders)
    private int minStockAlert;  // Ngưỡng cảnh báo

    // Constructor rỗng
    public CardProductDTO() {
    }

    // Constructor đầy đủ
    public CardProductDTO(int productId, String typeName, BigDecimal value, int quantity, int soldCount, int minStockAlert) {
        this.productId = productId;
        this.typeName = typeName;
        this.value = value;
        this.quantity = quantity;
        this.soldCount = soldCount;
        this.minStockAlert = minStockAlert;
    }

    // Getters & Setters (Bắt buộc để JSP đọc được bằng ${p.typeName})
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public BigDecimal getValue() { return value; }
    public void setValue(BigDecimal value) { this.value = value; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getSoldCount() { return soldCount; }
    public void setSoldCount(int soldCount) { this.soldCount = soldCount; }

    public int getMinStockAlert() { return minStockAlert; }
    public void setMinStockAlert(int minStockAlert) { this.minStockAlert = minStockAlert; }
}

