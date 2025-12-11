/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.Locale;
/**
 *
 * @author dotri
 */
public class CardProduct {
    private int productId;
    private String typeCode;        // Viettel, Vina, Mobi
    private String typeName;        // Tên hiển thị (Ví dụ: Thẻ Viettel)
    private long value;             // Mệnh giá (BIGINT -> long)
    
    private int quantity;           // Số lượng tồn kho
    private int minStockAlert;      // Ngưỡng cảnh báo
    
    private BigDecimal buyPrice;    // Giá nhập (Quan trọng: Dùng BigDecimal cho tiền tệ)
    private BigDecimal sellPrice;   // Giá bán
    
    private String imgUrl;
    private String thumbnailUrl;
    private String description;
    
    private boolean isActive;       // TINYINT(1) -> boolean
    private boolean allowDiscount;  // TINYINT(1) -> boolean
    
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public CardProduct() {
    }

    public CardProduct(int productId, String typeCode, String typeName, long value, int quantity, int minStockAlert, BigDecimal buyPrice, BigDecimal sellPrice, String imgUrl, String thumbnailUrl, String description, boolean isActive, boolean allowDiscount, Timestamp createdAt, Timestamp updatedAt) {
        this.productId = productId;
        this.typeCode = typeCode;
        this.typeName = typeName;
        this.value = value;
        this.quantity = quantity;
        this.minStockAlert = minStockAlert;
        this.buyPrice = buyPrice;
        this.sellPrice = sellPrice;
        this.imgUrl = imgUrl;
        this.thumbnailUrl = thumbnailUrl;
        this.description = description;
        this.isActive = isActive;
        this.allowDiscount = allowDiscount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public long getValue() {
        return value;
    }

    public void setValue(long value) {
        this.value = value;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getMinStockAlert() {
        return minStockAlert;
    }

    public void setMinStockAlert(int minStockAlert) {
        this.minStockAlert = minStockAlert;
    }

    public BigDecimal getBuyPrice() {
        return buyPrice;
    }

    public void setBuyPrice(BigDecimal buyPrice) {
        this.buyPrice = buyPrice;
    }

    public BigDecimal getSellPrice() {
        return sellPrice;
    }

    public void setSellPrice(BigDecimal sellPrice) {
        this.sellPrice = sellPrice;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean isAllowDiscount() {
        return allowDiscount;
    }

    public void setAllowDiscount(boolean allowDiscount) {
        this.allowDiscount = allowDiscount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    public String getFormattedPrice() {
        if (sellPrice == null) return "0 đ";
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat currencyVN = NumberFormat.getCurrencyInstance(localeVN);
        return currencyVN.format(sellPrice);
    }
}
