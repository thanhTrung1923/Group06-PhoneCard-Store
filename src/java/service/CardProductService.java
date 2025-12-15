package service;

import dao.CardProductDAO;
import model.CardProduct;
import java.util.List;

public class CardProductService {

    private final CardProductDAO dao = new CardProductDAO();

    public List<CardProduct> getAllProducts() {
        return dao.findAll();
    }

    public List<CardProduct> searchProducts(
            String typeCode,
            Long value,
            String order
    ) {
        return dao.search(typeCode, value, order);
    }

    public CardProduct getProductById(int id) {
        return dao.getProductById(id);
    }

    public void createProduct(CardProduct p) {
        if (p.getSellPrice().compareTo(p.getBuyPrice()) < 0) {
            System.out.println("⚠ Giá bán đang thấp hơn giá nhập!");
        }
        dao.insertProduct(p);
    }

    public void updateProduct(CardProduct p) {
        dao.updateProduct(p);
    }

    public void deleteProduct(int id) {
        dao.deleteProduct(id);
    }

    public List<Long> getAvailableValues() {
        return dao.getDistinctValues();
    }
}
