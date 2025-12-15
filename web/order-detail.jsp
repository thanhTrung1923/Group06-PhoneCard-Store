<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="vi_VN"/>



<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<div class="container py-5">
  
    
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/order-history" class="text-decoration-none text-secondary">
            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            
            <div class="card shadow-sm mb-4 border-0">
                <div class="card-header bg-white py-3 border-bottom">
                    <div class="d-flex justify-content-between align-items-center flex-wrap">
                        <h4 class="mb-0 text-primary fw-bold">
                            <i class="fas fa-file-invoice me-2"></i>Đơn hàng #${order.orderId}
                        </h4>
                        
                        <div class="mt-2 mt-sm-0">
                            <c:choose>
                                <c:when test="${order.status == 'Pending' || order.status == 'Processing'}">
                                    <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Đang xử lý</span>
                                </c:when>
                                <c:when test="${order.status == 'Completed' || order.status == 'Success'}">
                                    <span class="badge bg-success px-3 py-2 rounded-pill">Thành công</span>
                                </c:when>
                                <c:when test="${order.status == 'Cancelled'}">
                                    <span class="badge bg-danger px-3 py-2 rounded-pill">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary px-3 py-2 rounded-pill">${order.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <p class="text-muted mb-1"><small>Ngày tạo đơn</small></p>
                            <h6 class="fw-bold">
                                <i class="far fa-calendar-alt text-primary me-1"></i>
                                <fmt:formatDate value="${createdAtTs}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </h6>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <p class="text-muted mb-1"><small>Tổng giá trị</small></p>
                            <h4 class="fw-bold text-danger">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency"/>
                            </h4>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-header bg-light fw-bold py-3">
                    <i class="fas fa-list me-2"></i>Chi tiết sản phẩm
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Sản phẩm</th>
                                    <th class="text-center">Mệnh giá</th>
                                    <th class="text-end">Giá bán</th>
                                    <th class="text-end pe-4">Lợi nhuận</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty items}">
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                <i class="fas fa-box-open fa-2x mb-2"></i>
                                                <p>Không có sản phẩm nào trong đơn hàng này.</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${items}" var="it">
                                            <tr>
                                                <td class="ps-4 fw-bold text-primary">
                                                    ${it.productName}
                                                </td>

                                                <td class="text-center">
                                                    <span class="badge bg-light text-dark border">
                                                        <fmt:formatNumber value="${it.productValue}"/> đ
                                                    </span>
                                                </td>

                                                <td class="text-end fw-bold text-dark">
                                                    <fmt:formatNumber value="${it.finalPrice}" type="currency"/>
                                                </td>

                                                <td class="text-end pe-4 text-success fw-bold">
                                                    + <fmt:formatNumber value="${it.profit}" type="currency"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                            
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="2" class="text-end fw-bold pt-3">Tổng cộng:</td>
                                    <td class="text-end fw-bold pt-3 text-danger">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency"/>
                                    </td>
                                    <td></td> </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4 gap-2">
                <button class="btn btn-outline-secondary" onclick="window.print()">
                    <i class="fas fa-print me-1"></i> In đơn hàng
                </button>
                <a href="support" class="btn btn-primary">
                    <i class="fas fa-headset me-1"></i> Yêu cầu hỗ trợ
                </a>
            </div>

        </div>
    </div>
                                  
</div>

