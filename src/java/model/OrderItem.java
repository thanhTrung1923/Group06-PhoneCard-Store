/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
import java.math.BigDecimal;

public class OrderItem {

    private long itemId;
    private long orderId;
    private long productId;
    private String productName;
    private BigDecimal finalPrice;// Foreign Ke
    private int inventoryId; // Foreign Key
    private int quantity;
    private BigDecimal unitPrice;
    private Long assignedCardId; // ID thẻ đã giao (có thể NULL)

    public OrderItem() {
    }

    public OrderItem(long itemId, long orderId, long productId, String productName, BigDecimal finalPrice, int inventoryId, int quantity, BigDecimal unitPrice, Long assignedCardId) {
        this.itemId = itemId;
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.finalPrice = finalPrice;
        this.inventoryId = inventoryId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.assignedCardId = assignedCardId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(BigDecimal finalPrice) {
        this.finalPrice = finalPrice;
    }

    

    // Getter & Setter methods go here
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

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public int getQuantity() {
        return quantity;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
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

    public Long getAssignedCardId() {
        return assignedCardId;
    }

    public void setAssignedCardId(Long assignedCardId) {
        this.assignedCardId = assignedCardId;
    }


}


