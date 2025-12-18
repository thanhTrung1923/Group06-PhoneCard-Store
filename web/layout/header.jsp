<%-- 
    Document   : header
    Created on : Dec 11, 2025, 1:56:36 AM
    Author     : trung
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN" />

<header class="bg-white shadow-sm sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">

            <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-3 no-underline">
                <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center text-gray-600 font-semibold">
                    Logo
                </div>
                <div>
                    <div class="text-lg font-bold text-gray-900">PhoneCardStore</div>
                    <div class="text-xs text-gray-500">Nạp thẻ siêu tốc</div>
                </div>
            </a>

            <nav class="hidden md:flex items-center gap-8">
                <a href="${pageContext.request.contextPath}/home" class="text-gray-700 ${headerActive == 'home' ? 'font-medium text-green-500 hover:text-green-600' : 'hover:text-green-500'} transition">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/products" class="text-gray-700 ${headerActive == 'products' ? 'font-medium text-green-500 hover:text-green-600' : 'hover:text-green-500'} transition">Sản phẩm</a>
            </nav>

            <div class="flex items-center gap-4">
                <a href="${pageContext.request.contextPath}/cart"
                   class="relative p-2 text-gray-600 hover:text-gray-900">

                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5
                              M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17
                              m0 0a2 2 0 100 4 2 2 0 000-4
                              m-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                    <!-- Badge số lượng -->
                    <c:if test="${cartTotalQuantity > 0}">
                        <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs
                              w-5 h-5 flex items-center justify-center rounded-full">
                            ${cartTotalQuantity}
                        </span>
                    </c:if>
                </a>

                <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                        <div class="flex items-center gap-3 border-l pl-4 ml-2">

                            <a href="${pageContext.request.contextPath}/wallet">
                                <div class="bg-green-500 py-2 px-4 rounded-xl text-white font-bold flex gap-2 items-center">
                                    <fmt:formatNumber value="${sessionScope.balance}" />
                                    <span><i class="fa-solid fa-coins"></i></span>
                                </div>
                            </a>

                            <a href="order-history" class="text-gray-500 hover:text-green-600 transition" title="Lịch sử đơn hàng">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </a>
                            <a href="profile" class="flex items-center gap-2 no-underline group ml-2">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account.avatarUrl}">
                                        <img src="${sessionScope.account.avatarUrl}"
                                             alt="Avatar"
                                             class="w-8 h-8 rounded-full border border-gray-200 object-cover">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://ui-avatars.com/api/?background=random&name=${sessionScope.account.fullName}"
                                                 alt="Avatar"
                                                 class="w-8 h-8 rounded-full border border-gray-200 object-cover">
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="hidden lg:block text-sm">
                                            <p class="text-gray-900 font-medium group-hover:text-green-600 truncate max-w-[100px]">
                                                ${sessionScope.account.fullName}
                                            </p>
                                        </div>
                                        </a>

                                        <a href="logout" class="text-gray-500 hover:text-red-500 ml-1" title="Đăng xuất">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none"
                                                 viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                                            </svg>
                                        </a>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="flex items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/login">
                                                <button class="px-4 py-2 text-gray-700 hover:text-gray-900 font-medium hover:bg-gray-100 rounded-lg transition">
                                                    Đăng nhập
                                                </button>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/register">
                                                <button class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 font-medium shadow-md transition transform hover:-translate-y-0.5">
                                                    Đăng kí
                                                </button>
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                </div>
                                </div>
                                </div>
                                </header>