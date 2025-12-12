/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CardProductDAO;
import dtos.CardProductDetailDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author trung
 */
@WebServlet(name = "ProductDetailController", urlPatterns = {"/products/detail"})
public class ProductDetailController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CardProductDAO dao = new CardProductDAO();
        
        String productIdStr = request.getParameter("productId");
        
        int productId = 0;
        
        if (productIdStr != null && !productIdStr.isBlank()) {
            productId = Integer.parseInt(productIdStr);
        }
        
        CardProductDetailDTO cp = dao.getCardProductDetail(productId);
        
        request.setAttribute("cp", cp);
        request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }
    
}
