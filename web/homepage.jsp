<%-- 
    Document   : homepage
    Created on : Dec 11, 2025, 1:23:04 AM
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
        <title>Trang chủ</title>
        <jsp:include page="/layout/global-import-header.jsp" />
    </head>
    <c:if test="${not empty errorMessage}">
        <div class="max-w-7xl mx-auto px-4 mt-6">
            <div class="bg-red-100 border border-red-400 text-red-700 px-6 py-4 rounded-lg flex items-center gap-3">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span class="font-medium">
                    ${errorMessage}
                </span>
            </div>
        </div>
    </c:if>

    <body class="bg-gray-50">
        <jsp:include page="/layout/header.jsp" />

        <div class="container mx-auto mt-10 mb-10 min-h-screen">
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
                            <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-bolt text-green-600"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-sm p-8 hover:shadow-md transition-shadow">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-900 mb-2">Cam kết chính hãng</h3>
                                <p class="text-gray-600 text-sm">100% thẻ thật</p>
                            </div>
                            <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-shield text-blue-600"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-sm p-8 hover:shadow-md transition-shadow">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-900 mb-2">Hỗ trợ 24/7</h3>
                                <p class="text-gray-600 text-sm">Luôn sẵn sàng hỗ trợ mọi lúc mọi nơi</p>
                            </div>
                            <div class="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-headset text-purple-600"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="flex items-center justify-between mb-8">
                        <h2 class="text-2xl font-bold text-gray-900">Được mua nhiều nhất</h2>
                        <a href="${pageContext.request.contextPath}/products?orderBy=sold&orderType=desc" class="text-gray-900 font-medium flex items-center gap-2 hover:text-green-600">
                            Xem tất cả
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <c:forEach items="${cpMostBuyed}" var="cp">
                            <div class="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow ${cp.stock_quantity <= 0 ? 'opacity-75' : ''}">
                                <div class="relative">
                                    <div class="absolute top-3 left-3 text-sm font-medium rounded px-2 py-1 z-10
                                         ${cp.stock_quantity <= 0 ? 'bg-red-500 text-white' : 'bg-white text-gray-900'}">
                                        <c:choose>
                                            <c:when test="${cp.stock_quantity <= 0}">
                                                <i class="fa-solid fa-circle-xmark mr-1"></i>Hết hàng
                                            </c:when>
                                            <c:otherwise>
                                                Còn lại: ${cp.stock_quantity}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="absolute top-3 right-3 flex gap-2 z-10">
                                        <span class="bg-green-500 text-white text-xs font-semibold px-3 py-1 rounded">${cp.type_code}</span>
                                        <c:if test="${cp.discount_percent > 0}">
                                            <span class="bg-red-500 text-white text-xs font-semibold px-2 py-1 rounded">
                                                -<fmt:formatNumber value="${cp.discount_percent}" maxFractionDigits="0" />%
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="w-full h-40 bg-gray-200 rounded-lg overflow-hidden relative">
                                        <img src="${cp.thumbnail_url}" 
                                             class="w-full h-full object-cover transition duration-300 ease-in-out hover:scale-110
                                             ${cp.stock_quantity <= 0 ? 'filter grayscale' : ''}" 
                                             alt="${cp.type_name}">
                                    </div>
                                </div>

                                <div class="p-4">
                                    <div class="flex items-center gap-2 mb-2">
                                        <i class="fa-solid fa-star text-yellow-400"></i>
                                        <span class="font-semibold">${cp.avg_rating}</span>
                                        <span class="text-gray-400">•</span>
                                        <span class="text-sm text-gray-600">Đã bán ${cp.total_sold}</span>
                                    </div>

                                    <h3 class="font-semibold text-gray-900 mb-2">${cp.type_name}</h3>

                                    <div class="mb-4">
                                        <span class="text-lg font-bold text-gray-900">
                                            <fmt:formatNumber value="${cp.final_price}" type="currency" />
                                        </span>
                                        <c:if test="${cp.discount_percent > 0}">
                                            <span class="text-sm text-gray-400 line-through ml-2">
                                                <fmt:formatNumber value="${cp.sell_price}" type="currency" />
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="flex gap-2">
                                        <c:choose>
                                            <c:when test="${cp.stock_quantity <= 0}">
                                                <button class="flex-1 bg-gray-300 text-gray-500 py-2 px-4 rounded-lg font-medium cursor-not-allowed" disabled>
                                                    <i class="fa-solid fa-ban mr-1"></i>Hết hàng
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/checkout" method="get">
                                                    <input type="hidden" name="action" value="buyNow"/>
                                                    <input type="hidden" name="productId" value="${cp.product_id}"/>
                                                    <input type="hidden" name="quantity" value="1"/>
                                                    <input type="hidden" name="unitPrice" value="${cp.final_price}"/>

                                                    <button class="flex-1 bg-green-500 text-white py-2 px-4 rounded-lg">
                                                        Mua ngay
                                                    </button>
                                                </form>
                                                <button type="button" class="flex-1 bg-yellow-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                                    <a href="${pageContext.request.contextPath}/products/detail?productId=${cp.product_id}">Chi tiết</a>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="py-12">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="flex items-center justify-between mb-8">
                        <h2 class="text-2xl font-bold text-gray-900">Phản hồi tốt nhất</h2>
                        <a href="${pageContext.request.contextPath}/products?orderBy=rating&orderType=desc" class="text-gray-900 font-medium flex items-center gap-2 hover:text-green-600">
                            Xem tất cả
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <c:forEach items="${cpBestFeedback}" var="cp">
                            <div class="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow ${cp.stock_quantity <= 0 ? 'opacity-75' : ''}">
                                <div class="relative">
                                    <div class="absolute top-3 left-3 text-sm font-medium rounded px-2 py-1 z-10
                                         ${cp.stock_quantity <= 0 ? 'bg-red-500 text-white' : 'bg-white text-gray-900'}">
                                        <c:choose>
                                            <c:when test="${cp.stock_quantity <= 0}">
                                                <i class="fa-solid fa-circle-xmark mr-1"></i>Hết hàng
                                            </c:when>
                                            <c:otherwise>
                                                Còn lại: ${cp.stock_quantity}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="absolute top-3 right-3 flex gap-2 z-10">
                                        <span class="bg-green-500 text-white text-xs font-semibold px-3 py-1 rounded">${cp.type_code}</span>
                                        <c:if test="${cp.discount_percent > 0}">
                                            <span class="bg-red-500 text-white text-xs font-semibold px-2 py-1 rounded">
                                                -<fmt:formatNumber value="${cp.discount_percent}" maxFractionDigits="0" />%
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="w-full h-40 bg-gray-200 rounded-lg overflow-hidden relative">
                                        <img src="${cp.thumbnail_url}" 
                                             class="w-full h-full object-cover transition duration-300 ease-in-out hover:scale-110
                                             ${cp.stock_quantity <= 0 ? 'filter grayscale' : ''}" 
                                             alt="${cp.type_name}">
                                    </div>
                                </div>

                                <div class="p-4">
                                    <div class="flex items-center gap-2 mb-2">
                                        <span class="text-yellow-400">⭐</span>
                                        <span class="font-semibold">${cp.avg_rating}</span>
                                        <span class="text-gray-400">•</span>
                                        <span class="text-sm text-gray-600">Đã bán ${cp.total_sold}</span>
                                    </div>

                                    <h3 class="font-semibold text-gray-900 mb-2">${cp.type_name}</h3>

                                    <div class="mb-4">
                                        <span class="text-lg font-bold text-gray-900">
                                            <fmt:formatNumber value="${cp.final_price}" type="currency" />
                                        </span>
                                        <c:if test="${cp.discount_percent > 0}">
                                            <span class="text-sm text-gray-400 line-through ml-2">
                                                <fmt:formatNumber value="${cp.sell_price}" type="currency" />
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="flex gap-2">
                                        <c:choose>
                                            <c:when test="${cp.stock_quantity <= 0}">
                                                <button class="flex-1 bg-gray-300 text-gray-500 py-2 px-4 rounded-lg font-medium cursor-not-allowed" disabled>
                                                    <i class="fa-solid fa-ban mr-1"></i>Hết hàng
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/checkout" method="post">
                                                    <input type="hidden" name="action" value="buyNow"/>
                                                    <input type="hidden" name="productId" value="${cp.product_id}"/>
                                                    <input type="hidden" name="quantity" value="1"/>
                                                    <input type="hidden" name="unitPrice" value="${cp.final_price}"/>

                                                    <button class="flex-1 bg-green-500 text-white py-2 px-4 rounded-lg">
                                                        Mua ngay
                                                    </button>
                                                </form>

                                                <button type="button" class="flex-1 bg-yellow-500 text-white py-2 px-4 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                                    <a href="${pageContext.request.contextPath}/products/detail?productId=${cp.product_id}">Chi tiết</a>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="py-12">
                <div class="mx-auto px-4 sm:px-6 lg:px-8">
                    <h2 class="text-3xl font-bold text-gray-900 text-center mb-8">Khách hàng nói gì về chúng tôi</h2>
                    <div class="space-y-4">
                        <c:forEach items="${cfList}" var="cf">
                            <div class="bg-white rounded-lg shadow-sm p-6">
                                <div class="flex items-center justify-between mb-3">
                                    <div class="flex gap-1">
                                        <c:forEach begin="1" end="${cf.rating}">
                                            <i class="fa-solid fa-star text-yellow-400"></i>
                                        </c:forEach>
                                        <c:forEach begin="1" end="${5 - cf.rating}">
                                            <i class="fa-solid fa-star text-gray-300"></i>
                                        </c:forEach>
                                    </div>
                                    <c:if test="${not empty cf.category}">
                                        <span class="text-xs px-2 py-1 rounded-full bg-blue-100 text-blue-700 font-medium">
                                            <c:choose>
                                                <c:when test="${cf.category == 'SERVICE'}">Dịch vụ</c:when>
                                                <c:when test="${cf.category == 'PRODUCT'}">Sản phẩm</c:when>
                                                <c:when test="${cf.category == 'WEBSITE'}">Website</c:when>
                                                <c:when test="${cf.category == 'DELIVERY'}">Giao hàng</c:when>
                                                <c:otherwise>Khác</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:if>
                                </div>

                                <c:if test="${not empty cf.subject}">
                                    <h4 class="font-semibold text-gray-900 mb-2">${cf.subject}</h4>
                                </c:if>

                                <p class="text-gray-700 mb-4 line-clamp-3">"${cf.content}"</p>

                                <div class="flex items-center justify-between pt-3 border-t border-gray-100">
                                    <div>
                                        <p class="font-semibold text-gray-900">${cf.customerName}</p>
                                        <c:if test="${not empty cf.createdAt}">
                                            <p class="text-xs text-gray-500 mt-1">
                                                ${cf.getCreatedAtFormatted()}
                                            </p>
                                        </c:if>
                                    </div>

                                    <c:if test="${not empty cf.orderId}">
                                        <span class="flex items-center gap-1 text-xs text-green-600 font-medium">
                                            <i class="fa-solid fa-circle-check"></i>
                                            Đã mua hàng
                                        </span>
                                    </c:if>
                                </div>

                                <c:if test="${cf.isResponded and not empty cf.adminResponse}">
                                    <div class="mt-4 pl-4 border-l-2 border-blue-500 bg-blue-50 p-3 rounded">
                                        <p class="text-xs font-semibold text-blue-900 mb-1">Phản hồi từ Admin:</p>
                                        <p class="text-sm text-gray-700">${cf.adminResponse}</p>
                                        <c:if test="${not empty cf.respondedAt}">
                                            <p class="text-xs text-gray-500 mt-2">
                                                ${cf.getRespondedAtFormatted()}
                                            </p>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <script src="${pageContext.request.contextPath}/js/global-script.js"></script>
    </body>
</html>
