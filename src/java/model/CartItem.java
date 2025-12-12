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

/**
 *
 * @author trung
 */
public class CartItem {

    private Long itemId;
    private Long cartId;
    private Integer productId;
    private Integer quantity;
    private BigDecimal unitPrice;

    public CartItem() {
    }

    public CartItem(long itemId, long cartId, int quantity, BigDecimal unitPrice) {
        this.itemId = itemId;
        this.cartId = cartId;

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

    public int getQuantity() {
        return quantity;
    }

    public void setItemId(Long itemId) {
        this.itemId = itemId;
    }

    public void setCartId(Long cartId) {
        this.cartId = cartId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    @Override
    public String toString() {
        return "CartItem{" + "itemId=" + itemId + ", cartId=" + cartId + ", productId=" + productId + ", quantity=" + quantity + ", unitPrice=" + unitPrice + '}';
    }

}
