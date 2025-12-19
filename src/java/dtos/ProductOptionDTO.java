package dtos;

public class ProductOptionDTO {
    private int productId;
    private String label;

    public ProductOptionDTO() {}
    public ProductOptionDTO(int productId, String label) {
        this.productId = productId;
        this.label = label;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
}
