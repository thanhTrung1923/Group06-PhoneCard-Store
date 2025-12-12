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

public class DepositRequest {
    private long requestId;
    private int userId; // Foreign Key
    private BigDecimal amount;
    private String status; // PENDING, APPROVED, FAILED
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;

    public DepositRequest() {
    }

    public DepositRequest(long requestId, int userId, BigDecimal amount, String status, LocalDateTime createdAt, LocalDateTime approvedAt) {
        this.requestId = requestId;
        this.userId = userId;
        this.amount = amount;
        this.status = status;
        this.createdAt = createdAt;
        this.approvedAt = approvedAt;
    }
    
    // Getter & Setter methods go here

    public long getRequestId() {
        return requestId;
    }

    public void setRequestId(long requestId) {
        this.requestId = requestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(LocalDateTime approvedAt) {
        this.approvedAt = approvedAt;
    }
    
}
