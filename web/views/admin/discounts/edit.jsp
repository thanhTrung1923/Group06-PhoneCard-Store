<%-- 
    Document   : edit
    Created on : Dec 14, 2025, 2:04:05 AM
    Author     : DuyThai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"><title>Edit Promotion</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    body{margin:0;font-family:system-ui;background:#f6f7fb}
    .wrap{max-width:1100px;margin:24px auto;padding:0 16px}
    .card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;box-shadow:0 10px 30px rgba(15,23,42,.08);overflow:hidden}
    .hd{padding:14px 16px;border-bottom:1px solid #e2e8f0;background:#fbfcff;font-weight:900;display:flex;justify-content:space-between}
    .bd{padding:16px}
    label{font-size:12px;color:#64748b;display:block;margin-bottom:6px}
    input,textarea{width:100%;padding:10px;border-radius:12px;border:1px solid #e2e8f0}
    textarea{min-height:90px;resize:vertical}
    .row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
    .btn{padding:10px 14px;border-radius:12px;border:1px solid #e2e8f0;background:#fff;font-weight:900;cursor:pointer}
    .btn-primary{background:#2563eb;color:#fff;border-color:rgba(37,99,235,.35)}
    table{width:100%;border-collapse:collapse;margin-top:12px}
    th,td{padding:10px;border-bottom:1px solid #f1f5f9;text-align:left}
    th{background:#f8fafc;font-size:12px;color:#64748b;text-transform:uppercase;letter-spacing:.08em}
    .alert{padding:10px 12px;border:1px solid #fecaca;background:#fff1f2;color:#991b1b;border-radius:12px;margin-bottom:12px}
    .ok{padding:10px 12px;border:1px solid #bbf7d0;background:#dcfce7;color:#14532d;border-radius:12px;margin-bottom:12px}
  </style>
</head>
<body>
<div class="wrap">
  <a class="btn" href="${pageContext.request.contextPath}/admin/discounts?action=list">← Back</a>
  <div style="height:12px"></div>

  <div class="card">
    <div class="hd">
      <div>Edit Promotion #${promo.promotionId}</div>
      <div style="color:#64748b;font-weight:700">${promo.promotionName}</div>
    </div>
    <div class="bd">
      <c:if test="${param.msg == 'updated'}"><div class="ok">Updated successfully.</div></c:if>
      <c:if test="${param.msg == 'created'}"><div class="ok">Created successfully.</div></c:if>

      <c:if test="${not empty error}">
        <div class="alert">${error}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/admin/discounts">
        <input type="hidden" name="action" value="editSubmit"/>
        <input type="hidden" name="back" value="edit"/>
        <input type="hidden" name="id" value="${promo.promotionId}"/>

        <label>Promotion Name</label>
        <input name="promotionName" value="${promo.promotionName}" required>

        <div style="height:10px"></div>

        <label>Description</label>
        <textarea name="description">${promo.description}</textarea>

        <div style="height:10px"></div>

        <div class="row">
          <div>
            <label>Start At</label>
            <input type="datetime-local" name="startAt"
                   value="${fn:substring(promo.startAt,0,16)}" required>
          </div>
          <div>
            <label>End At</label>
            <input type="datetime-local" name="endAt"
                   value="${fn:substring(promo.endAt,0,16)}" required>
          </div>
        </div>

        <div style="height:10px"></div>

        <label><input type="checkbox" name="isActive" ${promo.active ? 'checked' : ''}> Active</label>

        <div style="height:14px"></div>
        <strong>Select Products & Discount %</strong>

        <table>
          <thead>
            <tr>
              <th style="width:70px;">Select</th>
              <th>Product</th>
              <th style="width:160px;">Sell Price</th>
              <th style="width:170px;">Discount (%)</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="p" items="${products}">
              <c:set var="disc" value="${discountMap[p.productId]}"/>
              <tr>
                <td>
                  <input type="checkbox" name="pid" value="${p.productId}"
                         ${disc != null ? 'checked' : ''}>
                </td>
                <td><strong>${p.typeName}</strong> ${p.value}</td>
                <td>${p.sellPrice}</td>
                <td>
                  <input type="number" step="0.01" min="0" max="100"
                         name="disc_${p.productId}"
                         value="${disc != null ? disc : 0}">
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <div style="height:14px"></div>
        <button class="btn btn-primary" type="submit"
                onclick="return confirm('Save changes?');">Save</button>
      </form>
    </div>
  </div>
</div>

<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
</body>
</html>

