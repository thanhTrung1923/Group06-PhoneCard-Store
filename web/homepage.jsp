<%-- 
    Document   : homepage
    Created on : Dec 11, 2025, 1:23:04 AM
    Author     : trung
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <jsp:include page="/layout/global-import-header.jsp" />
    </head>
    <body class="bg-gray-50">
        <jsp:include page="/layout/header.jsp" />

        <div class="container mx-auto mt-10 mb-10">
            <div class="bg-gradient-to-r from-green-500 to-green-400 rounded-3xl mx-4 my-8 p-12 max-w-7xl lg:mx-auto">
                <h1 class="text-4xl md:text-5xl font-bold text-white mb-4">
                    Nạp nhanh chóng<br>Thao tác gọn lẹ
                </h1>
                <p class="text-white text-lg mb-6">Hỗ trợ đa dạng loại thẻ. Giao dịch tự động 24/7</p>
                <div class="flex gap-3">
                    <button class="bg-white text-gray-900 px-6 py-3 rounded-full font-semibold hover:bg-gray-50 transition-colors">
                        Mua ngay
                    </button>
                    <button class="bg-green-600 text-white px-6 py-3 rounded-full font-semibold hover:bg-green-700 transition-colors">
                        Xem ưu đãi
                    </button>
                </div>
            </div>

            <div class="max-w-7xl mx-auto px-4 py-8">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-white rounded-2xl shadow-sm p-8 hover:shadow-md transition-shadow">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-900 mb-2">Nạp siêu tốc</h3>
                                <p class="text-gray-600 text-sm">Giao dịch tự động trong vòng 30s</p>
                            </div>
                            <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <svg class="w-6 h-6 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z" />
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-sm p-8 hover:shadow-md transition-shadow">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-900 mb-2">Bảo mật cao</h3>
                                <p class="text-gray-600 text-sm">Mã hoá thông tin, đảm bảo an toàn</p>
                            </div>
                            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <svg class="w-6 h-6 text-blue-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                </svg>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-sm p-8 hover:shadow-md transition-shadow">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-900 mb-2">Hỗ trợ 24/7</h3>
                                <p class="text-gray-600 text-sm">Luôn sẵn sàng hỗ trợ mọi lúc mọi nơi</p>
                            </div>
                            <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                                <svg class="w-6 h-6 text-purple-500" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M2 3a1 1 0 011-1h2.153a1 1 0 01.986.836l.74 4.435a1 1 0 01-.54 1.06l-1.548.773a11.037 11.037 0 006.105 6.105l.774-1.548a1 1 0 011.059-.54l4.435.74a1 1 0 01.836.986V17a1 1 0 01-1 1h-2C7.82 18 2 12.18 2 5V3z" />
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="flex items-center justify-between mb-8">
                        <h2 class="text-2xl font-bold text-gray-900">Được mua nhiều nhất</h2>
                        <a href="#" class="text-gray-900 font-medium flex items-center gap-2 hover:text-green-600">
                            Xem tất cả
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div class="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
                            <div class="relative">
                                <div class="absolute top-3 left-3 text-sm font-medium">Còn lại: 240</div>
                                <div class="absolute top-3 right-3 flex gap-2">
                                    <span class="bg-green-500 text-white text-xs font-semibold px-3 py-1 rounded">Viettel</span>
                                    <span class="bg-red-500 text-white text-xs font-semibold px-2 py-1 rounded">-5%</span>
                                </div>
                                <div class="w-full h-40 bg-gray-200"></div>
                            </div>
                            <div class="p-4">
                                <div class="flex items-center gap-2 mb-2">
                                    <span class="text-yellow-400">⭐</span>
                                    <span class="font-semibold">4.9</span>
                                    <span class="text-gray-400">•</span>
                                    <span class="text-sm text-gray-600">Đã bán 4000</span>
                                </div>
                                <h3 class="font-semibold text-gray-900 mb-2">Thẻ điện thoại Viettel 10.000đ</h3>
                                <div class="mb-4">
                                    <span class="text-lg font-bold text-gray-900">9.500đ</span>
                                    <span class="text-sm text-gray-400 line-through ml-2">10.000đ</span>
                                </div>
                                <div class="flex gap-2">
                                    <button class="flex-1 bg-green-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-green-600 transition-colors">
                                        Mua ngay
                                    </button>
                                    <button class="flex-1 bg-yellow-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                        Chi tiết
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
                            <div class="relative">
                                <div class="absolute top-3 left-3 text-sm font-medium">Còn lại: 240</div>
                                <div class="absolute top-3 right-3">
                                    <span class="bg-green-500 text-white text-xs font-semibold px-3 py-1 rounded">Viettel</span>
                                </div>
                                <div class="w-full h-40 bg-gray-200"></div>
                            </div>
                            <div class="p-4">
                                <div class="flex items-center gap-2 mb-2">
                                    <span class="text-yellow-400">⭐</span>
                                    <span class="font-semibold">4.9</span>
                                    <span class="text-gray-400">•</span>
                                    <span class="text-sm text-gray-600">Đã bán 4000</span>
                                </div>
                                <h3 class="font-semibold text-gray-900 mb-2">Thẻ điện thoại Viettel 10.000đ</h3>
                                <div class="mb-4">
                                    <span class="text-lg font-bold text-gray-900">10.000đ</span>
                                </div>
                                <div class="flex gap-2">
                                    <button class="flex-1 bg-green-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-green-600 transition-colors">
                                        Mua ngay
                                    </button>
                                    <button class="flex-1 bg-yellow-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                        Chi tiết
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="py-12">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <!-- Header -->
                    <div class="flex items-center justify-between mb-8">
                        <h2 class="text-2xl font-bold text-gray-900">Phản hồi tốt nhất</h2>
                        <a href="#" class="text-gray-900 font-medium flex items-center gap-2 hover:text-green-600">
                            Xem tất cả
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div class="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
                            <div class="relative">
                                <div class="absolute top-3 left-3 text-sm font-medium">Còn lại: 240</div>
                                <div class="absolute top-3 right-3 flex gap-2">
                                    <span class="bg-green-500 text-white text-xs font-semibold px-3 py-1 rounded">Viettel</span>
                                    <span class="bg-red-500 text-white text-xs font-semibold px-2 py-1 rounded">-5%</span>
                                </div>
                                <div class="w-full h-40 bg-gray-200"></div>
                            </div>
                            <div class="p-4">
                                <div class="flex items-center gap-2 mb-2">
                                    <span class="text-yellow-400">⭐</span>
                                    <span class="font-semibold">4.9</span>
                                    <span class="text-gray-400">•</span>
                                    <span class="text-sm text-gray-600">Đã bán 4000</span>
                                </div>
                                <h3 class="font-semibold text-gray-900 mb-2">Thẻ điện thoại Viettel 10.000đ</h3>
                                <div class="mb-4">
                                    <span class="text-lg font-bold text-gray-900">9.500đ</span>
                                    <span class="text-sm text-gray-400 line-through ml-2">10.000đ</span>
                                </div>
                                <div class="flex gap-2">
                                    <button class="flex-1 bg-green-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-green-600 transition-colors">
                                        Mua ngay
                                    </button>
                                    <button class="flex-1 bg-yellow-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                        Chi tiết
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
                            <div class="relative">
                                <div class="absolute top-3 left-3 text-sm font-medium">Còn lại: 240</div>
                                <div class="absolute top-3 right-3">
                                    <span class="bg-green-500 text-white text-xs font-semibold px-3 py-1 rounded">Viettel</span>
                                </div>
                                <div class="w-full h-40 bg-gray-200"></div>
                            </div>
                            <div class="p-4">
                                <div class="flex items-center gap-2 mb-2">
                                    <span class="text-yellow-400">⭐</span>
                                    <span class="font-semibold">4.9</span>
                                    <span class="text-gray-400">•</span>
                                    <span class="text-sm text-gray-600">Đã bán 4000</span>
                                </div>
                                <h3 class="font-semibold text-gray-900 mb-2">Thẻ điện thoại Viettel 10.000đ</h3>
                                <div class="mb-4">
                                    <span class="text-lg font-bold text-gray-900">10.000đ</span>
                                </div>
                                <div class="flex gap-2">
                                    <button class="flex-1 bg-green-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-green-600 transition-colors">
                                        Mua ngay
                                    </button>
                                    <button class="flex-1 bg-yellow-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                        Chi tiết
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="py-12">
                <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                    <h2 class="text-3xl font-bold text-gray-900 text-center mb-8">Khách hàng nói gì về chúng tôi</h2>

                    <div class="space-y-4">
                        <div class="bg-white rounded-lg shadow-sm p-6">
                            <div class="flex gap-1 mb-3">
                                <span class="text-yellow-400 text-lg">⭐</span>
                                <span class="text-yellow-400 text-lg">⭐</span>
                                <span class="text-yellow-400 text-lg">⭐</span>
                                <span class="text-yellow-400 text-lg">⭐</span>
                                <span class="text-yellow-400 text-lg">⭐</span>
                            </div>
                            <p class="text-gray-700 mb-3">"Dịch vụ tuyệt con mẹ nó vời á"</p>
                            <p class="font-semibold text-gray-900">Thành Trung</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <script src="/js/global-script.js"></script>
    </body>
</html>
