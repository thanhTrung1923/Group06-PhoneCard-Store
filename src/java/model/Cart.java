/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
import java.time.LocalDateTime;

public class Cart {
    private long cartId;
    private int userId; // Foreign Key
    private LocalDateTime createdAt;

    public Cart() {
    }

    public Cart(long cartId, int userId, LocalDateTime createdAt) {
        this.cartId = cartId;
        this.userId = userId;
        this.createdAt = createdAt;
    }
    
    // Getter & Setter methods go here

    public long getCartId() {
        return cartId;
    }

    public void setCartId(long cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
}
