<%-- 
    Document   : wallet-history
    Created on : Dec 18, 2025, 11:30:30 PM
    Author     : trung
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ví của bạn</title>
        <jsp:include page="/layout/global-import-header.jsp" />
    </head>
    <body class="bg-gray-50">
        <jsp:include page="/layout/header.jsp" />

        <div class="container mx-auto mt-10 mb-10 min-h-screen">
            <div class="max-w-7xl mx-auto px-4 py-8">
                <!-- Filter Form -->
                <div class="bg-white rounded-xl shadow-sm p-6 mb-8">
                    <form class="flex flex-wrap items-end gap-4" action="${pageContext.request.contextPath}/wallet/history" method="GET">
                        <div class="flex-1 min-w-[200px]">
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                <i class="fas fa-dollar-sign text-green-600 mr-1"></i>Số tiền
                            </label>
                            <div class="flex gap-2">
                                <input type="number" 
                                       name="minAmount" 
                                       placeholder="Từ" 
                                       min="0"
                                       step="1000"
                                       value="${param.minAmount}"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                                <input type="number" 
                                       name="maxAmount" 
                                       placeholder="Đến" 
                                       min="0"
                                       step="1000"
                                       value="${param.maxAmount}"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                            </div>
                        </div>

                        <div class="flex-1 min-w-[180px]">
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                <i class="fas fa-filter text-blue-600 mr-1"></i>Loại giao dịch
                            </label>
                            <select name="type" 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                                <option value="">Tất cả</option>
                                <option value="DEPOSIT" ${param.type == 'DEPOSIT' ? 'selected' : ''}>Nạp tiền</option>
                                <option value="PURCHASE" ${param.type == 'PURCHASE' ? 'selected' : ''}>Mua hàng</option>
                                <option value="REFUND" ${param.type == 'REFUND' ? 'selected' : ''}>Hoàn tiền</option>
                            </select>
                        </div>

                        <div class="flex-1 min-w-[200px]">
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                <i class="fas fa-calendar text-purple-600 mr-1"></i>Ngày giao dịch
                            </label>
                            <div class="flex gap-2">
                                <input type="date" 
                                       name="fromDate" 
                                       value="${param.fromDate}"
                                       max="<jsp:useBean id="now" class="java.util.Date"/><fmt:formatDate value="${now}" pattern="yyyy-MM-dd"/>"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                                <input type="date" 
                                       name="toDate" 
                                       value="${param.toDate}"
                                       max="<fmt:formatDate value="${now}" pattern="yyyy-MM-dd"/>"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm">
                            </div>
                        </div>

                        <div class="flex gap-2">
                            <button type="submit" 
                                    class="bg-green-500 text-white px-5 py-2 rounded-lg font-medium hover:bg-green-600 transition-colors flex items-center gap-2 whitespace-nowrap">
                                <i class="fas fa-search"></i>
                                Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/wallet/history" 
                               class="bg-gray-200 text-gray-700 px-5 py-2 rounded-lg font-medium hover:bg-gray-300 transition-colors flex items-center gap-2 whitespace-nowrap">
                                <i class="fas fa-redo"></i>
                                Đặt lại
                            </a>
                        </div>
                    </form>
                </div>

                <div class="bg-white rounded-2xl shadow-sm p-8">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="text-2xl font-bold text-gray-900">
                            Giao dịch 
                            <span class="text-lg text-gray-500 font-normal">
                                (${totalTransactions} kết quả)
                            </span>
                        </h2>
                        <a href="${pageContext.request.contextPath}/wallet" class="text-blue-600 font-medium flex items-center gap-2 hover:text-blue-700">
                            Xem tổng quan
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <div class="space-y-4">
                        <c:forEach items="${transactions}" var="transaction">
                            <div class="flex items-center justify-between p-4 border border-gray-100 rounded-lg hover:bg-gray-50 transition-colors">
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-full flex items-center justify-center
                                         ${transaction.type == 'DEPOSIT' ? 'bg-green-100' : 
                                           transaction.type == 'REFUND' ? 'bg-blue-100' : 'bg-orange-100'}">
                                        <i class="fas ${transaction.type == 'DEPOSIT' ? 'fa-plus text-green-600' : 
                                                        transaction.type == 'REFUND' ? 'fa-undo text-blue-600' : 
                                                        'fa-shopping-cart text-orange-600'}"></i>
                                    </div>
                                    <div>
                                        <p class="font-semibold text-gray-900">
                                            <c:choose>
                                                <c:when test="${transaction.type == 'DEPOSIT'}">Nạp tiền</c:when>
                                                <c:when test="${transaction.type == 'PURCHASE'}">Mua hàng</c:when>
                                                <c:when test="${transaction.type == 'REFUND'}">Hoàn tiền</c:when>
                                                <c:otherwise>${transaction.type}</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="text-sm text-gray-500">${transaction.reference}</p>
                                        <p class="text-xs text-gray-400 mt-1">
                                            ${transaction.createdAt}
                                        </p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="font-bold text-lg ${transaction.type == 'DEPOSIT' || transaction.type == 'REFUND' ? 'text-green-600' : 'text-red-600'}">
                                        ${transaction.type == 'DEPOSIT' || transaction.type == 'REFUND' ? '+' : ''}
                                        <fmt:formatNumber value="${transaction.amount}" pattern="#,###"/>
                                        <i class="fa-solid fa-coins text-sm ml-1"></i>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty transactions}">
                            <div class="text-center py-12">
                                <i class="fas fa-inbox text-gray-300 text-5xl mb-4"></i>
                                <p class="text-gray-500 text-lg">Chưa có giao dịch nào</p>
                                <c:if test="${not empty param.minAmount or not empty param.maxAmount or not empty param.type or not empty param.fromDate or not empty param.toDate}">
                                    <p class="text-gray-400 text-sm mt-2">Thử điều chỉnh bộ lọc của bạn</p>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="flex justify-center items-center gap-2 mt-8">
                            <c:if test="${page > 1}">
                                <a href="?page=${page - 1}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}&type=${param.type}&fromDate=${param.fromDate}&toDate=${param.toDate}" 
                                   class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == page}">
                                        <span class="px-4 py-2 bg-green-500 text-white rounded-lg font-medium">
                                            ${i}
                                        </span>
                                    </c:when>
                                    <c:when test="${i == 1 or i == totalPages or (i >= page - 2 and i <= page + 2)}">
                                        <a href="?page=${i}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}&type=${param.type}&fromDate=${param.fromDate}&toDate=${param.toDate}" 
                                           class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                            ${i}
                                        </a>
                                    </c:when>
                                    <c:when test="${i == page - 3 or i == page + 3}">
                                        <span class="px-2 text-gray-400">...</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${page < totalPages}">
                                <a href="?page=${page + 1}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}&type=${param.type}&fromDate=${param.fromDate}&toDate=${param.toDate}" 
                                   class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <script src="${pageContext.request.contextPath}/js/global-script.js"></script>
    </body>
</html>