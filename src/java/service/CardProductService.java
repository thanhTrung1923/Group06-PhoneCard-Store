/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.CardProductDAO;
import model.CardProduct;
import java.util.List;

public class CardProductService {

    // Service gọi DAO, không gọi trực tiếp Database
    private final CardProductDAO dao = new CardProductDAO();

    public List<CardProduct> getAllProducts() {
        return dao.getAllCardProducts();
    }

    public CardProduct getProductById(int id) {
        return dao.getProductById(id);
    }

    public void createProduct(CardProduct p) {
        if (p.getSellPrice().compareTo(p.getBuyPrice()) < 0) {
            System.out.println("Cảnh báo: Giá bán đang thấp hơn giá nhập!");
        }
        
        dao.insertProduct(p);
    }

    public void updateProduct(CardProduct p) {
        // Logic kiểm tra nếu cần...
        dao.updateProduct(p);
    }

    public void deleteProduct(int id) {
        dao.deleteProduct(id);
    }
}
