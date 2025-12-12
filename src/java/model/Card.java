/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author trung
 */
public class Card {
    
    public static final String STATUS_IN_STOCK = "IN_STOCK";
    public static final String STATUS_SOLD = "SOLD";
    public static final String STATUS_RESERVED = "RESERVED";

    private Long cardId;
    private Integer productId;
    private Long batchId;
    private String serial;
    private String code;
    private Integer supplierId;
    private String status; // IN_STOCK, SOLD, RESERVED
    private LocalDateTime createdAt;
    private LocalDateTime soldAt;

    public Card() {
    }
    
    public Card(Integer productId, Integer supplierId, String serial, String code, String status) {
        this.productId = productId;
        this.supplierId = supplierId;
        this.serial = serial;
        this.code = code;
        this.status = status;
        this.createdAt = LocalDateTime.now(); // Tự động lấy giờ hiện tại
    }

    public Long getCardId() {
        return cardId;
    }

    public void setCardId(Long cardId) {
        this.cardId = cardId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Long getBatchId() {
        return batchId;
    }

    public void setBatchId(Long batchId) {
        this.batchId = batchId;
    }

    public String getSerial() {
        return serial;
    }

    public void setSerial(String serial) {
        this.serial = serial;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
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

    public LocalDateTime getSoldAt() {
        return soldAt;
    }

    public void setSoldAt(LocalDateTime soldAt) {
        this.soldAt = soldAt;
    }

    @Override
    public String toString() {
        return "Card{" + "cardId=" + cardId + ", productId=" + productId + ", batchId=" + batchId + ", serial=" + serial + ", code=" + code + ", supplierId=" + supplierId + ", status=" + status + ", createdAt=" + createdAt + ", soldAt=" + soldAt + '}';
    }

}