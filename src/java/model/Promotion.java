
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

public class Promotion {
    private int promotionId;
    private String promotionName;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private boolean isActive;
    private String bannerUrl;
    private LocalDateTime createdAt;

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

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
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

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
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
    
}
