<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lá»ch sá»­ ÄÆ¡n hÃ ng</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <jsp:include page="/layout/global-import-header.jsp" />
        <style>
            body {
                background-color: #f8f9fa;
            }
            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .table thead th {
                background-color: #e9ecef;
                border-top: none;
            }
            .status-badge {
                font-size: 0.9em;
                padding: 6px 12px;
                border-radius: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/layout/header.jsp" />

        <c:if test="${empty sessionScope.account}">
            <c:redirect url="login"/>
        </c:if>

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-10">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-primary"><i class="fas fa-history me-2"></i>Lá»ch sá»­ ÄÆ¡n hÃ ng</h2>
                        <a href="home" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Trang chá»§
                        </a>
                    </div>
                    <form method="get" action="order-history" class="row g-3 mb-4">

                        <!-- Tráº¡ng thÃ¡i -->
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Tráº¡ng thÃ¡i</label>
                            <select name="status" class="form-select">
                                <option value="">-- Táº¥t cáº£ --</option>
                                <option value="PAID" ${param.status == 'PAID' ? 'selected' : ''}>ThÃ nh cÃ´ng</option>
                                <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Äang xá»­ lÃ½</option>
                                <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>ÄÃ£ há»§y</option>
                            </select>
                        </div>

                        <!-- Tá»« ngÃ y -->
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Tá»« ngÃ y</label>
                            <input type="date" name="fromDate" value="${param.fromDate}" class="form-control"/>
                        </div>

                        <!-- Äáº¿n ngÃ y -->
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Äáº¿n ngÃ y</label>
                            <input type="date" name="toDate" value="${param.toDate}" class="form-control"/>
                        </div>

                        <!-- NÃºt -->
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-filter me-1"></i> Lá»c
                            </button>
                        </div>

                    </form>

                    <div class="card p-4">
                        <c:choose>
                            <%-- TrÆ°á»ng há»£p chÆ°a cÃ³ ÄÆ¡n hÃ ng --%>
                            <c:when test="${empty orders}">
                                <div class="text-center py-5">
                                    <i class="fas fa-shopping-cart fa-4x text-muted mb-3"></i>
                                    <p class="lead text-muted">Báº¡n chÆ°a cÃ³ ÄÆ¡n hÃ ng nÃ o.</p>
                                    <a href="home" class="btn btn-primary mt-2">Mua sáº¯m ngay</a>
                                </div>
                            </c:when>

                            <%-- TrÆ°á»ng há»£p cÃ³ ÄÆ¡n hÃ ng --%>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>MÃ£ ÄÆ¡n</th>
                                                <th>NgÃ y Äáº·t</th>
                                                <th>Tá»ng tiá»n</th>
                                                <th>Tráº¡ng thÃ¡i</th>
                                                <th class="text-center">HÃ nh Äá»ng</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${orders}" var="o">
                                                <tr>
                                                    <td class="fw-bold text-secondary">#${o.orderId}</td>

                                                    <td>
                                                        <i class="far fa-calendar-alt text-muted me-1"></i>
                                                        <%-- Äá»nh dáº¡ng ngÃ y giá»: 15-12-2025 14:30 --%>
                                                        <fmt:formatDate value="${o.createdAtDate}" pattern="dd-MM-yyyy HH:mm"/>
                                                    </td>

                                                    <td class="fw-bold text-danger">
                                                        <fmt:formatNumber value="${o.totalAmount}" type="currency"/>
                                                    </td>

                                                    <td>
                                                        <%-- Logic hiá»n thá» mÃ u sáº¯c tráº¡ng thÃ¡i --%>
                                                        <c:choose>
                                                            <c:when test="${o.status == 'Pending' || o.status == 'Processing'}">
                                                                <span class="badge bg-warning text-dark status-badge">Äang xá»­ lÃ½</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'Completed' || o.status == 'Success'}">
                                                                <span class="badge bg-success status-badge">ThÃ nh cÃ´ng</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'Cancelled'}">
                                                                <span class="badge bg-danger status-badge">ÄÃ£ há»§y</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'Shipping'}">
                                                                <span class="badge bg-info text-dark status-badge">Äang giao</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary status-badge">${o.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td class="text-center">
                                                        <a href="order-detail?id=${o.orderId}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-eye"></i> Chi tiáº¿t
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/layout/footer.jsp" />

        <jsp:include page="/layout/global-import-footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>