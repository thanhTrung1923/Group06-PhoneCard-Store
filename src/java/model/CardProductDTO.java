package model;

import java.math.BigDecimal;
import java.sql.Timestamp; 

public class CardProductDTO {
    // ... Các trường cũ giữ nguyên (productId, typeName, value, quantity, minStock, soldCount) ...
    private int productId;
    private String typeName;
    private BigDecimal value;
    private int quantity; // In Stock
    private int minStockAlert;
    private int soldCount; // Sold

    private int reservedCount; // Reserved
    private Timestamp lastImportDate;
    private int lastImportQuantity;
    private Timestamp lastSoldDate;

    public int getReservedCount() { return reservedCount; }
    public void setReservedCount(int reservedCount) { this.reservedCount = reservedCount; }

    public Timestamp getLastImportDate() { return lastImportDate; }
    public void setLastImportDate(Timestamp lastImportDate) { this.lastImportDate = lastImportDate; }

    public int getLastImportQuantity() { return lastImportQuantity; }
    public void setLastImportQuantity(int lastImportQuantity) { this.lastImportQuantity = lastImportQuantity; }

    public Timestamp getLastSoldDate() { return lastSoldDate; }
    public void setLastSoldDate(Timestamp lastSoldDate) { this.lastSoldDate = lastSoldDate; }
    

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    public BigDecimal getValue() { return value; }
    public void setValue(BigDecimal value) { this.value = value; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getMinStockAlert() { return minStockAlert; }
    public void setMinStockAlert(int minStockAlert) { this.minStockAlert = minStockAlert; }
    public int getSoldCount() { return soldCount; }
    public void setSoldCount(int soldCount) { this.soldCount = soldCount; }
}