<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <title>Danh sách yêu cầu hỗ trợ</title>
                <jsp:include page="/layout/global-import-header.jsp" />
            </head>

            <body class="bg-gray-50">
                <jsp:include page="/layout/header.jsp" />

                <div class="max-w-7xl mx-auto px-4 py-10 min-h-screen">

                    <h1 class="text-3xl font-bold mb-8">
                        🎧 Danh sách yêu cầu hỗ trợ (Staff)
                    </h1>

                    <c:if test="${empty tickets}">
                        <p class="text-gray-500 italic">
                            Hiện chưa có yêu cầu hỗ trợ nào.
                        </p>
                    </c:if>

                    <c:if test="${not empty tickets}">
                        <div class="bg-white rounded-xl shadow-sm overflow-hidden">

                            <table class="w-full text-sm">
                                <thead class="bg-gray-100 text-gray-700">
                                    <tr>
                                        <th class="px-4 py-3 text-left">Mã</th>
                                        <th class="px-4 py-3 text-left">Khách hàng</th>
                                        <th class="px-4 py-3 text-left">Tiêu đề</th>
                                        <th class="px-4 py-3 text-center">Ưu tiên</th>
                                        <th class="px-4 py-3 text-center">Trạng thái</th>
                                        <th class="px-4 py-3 text-center">Đơn hàng</th>
                                        <th class="px-4 py-3 text-right">Ngày tạo</th>
                                        <th class="px-4 py-3 text-center">Hành động</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach items="${tickets}" var="t">
                                        <tr class="border-t hover:bg-gray-50">

                                            <td class="px-4 py-3 font-medium">
                                                #${t.ticketId}
                                            </td>

                                            <td class="px-4 py-3">
                                                ${t.userName}
                                            </td>

                                            <td class="px-4 py-3">
                                                ${t.subject}
                                            </td>

                                            <!-- PRIORITY -->
                                            <td class="px-4 py-3 text-center">
                                                <c:choose>
                                                    <c:when test="${t.priority == 'URGENT'}">
                                                        <span class="text-red-600 font-semibold">Khẩn cấp</span>
                                                    </c:when>
                                                    <c:when test="${t.priority == 'HIGH'}">
                                                        <span class="text-orange-500 font-semibold">Cao</span>
                                                    </c:when>
                                                    <c:when test="${t.priority == 'MEDIUM'}">
                                                        <span class="text-yellow-600">Trung bình</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-500">Thấp</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- STATUS -->
                                            <td class="px-4 py-3 text-center">
                                                <c:choose>
                                                    <c:when test="${t.status == 'NEW'}">
                                                        <span
                                                            class="bg-blue-100 text-blue-600 px-3 py-1 rounded-full text-xs font-semibold">
                                                            Mới
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'PROCESSING'}">
                                                        <span
                                                            class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-semibold">
                                                            Đang xử lý
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'RESOLVED'}">
                                                        <span
                                                            class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-semibold">
                                                            Đã xử lý
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="bg-gray-100 text-gray-600 px-3 py-1 rounded-full text-xs font-semibold">
                                                            Đã đóng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- ORDER -->
                                            <td class="px-4 py-3 text-center">
                                                <c:choose>
                                                    <c:when test="${not empty t.orderId}">
                                                        #${t.orderId}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="px-4 py-3 text-right text-gray-500">
                                                <fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>

                                            <!-- ACTION -->
                                            <td class="px-4 py-3 text-center">
                                                <button onclick="openTicketModal(${t.ticketId})"
                                                    class="text-green-600 hover:underline font-medium cursor-pointer bg-transparent border-none">
                                                    Xem / Trả lời
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>

                            </table>
                        </div>
                    </c:if>

                </div>

                <!-- ===================== MODAL POPUP ===================== -->
                <div id="ticketModal"
                    class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
                    <div class="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">

                        <!-- Modal Header -->
                        <div
                            class="bg-gradient-to-r from-green-600 to-green-700 text-white px-6 py-4 rounded-t-xl flex justify-between items-center">
                            <h2 class="text-xl font-bold flex items-center gap-2">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
                                </svg>
                                Chi tiết yêu cầu hỗ trợ
                            </h2>
                            <button onclick="closeTicketModal()" class="text-white hover:text-gray-200 transition">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </div>

                        <!-- Modal Body -->
                        <div class="p-6">
                            <!-- Loading State -->
                            <div id="modalLoading" class="text-center py-12">
                                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600 mx-auto">
                                </div>
                                <p class="mt-4 text-gray-600">Đang tải dữ liệu...</p>
                            </div>

                            <!-- Ticket Details -->
                            <div id="modalContent" class="hidden">
                                <!-- Ticket Info Card -->
                                <div class="bg-gray-50 rounded-lg p-5 mb-6">
                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <p class="text-sm text-gray-600 mb-1">Mã yêu cầu</p>
                                            <p class="font-semibold text-lg" id="modal-ticket-id"></p>
                                        </div>
                                        <div>
                                            <p class="text-sm text-gray-600 mb-1">Khách hàng</p>
                                            <p class="font-semibold" id="modal-customer-name"></p>
                                        </div>
                                        <div>
                                            <p class="text-sm text-gray-600 mb-1">Độ ưu tiên</p>
                                            <p id="modal-priority"></p>
                                        </div>
                                        <div>
                                            <p class="text-sm text-gray-600 mb-1">Trạng thái hiện tại</p>
                                            <p id="modal-status"></p>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <p class="text-sm text-gray-600 mb-1">Tiêu đề</p>
                                        <p class="font-semibold text-lg" id="modal-subject"></p>
                                    </div>
                                    <div class="mt-4">
                                        <p class="text-sm text-gray-600 mb-1">Nội dung vấn đề</p>
                                        <div class="bg-white rounded p-4 mt-2 border border-gray-200">
                                            <p class="text-gray-800 whitespace-pre-wrap" id="modal-content"></p>
                                        </div>
                                    </div>
                                    <div class="mt-3 text-xs text-gray-500">
                                        <p>Thời gian tạo: <span id="modal-created-at"></span></p>
                                    </div>
                                </div>

                                <!-- Reply History -->
                                <div class="mb-6">
                                    <h3 class="text-lg font-semibold mb-3 flex items-center gap-2">
                                        <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor"
                                            viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
                                        </svg>
                                        Lịch sử trả lời
                                    </h3>
                                    <div id="reply-history" class="space-y-3">
                                        <!-- Replies will be dynamically inserted here -->
                                    </div>
                                </div>

                                <!-- Reply Form -->
                                <form method="post" action="${pageContext.request.contextPath}/staff/support"
                                    class="border-t pt-6">
                                    <input type="hidden" name="ticketId" id="form-ticket-id">

                                    <div class="mb-4">
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            Câu trả lời của bạn <span class="text-red-500">*</span>
                                        </label>
                                        <textarea name="reply" id="reply-textarea" rows="5" required
                                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                            placeholder="Nhập nội dung trả lời cho khách hàng..."></textarea>
                                    </div>

                                    <div class="mb-6">
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            Cập nhật trạng thái <span class="text-red-500">*</span>
                                        </label>
                                        <select name="status" required
                                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent">
                                            <option value="NEW">Mới</option>
                                            <option value="PROCESSING">Đang xử lý</option>
                                            <option value="RESOLVED">Đã xử lý</option>
                                            <option value="CLOSED">Đã đóng</option>
                                        </select>
                                    </div>

                                    <div class="flex gap-3 justify-end">
                                        <button type="button" onclick="closeTicketModal()"
                                            class="px-6 py-2.5 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition font-medium">
                                            Hủy
                                        </button>
                                        <button type="submit"
                                            class="px-6 py-2.5 bg-green-600 text-white rounded-lg hover:bg-green-700 transition font-medium flex items-center gap-2">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                                            </svg>
                                            Gửi trả lời
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>

                <script>
                    const contextPath = '${pageContext.request.contextPath}';

                    function openTicketModal(ticketId) {
                        const modal = document.getElementById('ticketModal');
                        const loading = document.getElementById('modalLoading');
                        const content = document.getElementById('modalContent');

                        // Show modal and loading
                        modal.classList.remove('hidden');
                        loading.classList.remove('hidden');
                        content.classList.add('hidden');

                        // Fetch ticket details từ API endpoint
                        fetch(contextPath + '/staff/support/api?ticketId=' + ticketId)
                            .then(function (response) {
                                if (!response.ok) {
                                    throw new Error('Không thể tải dữ liệu');
                                }
                                return response.json();
                            })
                            .then(function (data) {
                                populateModal(data, ticketId);
                                loading.classList.add('hidden');
                                content.classList.remove('hidden');
                            })
                            .catch(function (error) {
                                console.error('Error:', error);
                                alert('Có lỗi xảy ra khi tải dữ liệu: ' + error.message);
                                closeTicketModal();
                            });
                    }

                    function populateModal(data, ticketId) {
                        const ticket = data.ticket;
                        const replies = data.replies || [];

                        // Populate ticket info
                        document.getElementById('modal-ticket-id').textContent = '#' + ticket.ticketId;
                        document.getElementById('modal-customer-name').textContent = ticket.customerName;
                        document.getElementById('modal-subject').textContent = ticket.subject;
                        document.getElementById('modal-content').textContent = ticket.content;
                        document.getElementById('modal-created-at').textContent = ticket.createdAt;
                        document.getElementById('form-ticket-id').value = ticketId;

                        // Priority badge
                        const priority = ticket.priority;
                        let priorityHTML = '';
                        if (priority === 'URGENT') {
                            priorityHTML = '<span class="text-red-600 font-semibold">Khẩn cấp</span>';
                        } else if (priority === 'HIGH') {
                            priorityHTML = '<span class="text-orange-500 font-semibold">Cao</span>';
                        } else if (priority === 'MEDIUM') {
                            priorityHTML = '<span class="text-yellow-600">Trung bình</span>';
                        } else {
                            priorityHTML = '<span class="text-gray-500">Thấp</span>';
                        }
                        document.getElementById('modal-priority').innerHTML = priorityHTML;

                        // Status badge
                        const status = ticket.status;
                        let statusHTML = '';
                        if (status === 'NEW') {
                            statusHTML = '<span class="bg-blue-100 text-blue-600 px-3 py-1 rounded-full text-xs font-semibold">Mới</span>';
                        } else if (status === 'PROCESSING') {
                            statusHTML = '<span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-semibold">Đang xử lý</span>';
                        } else if (status === 'RESOLVED') {
                            statusHTML = '<span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-semibold">Đã xử lý</span>';
                        } else {
                            statusHTML = '<span class="bg-gray-100 text-gray-600 px-3 py-1 rounded-full text-xs font-semibold">Đã đóng</span>';
                        }
                        document.getElementById('modal-status').innerHTML = statusHTML;

                        // Populate replies
                        const replyHistoryEl = document.getElementById('reply-history');
                        if (replies.length === 0) {
                            replyHistoryEl.innerHTML = '<p class="text-gray-500 italic text-sm">Chưa có phản hồi nào</p>';
                        } else {
                            let repliesHTML = '';
                            for (let i = 0; i < replies.length; i++) {
                                const reply = replies[i];
                                const isStaff = reply.staffReply;
                                const bgColor = isStaff ? 'bg-green-50 border-green-200' : 'bg-blue-50 border-blue-200';
                                const icon = isStaff ? '👨‍💼' : '👤';

                                // Format date
                                let createdAt = '';
                                if (reply.createdAt) {
                                    const dateArr = reply.createdAt;
                                    createdAt = dateArr[2] + '/' + dateArr[1] + '/' + dateArr[0] + ' ' +
                                        dateArr[3] + ':' + (dateArr[4] < 10 ? '0' : '') + dateArr[4];
                                }

                                repliesHTML += '<div class="border ' + bgColor + ' rounded-lg p-4">' +
                                    '<div class="flex justify-between items-start mb-2">' +
                                    '<p class="font-semibold text-sm flex items-center gap-2">' +
                                    '<span>' + icon + '</span>' +
                                    escapeHtml(reply.userName) + (isStaff ? ' (Staff)' : ' (Khách hàng)') +
                                    '</p>' +
                                    '<p class="text-xs text-gray-500">' + createdAt + '</p>' +
                                    '</div>' +
                                    '<p class="text-gray-800 whitespace-pre-wrap">' + escapeHtml(reply.content) + '</p>' +
                                    '</div>';
                            }
                            replyHistoryEl.innerHTML = repliesHTML;
                        }

                        // Set default status in dropdown
                        const statusSelect = document.querySelector('select[name="status"]');
                        statusSelect.value = status;
                    }

                    function escapeHtml(text) {
                        const map = {
                            '&': '&amp;',
                            '<': '&lt;',
                            '>': '&gt;',
                            '"': '&quot;',
                            "'": '&#039;'
                        };
                        return String(text).replace(/[&<>"']/g, function (m) { return map[m]; });
                    }

                    function closeTicketModal() {
                        document.getElementById('ticketModal').classList.add('hidden');
                        document.getElementById('reply-textarea').value = '';
                    }

                    // Close modal when clicking outside
                    document.getElementById('ticketModal').addEventListener('click', function (e) {
                        if (e.target === this) {
                            closeTicketModal();
                        }
                    });
                </script>

                <jsp:include page="/layout/footer.jsp" />
                <jsp:include page="/layout/global-import-footer.jsp" />
            </body>

            </html>