/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 * Updated by: Member 5 (Inventory Logic)
 */
public class ImportBatch {
    
    // Các trường hiện có
    private long batchId;
    private String filename;
    private Integer importedBy; 
    private LocalDateTime createdAt;

    private Integer supplierId; 
    private Integer totalCards;  
    private Double totalAmount;  
    private String note;         

    // Constructor rỗng
    public ImportBatch() {
    }

    // Constructor đầy đủ
    public ImportBatch(long batchId, String filename, Integer importedBy, LocalDateTime createdAt, 
                       Integer supplierId, Integer totalCards, Double totalAmount, String note) {
        this.batchId = batchId;
        this.filename = filename;
        this.importedBy = importedBy;
        this.createdAt = createdAt;
        this.supplierId = supplierId;
        this.totalCards = totalCards;
        this.totalAmount = totalAmount;
        this.note = note;
    }
    
    // --- GETTER & SETTER (Bắt buộc phải có đủ) ---

    public long getBatchId() {
        return batchId;
    }

    public void setBatchId(long batchId) {
        this.batchId = batchId;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }
    
    public void setFileName(String filename) {
        this.filename = filename;
    }
    public String getFileName() {
        return filename;
    }

    public Integer getImportedBy() {
        return importedBy;
    }

    public void setImportedBy(Integer importedBy) {
        this.importedBy = importedBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    

    public Integer getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }

    public Integer getTotalCards() {
        return totalCards;
    }

    public void setTotalCards(Integer totalCards) {
        this.totalCards = totalCards;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}