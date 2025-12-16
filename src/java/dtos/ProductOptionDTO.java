package dtos;

import java.math.BigDecimal;

public class ProductOptionDTO {
    private int productId;
    private String typeCode;
    private String typeName;
    private long value;
    private BigDecimal sellPrice;

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getTypeCode() { return typeCode; }
    public void setTypeCode(String typeCode) { this.typeCode = typeCode; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public long getValue() { return value; }
    public void setValue(long value) { this.value = value; }

    public BigDecimal getSellPrice() { return sellPrice; }
    public void setSellPrice(BigDecimal sellPrice) { this.sellPrice = sellPrice; }
}
