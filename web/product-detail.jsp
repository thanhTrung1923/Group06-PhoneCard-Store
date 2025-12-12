<%-- 
    Document   : product-detail
    Created on : Dec 11, 2025, 1:23:55 AM
    Author     : trung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết sản phẩm</title>
        <jsp:include page="/layout/global-import-header.jsp" />
    </head>
    <body>
        <jsp:include page="/layout/header.jsp" />

        <div class="container mx-auto mb-10 mt-10">
            <div class="max-w-6xl mx-auto bg-white rounded-2xl shadow-xl overflow-hidden">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 p-8">
                    <div class="space-y-4">
                        <div class="relative aspect-square bg-gradient-to-br from-blue-50 to-purple-50 rounded-xl overflow-hidden">
                            <img 
                                src="https://img.giftpop.vn/brand/VIETTEL/MP2308220021_BASIC_origin.jpg" 
                                alt="Thẻ Viettel" 
                                class="w-full h-full object-contain p-8 hover:scale-105 transition-transform duration-300"
                                >
                            <div class="absolute top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-full text-sm font-semibold shadow-lg">
                                <i class="fas fa-fire mr-1"></i> Hot
                            </div>
                        </div>

                        <div class="grid grid-cols-4 gap-3">
                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-blue-500 cursor-pointer">
                                <img src="https://img.giftpop.vn/brand/VIETTEL/MP2308220021_BASIC_origin.jpg" class="w-full h-full object-cover">
                            </div>
                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-transparent hover:border-gray-300 cursor-pointer">
                                <img src="https://img.giftpop.vn/brand/VIETTEL/MP2308220022_BASIC_origin.jpg" class="w-full h-full object-cover">
                            </div>
                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-transparent hover:border-gray-300 cursor-pointer">
                                <img src="https://down-vn.img.susercontent.com/file/e8954eb414dd32c1d50c103eecd339d4_tn" class="w-full h-full object-cover">
                            </div>
                            <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 border-transparent hover:border-gray-300 cursor-pointer">
                                <img src="https://down-vn.img.susercontent.com/file/456360f7e2d51b81853ac643c593b0f8_tn.webp" class="w-full h-full object-cover">
                            </div>
                        </div>
                    </div>

                    
                    <div class="space-y-6">
                        <div>
                            <div class="flex items-center gap-2 mb-2">
                                <span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-semibold">VIETTEL</span>
                                <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-semibold">
                                    <i class="fas fa-check-circle mr-1"></i> Còn hàng
                                </span>
                            </div>
                            <h1 class="text-3xl font-bold text-gray-900 mb-2">Thẻ Viettel mệnh giá 100.000đ</h1>
                            <div class="flex items-center gap-4 text-sm text-gray-600">
                                <div class="flex items-center">
                                    <i class="fas fa-star text-yellow-400 mr-1"></i>
                                    <span class="font-semibold">4.9</span>
                                    <span class="ml-1">(1,250 đánh giá)</span>
                                </div>
                                <div class="h-4 w-px bg-gray-300"></div>
                                <span><i class="fas fa-shopping-cart mr-1"></i> Đã bán 15,000+</span>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-orange-50 to-red-50 rounded-xl p-6 border border-orange-200">
                            <div class="flex items-baseline gap-3">
                                <span class="text-4xl font-bold text-red-600">100.000đ</span>
                                <span class="text-xl text-gray-400 line-through">105.000đ</span>
                                <span class="bg-red-500 text-white px-2 py-1 rounded text-sm font-semibold">-5%</span>
                            </div>
                            <p class="text-sm text-gray-600 mt-2">
                                <i class="fas fa-tag mr-1"></i> Giá gốc: <span class="font-semibold">95.000đ</span> (Lãi: 5.000đ/thẻ)
                            </p>
                        </div>

                        <div class="space-y-4">
                            <div class="flex items-center justify-between">
                                <span class="text-gray-700 font-medium">Số lượng còn lại:</span>
                                <span class="text-green-600 font-bold text-lg">
                                    <i class="fas fa-box mr-1"></i> 1,500 thẻ
                                </span>
                            </div>

                            <div class="flex items-center gap-4">
                                <span class="text-gray-700 font-medium">Số lượng:</span>
                                <div class="flex items-center border border-gray-300 rounded-lg">
                                    <button class="px-4 py-2 hover:bg-gray-100 transition-colors">
                                        <i class="fas fa-minus text-gray-600"></i>
                                    </button>
                                    <input type="number" value="1" min="1" max="50" class="w-16 text-center border-x border-gray-300 py-2 focus:outline-none">
                                    <button class="px-4 py-2 hover:bg-gray-100 transition-colors">
                                        <i class="fas fa-plus text-gray-600"></i>
                                    </button>
                                </div>
                                <span class="text-sm text-gray-500">(Tối đa 50 thẻ/đơn)</span>
                            </div>
                        </div>

                        <div class="space-y-3">
                            <button class="w-full bg-gradient-to-r from-green-600 to-green-700 hover:from-blue-700 hover:to-blue-800 text-white font-bold py-4 rounded-xl transition-all duration-300 transform shadow-sm hover:shadow-md">
                                <i class="fas fa-shopping-cart mr-2"></i>
                                Thêm vào giỏ hàng
                            </button>
                            <button class="w-full bg-gradient-to-r from-yellow-500 to-yellow-500 hover:from-yellow-600 hover:to-orange-600 text-white font-bold py-4 rounded-xl transition-all duration-300 transform shadow-sm hover:shadow-md">
                                <i class="fas fa-bolt mr-2"></i>
                                Mua ngay
                            </button>
                        </div>

                        <div class="grid grid-cols-2 gap-4 pt-4 border-t border-gray-200">
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-shield-check text-blue-600"></i>
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
                                    <p class="font-semibold text-gray-900">Giao hàng nhanh</p>
                                    <p class="text-gray-500 text-xs">Trong 5 phút</p>
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
                            <div class="flex items-center gap-3 text-sm">
                                <div class="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center">
                                    <i class="fas fa-sync text-yellow-600"></i>
                                </div>
                                <div>
                                    <p class="font-semibold text-gray-900">Đổi trả dễ dàng</p>
                                    <p class="text-gray-500 text-xs">Trong 24 giờ</p>
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
                            <i class="fas fa-star mr-2"></i>Đánh giá (1,250)
                        </button>
                    </div>

                    <div class="p-8 space-y-6">
                        <div>
                            <h3 class="text-xl font-bold text-gray-900 mb-4">Thông tin chi tiết</h3>
                            <div class="prose prose-blue max-w-none text-gray-700 leading-relaxed">
                                <p class="mb-4">Thẻ nạp Viettel mệnh giá 100,000đ là sản phẩm thẻ cào điện thoại chính hãng từ nhà mạng Viettel. Thẻ được sử dụng để nạp tiền vào tài khoản điện thoại di động thuê bao trả trước của mạng Viettel.</p>

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
                                    <span class="font-semibold text-gray-900">Viettel</span>
                                </div>
                                <div class="flex justify-between py-2 border-b border-gray-200">
                                    <span class="text-gray-600">Mệnh giá:</span>
                                    <span class="font-semibold text-gray-900">100,000đ</span>
                                </div>
                                <div class="flex justify-between py-2 border-b border-gray-200">
                                    <span class="text-gray-600">Trạng thái:</span>
                                    <span class="font-semibold text-green-600">Còn hàng</span>
                                </div>
                                <div class="flex justify-between py-2 border-b border-gray-200">
                                    <span class="text-gray-600">Tồn kho:</span>
                                    <span class="font-semibold text-gray-900">1,500 thẻ</span>
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
    </body>
</html>
