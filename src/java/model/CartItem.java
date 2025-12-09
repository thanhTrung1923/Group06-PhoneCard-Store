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

public class CartItem {
    private long itemId;
    private long cartId; // Foreign Key
    private int inventoryId; // Foreign Key
    private int quantity;
    private BigDecimal unitPrice;

    public CartItem() {
    }

    public CartItem(long itemId, long cartId, int inventoryId, int quantity, BigDecimal unitPrice) {
        this.itemId = itemId;
        this.cartId = cartId;
        this.inventoryId = inventoryId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }
    
    // Getter & Setter methods go here

    public long getItemId() {
        return itemId;
    }

    public void setItemId(long itemId) {
        this.itemId = itemId;
    }

    public long getCartId() {
        return cartId;
    }

    public void setCartId(long cartId) {
        this.cartId = cartId;
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

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
}