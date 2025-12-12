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

public class PromotionDetail {
    private long detailId;
    private int promotionId; // Foreign Key
    private int cardTypeId; // Foreign Key
    private BigDecimal discountPercent;

    public PromotionDetail() {
    }

    public PromotionDetail(long detailId, int promotionId, int cardTypeId, BigDecimal discountPercent) {
        this.detailId = detailId;
        this.promotionId = promotionId;
        this.cardTypeId = cardTypeId;
        this.discountPercent = discountPercent;
    }
    
    // Getter & Setter methods go here

    public long getDetailId() {
        return detailId;
    }

    public void setDetailId(long detailId) {
        this.detailId = detailId;
    }

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public int getCardTypeId() {
        return cardTypeId;
    }

    public void setCardTypeId(int cardTypeId) {
        this.cardTypeId = cardTypeId;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }
    
}