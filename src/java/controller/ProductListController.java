/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CardProductDAO;
import dtos.CardProductDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author trung
 */
@WebServlet(name = "ProductListController", urlPatterns = {"/products"})
public class ProductListController extends HttpServlet {

    private final int ITEMS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CardProductDAO dao = new CardProductDAO();

        String pageStr = request.getParameter("page");
        String typeName = request.getParameter("typeName");
        String typeCode = request.getParameter("typeCode");
        String description = request.getParameter("description");
        String valueStr = request.getParameter("value");
        String orderBy = request.getParameter("orderBy");
        String orderType = request.getParameter("orderType");

        int page = 1;
        if (pageStr != null && !pageStr.isBlank()) {
            page = Integer.parseInt(pageStr);
        }

        long value = 0;
        if (valueStr != null && !valueStr.isBlank()) {
            value = Long.parseLong(valueStr);
        }

        int offset = (page - 1) * ITEMS_PER_PAGE;

        List<CardProductDTO> cpList = dao.getCardProductsList(ITEMS_PER_PAGE, offset, typeName, value, typeCode, description, orderBy, orderType);

        int totalProducts = dao.countCardProducts(typeName, value, typeCode, description);
        int totalPages = (int) Math.ceil((double) totalProducts / ITEMS_PER_PAGE);

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("typeName", typeName);
        request.setAttribute("typeCode", typeCode);
        request.setAttribute("description", description);
        request.setAttribute("value", value);
        request.setAttribute("orderBy", orderBy);
        request.setAttribute("orderType", orderType);
        request.setAttribute("cpList", cpList);
        request.getRequestDispatcher("product-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
