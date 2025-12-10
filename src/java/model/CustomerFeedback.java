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
public class CustomerFeedback {

    private Long feedbackId;
    private Integer userId;
    private Long orderId;
    private Integer rating;
    private String category; // SERVICE, PRODUCT, WEBSITE, DELIVERY, OTHER
    private String subject;
    private String content;
    private Boolean isPublic;
    private Boolean isResponded;
    private String adminResponse;
    private Integer respondedBy;
    private LocalDateTime respondedAt;
    private LocalDateTime createdAt;

    public CustomerFeedback() {
    }

    public Long getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(Long feedbackId) {
        this.feedbackId = feedbackId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public Boolean getIsResponded() {
        return isResponded;
    }

    public void setIsResponded(Boolean isResponded) {
        this.isResponded = isResponded;
    }

    public String getAdminResponse() {
        return adminResponse;
    }

    public void setAdminResponse(String adminResponse) {
        this.adminResponse = adminResponse;
    }

    public Integer getRespondedBy() {
        return respondedBy;
    }

    public void setRespondedBy(Integer respondedBy) {
        this.respondedBy = respondedBy;
    }

    public LocalDateTime getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(LocalDateTime respondedAt) {
        this.respondedAt = respondedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "CustomerFeedback{" + "feedbackId=" + feedbackId + ", userId=" + userId + ", orderId=" + orderId + ", rating=" + rating + ", category=" + category + ", subject=" + subject + ", content=" + content + ", isPublic=" + isPublic + ", isResponded=" + isResponded + ", adminResponse=" + adminResponse + ", respondedBy=" + respondedBy + ", respondedAt=" + respondedAt + ", createdAt=" + createdAt + '}';
    }

}
