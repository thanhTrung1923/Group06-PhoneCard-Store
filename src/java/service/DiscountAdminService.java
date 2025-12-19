package service;

import dao.admin.DiscountDAO;
import dtos.ProductOptionDTO;
import dtos.PromotionDTO;
import dtos.PromotionDetailDTO;
import dtos.PromotionListDTO;

import java.sql.Timestamp;
import java.util.List;

public class DiscountAdminService {

    private final DiscountDAO dao = new DiscountDAO();

    public List<PromotionListDTO> searchPromotions(
            String keyword, String timeStatus, String activeFlag,
            String sort, String dir, int page, int pageSize
    ) throws Exception {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(pageSize, 1);
        int offset = (safePage - 1) * safeSize;
        return dao.searchPromotions(keyword, timeStatus, activeFlag, sort, dir, offset, safeSize);
    }

    public int countPromotions(String keyword, String timeStatus, String activeFlag) throws Exception {
        return dao.countPromotions(keyword, timeStatus, activeFlag);
    }

    // ===== Detail screen =====
    public PromotionDTO getPromotion(int promotionId) throws Exception {
        return dao.getPromotion(promotionId);
    }

    public List<PromotionDetailDTO> getPromotionDetails(int promotionId) throws Exception {
        return dao.getPromotionDetails(promotionId);
    }

    public List<ProductOptionDTO> getProductOptions() throws Exception {
        return dao.getProductOptions();
    }

    // ===== CRUD =====
    public boolean updatePromotion(int id, String name, Timestamp startAt, Timestamp endAt, boolean active) throws Exception {
        return dao.updatePromotion(id, name, startAt, endAt, active);
    }

    public boolean upsertPromotionDetail(int promotionId, int productId, double percent) throws Exception {
        return dao.upsertPromotionDetail(promotionId, productId, percent);
    }

    public boolean deletePromotionDetail(int promotionId, int productId) throws Exception {
        return dao.deletePromotionDetail(promotionId, productId);
    }

    public boolean deletePromotion(int promotionId) throws Exception {
        return dao.deletePromotion(promotionId);
    }
}
