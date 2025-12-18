/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.WalletDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import model.User;
import model.WalletTransaction;

/**
 *
 * @author trung
 */
@WebServlet(name = "WalletController", urlPatterns = {"/wallet"})
public class WalletController extends HttpServlet {

    private final WalletDAO wlDao = new WalletDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");

        if (user == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = user.getUserId();

        List<WalletTransaction> recentTransactions = wlDao.getListRecentWalletTransaction(userId);
        BigDecimal totalDeposit = wlDao.getUserTotalCash(userId, "DEPOSIT");
        BigDecimal totalSpent = wlDao.getUserTotalCash(userId, "PURCHASE");
        int monthlyTransactions = wlDao.getTotalWalletTransactionInMonth(userId);

        request.setAttribute("recentTransactions", recentTransactions);
        request.setAttribute("totalDeposit", totalDeposit);
        request.setAttribute("totalSpent", totalSpent);
        request.setAttribute("monthlyTransactions", monthlyTransactions);
        request.getRequestDispatcher("wallet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
