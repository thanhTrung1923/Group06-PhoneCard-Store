package dtos;

import java.sql.Timestamp;

public class PromotionDTO {
    private int promotionId;
    private String promotionName;
    private Timestamp startAt;
    private Timestamp endAt;
    private boolean active;

    private String createdByName;
    private String createdByEmail;

    // UPCOMING / ONGOING / EXPIRED
    private String timeStatus;

    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }

    public String getPromotionName() { return promotionName; }
    public void setPromotionName(String promotionName) { this.promotionName = promotionName; }

    public Timestamp getStartAt() { return startAt; }
    public void setStartAt(Timestamp startAt) { this.startAt = startAt; }

    public Timestamp getEndAt() { return endAt; }
    public void setEndAt(Timestamp endAt) { this.endAt = endAt; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getCreatedByEmail() { return createdByEmail; }
    public void setCreatedByEmail(String createdByEmail) { this.createdByEmail = createdByEmail; }

    public String getTimeStatus() { return timeStatus; }
    public void setTimeStatus(String timeStatus) { this.timeStatus = timeStatus; }
}
