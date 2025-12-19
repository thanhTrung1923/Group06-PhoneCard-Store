<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Giỏ hàng</title>
        <jsp:include page="/layout/global-import-header.jsp"/>
    </head>

    <body class="bg-gray-50">
        <jsp:include page="/layout/header.jsp"/>

        <div class="max-w-7xl mx-auto px-4 py-10 min-h-screen">
            <button onclick="history.back()"
                    class="flex items-center gap-2 px-4 py-2 rounded-full
                    bg-white border border-gray-200 shadow-sm
                    text-gray-600 hover:text-green-600 hover:border-green-500
                    hover:shadow transition-all">
                <i class="fa-solid fa-arrow-left"></i>
                <span class="font-medium">Quay lại</span>
            </button>
            <h1 class="text-3xl font-bold text-gray-900 mb-8">🛒 Giỏ hàng của bạn</h1>
            <c:if test="${not empty sessionScope.checkoutSuccess}">
                <div class="fixed top-20 right-6 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50">
                    Thanh toán thành công
                </div>

                <c:remove var="checkoutSuccess" scope="session"/>
            </c:if>
            <c:if test="${not empty checkoutError}">
                <div class="fixed top-20 right-6 bg-red-500 text-white px-6 py-3 rounded-lg shadow-lg z-50">
                    ${checkoutError}
                </div>
            </c:if>
            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="bg-white rounded-xl shadow-sm p-10 text-center">
                        <i class="fa-solid fa-cart-shopping text-5xl text-gray-300 mb-4"></i>
                        <p class="text-gray-600 mb-6">Giỏ hàng của bạn đang trống</p>
                        <a href="${pageContext.request.contextPath}/home"
                           class="inline-block bg-green-500 text-white px-6 py-3 rounded-lg hover:bg-green-600">
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                        <div class="lg:col-span-2 space-y-4">
                            <c:forEach items="${cartItems}" var="i">
                                <c:set var="p" value="${productInfoMap[i.productId]}"/>

                                <div class="flex bg-white p-4 rounded-xl gap-4">
                                    <img src="${p.thumbnail}" class="w-24 h-24 rounded object-cover"/>

                                    <div class="flex-1">
                                        <h3 class="font-semibold">${p.typeName}</h3>
                                        <p class="text-sm text-gray-500">${p.typeCode}</p>

                                        <div class="flex gap-2 mt-2">
                                            <a href="cart?action=decrease&id=${i.productId}">-</a>
                                            <span>${i.quantity}</span>
                                            <a href="cart?action=increase&id=${i.productId}">+</a>
                                        </div>
                                    </div>

                                    <div class="text-right">
                                        <fmt:formatNumber
                                            value="${i.unitPrice * i.quantity}"
                                            type="currency"/>
                                        <a href="cart?action=remove&id=${i.productId}"
                                           class="text-red-500 text-sm">Xoá</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="bg-white rounded-xl shadow-sm p-6 h-fit">
                            <h3 class="text-lg font-bold mb-4">Tổng đơn hàng</h3>

                            <div class="flex justify-between mb-2">
                                <span>Tạm tính</span>
                                <span>
                                    <fmt:formatNumber value="${cartSubTotal}" type="currency"/>
                                </span>
                            </div>

                            <div class="flex justify-between mb-4">
                                <span>Phí dịch vụ</span>
                                <span>0 ₫</span>
                            </div>

                            <div class="border-t pt-4 flex justify-between font-bold text-lg">
                                <span>Tổng cộng</span>
                                <span class="text-green-600">
                                    <fmt:formatNumber value="${cartSubTotal}" type="currency"/>
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout"
                               class="block text-center mt-6 bg-green-500 text-white py-3 rounded-lg
                               hover:bg-green-600 font-semibold">
                                Thanh toán
                            </a>
                        </div>

                    </div>
                </c:otherwise>
            </c:choose>

        </div>

        <jsp:include page="/layout/footer.jsp"/>
        <jsp:include page="/layout/global-import-footer.jsp"/>
        <script>
            setTimeout(() => {
                const alert = document.querySelector('.fixed.top-20');
                if (alert)
                    alert.remove();
            }, 3000);
        </script>
    </body>
</html>

