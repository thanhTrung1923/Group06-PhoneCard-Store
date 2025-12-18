<%-- 
    Document   : footer
    Created on : Dec 11, 2025, 1:56:41 AM
    Author     : trung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer class="bg-green-900 text-white py-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
            <div class="flex items-start gap-3">
                <div class="w-12 h-12 bg-white bg-opacity-10 rounded-lg flex items-center justify-center text-white font-semibold border border-white border-opacity-30">
                    Logo
                </div>
                <div>
                    <div class="text-lg font-bold">PhoneCardStore</div>
                    <div class="text-sm text-gray-300">Nạp thẻ siêu tốc</div>
                </div>
            </div>

            <div>
                <h3 class="text-lg font-semibold mb-3">Sản phẩm</h3>
                <ul class="space-y-2">
                    <li><a href="products" class="text-gray-300 hover:text-white text-sm">Thẻ điện thoại</a></li>
                </ul>
            </div>

            <div>
                <h3 class="text-lg font-semibold mb-3">Hỗ trợ</h3>
                <ul class="space-y-2">
                    <form action="${pageContext.request.contextPath}/support" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="create">
                        <button type="submit"
                                class="text-gray-300 hover:text-white text-sm bg-transparent border-none cursor-pointer">
                            Yêu cầu hỗ trợ
                        </button>
                    </form>
                </ul>
            </div>
        </div>

        <div class="border-t border-white border-opacity-20 pt-6 text-center">
            <p class="text-sm">© 2024 PhoneCardStore. Bản quyền thuộc về chúng tôi.</p>
        </div>
    </div>
</footer>