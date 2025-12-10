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

public class Payment {
    private long paymentId;
    private long depositRequestId; // Foreign Key
    private BigDecimal amount;

    private String vnpTransactionNo;
    private String vnpBankCode;
    private String vnpBankTranNo;
    private String vnpCardType;

    private String vnpResponseCode;
    private String vnpTransactionStatus;

    private LocalDateTime payDate;
    private LocalDateTime createdAt;

    public Payment() {
    }

    public Payment(long paymentId, long depositRequestId, BigDecimal amount, String vnpTransactionNo, String vnpBankCode, String vnpBankTranNo, String vnpCardType, String vnpResponseCode, String vnpTransactionStatus, LocalDateTime payDate, LocalDateTime createdAt) {
        this.paymentId = paymentId;
        this.depositRequestId = depositRequestId;
        this.amount = amount;
        this.vnpTransactionNo = vnpTransactionNo;
        this.vnpBankCode = vnpBankCode;
        this.vnpBankTranNo = vnpBankTranNo;
        this.vnpCardType = vnpCardType;
        this.vnpResponseCode = vnpResponseCode;
        this.vnpTransactionStatus = vnpTransactionStatus;
        this.payDate = payDate;
        this.createdAt = createdAt;
    }

    // Getter & Setter methods go here (Sử dụng Alt + Insert để tạo)
    
    public long getPaymentId() { return paymentId; }
    public void setPaymentId(long paymentId) { this.paymentId = paymentId; }

    public long getDepositRequestId() { return depositRequestId; }
    public void setDepositRequestId(long depositRequestId) { this.depositRequestId = depositRequestId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    // ... (và các getter/setter còn lại)

    public String getVnpTransactionNo() {
        return vnpTransactionNo;
    }

    public void setVnpTransactionNo(String vnpTransactionNo) {
        this.vnpTransactionNo = vnpTransactionNo;
    }

    public String getVnpBankCode() {
        return vnpBankCode;
    }

    public void setVnpBankCode(String vnpBankCode) {
        this.vnpBankCode = vnpBankCode;
    }

    public String getVnpBankTranNo() {
        return vnpBankTranNo;
    }

    public void setVnpBankTranNo(String vnpBankTranNo) {
        this.vnpBankTranNo = vnpBankTranNo;
    }

    public String getVnpCardType() {
        return vnpCardType;
    }

    public void setVnpCardType(String vnpCardType) {
        this.vnpCardType = vnpCardType;
    }

    public String getVnpResponseCode() {
        return vnpResponseCode;
    }

    public void setVnpResponseCode(String vnpResponseCode) {
        this.vnpResponseCode = vnpResponseCode;
    }

    public String getVnpTransactionStatus() {
        return vnpTransactionStatus;
    }

    public void setVnpTransactionStatus(String vnpTransactionStatus) {
        this.vnpTransactionStatus = vnpTransactionStatus;
    }

    public LocalDateTime getPayDate() {
        return payDate;
    }

    public void setPayDate(LocalDateTime payDate) {
        this.payDate = payDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
}
