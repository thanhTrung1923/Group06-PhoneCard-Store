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
import java.time.LocalDateTime;

public class Wallet {
    private int walletId;
    private int userId; // Foreign Key
    private BigDecimal balance;
    private LocalDateTime updatedAt;

    public Wallet() {
    }

    public Wallet(int walletId, int userId, BigDecimal balance, LocalDateTime updatedAt) {
        this.walletId = walletId;
        this.userId = userId;
        this.balance = balance;
        this.updatedAt = updatedAt;
    }
    
    // Getter & Setter methods go here

    public int getWalletId() {
        return walletId;
    }

    public void setWalletId(int walletId) {
        this.walletId = walletId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
}
