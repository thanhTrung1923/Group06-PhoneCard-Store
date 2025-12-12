<%-- 
    Document   : header
    Created on : Dec 11, 2025, 1:56:36 AM
    Author     : trung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header class="bg-white shadow-sm">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            <!-- Logo -->
            <div class="flex items-center gap-3">
                <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center text-gray-600 font-semibold">
                    Logo
                </div>
                <div>
                    <div class="text-lg font-bold text-gray-900">PhoneCardStore</div>
                    <div class="text-xs text-gray-500">Nạp thẻ siêu tốc</div>
                </div>
            </div>

            <nav class="hidden md:flex items-center gap-8">
                <a href="${pageContext.request.contextPath}/home" class="text-gray-700 ${headerActive == 'home' ? 'font-medium text-green-500 hover:text-green-600' : 'hover:text-green-500'} transition">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/products" class="text-gray-700 ${headerActive == 'products' ? 'font-medium text-green-500 hover:text-green-600' : 'hover:text-green-500'} transition">Sản phẩm</a>
                <a href="${pageContext.request.contextPath}/news" class="text-gray-700 ${headerActive == 'news' ? 'font-medium text-green-500 hover:text-green-600' : 'hover:text-green-500'} transition">Bài viết</a>
                <a href="${pageContext.request.contextPath}/ticket" class="text-gray-700 ${headerActive == 'ticket' ? 'font-medium text-green-500 hover:text-green-600' : 'hover:text-green-500'} transition">Ticket Hỗ trợ</a>
            </nav>

            <div class="flex items-center gap-4">
                <button class="p-2 text-gray-600 hover:text-gray-900">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                    </svg>
                </button>
                <button class="p-2 text-gray-600 hover:text-gray-900">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                    </svg>
                </button>
                <button class="px-4 py-2 text-gray-700 hover:text-gray-900 font-medium">
                    Đăng nhập
                </button>
                <button class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 font-medium">
                    Đăng kí
                </button>
            </div>
        </div>
    </div>
</header>