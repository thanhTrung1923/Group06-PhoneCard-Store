<%-- 
    Document   : detail
    Created on : Dec 14, 2025, 2:03:47 AM
    Author     : DuyThai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"><title>Create Promotion</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    body{margin:0;font-family:system-ui;background:#f6f7fb}
    .wrap{max-width:1100px;margin:24px auto;padding:0 16px}
    .card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;box-shadow:0 10px 30px rgba(15,23,42,.08);overflow:hidden}
    .hd{padding:14px 16px;border-bottom:1px solid #e2e8f0;background:#fbfcff;font-weight:900}
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
  </style>
</head>
<body>
<div class="wrap">
  <a class="btn" href="${pageContext.request.contextPath}/admin/discounts?action=list">← Back</a>
  <div style="height:12px"></div>

  <div class="card">
    <div class="hd">Create Promotion</div>
    <div class="bd">
      <c:if test="${not empty error}">
        <div class="alert">${error}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/admin/discounts">
        <input type="hidden" name="action" value="createSubmit"/>
        <input type="hidden" name="back" value="create"/>

        <label>Promotion Name</label>
        <input name="promotionName" required>

        <div style="height:10px"></div>

        <label>Description</label>
        <textarea name="description"></textarea>

        <div style="height:10px"></div>

        <div class="row">
          <div>
            <label>Start At</label>
            <input type="datetime-local" name="startAt" required>
          </div>
          <div>
            <label>End At</label>
            <input type="datetime-local" name="endAt" required>
          </div>
        </div>

        <div style="height:10px"></div>

        <label><input type="checkbox" name="isActive" checked> Active</label>

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
              <tr>
                <td><input type="checkbox" name="pid" value="${p.productId}"></td>
                <td><strong>${p.typeName}</strong> ${p.value}</td>
                <td>${p.sellPrice}</td>
                <td>
                  <input type="number" step="0.01" min="0" max="100"
                         name="disc_${p.productId}" value="0">
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <div style="height:14px"></div>
        <button class="btn btn-primary" type="submit"
                onclick="return confirm('Create this promotion?');">Create</button>
      </form>
    </div>
  </div>
</div>
</body>
</html>

