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

            <c:choose>
                <c:when test="${not empty cp}">
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

                                <!--                        <div class="grid grid-cols-4 gap-3">
                                                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-blue-500 cursor-pointer">
                                                                <img src="${not empty cp.img_url ? cp.img_url : cp.thumbnail_url}" class="w-full h-full object-cover">
                                                            </div>
                                                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-transparent hover:border-gray-300 cursor-pointer">
                                                                <img src="${not empty cp.thumbnail_url ? cp.thumbnail_url : cp.img_url}" class="w-full h-full object-cover">
                                                            </div>
                                                        </div>-->
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

                                <form class="space-y-4" action="${pageContext.request.contextPath}/cart" method="POST">
                                    <input type="hidden" name="productId" value="${cp.product_id}" />
                                    <input type="hidden" name="maxQuantity" value="${cp.max_quantity_per_order}" />
                                    <input type="hidden" name="stockQuantity" value="${cp.stock_quantity}" />

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
                                                <button type="button" id="btn-decrease" class="px-4 py-2 hover:bg-gray-100 transition-colors" ${cp.stock_quantity == 0 ? 'disabled' : ''}>
                                                    <i class="fas fa-minus text-gray-600"></i>
                                                </button>
                                                <input type="number"
                                                       name="quantity"
                                                       id="quantity-input"
                                                       value="${cp.stock_quantity > 0 ? 1 : 0}"
                                                       min="${cp.stock_quantity > 0 ? 1 : 0}"
                                                       max="${cp.stock_quantity > cp.max_quantity_per_order ? cp.max_quantity_per_order : cp.stock_quantity}"
                                                       ${cp.stock_quantity == 0 ? 'disabled' : ''}
                                                       class="w-16 text-center border-x border-gray-300 py-2 focus:outline-none">
                                                <button type="button" id="btn-increase" class="px-4 py-2 hover:bg-gray-100 transition-colors" ${cp.stock_quantity == 0 ? 'disabled' : ''}>
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
                                                <a href="${pageContext.request.contextPath}/checkout?action=buyNow&productId=${cp.product_id}&quantity=1&unitPrice=${cp.final_price}">
                                                    <button type="button" class="mt-2 w-full bg-gradient-to-r from-yellow-500 to-yellow-500 hover:from-yellow-600 hover:to-orange-600 text-white font-bold py-4 rounded-xl transition-all duration-300 transform shadow-sm hover:shadow-md">
                                                        Mua ngay
                                                    </button>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button disabled class="w-full bg-gray-300 text-gray-500 font-bold py-4 rounded-xl cursor-not-allowed">
                                                    <i class="fas fa-ban mr-2"></i>
                                                    Tạm hết hàng
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </form>

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
                                <button class="tab-button px-8 py-4 font-semibold text-blue-600 border-b-2 border-blue-600 transition-colors">
                                    <i class="fas fa-info-circle mr-2"></i>Mô tả sản phẩm
                                </button>
                                <button class="tab-button px-8 py-4 font-semibold text-gray-600 hover:text-blue-600 hover:bg-gray-50 transition-colors">
                                    <i class="fas fa-star mr-2"></i>Đánh giá 
                                    <c:if test="${cp.review_count > 0}">
                                        (${cp.review_count})
                                    </c:if>
                                </button>
                            </div>

                            <div class="tab-content p-8 space-y-6">
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

                            <div class="tab-content hidden p-8">
                                <div class="bg-gradient-to-br from-green-50 to-green-200 rounded-xl p-6 mb-6">
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <h3 class="text-xl font-bold text-gray-900 mb-2">Đánh giá từ khách hàng</h3>
                                            <div class="flex items-center gap-2">
                                                <div class="flex">
                                                    <c:forEach begin="1" end="5">
                                                        <i class="fas fa-star text-yellow-400 text-lg"></i>
                                                    </c:forEach>
                                                </div>
                                                <span class="text-2xl font-bold text-gray-900">${cp.avg_rating > 0 ? cp.avg_rating : '0.0'}</span>
                                                <span class="text-gray-600">/ 5.0</span>
                                            </div>
                                            <p class="text-sm text-gray-600 mt-1">${cp.review_count} đánh giá</p>
                                        </div>
                                        <div class="text-right">
                                            <i class="fas fa-comments text-5xl text-yellow-400 opacity-20"></i>
                                        </div>
                                    </div>
                                </div>

                                <div id="feedback-list" class="space-y-4 mb-6">
                                </div>

                                <div id="loading-spinner" class="hidden text-center py-8">
                                    <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-blue-500 border-t-transparent"></div>
                                    <p class="text-gray-600 mt-3">Đang tải đánh giá...</p>
                                </div>

                                <div id="no-feedback-msg" class="hidden text-center py-12">
                                    <i class="fas fa-comment-slash text-6xl text-gray-300 mb-4"></i>
                                    <h4 class="text-xl font-semibold text-gray-900 mb-2">Chưa có đánh giá</h4>
                                    <p class="text-gray-600">Sản phẩm này chưa có đánh giá nào. Hãy là người đầu tiên đánh giá!</p>
                                </div>

                                <div class="text-center">
                                    <button id="load-more-btn" class="hidden px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg transition-colors duration-300 shadow-sm hover:shadow-md">
                                        <i class="fas fa-chevron-down mr-2"></i>
                                        Xem thêm đánh giá
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="max-w-6xl mx-auto text-center flex items-center justify-center min-h-[534px] shadow">
                        <p class="font-bold text-xl">Không tìm thấy sản phẩm nào như vậy :((</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <jsp:include page="/layout/global-script.jsp" />
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const ok = '${sessionScope.ok}';

                if (ok && ok === 'true') {
                    iziToast.show({
                        title: 'Thêm vào giỏ hàng',
                        message: 'Bạn đã thêm sản phẩm vào giỏ hàng thành công.',
                        color: 'green',
                        position: 'topRight'
                    });
            <c:remove var="ok" scope="session"/>
                }

                if (ok && ok === 'false') {
                    iziToast.show({
                        title: 'Thêm vào giỏ hàng',
                        message: 'Có lỗi xảy ra trong quá trình thêm sản phẩm vào giỏ hàng, vui lòng thử lại sau',
                        color: 'red',
                        position: 'topRight'
                    });
            <c:remove var="ok" scope="session"/>
                }
            });

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

                quantityInput.addEventListener('input', function () {
                    const minValue = parseInt(this.min);
                    const maxValue = parseInt(this.max);
                    let value = parseInt(this.value);

                    if (isNaN(value) || value < minValue) {
                        iziToast.show({
                            title: 'Úi có chút hiểu nhầm!',
                            message: 'Số lượng sản phẩm ít nhất có thể đặt là: ' + minValue,
                            position: 'topRight',
                            color: 'red'
                        });
                        this.value = minValue;
                    } else if (value > maxValue) {
                        iziToast.show({
                            title: 'Úi có chút hiểu nhầm!',
                            message: 'Số lượng sản phẩm nhiều nhất có thể đặt là: ' + maxValue,
                            position: 'topRight',
                            color: 'red'
                        });
                        this.value = maxValue;
                    }
                });
            }

            const tabButtons = document.querySelectorAll('.tab-button');
            const tabContents = document.querySelectorAll('.tab-content');

            let currentPage = 1;
            let isLoading = false;
            let hasMoreFeedbacks = true;

            tabButtons.forEach((button, index) => {
                button.addEventListener('click', () => {
                    tabButtons.forEach(btn => {
                        btn.classList.remove('text-blue-600', 'border-b-2', 'border-blue-600');
                        btn.classList.add('text-gray-600', 'hover:text-blue-600', 'hover:bg-gray-50');
                    });

                    button.classList.remove('text-gray-600', 'hover:text-blue-600', 'hover:bg-gray-50');
                    button.classList.add('text-blue-600', 'border-b-2', 'border-blue-600');

                    tabContents.forEach(content => {
                        content.classList.add('hidden');
                    });

                    tabContents[index].classList.remove('hidden');

                    if (index === 1 && currentPage === 1) {
                        loadFeedbacks();
                    }
                });
            });

            function getProductId() {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get('productId');
            }

            function formatDate(dateString) {
                const date = new Date(dateString);
                const now = new Date();
                const diffTime = Math.abs(now - date);
                const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

                if (diffDays === 0) {
                    return 'Hôm nay';
                } else if (diffDays === 1) {
                    return 'Hôm qua';
                } else if (diffDays < 7) {
                    return diffDays + ' ngày trước';
                } else {
                    return date.toLocaleDateString('vi-VN', {
                        day: '2-digit',
                        month: '2-digit',
                        year: 'numeric'
                    });
                }
            }

            function renderStars(rating) {
                let html = '';
                for (let i = 1; i <= 5; i++) {
                    if (i <= rating) {
                        html += '<i class="fa-solid fa-star text-yellow-400"></i>';
                    } else {
                        html += '<i class="fa-solid fa-star text-gray-300"></i>';
                    }
                }
                return html;
            }

            function getCategoryLabel(category) {
                const labels = {
                    'SERVICE': 'Dịch vụ',
                    'PRODUCT': 'Sản phẩm',
                    'WEBSITE': 'Website',
                    'DELIVERY': 'Giao hàng'
                };
                return labels[category] || 'Khác';
            }

            function renderFeedback(feedback) {
                let html = '<div class="bg-white rounded-lg shadow-md p-6">';

                html += '<div class="flex items-center justify-between mb-3">';
                html += '<div class="flex gap-1">' + renderStars(feedback.rating) + '</div>';
                if (feedback.category) {
                    html += '<span class="text-xs px-2 py-1 rounded-full bg-blue-100 text-blue-700 font-medium">';
                    html += getCategoryLabel(feedback.category);
                    html += '</span>';
                }
                html += '</div>';

                if (feedback.subject) {
                    html += '<h4 class="font-semibold text-gray-900 mb-2">' + escapeHtml(feedback.subject) + '</h4>';
                }

                html += '<p class="text-gray-700 mb-4 line-clamp-3">"' + escapeHtml(feedback.content) + '"</p>';

                html += '<div class="flex items-center justify-between pt-3 border-t border-gray-100">';
                html += '<div>';
                html += '<p class="font-semibold text-gray-900">' + escapeHtml(feedback.customerName) + '</p>';
                if (feedback.createdAt) {
                    html += '<p class="text-xs text-gray-500 mt-1">' + formatDate(feedback.createdAt) + '</p>';
                }
                html += '</div>';

                if (feedback.orderId) {
                    html += '<span class="flex items-center gap-1 text-xs text-green-600 font-medium">';
                    html += '<i class="fa-solid fa-circle-check"></i>';
                    html += 'Đã mua hàng';
                    html += '</span>';
                }
                html += '</div>';

                if (feedback.isResponded && feedback.adminResponse) {
                    html += '<div class="mt-4 pl-4 border-l-2 border-blue-500 bg-blue-50 p-3 rounded">';
                    html += '<p class="text-xs font-semibold text-blue-900 mb-1">Phản hồi từ Admin:</p>';
                    html += '<p class="text-sm text-gray-700">' + escapeHtml(feedback.adminResponse) + '</p>';
                    if (feedback.respondedAt) {
                        html += '<p class="text-xs text-gray-500 mt-2">' + formatDate(feedback.respondedAt) + '</p>';
                    }
                    html += '</div>';
                }

                html += '</div>';
                return html;
            }

            function escapeHtml(text) {
                const map = {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;',
                    "'": '&#039;'
                };
                return text.replace(/[&<>"']/g, m => map[m]);
            }

            async function loadFeedbacks(append = false) {
                if (isLoading || (!hasMoreFeedbacks && append))
                    return;

                const productId = getProductId();
                if (!productId) {
                    console.error('Product ID not found');
                    return;
                }

                const feedbackList = document.getElementById('feedback-list');
                const loadMoreBtn = document.getElementById('load-more-btn');
                const loadingSpinner = document.getElementById('loading-spinner');
                const noFeedbackMsg = document.getElementById('no-feedback-msg');

                isLoading = true;

                if (append && loadMoreBtn) {
                    loadMoreBtn.classList.add('hidden');
                }
                if (loadingSpinner) {
                    loadingSpinner.classList.remove('hidden');
                }

                try {
                    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
                    const apiUrl = window.location.origin + contextPath + '/product/feedbacks?productId=' + productId + '&page=' + currentPage;

                    const response = await fetch(apiUrl);

                    if (!response.ok) {
                        throw new Error('Failed to fetch feedbacks');
                    }

                    const result = await response.json();

                    if (result.status === 200 && result.data) {
                        const feedbacks = result.data;

                        if (feedbacks.length === 0) {
                            hasMoreFeedbacks = false;
                            if (!append && noFeedbackMsg) {
                                noFeedbackMsg.classList.remove('hidden');
                            }
                            if (loadMoreBtn) {
                                loadMoreBtn.classList.add('hidden');
                            }
                        } else {
                            let feedbacksHTML = '';
                            for (let i = 0; i < feedbacks.length; i++) {
                                feedbacksHTML += renderFeedback(feedbacks[i]);
                            }

                            if (append) {
                                feedbackList.insertAdjacentHTML('beforeend', feedbacksHTML);
                            } else {
                                feedbackList.innerHTML = feedbacksHTML;
                            }

                            if (noFeedbackMsg) {
                                noFeedbackMsg.classList.add('hidden');
                            }

                            if (feedbacks.length === 10 && loadMoreBtn) {
                                loadMoreBtn.classList.remove('hidden');
                            } else {
                                hasMoreFeedbacks = false;
                                if (loadMoreBtn) {
                                    loadMoreBtn.classList.add('hidden');
                                }
                            }

                            currentPage++;
                        }
                    } else {
                        console.error('Error:', result.message);
                        alert('Không thể tải đánh giá. Vui lòng thử lại sau!');
                    }
                } catch (error) {
                    console.error('Error loading feedbacks:', error);
                    alert('Đã có lỗi xảy ra khi tải đánh giá!');
                } finally {
                    isLoading = false;
                    if (loadingSpinner) {
                        loadingSpinner.classList.add('hidden');
                    }
            }
            }

            const loadMoreBtn = document.getElementById('load-more-btn');
            if (loadMoreBtn) {
                loadMoreBtn.addEventListener('click', () => {
                    loadFeedbacks(true);
                });
            }
        </script>
    </body>
</html>