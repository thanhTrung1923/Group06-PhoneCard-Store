package service;

import dao.admin.PromotionDAO;
import dtos.PromotionListDTO;

import java.sql.SQLException;
import java.util.List;
import dtos.ProductOptionDTO;
import dtos.PromotionFormDTO;
import java.math.BigDecimal;
import java.util.Map;


public class PromotionAdminService {
    private final PromotionDAO dao = new PromotionDAO();

    public List<PromotionListDTO> search(String keyword, String timeStatus, String isActive,
                                         int page, int pageSize) throws SQLException {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(1, Math.min(pageSize, 50));
        int offset = (safePage - 1) * safeSize;
        return dao.searchPromotions(keyword, timeStatus, isActive, offset, safeSize);
    }

    public int count(String keyword, String timeStatus, String isActive) throws SQLException {
        return dao.countPromotions(keyword, timeStatus, isActive);
    }
    public List<ProductOptionDTO> listProducts() throws SQLException {
    return dao.listProducts();
}

public PromotionFormDTO getPromotion(int id) throws SQLException {
    return dao.getPromotion(id);
}

public Map<Integer, BigDecimal> getPromotionDiscountMap(int promotionId) throws SQLException {
    return dao.getPromotionDiscountMap(promotionId);
}

public int createPromotion(PromotionFormDTO form, int createdBy, Map<Integer, BigDecimal> details) throws SQLException {
    validatePromotion(form, details);
    return dao.insertPromotion(form, createdBy, details);
}

public boolean updatePromotion(PromotionFormDTO form, Map<Integer, BigDecimal> details) throws SQLException {
    validatePromotion(form, details);
    return dao.updatePromotion(form, details);
}

private void validatePromotion(PromotionFormDTO form, Map<Integer, BigDecimal> details) {
    if (form.getPromotionName() == null || form.getPromotionName().trim().isEmpty())
        throw new IllegalArgumentException("Promotion name is required.");

    if (form.getStartAt() == null || form.getEndAt() == null)
        throw new IllegalArgumentException("Start/End time is required.");

    if (!form.getEndAt().after(form.getStartAt()))
        throw new IllegalArgumentException("End time must be after start time.");

    if (details == null || details.isEmpty())
        throw new IllegalArgumentException("Please select at least 1 product for discount.");

    for (var e : details.entrySet()) {
        if (e.getValue() == null) throw new IllegalArgumentException("Discount percent is required.");
        double v = e.getValue().doubleValue();
        if (v < 0 || v > 100) throw new IllegalArgumentException("Discount must be between 0 and 100.");
    }
}

}
