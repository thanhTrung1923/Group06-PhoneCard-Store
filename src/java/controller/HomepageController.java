/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CardProductDAO;
import dao.CustomerFeedbackDAO;
import dtos.CardProductDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.CustomerFeedback;

/**
 *
 * @author trung
 */
@WebServlet(name = "HomepageController", urlPatterns = {"/home"})
public class HomepageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CardProductDAO cpDao = new CardProductDAO();
        CustomerFeedbackDAO cfDao = new CustomerFeedbackDAO();

        List<CardProductDTO> cpMostBuyed = cpDao.getCardProductsMostBuyed(8, 0);
        List<CardProductDTO> cpBestFeedback = cpDao.getCardProductsBestFeedback(8, 0);
        List<CustomerFeedback> cfList = cfDao.getListFeedbackForHomepage(8, 0);

        request.setAttribute("headerActive", "home");
        request.setAttribute("cpMostBuyed", cpMostBuyed);
        request.setAttribute("cpBestFeedback", cpBestFeedback);
        request.setAttribute("cfList", cfList);
        request.getRequestDispatcher("homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
