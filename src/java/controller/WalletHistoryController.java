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
import java.time.LocalDateTime;
import java.util.List;
import model.User;
import model.WalletTransaction;

@WebServlet(name = "WalletHistoryController", urlPatterns = {"/wallet/history"})
public class WalletHistoryController extends HttpServlet {

    private final int ITEMS_PER_PAGE = 1;
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

        String minAmountStr = request.getParameter("minAmount");
        String maxAmountStr = request.getParameter("maxAmount");
        String type = request.getParameter("type");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        String pageStr = request.getParameter("page");

        int page = 1;
        LocalDateTime fromDate = null;
        LocalDateTime toDate = null;
        BigDecimal minAmount = null;
        BigDecimal maxAmount = null;

        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (fromDateStr != null && !fromDateStr.isBlank()) {
            try {
                fromDate = LocalDateTime.parse(fromDateStr + "T00:00:00");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (toDateStr != null && !toDateStr.isBlank()) {
            try {
                toDate = LocalDateTime.parse(toDateStr + "T23:59:59");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (minAmountStr != null && !minAmountStr.isBlank()) {
            try {
                minAmount = new BigDecimal(minAmountStr);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        if (maxAmountStr != null && !maxAmountStr.isBlank()) {
            try {
                maxAmount = new BigDecimal(maxAmountStr);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        int offset = (page - 1) * ITEMS_PER_PAGE;

        List<WalletTransaction> transactions = wlDao.getListWalletTransaction(userId, ITEMS_PER_PAGE, offset, minAmount, maxAmount, fromDate, toDate, type);

        int totalTransactions = wlDao.countListWalletTransaction(userId, minAmount, maxAmount, fromDate, toDate, type);

        int totalPages = (int) Math.ceil((double) totalTransactions / ITEMS_PER_PAGE);

        request.setAttribute("page", page);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("minAmount", minAmount);
        request.setAttribute("maxAmount", maxAmount);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTransactions", totalTransactions);
        request.setAttribute("transactions", transactions);
        request.setAttribute("type", type);

        request.getRequestDispatcher("/wallet-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
