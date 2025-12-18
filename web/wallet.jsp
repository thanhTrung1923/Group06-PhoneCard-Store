<%-- 
    Document   : wallet
    Created on : Dec 18, 2025, 8:18:39 PM
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
            <div class="bg-green-500 rounded-3xl p-12 max-w-7xl lg:mx-auto">
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                    <div>
                        <h1 class="text-4xl md:text-5xl font-bold text-white mb-4">
                            Ví của bạn
                        </h1>
                        <p class="text-white text-lg">Quản lý số dư và giao dịch của bạn</p>
                    </div>
                    <div class="bg-white/20 backdrop-blur-sm rounded-2xl p-6 min-w-[280px]">
                        <p class="text-white text-sm mb-2">Số dư hiện tại</p>
                        <p class="text-4xl font-bold text-white">
                            <fmt:formatNumber value="${sessionScope.balance}"/>
                            <span><i class="fa-solid fa-coins"></i></span>
                        </p>
                    </div>
                </div>
            </div>

            <div class="max-w-7xl mx-auto px-4 py-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <button class="bg-white rounded-2xl shadow-sm p-8 hover:shadow-md transition-shadow group">
                        <div class="flex items-center justify-between mb-4">
                            <div class="text-left">
                                <h3 class="text-xl font-bold text-gray-900 mb-2">Nạp tiền</h3>
                                <p class="text-gray-600 text-sm">Thêm tiền vào ví của bạn</p>
                            </div>
                            <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center group-hover:bg-green-200 transition-colors">
                                <i class="fas fa-plus text-green-600 text-xl"></i>
                            </div>
                        </div>
                    </button>

                    <button class="bg-white rounded-2xl shadow-sm p-8 hover:shadow-md transition-shadow group">
                        <div class="flex items-center justify-between mb-4">
                            <div class="text-left">
                                <h3 class="text-xl font-bold text-gray-900 mb-2">Lịch sử</h3>
                                <p class="text-gray-600 text-sm">Xem tất cả giao dịch</p>
                            </div>
                            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                                <i class="fas fa-history text-blue-600 text-xl"></i>
                            </div>
                        </div>
                    </button>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-gray-600 text-sm mb-1">Tổng nạp</p>
                                <p class="text-2xl font-bold text-gray-900">
                                    <fmt:formatNumber value="${totalDeposit}" type="currency" />
                                </p>
                            </div>
                            <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-arrow-up text-green-600"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-gray-600 text-sm mb-1">Tổng chi</p>
                                <p class="text-2xl font-bold text-gray-900">
                                    <fmt:formatNumber value="${totalSpent}" type="currency" />
                                </p>
                            </div>
                            <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-arrow-down text-red-600"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-gray-600 text-sm mb-1">Giao dịch tháng này</p>
                                <p class="text-2xl font-bold text-gray-900">${monthlyTransactions}</p>
                            </div>
                            <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                <i class="fas fa-exchange-alt text-blue-600"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Transactions -->
                <div class="bg-white rounded-2xl shadow-sm p-8">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="text-2xl font-bold text-gray-900">Giao dịch gần đây</h2>
                        <a href="${pageContext.request.contextPath}/wallet/transactions" class="text-blue-600 font-medium flex items-center gap-2 hover:text-blue-700">
                            Xem tất cả
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <div class="space-y-4">
                        <c:forEach items="${recentTransactions}" var="transaction">
                            <div class="flex items-center justify-between p-4 border border-gray-100 rounded-lg hover:bg-gray-50 transition-colors">
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-full flex items-center justify-center
                                         ${transaction.type == 'DEPOSIT' ? 'bg-green-100' : 
                                           transaction.type == 'WITHDRAW' ? 'bg-orange-100' : 'bg-blue-100'}">
                                        <i class="fas ${transaction.type == 'DEPOSIT' ? 'fa-plus text-green-600' : 
                                                        transaction.type == 'WITHDRAW' ? 'fa-minus text-orange-600' : 
                                                        'fa-shopping-cart text-blue-600'}"></i>
                                    </div>
                                    <div>
                                        <p class="font-semibold text-gray-900">${transaction.reference}</p>
                                        <p class="text-sm text-gray-500">${transaction.createdAt}</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="font-bold ${transaction.type == 'DEPOSIT' ? 'text-green-600' : 'text-red-600'}">
                                        ${transaction.type == 'DEPOSIT' ? '+' : ''}
                                        <fmt:formatNumber value="${transaction.amount}" type="currency" />
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty recentTransactions}">
                            <div class="text-center py-12">
                                <i class="fas fa-inbox text-gray-300 text-5xl mb-4"></i>
                                <p class="text-gray-500">Chưa có giao dịch nào</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <script src="${pageContext.request.contextPath}/js/global-script.js"></script>
    </body>
</html>