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



/**
 * @author trung
 */
public class Promotion {

    private Integer promotionId;
    private String promotionName;
    private String description;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private Boolean isActive;
    private String bannerUrl;
    private LocalDateTime createdAt;
    private Integer createdBy;


    public Promotion() {
    }


    public Promotion(int promotionId, String promotionName, LocalDateTime startAt, LocalDateTime endAt, boolean isActive, String bannerUrl, LocalDateTime createdAt) {
        this.promotionId = promotionId;
        this.promotionName = promotionName;
        this.startAt = startAt;
        this.endAt = endAt;
        this.isActive = isActive;
        this.bannerUrl = bannerUrl;
        this.createdAt = createdAt;
    }
    
    // Getter & Setter methods go here

 

    public Integer getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(Integer promotionId) {
        this.promotionId = promotionId;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }



    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public LocalDateTime getStartAt() {
        return startAt;
    }

    public void setStartAt(LocalDateTime startAt) {
        this.startAt = startAt;
    }

    public LocalDateTime getEndAt() {
        return endAt;
    }

    public void setEndAt(LocalDateTime endAt) {
        this.endAt = endAt;
    }



    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public String getBannerUrl() {
        return bannerUrl;
    }

    public void setBannerUrl(String bannerUrl) {
        this.bannerUrl = bannerUrl;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    


    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "Promotion{" + "promotionId=" + promotionId + ", promotionName=" + promotionName + ", description=" + description + ", startAt=" + startAt + ", endAt=" + endAt + ", isActive=" + isActive + ", bannerUrl=" + bannerUrl + ", createdAt=" + createdAt + ", createdBy=" + createdBy + '}';
    }


}
