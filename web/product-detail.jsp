<%-- 
    Document   : product-detail
    Created on : Dec 11, 2025, 1:23:55 AM
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
        <title>${cp.type_name} - Chi tiết sản phẩm</title>
        <jsp:include page="/layout/global-import-header.jsp" />
    </head>
    <body>
        <jsp:include page="/layout/header.jsp" />

        <div class="container mx-auto mb-10 mt-10">
            <div class="max-w-6xl mx-auto mb-6 text-sm">
                <span class="text-gray-600"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></span>
                <span class="mx-2 text-gray-400">></span>
                <span class="text-gray-600"><a href="${pageContext.request.contextPath}/products">Danh sách sản phẩm</a></span>
                <span class="mx-2 text-gray-400">></span>
                <span class="text-green-500 font-semibold">${cp.type_name}</span>
            </div>

            <div class="max-w-6xl mx-auto bg-white rounded-2xl shadow-xl overflow-hidden">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 p-8">
                    <div class="space-y-4">
                        <div class="relative aspect-square bg-gradient-to-br from-blue-50 to-purple-50 rounded-xl overflow-hidden">
                            <img 
                                src="${not empty cp.img_url ? cp.img_url : cp.thumbnail_url}" 
                                alt="${cp.type_name}" 
                                class="w-full h-full object-contain p-8 hover:scale-105 transition-transform duration-300"
                                >
                            <c:if test="${cp.discount_percent > 0}">
                                <div class="absolute top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-full text-sm font-semibold shadow-lg">
                                    <i class="fas fa-fire mr-1"></i> -<fmt:formatNumber value="${cp.discount_percent}" maxFractionDigits="0" />%
                                </div>
                            </c:if>
                        </div>

                        <div class="grid grid-cols-4 gap-3">
                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-blue-500 cursor-pointer">
                                <img src="${not empty cp.img_url ? cp.img_url : cp.thumbnail_url}" class="w-full h-full object-cover">
                            </div>
                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-transparent hover:border-gray-300 cursor-pointer">
                                <img src="${not empty cp.thumbnail_url ? cp.thumbnail_url : cp.img_url}" class="w-full h-full object-cover">
                            </div>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <div>
                            <div class="flex items-center gap-2 mb-2">
                                <span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-semibold uppercase">${cp.type_code}</span>
                                <c:choose>
                                    <c:when test="${cp.stock_status == 'IN_STOCK'}">
                                        <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-semibold">
                                            <i class="fas fa-check-circle mr-1"></i> Còn hàng
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-semibold">
                                            <i class="fas fa-times-circle mr-1"></i> Hết hàng
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h1 class="text-3xl font-bold text-gray-900 mb-2">${cp.type_name}</h1>
                            <div class="flex items-center gap-4 text-sm text-gray-600">
                                <div class="flex items-center">
                                    <i class="fas fa-star text-yellow-400 mr-1"></i>
                                    <span class="font-semibold">${cp.avg_rating > 0 ? cp.avg_rating : 'Chưa có'}</span>
                                    <span class="ml-1">(${cp.review_count} đánh giá)</span>
                                </div>
                                <div class="h-4 w-px bg-gray-300"></div>
                                <span><i class="fas fa-shopping-cart mr-1"></i> Đã bán ${cp.total_sold > 0 ? cp.total_sold : 0}</span>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-orange-50 to-red-50 rounded-xl p-6 border border-orange-200">
                            <div class="flex items-baseline gap-3">
                                <span class="text-4xl font-bold text-red-600">
                                    <fmt:formatNumber value="${cp.final_price}" type="currency" />
                                </span>
                                <c:if test="${cp.discount_percent > 0}">
                                    <span class="text-xl text-gray-400 line-through">
                                        <fmt:formatNumber value="${cp.sell_price}" type="currency" />
                                    </span>
                                    <span class="bg-red-500 text-white px-2 py-1 rounded text-sm font-semibold">
                                        -<fmt:formatNumber value="${cp.discount_percent}" maxFractionDigits="0" />%
                                    </span>
                                </c:if>
                            </div>
                            <p class="text-sm text-gray-600 mt-2">
                                <i class="fas fa-tag mr-1"></i> Giá gốc: 
                                <span class="font-semibold">
                                    <fmt:formatNumber value="${cp.sell_price}" type="currency" />
                                </span>
                                <c:if test="${(cp.sell_price - cp.final_price) > 0}">
                                    (Lãi: <fmt:formatNumber value="${cp.sell_price - cp.original_price}" type="currency" />/thẻ)
                                </c:if>
                            </p>
                        </div>

                        <div class="space-y-4">
                            <div class="flex items-center justify-between">
                                <span class="text-gray-700 font-medium">Số lượng còn lại:</span>
                                <span class="${cp.stock_quantity > 0 ? 'text-green-600' : 'text-red-600'} font-bold text-lg">
                                    <i class="fas fa-box mr-1"></i> 
                                    <fmt:formatNumber value="${cp.stock_quantity}" groupingUsed="true" /> thẻ
                                </span>
                            </div>

                            <div class="flex items-center gap-4">
                                <span class="text-gray-700 font-medium">Số lượng:</span>
                                <div class="flex items-center border border-gray-300 rounded-lg">
                                    <button id="btn-decrease" class="px-4 py-2 hover:bg-gray-100 transition-colors" ${cp.stock_quantity == 0 ? 'disabled' : ''}>
                                        <i class="fas fa-minus text-gray-600"></i>
                                    </button>
                                    <input type="number"
                                           id="quantity-input"
                                           value="${cp.stock_quantity > 0 ? 1 : 0}"
                                           min="${cp.stock_quantity > 0 ? 1 : 0}"
                                           max="${cp.stock_quantity > cp.max_quantity_per_order ? cp.max_quantity_per_order : cp.stock_quantity}"
                                           ${cp.stock_quantity == 0 ? 'disabled' : ''}
                                           class="w-16 text-center border-x border-gray-300 py-2 focus:outline-none">
                                    <button id="btn-increase" class="px-4 py-2 hover:bg-gray-100 transition-colors" ${cp.stock_quantity == 0 ? 'disabled' : ''}>
                                        <i class="fas fa-plus text-gray-600"></i>
                                    </button>
                                </div>
                                <span class="text-sm text-gray-500">(Tối đa ${cp.max_quantity_per_order} thẻ/đơn)</span>
                            </div>
                        </div>

                        <div class="space-y-3">
                            <c:choose>
                                <c:when test="${cp.stock_quantity > 0}">
                                    <button class="w-full bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white font-bold py-4 rounded-xl transition-all duration-300 transform shadow-sm hover:shadow-md">
                                        <i class="fas fa-shopping-cart mr-2"></i>
                                        Thêm vào giỏ hàng
                                    </button>
                                    <button class="w-full bg-gradient-to-r from-yellow-500 to-yellow-500 hover:from-yellow-600 hover:to-orange-600 text-white font-bold py-4 rounded-xl transition-all duration-300 transform shadow-sm hover:shadow-md">
                                        <i class="fas fa-bolt mr-2"></i>
                                        Mua ngay
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button disabled class="w-full bg-gray-300 text-gray-500 font-bold py-4 rounded-xl cursor-not-allowed">
                                        <i class="fas fa-ban mr-2"></i>
                                        Tạm hết hàng
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="grid grid-cols-2 gap-4 pt-4 border-t border-gray-200">
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-shield text-blue-600"></i>
                                </div>
                                <div>
                                    <p class="font-semibold text-gray-900">Cam kết chính hãng</p>
                                    <p class="text-gray-500 text-xs">100% thẻ thật</p>
                                </div>
                            </div>
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-bolt text-green-600"></i>
                                </div>
                                <div>
                                    <p class="font-semibold text-gray-900">Nạp siêu tốc</p>
                                    <p class="text-gray-500 text-xs">Giao dịch tự động trong vòng 30s</p>
                                </div>
                            </div>
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-headset text-purple-600"></i>
                                </div>
                                <div>
                                    <p class="font-semibold text-gray-900">Hỗ trợ 24/7</p>
                                    <p class="text-gray-500 text-xs">Tư vấn miễn phí</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="border-t border-gray-200">
                    <div class="flex border-b border-gray-200">
                        <button class="px-8 py-4 font-semibold text-blue-600 border-b-2 border-blue-600">
                            <i class="fas fa-info-circle mr-2"></i>Mô tả sản phẩm
                        </button>
                        <button class="px-8 py-4 font-semibold text-gray-600 hover:text-blue-600 hover:bg-gray-50 transition-colors">
                            <i class="fas fa-star mr-2"></i>Đánh giá 
                            <c:if test="${cp.review_count > 0}">
                                (${cp.review_count})
                            </c:if>
                        </button>
                    </div>

                    <div class="p-8 space-y-6">
                        <div>
                            <h3 class="text-xl font-bold text-gray-900 mb-4">Thông tin chi tiết</h3>
                            <div class="prose prose-blue max-w-none text-gray-700 leading-relaxed">
                                <p class="mb-4">
                                    <c:choose>
                                        <c:when test="${not empty cp.description}">
                                            ${cp.description}
                                        </c:when>
                                        <c:otherwise>
                                            ${cp.type_name} là sản phẩm thẻ cào điện thoại chính hãng từ nhà mạng ${cp.type_code}. 
                                            Thẻ được sử dụng để nạp tiền vào tài khoản điện thoại di động thuê bao trả trước.
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <h4 class="font-bold text-gray-900 mt-6 mb-3">Ưu điểm nổi bật:</h4>
                                <ul class="list-disc list-inside space-y-2 ml-4">
                                    <li>Thẻ chính hãng 100%, cam kết hoàn tiền nếu thẻ lỗi</li>
                                    <li>Nạp tiền nhanh chóng, tiện lợi chỉ trong vài phút</li>
                                    <li>Hỗ trợ thanh toán đa dạng: Ví điện tử</li>
                                    <li>Được áp dụng khuyến mãi và ưu đãi theo từng thời điểm</li>
                                    <li>Thời hạn sử dụng dài, không lo mất giá trị</li>
                                </ul>

                                <h4 class="font-bold text-gray-900 mt-6 mb-3">Hướng dẫn sử dụng:</h4>
                                <ol class="list-decimal list-inside space-y-2 ml-4">
                                    <li>Soạn tin: NAP [Mã thẻ] [Số serial] gửi 9123 (miễn phí)</li>
                                    <li>Hoặc gọi 1800 8098 để nạp thẻ tự động</li>
                                    <li>Chờ tin nhắn xác nhận nạp thành công</li>
                                </ol>
                            </div>
                        </div>

                        <div class="bg-gray-50 rounded-xl p-6">
                            <h3 class="text-xl font-bold text-gray-900 mb-4">Thông số kỹ thuật</h3>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="flex justify-between py-2 border-b border-gray-200">
                                    <span class="text-gray-600">Nhà mạng:</span>
                                    <span class="font-semibold text-gray-900 uppercase">${cp.type_code}</span>
                                </div>
                                <div class="flex justify-between py-2 border-b border-gray-200">
                                    <span class="text-gray-600">Mệnh giá:</span>
                                    <span class="font-semibold text-gray-900">
                                        <fmt:formatNumber value="${cp.value}" type="currency" />
                                    </span>
                                </div>
                                <div class="flex justify-between py-2 border-b border-gray-200">
                                    <span class="text-gray-600">Trạng thái:</span>
                                    <span class="font-semibold ${cp.stock_status == 'IN_STOCK' ? 'text-green-600' : 'text-red-600'}">
                                        ${cp.stock_status == 'IN_STOCK' ? 'Còn hàng' : 'Hết hàng'}
                                    </span>
                                </div>
                                <div class="flex justify-between py-2 border-b border-gray-200">
                                    <span class="text-gray-600">Tồn kho:</span>
                                    <span class="font-semibold text-gray-900">
                                        <fmt:formatNumber value="${cp.stock_quantity}" groupingUsed="true" /> thẻ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <script src="${pageContext.request.contextPath}/js/global-script.js"></script>
        <script>
            // Quantity buttons functionality
            const quantityInput = document.getElementById('quantity-input');
            const btnDecrease = document.getElementById('btn-decrease');
            const btnIncrease = document.getElementById('btn-increase');

            if (quantityInput && btnDecrease && btnIncrease) {
                btnDecrease.addEventListener('click', () => {
                    const currentValue = parseInt(quantityInput.value);
                    const minValue = parseInt(quantityInput.min);
                    if (currentValue > minValue) {
                        quantityInput.value = currentValue - 1;
                    }
                });

                btnIncrease.addEventListener('click', () => {
                    const currentValue = parseInt(quantityInput.value);
                    const maxValue = parseInt(quantityInput.max);
                    if (currentValue < maxValue) {
                        quantityInput.value = currentValue + 1;
                    }
                });

                quantityInput.addEventListener('change', function () {
                    const minValue = parseInt(this.min);
                    const maxValue = parseInt(this.max);
                    let value = parseInt(this.value);

                    if (isNaN(value) || value < minValue) {
                        this.value = minValue;
                    } else if (value > maxValue) {
                        this.value = maxValue;
                    }
                });
            }
        </script>
    </body>
</html>