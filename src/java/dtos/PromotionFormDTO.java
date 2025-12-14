package dtos;

import java.sql.Timestamp;

public class PromotionFormDTO {
    private int promotionId;
    private String promotionName;
    private String description;
    private Timestamp startAt;
    private Timestamp endAt;
    private boolean active;

    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }

    public String getPromotionName() { return promotionName; }
    public void setPromotionName(String promotionName) { this.promotionName = promotionName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getStartAt() { return startAt; }
    public void setStartAt(Timestamp startAt) { this.startAt = startAt; }

    public Timestamp getEndAt() { return endAt; }
    public void setEndAt(Timestamp endAt) { this.endAt = endAt; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
