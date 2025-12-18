<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Tạo yêu cầu hỗ trợ</title>
        <jsp:include page="/layout/global-import-header.jsp"/>
    </head>

    <body class="bg-gray-50">

        <!-- HEADER -->
        <jsp:include page="/layout/header.jsp"/>

        <div class="max-w-4xl mx-auto px-4 py-10 min-h-screen">

            <!-- Nút quay lại -->
            <button onclick="history.back()"
                    class="flex items-center gap-2 px-4 py-2 rounded-full
                    bg-white border border-gray-200 shadow-sm
                    text-gray-600 hover:text-green-600 hover:border-green-500
                    hover:shadow transition-all mb-6">
                <i class="fa-solid fa-arrow-left"></i>
                <span class="font-medium">Quay lại</span>
            </button>

            <!-- TIÊU ĐỀ -->
            <h1 class="text-3xl font-bold text-gray-900 mb-8">
                🎧 Tạo yêu cầu hỗ trợ
            </h1>

            <!-- FORM -->
            <div class="bg-white rounded-xl shadow-sm p-8 max-w-2xl">

                <form action="${pageContext.request.contextPath}/support"
                      method="post"
                      class="space-y-6">

                    <!-- Subject -->
                    <div>
                        <label class="block font-medium mb-2">
                            Tiêu đề
                        </label>
                        <input type="text"
                               name="subject"
                               required
                               class="w-full border rounded-lg px-4 py-2
                               focus:outline-none focus:ring-2 focus:ring-green-400"
                               placeholder="Ví dụ: Không nhận được mã thẻ">
                    </div>

                    <!-- Content -->
                    <div>
                        <label class="block font-medium mb-2">
                            Nội dung chi tiết
                        </label>
                        <textarea name="content"
                                  rows="5"
                                  required
                                  class="w-full border rounded-lg px-4 py-2
                                  focus:outline-none focus:ring-2 focus:ring-green-400"
                                  placeholder="Mô tả chi tiết vấn đề bạn đang gặp phải"></textarea>
                    </div>
                    <div>
                        <label class="block font-medium mb-2">
                            Đơn hàng liên quan (nếu có)
                        </label>
                        <select name="orderId"
                                class="w-full border rounded-lg px-4 py-2
                                focus:outline-none focus:ring-2 focus:ring-green-400">
                            <option value="">-- Không liên quan đơn hàng --</option>

                            <c:forEach items="${orders}" var="o">
                                <option value="${o.orderId}">
                                    #${o.orderId} -
                                <fmt:formatNumber value="${o.totalAmount}" type="currency"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
<!--                     Priority 
                    <div>
                        <label class="block font-medium mb-2">
                            Mức độ ưu tiên
                        </label>
                        <select name="priority"
                                class="w-full border rounded-lg px-4 py-2
                                focus:outline-none focus:ring-2 focus:ring-green-400">
                            <option value="LOW">Thấp</option>
                            <option value="MEDIUM" selected>Trung bình</option>
                            <option value="HIGH">Cao</option>
                            <option value="URGENT">Khẩn cấp</option>
                        </select>
                    </div>-->

                    <!-- BUTTON -->
                    <div class="flex justify-end gap-3 pt-4">
                        <a href="${pageContext.request.contextPath}/support?action=history"
                           class="px-6 py-2 rounded-lg border
                           text-gray-600 hover:bg-gray-100">
                            Huỷ
                        </a>
                        <button type="submit"
                                class="px-6 py-2 rounded-lg
                                bg-green-500 text-white
                                hover:bg-green-600 font-semibold">
                            Gửi yêu cầu
                        </button>
                    </div>

                </form>
            </div>
        </div>

        <!-- FOOTER -->
        <jsp:include page="/layout/footer.jsp"/>
        <jsp:include page="/layout/global-import-footer.jsp"/>

    </body>
</html>
