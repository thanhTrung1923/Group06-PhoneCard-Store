package service;

import dao.admin.DiscountDAO;
import dtos.DiscountListDTO;

import java.sql.SQLException;
import java.util.List;

public class DiscountAdminService {
    private final DiscountDAO dao = new DiscountDAO();

    public List<DiscountListDTO> search(String keyword, String timeStatus, String isActive,
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
