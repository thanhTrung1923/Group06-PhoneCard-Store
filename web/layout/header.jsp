<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<<<<<<< HEAD
<header class="bg-white shadow-sm sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            
=======
<header class="bg-white shadow-sm sticky top-0 z-50"> <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
>>>>>>> 6713f347dd754ad76e0e2b1709ab444617de80b9
            <a href="home" class="flex items-center gap-3 no-underline">
                <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center text-gray-600 font-semibold">
                    Logo
                </div>
                <div>
                    <div class="text-lg font-bold text-gray-900">PhoneCardStore</div>
                    <div class="text-xs text-gray-500">Nạp thẻ siêu tốc</div>
                </div>
            </a>

            <nav class="hidden md:flex items-center gap-8">
                <a href="home" class="text-green-500 font-medium hover:text-green-600 no-underline">Trang chủ</a>
                <a href="#" class="text-gray-700 hover:text-cyan-500 no-underline">Sản phẩm</a>
                <a href="#" class="text-gray-700 hover:text-cyan-500 no-underline">Bài viết</a>
                <a href="#" class="text-gray-700 hover:text-cyan-500 no-underline">Ticket Hỗ trợ</a>
            </nav>

            <div class="flex items-center gap-4">
                
                <button class="p-2 text-gray-600 hover:text-gray-900">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                </button>
<<<<<<< HEAD

=======
                
>>>>>>> 6713f347dd754ad76e0e2b1709ab444617de80b9
                <button class="p-2 text-gray-600 hover:text-gray-900 relative">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
<<<<<<< HEAD
                    <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/4 -translate-y-1/4 bg-red-500 rounded-full">
                        0
                    </span>
                </button>

                <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                        <div class="flex items-center gap-3 border-l pl-4 ml-2">

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

=======
                    <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/4 -translate-y-1/4 bg-red-500 rounded-full">0</span>
                </button>

                <c:choose>
                    
                    <%-- TRƯỜNG HỢP 1: ĐÃ ĐĂNG NHẬP (Session có 'account') --%>
                    <c:when test="${sessionScope.account != null}">
                        <div class="flex items-center gap-3 border-l pl-4 ml-2">
                            <a href="profile" class="flex items-center gap-2 no-underline group">
                                <img src="${sessionScope.account.avatarUrl != null ? sessionScope.account.avatarUrl : 'https://ui-avatars.com/api/?background=random&name='}${sessionScope.account.fullName}" 
                                     alt="Avatar" 
                                     class="w-8 h-8 rounded-full border border-gray-200 object-cover">
>>>>>>> 6713f347dd754ad76e0e2b1709ab444617de80b9
                                <div class="hidden lg:block text-sm">
                                    <p class="text-gray-900 font-medium group-hover:text-green-600 truncate max-w-[100px]">
                                        ${sessionScope.account.fullName}
                                    </p>
                                </div>
                            </a>
<<<<<<< HEAD

                            <a href="logout" class="text-gray-500 hover:text-red-500 ml-1" title="Đăng xuất">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none"
                                     viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
=======
                            
                            <a href="logout" class="text-gray-500 hover:text-red-500" title="Đăng xuất">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
>>>>>>> 6713f347dd754ad76e0e2b1709ab444617de80b9
                                </svg>
                            </a>
                        </div>
                    </c:when>

<<<<<<< HEAD
=======
                    <%-- TRƯỜNG HỢP 2: CHƯA ĐĂNG NHẬP (Khách vãng lai) --%>
>>>>>>> 6713f347dd754ad76e0e2b1709ab444617de80b9
                    <c:otherwise>
                        <div class="flex items-center gap-2">
                            <a href="login">
                                <button class="px-4 py-2 text-gray-700 hover:text-gray-900 font-medium hover:bg-gray-100 rounded-lg transition">
                                    Đăng nhập
                                </button>
                            </a>
                            <a href="register">
                                <button class="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 font-medium shadow-md transition transform hover:-translate-y-0.5">
                                    Đăng kí
                                </button>
                            </a>
                        </div>
                    </c:otherwise>
<<<<<<< HEAD

=======
                    
>>>>>>> 6713f347dd754ad76e0e2b1709ab444617de80b9
                </c:choose>
            </div>
        </div>
    </div>
</header>