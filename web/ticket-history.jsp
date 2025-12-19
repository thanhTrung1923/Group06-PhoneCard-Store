<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Lịch sử hỗ trợ</title>
        <jsp:include page="/layout/global-import-header.jsp"/>
    </head>

    <body class="bg-gray-50">

        <!-- HEADER -->
        <jsp:include page="/layout/header.jsp"/>

        <div class="max-w-7xl mx-auto px-4 py-10 min-h-screen">

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
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold text-gray-900">
                    🎧 Lịch sử yêu cầu hỗ trợ
                </h1>
                <a href="${pageContext.request.contextPath}/support?action=create"
                   class="bg-green-500 text-white px-5 py-2 rounded-lg
                   hover:bg-green-600 font-semibold">
                    + Tạo yêu cầu mới
                </a>
            </div>

            <!-- NẾU CHƯA CÓ TICKET -->
            <c:if test="${empty tickets}">
                <div class="bg-white rounded-xl shadow-sm p-10 text-center">
                    <i class="fa-solid fa-headset text-5xl text-gray-300 mb-4"></i>
                    <p class="text-gray-600 mb-6">
                        Bạn chưa gửi yêu cầu hỗ trợ nào
                    </p>
                    <a href="${pageContext.request.contextPath}/support?action=create"
                       class="inline-block bg-green-500 text-white px-6 py-3 rounded-lg
                       hover:bg-green-600">
                        Tạo yêu cầu đầu tiên
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty tickets}">
                <div class="bg-white rounded-xl shadow-sm overflow-hidden">

                    <table class="w-full text-sm">
                        <thead class="bg-gray-100 text-gray-700">
                            <tr>
                                <th class="px-4 py-3 text-left">Mã</th>
                                <th class="px-4 py-3 text-left">Tiêu đề</th>
                                <th class="px-4 py-3 text-center">Trạng thái</th>
                                <th class="px-4 py-3 text-right">Ngày tạo</th>
                                <th class="px-4 py-3 text-center">Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${tickets}" var="t">
                                <tr class="border-t hover:bg-gray-50 transition">

                                    <td class="px-4 py-3 font-medium">
                                        #${t.ticketId}
                                    </td>

                                    <td class="px-4 py-3">
                                        ${t.subject}
                                    </td>
<!--                                     ORDER 
                                    <td class="px-4 py-3 text-center">
                                        <c:choose>
                                            <c:when test="${not empty t.orderId}">
                                                <span class="text-green-600 font-medium">
                                                    #${t.orderId}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400 italic">
                                                    Không có
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>-->

                                    <!-- PRIORITY -->
<!--                                    <td class="px-4 py-3 text-center">
                                        <c:choose>
                                            <c:when test="${t.priority == 'URGENT'}">
                                                <span class="text-red-600 font-semibold">Khẩn cấp</span>
                                            </c:when>
                                            <c:when test="${t.priority == 'HIGH'}">
                                                <span class="text-orange-500 font-semibold">Cao</span>
                                            </c:when>
                                            <c:when test="${t.priority == 'MEDIUM'}">
                                                <span class="text-yellow-600">Trung bình</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-500">Thấp</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>-->

                                    <!-- STATUS -->
                                    <td class="px-4 py-3 text-center">
                                        <c:choose>
                                            <c:when test="${t.status == 'NEW'}">
                                                <span class="bg-blue-100 text-blue-600
                                                      px-3 py-1 rounded-full text-xs font-semibold">
                                                    Mới
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status == 'PROCESSING'}">
                                                <span class="bg-yellow-100 text-yellow-700
                                                      px-3 py-1 rounded-full text-xs font-semibold">
                                                    Đang xử lý
                                                </span>
                                            </c:when>
                                            <c:when test="${t.status == 'RESOLVED'}">
                                                <span class="bg-green-100 text-green-700
                                                      px-3 py-1 rounded-full text-xs font-semibold">
                                                    Đã xử lý
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bg-gray-100 text-gray-600
                                                      px-3 py-1 rounded-full text-xs font-semibold">
                                                    Đã đóng
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="px-4 py-3 text-right text-gray-500">
                                        <fmt:formatDate value="${t.createdAt}"
                                                        pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="px-4 py-3 text-center">
                                        <a href="${pageContext.request.contextPath}/support?action=detail&ticketId=${t.ticketId}"
                                           class="text-green-600 hover:underline font-medium">
                                            Xem
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </div>
            </c:if>
        </div>

        <!-- FOOTER -->
        <jsp:include page="/layout/footer.jsp"/>
        <jsp:include page="/layout/global-import-footer.jsp"/>

    </body>
</html>
