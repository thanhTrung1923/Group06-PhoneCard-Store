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

public class Feedback {
    private long feedbackId;
    private Integer userId; // Có thể NULL nên dùng Integer
    private String content;
    private String status; // NEW, PROCESSING, CLOSED
    private Integer processedBy; // Có thể NULL
    private LocalDateTime createdAt;

    public Feedback() {
    }

    public Feedback(long feedbackId, Integer userId, String content, String status, Integer processedBy, LocalDateTime createdAt) {
        this.feedbackId = feedbackId;
        this.userId = userId;
        this.content = content;
        this.status = status;
        this.processedBy = processedBy;
        this.createdAt = createdAt;
    }
    
    // Getter & Setter methods go here

    public long getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(long feedbackId) {
        this.feedbackId = feedbackId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Integer processedBy) {
        this.processedBy = processedBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
}
