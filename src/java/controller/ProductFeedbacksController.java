/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.CustomerFeedbackDAO;
import dtos.ApiResponse;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;
import model.CustomerFeedback;
import ulti.LocalDateTimeAdapter;

/**
 *
 * @author trung
 */
@WebServlet(name = "ProductFeedbacksController", urlPatterns = {"/product/feedbacks"})
public class ProductFeedbacksController extends HttpServlet {

    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .setPrettyPrinting()
            .create();

    private final int ITEMS_PER_PAGE = 10;

    //Đây là doGet dựa theo REST
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            String productIdStr = request.getParameter("productId");
            String pageStr = request.getParameter("page");

            CustomerFeedbackDAO dao = new CustomerFeedbackDAO();

            if (productIdStr == null || productIdStr.isBlank()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                ApiResponse apiResponse = new ApiResponse(400, "Sai định dạng product id!", null);
                out.print(gson.toJson(apiResponse));
                out.flush();
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int page = 1;

            if (pageStr != null && !pageStr.isBlank()) {
                page = Integer.parseInt(pageStr);
            }

            int offset = (page - 1) * ITEMS_PER_PAGE;

            List< CustomerFeedback> cfList = dao.getListFeedbacksForProduct(10, offset, productId);

            response.setStatus(HttpServletResponse.SC_OK);
            ApiResponse apiResponse = new ApiResponse(200, "Lấy danh sách feedbacks thành công", cfList, page);
            out.print(gson.toJson(apiResponse));
            out.flush();
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            ApiResponse apiResponse = new ApiResponse(400, "Tham số không hợp lệ: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            ApiResponse apiResponse = new ApiResponse(500, "Lỗi server: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
