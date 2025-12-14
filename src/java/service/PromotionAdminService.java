package service;

import dao.admin.PromotionDAO;
import dtos.PromotionListDTO;

import java.sql.SQLException;
import java.util.List;

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
}
