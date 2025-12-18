<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết yêu cầu hỗ trợ</title>
    <jsp:include page="/layout/global-import-header.jsp"/>
</head>

<body class="bg-gray-50">

    <!-- HEADER -->
    <jsp:include page="/layout/header.jsp"/>

    <div class="max-w-4xl mx-auto px-4 py-10 min-h-screen">

        <!-- TIÊU ĐỀ -->
        <h1 class="text-2xl font-bold mb-6">
            🎧 Yêu cầu #${ticket.ticketId}
        </h1>

        <!-- THÔNG TIN TICKET -->
        <div class="bg-white rounded-lg p-6 mb-6 shadow-sm">
            <p><b>Tiêu đề:</b> ${ticket.subject}</p>

            <p class="mt-2">
                <b>Nội dung:</b><br/>
                ${ticket.content}
            </p>

            <p class="mt-3 text-sm text-gray-500">
                Trạng thái:
                <span class="font-medium">${ticket.status}</span>
            </p>
        </div>

        <!-- PHẢN HỒI -->
        <h2 class="text-lg font-semibold mb-4">
            Phản hồi từ bộ phận hỗ trợ
        </h2>

        <c:if test="${empty replies}">
            <p class="text-gray-500 italic">
                Chưa có phản hồi từ nhân viên hỗ trợ
            </p>
        </c:if>

        <c:forEach items="${replies}" var="r">
            <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-4 rounded shadow-sm">
                <p class="font-medium text-green-700">
                    ${r.userName} (Nhân viên)
                </p>

                <p class="mt-2">
                    ${r.content}
                </p>

                <p class="text-xs text-gray-500 mt-2">
                    <fmt:formatDate value="${r.createdAtDate}"
                                    pattern="dd/MM/yyyy HH:mm"/>
                </p>
            </div>
        </c:forEach>

        <!-- BACK -->
        <a href="${pageContext.request.contextPath}/support?action=history"
           class="inline-block mt-6 text-gray-600 hover:underline">
            ← Quay lại danh sách
        </a>
    </div>

    <!-- FOOTER -->
    <jsp:include page="/layout/footer.jsp"/>
    <jsp:include page="/layout/global-import-footer.jsp"/>

</body>
</html>
