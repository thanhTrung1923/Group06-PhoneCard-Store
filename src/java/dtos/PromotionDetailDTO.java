package dtos;

import java.math.BigDecimal;

public class PromotionDetailDTO {
    private long detailId;
    private int promotionId;
    private int productId;
    private String productName; // ex: Viettel 10000
    private BigDecimal discountPercent;

    public long getDetailId() { return detailId; }
    public void setDetailId(long detailId) { this.detailId = detailId; }

    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(BigDecimal discountPercent) { this.discountPercent = discountPercent; }
}
