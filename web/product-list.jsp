<%-- 
    Document   : product-list
    Created on : Dec 11, 2025, 1:23:21 AM
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
        <title>Danh sách sản phẩm</title>
        <jsp:include page="/layout/global-import-header.jsp" />
    </head>
    <body>
        <jsp:include page="/layout/header.jsp" />

        <div class="container mx-auto mb-10 mt-10 min-h-screen">
            <div class="mb-6 text-sm">
                <span class="text-gray-600"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></span>
                <span class="mx-2 text-gray-400">></span>
                <span class="text-green-500 font-semibold">Danh sách sản phẩm</span>
            </div>

            <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
                <form action="${pageContext.request.contextPath}/products">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-4">
                        <input name="typeName" type="text" value="${typeName}" placeholder="Tìm kiếm theo tên" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                        <input name="typeCode" type="text" value="${typeCode}" placeholder="Tìm kiếm theo loại" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                        <input name="value" type="number" value="${value}" placeholder="Tìm kiếm theo mệnh giá" min="0" max="500000" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                        <input name="description" type="text" value="${description}" placeholder="Tìm kiếm theo mô tả" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <select name="orderBy" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
                            <option value="">Sắp xếp theo</option>
                            <option value="price" ${orderBy == 'price' ? 'selected' : ''}>Sắp xếp theo: Giá</option>
                            <option value="name" ${orderBy == 'name' ? 'selected' : ''}>Sắp xếp theo: Tên</option>
                            <option value="sold" ${orderBy == 'sold' ? 'selected' : ''}>Sắp xếp theo: Số lượng đã bán</option>
                            <option value="rating" ${orderBy == 'rating' ? 'selected' : ''}>Sắp xếp theo: Số lượng phản hồi</option>
                        </select>
                        <select name="orderType" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
                            <option value="">Thứ tự sắp xếp</option>
                            <option value="asc" ${orderType == 'asc' ? 'selected' : ''}>Tăng dần</option>
                            <option value="desc" ${orderType == 'desc' ? 'selected' : ''}>Giảm dần</option>
                        </select>
                    </div>
                    <div class="flex gap-3 justify-end">
                        <button class="px-6 py-2 bg-green-500 text-white font-semibold rounded-lg hover:bg-green-600 transition-colors">
                            <i class="fa-solid fa-filter mr-2"></i>Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/products" class="px-6 py-2 bg-red-500 text-white font-semibold rounded-lg hover:bg-red-600 transition-colors cursor-pointer">
                            <i class="fa-solid fa-times mr-2"></i>Xoá Lọc
                        </a>
                    </div>
                </form>
            </div>

            <div class="flex gap-6">
                <div class="flex-1">
                    <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-6 mb-6">
                        <c:forEach items="${cpList}" var="cp">
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

                    <div class="flex items-center justify-center gap-2">
                        <a href="?page=${currentPage > 1 ? currentPage - 1 : 1}" 
                           class="px-4 py-2 rounded-lg font-semibold transition-all ${currentPage == 1 ? 'bg-gray-200 text-gray-400 cursor-not-allowed pointer-events-none' : 'bg-green-500 text-white hover:bg-green-600'}">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?page=${i}" 
                               class="w-10 h-10 rounded-lg font-semibold transition-all flex items-center justify-center ${currentPage == i ? 'bg-green-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'}">
                                ${i}
                            </a>
                        </c:forEach>

                        <a href="?page=${currentPage < totalPages ? currentPage + 1 : totalPages}" 
                           class="px-4 py-2 rounded-lg font-semibold transition-all ${currentPage == totalPages ? 'bg-gray-200 text-gray-400 cursor-not-allowed pointer-events-none' : 'bg-green-500 text-white hover:bg-green-600'}">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <script src="${pageContext.request.contextPath}/js/global-script.js"></script>
    </body>
</html>
