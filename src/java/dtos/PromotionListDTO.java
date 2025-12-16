package dtos;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class PromotionListDTO {
    private int promotionId;
    private String promotionName;
    private Timestamp startAt;
    private Timestamp endAt;

    private String timeStatus; // UPCOMING / ONGOING / EXPIRED
    private boolean active;

    private int productCount;

    private String createdByName;
    private String createdByEmail;

    private BigDecimal minDiscountPercent;
    private BigDecimal maxDiscountPercent;

    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }

    public String getPromotionName() { return promotionName; }
    public void setPromotionName(String promotionName) { this.promotionName = promotionName; }

    public Timestamp getStartAt() { return startAt; }
    public void setStartAt(Timestamp startAt) { this.startAt = startAt; }

    public Timestamp getEndAt() { return endAt; }
    public void setEndAt(Timestamp endAt) { this.endAt = endAt; }

    public String getTimeStatus() { return timeStatus; }
    public void setTimeStatus(String timeStatus) { this.timeStatus = timeStatus; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public int getProductCount() { return productCount; }
    public void setProductCount(int productCount) { this.productCount = productCount; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getCreatedByEmail() { return createdByEmail; }
    public void setCreatedByEmail(String createdByEmail) { this.createdByEmail = createdByEmail; }

    public BigDecimal getMinDiscountPercent() { return minDiscountPercent; }
    public void setMinDiscountPercent(BigDecimal minDiscountPercent) { this.minDiscountPercent = minDiscountPercent; }

    public BigDecimal getMaxDiscountPercent() { return maxDiscountPercent; }
    public void setMaxDiscountPercent(BigDecimal maxDiscountPercent) { this.maxDiscountPercent = maxDiscountPercent; }
}
