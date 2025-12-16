package service;

import dao.admin.DiscountDAO;
import dtos.PromotionListDTO;

import java.util.List;

public class DiscountAdminService {

    private final DiscountDAO dao = new DiscountDAO();

    public List<PromotionListDTO> searchPromotions(
            String keyword,
            String timeStatus,
            String activeFlag,
            String sort, String dir,
            int page, int pageSize
    ) throws Exception {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(pageSize, 1);
        int offset = (safePage - 1) * safeSize;
        return dao.searchPromotions(keyword, timeStatus, activeFlag, sort, dir, offset, safeSize);
    }

    public int countPromotions(String keyword, String timeStatus, String activeFlag) throws Exception {
        return dao.countPromotions(keyword, timeStatus, activeFlag);
    }
}
