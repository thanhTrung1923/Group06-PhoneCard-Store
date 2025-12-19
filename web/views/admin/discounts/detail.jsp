<%-- 
    Document   : detail
    Created on : Dec 16, 2025, 9:00:01 AM
    Author     : DuyThai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chi tiết khuyến mãi</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <style>
    :root{--bg:#f6f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--border:#e2e8f0;--primary:#2563eb;--radius:16px;--shadow:0 10px 30px rgba(15,23,42,.08);}
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui;background:linear-gradient(180deg,#fff 0%,var(--bg) 45%);color:var(--text)}
    .wrap{max-width:1200px;margin:22px auto;padding:0 16px 40px}
    .top{display:flex;justify-content:space-between;align-items:flex-end;gap:12px;margin-bottom:12px}
    .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}
    .hd{padding:14px 16px;border-bottom:1px solid var(--border);background:#fbfcff;display:flex;justify-content:space-between;align-items:center}
    .bd{padding:16px}
    .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;cursor:pointer}
    .btn-primary{background:linear-gradient(180deg,var(--primary),#1d4ed8);border-color:rgba(37,99,235,.45);color:#fff}
    .btn-danger{border-color:rgba(220,38,38,.35);background:rgba(220,38,38,.06);color:#b91c1c}
    .alert{padding:10px 12px;border-radius:12px;border:1px solid #fecaca;background:#fff1f2;color:#991b1b;margin-bottom:12px;font-size:13px}
    label{display:block;font-size:12px;color:var(--muted);margin-bottom:6px}
    input,select{width:100%;padding:10px;border-radius:12px;border:1px solid var(--border);background:#fff}
    .grid{display:grid;grid-template-columns:2fr 1fr;gap:12px}
    @media(max-width:1000px){.grid{grid-template-columns:1fr}}
    .table-wrap{margin-top:14px;border-radius:14px;border:1px solid var(--border);overflow:auto}
    table{width:100%;border-collapse:collapse;min-width:800px}
    thead th{position:sticky;top:0;background:#f8fafc;border-bottom:1px solid var(--border);padding:12px;text-align:left;font-size:12px;color:var(--muted);text-transform:uppercase;letter-spacing:.08em;white-space:nowrap}
    tbody td{padding:12px;border-bottom:1px solid #f1f5f9;font-size:14px;vertical-align:middle}
    .muted{color:var(--muted);font-size:13px}
    .row{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
    .pill{border:1px solid var(--border);background:#fff;border-radius:999px;padding:8px 12px;font-size:13px;color:var(--muted)}
  </style>
</head>

<body>

<%-- ✅ Format datetime-local value trước (không nhét fmt tag vào attribute) --%>
<c:set var="startAtVal" value=""/>
<c:set var="endAtVal" value=""/>

<c:if test="${not empty p and not empty p.startAt}">
  <fmt:formatDate value="${p.startAt}" pattern="yyyy-MM-dd'T'HH:mm" var="startAtVal"/>
</c:if>
<c:if test="${not empty p and not empty p.endAt}">
  <fmt:formatDate value="${p.endAt}" pattern="yyyy-MM-dd'T'HH:mm" var="endAtVal"/>
</c:if>

<div class="wrap">
  <div class="top">
    <div>
      <h2 style="margin:0;">Chi tiết khuyến mãi #${p.promotionId}</h2>
      <div class="muted">Xem / Cập nhật / Thêm / Xóa promotion_details</div>
    </div>
    <div class="row">
      <a class="btn" href="${pageContext.request.contextPath}/admin/discounts?action=list">← Quay lại</a>
    </div>
  </div>

  <c:if test="${not empty error}">
    <div class="alert">Lỗi: ${error}</div>
  </c:if>

  <c:if test="${not empty msg}">
    <div class="alert">
      <c:choose>
        <c:when test="${msg=='updated'}">✅ Cập nhật khuyến mãi thành công</c:when>
        <c:when test="${msg=='saved'}">✅ Lưu discount sản phẩm thành công</c:when>
        <c:when test="${msg=='deleted'}">✅ Xóa thành công</c:when>
        <c:otherwise>⚠️ Có lỗi xảy ra</c:otherwise>
      </c:choose>
    </div>
  </c:if>

  <div class="grid">
    <!-- UPDATE PROMOTION -->
    <div class="card">
      <div class="hd">
        <strong>Thông tin khuyến mãi</strong>
        <span class="pill">Trạng thái: <strong>${p.timeStatus}</strong></span>
      </div>
      <div class="bd">
        <form method="post" action="${pageContext.request.contextPath}/admin/discounts">
          <input type="hidden" name="action" value="updatePromotion"/>
          <input type="hidden" name="id" value="${p.promotionId}"/>

          <div style="display:grid;grid-template-columns:1.5fr 1fr;gap:10px;">
            <div>
              <label>Tên khuyến mãi</label>
              <input name="name" value="${p.promotionName}" required/>
            </div>
            <div>
              <label>Kích hoạt</label>
              <select name="active">
                <option value="1" ${p.active?'selected':''}>Có</option>
                <option value="0" ${!p.active?'selected':''}>Không</option>
              </select>
            </div>

            <div>
              <label>Bắt đầu</label>
              <input type="datetime-local" name="startAt" value="${startAtVal}" required/>
            </div>

            <div>
              <label>Kết thúc</label>
              <input type="datetime-local" name="endAt" value="${endAtVal}" required/>
            </div>
          </div>

          <div class="row" style="margin-top:12px;">
            <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
          </div>
        </form>

        <hr style="border:none;border-top:1px solid var(--border);margin:16px 0;"/>

        <form method="post" action="${pageContext.request.contextPath}/admin/discounts"
              onsubmit="return confirm('Xóa toàn bộ khuyến mãi này?');">
          <input type="hidden" name="action" value="deletePromotion"/>
          <input type="hidden" name="id" value="${p.promotionId}"/>
          <button class="btn btn-danger" type="submit">Xóa khuyến mãi</button>
        </form>

        <div class="muted" style="margin-top:10px;">
          Tạo bởi: <strong>${p.createdByName}</strong> (${p.createdByEmail})
        </div>
      </div>
    </div>

    <!-- ADD/UPDATE DETAIL -->
    <div class="card">
      <div class="hd"><strong>Thêm / Cập nhật Discount cho sản phẩm</strong></div>
      <div class="bd">
        <form method="post" action="${pageContext.request.contextPath}/admin/discounts">
          <input type="hidden" name="action" value="upsertDetail"/>
          <input type="hidden" name="id" value="${p.promotionId}"/>

          <div style="display:grid;grid-template-columns:1fr 160px;gap:10px;">
            <div>
              <label>Sản phẩm</label>
              <select name="productId" required>
                <option value="">-- Chọn sản phẩm --</option>
                <c:forEach var="x" items="${products}">
                  <option value="${x.productId}">${x.label}</option>
                </c:forEach>
              </select>
            </div>
            <div>
              <label>Giảm (%)</label>
              <input type="number" step="0.01" min="0.01" max="100" name="discountPercent" required/>
            </div>
          </div>

          <div class="row" style="margin-top:12px;">
            <button class="btn btn-primary" type="submit">Lưu</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- LIST DETAILS -->
  <div class="card" style="margin-top:14px;">
    <div class="hd"><strong>Danh sách sản phẩm áp dụng</strong></div>
    <div class="bd">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Product ID</th>
              <th>Sản phẩm</th>
              <th>Giảm (%)</th>
              <th style="width:200px;">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:if test="${empty items}">
              <tr><td colspan="4" style="padding:18px;text-align:center;color:var(--muted)">Chưa có sản phẩm nào.</td></tr>
            </c:if>

            <c:forEach var="it" items="${items}">
              <tr>
                <td>#${it.productId}</td>
                <td><strong>${it.productName}</strong></td>
                <td>${it.discountPercent}%</td>
                <td>
                  <form method="post" action="${pageContext.request.contextPath}/admin/discounts"
                        onsubmit="return confirm('Xóa sản phẩm này khỏi khuyến mãi?');">
                    <input type="hidden" name="action" value="deleteDetail"/>
                    <input type="hidden" name="id" value="${p.promotionId}"/>
                    <input type="hidden" name="productId" value="${it.productId}"/>
                    <button class="btn btn-danger" type="submit">Xóa</button>
                  </form>
                </td>
              </tr>
            </c:forEach>

          </tbody>
        </table>
      </div>
    </div>
  </div>

</div>
</body>
</html>
