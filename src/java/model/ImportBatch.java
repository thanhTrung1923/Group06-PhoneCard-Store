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

public class ImportBatch {
    private long batchId;
    private String filename;
    private Integer importedBy; // Foreign Key
    private LocalDateTime createdAt;

    public ImportBatch() {
    }

    public ImportBatch(long batchId, String filename, Integer importedBy, LocalDateTime createdAt) {
        this.batchId = batchId;
        this.filename = filename;
        this.importedBy = importedBy;
        this.createdAt = createdAt;
    }
    
    // Getter & Setter methods go here

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
    
}