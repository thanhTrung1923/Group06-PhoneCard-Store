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

public class WalletTransaction {
    private long transactionId;
    private int walletId; // Foreign Key
    private BigDecimal amount;
    private String type; // DEPOSIT, PURCHASE, REFUND (hoặc dùng Enum)
    private String reference;
    private LocalDateTime createdAt;

    public WalletTransaction() {
    }

    public WalletTransaction(long transactionId, int walletId, BigDecimal amount, String type, String reference, LocalDateTime createdAt) {
        this.transactionId = transactionId;
        this.walletId = walletId;
        this.amount = amount;
        this.type = type;
        this.reference = reference;
        this.createdAt = createdAt;
    }
    
    // Getter & Setter methods go here

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    public int getWalletId() {
        return walletId;
    }

    public void setWalletId(int walletId) {
        this.walletId = walletId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
}
