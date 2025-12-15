package model;

import java.math.BigDecimal;

public class OrderItem {

    private long itemId;
    private long orderId;
    private int productId;

    private String productName;
    private long productValue;

    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal finalPrice;
    private BigDecimal profit;

    private Long assignedCardId;

    public OrderItem() {}

    public long getItemId() {
        return itemId;
    }

    public void setItemId(long itemId) {
        this.itemId = itemId;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public long getProductValue() {
        return productValue;
    }

    public void setProductValue(long productValue) {
        this.productValue = productValue;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(BigDecimal finalPrice) {
        this.finalPrice = finalPrice;
    }

    public BigDecimal getProfit() {
        return profit;
    }

    public void setProfit(BigDecimal profit) {
        this.profit = profit;
    }

    public Long getAssignedCardId() {
        return assignedCardId;
    }

    public void setAssignedCardId(Long assignedCardId) {
        this.assignedCardId = assignedCardId;
    }
}
