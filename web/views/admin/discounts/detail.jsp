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
  <meta charset="UTF-8" />
  <title>Discount Detail</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <style>
    :root{
      --bg:#f6f7fb; --card:#fff; --text:#0f172a; --muted:#64748b; --border:#e2e8f0;
      --primary:#2563eb; --shadow:0 10px 30px rgba(15,23,42,.08); --radius:16px;
      --ok:#16a34a; --bad:#dc2626; --warn:#d97706;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui;background:linear-gradient(180deg,#fff 0%,var(--bg) 45%);color:var(--text)}
    .wrap{max-width:1100px;margin:22px auto;padding:0 16px 40px}
    h1{margin:0;font-size:22px}
    .sub{margin-top:6px;color:var(--muted);font-size:13px}

    .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden;margin-top:14px}
    .hd{padding:14px 16px;border-bottom:1px solid var(--border);background:#fbfcff;display:flex;justify-content:space-between;align-items:center}
    .bd{padding:16px}
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
    @media(max-width:900px){.grid{grid-template-columns:1fr}}

    label{display:block;font-size:12px;color:var(--muted);margin-bottom:6px}
    input,select,textarea{width:100%;padding:10px;border-radius:12px;border:1px solid var(--border);background:#fff}
    textarea{min-height:90px;resize:vertical}

    .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;cursor:pointer}
    .btn-primary{background:linear-gradient(180deg,var(--primary),#1d4ed8);border-color:rgba(37,99,235,.45);color:#fff}
    .btn-danger{border-color:rgba(220,38,38,.35);background:rgba(220,38,38,.08);color:#b91c1c}

    .alert{padding:10px 12px;border-radius:12px;border:1px solid #fecaca;background:#fff1f2;color:#991b1b;margin-bottom:12px;font-size:13px}
    .ok{padding:10px 12px;border-radius:12px;border:1px solid #bbf7d0;background:#dcfce7;color:#14532d;margin-bottom:12px;font-size:13px}

    table{width:100%;border-collapse:collapse}
    thead th{background:#f8fafc;border-bottom:1px solid var(--border);padding:10px;text-align:left;font-size:12px;color:var(--muted);text-transform:uppercase;letter-spacing:.08em}
    tbody td{padding:10px;border-bottom:1px solid #f1f5f9;font-size:14px;vertical-align:middle}
    .row-actions{display:flex;gap:8px;flex-wrap:wrap}
    .mono{font-family:ui-monospace, Menlo, Consolas, monospace;}
  </style>
</head>

<body>
<div class="wrap">
  <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:12px;">
    <div>
      <h1>Discount Detail</h1>
      <div class="sub">Edit promotion info and manage discount per product</div>
    </div>
    <a class="btn" href="${pageContext.request.contextPath}/admin/discounts?action=list">← Back to List</a>
  </div>

  <c:if test="${not empty error}">
    <div class="alert">Error: ${error}</div>
  </c:if>

  <c:if test="${msg == 'updated'}"><div class="ok">Promotion updated.</div></c:if>
  <c:if test="${msg == 'detail_added'}"><div class="ok">Discount added.</div></c:if>
  <c:if test="${msg == 'detail_updated'}"><div class="ok">Discount updated.</div></c:if>
  <c:if test="${msg == 'detail_deleted'}"><div class="ok">Discount deleted.</div></c:if>
  <c:if test="${msg == 'detail_exists'}"><div class="alert">This product already exists in the promotion.</div></c:if>

  <!-- PROMOTION INFO -->
  <div class="card">
    <div class="hd">
      <strong>Promotion #${promotion.promotionId}</strong>

      <form method="post" action="${pageContext.request.contextPath}/admin/discounts"
            onsubmit="return confirm('Delete this promotion? (will delete all details)')">
        <input type="hidden" name="action" value="deletePromotion"/>
        <input type="hidden" name="id" value="${promotion.promotionId}"/>
        <button class="btn btn-danger" type="submit">Delete Promotion</button>
      </form>
    </div>

    <div class="bd">
      <form method="post" action="${pageContext.request.contextPath}/admin/discounts" onsubmit="return validateTime()">
        <input type="hidden" name="action" value="updatePromotion"/>
        <input type="hidden" name="id" value="${promotion.promotionId}"/>

        <div class="grid">
          <div>
            <label>Promotion name</label>
            <input name="promotionName" value="${promotion.promotionName}" required/>
          </div>

          <div>
            <label>Active</label>
            <select name="isActive">
              <option value="1" ${promotion.active ? "selected":""}>YES</option>
              <option value="0" ${!promotion.active ? "selected":""}>NO</option>
            </select>
          </div>

          <div>
            <label>Start time</label>
            <input id="startAt" type="datetime-local" name="startAt"
                   value="<fmt:formatDate value='${promotion.startAt}' pattern='yyyy-MM-dd''T''HH:mm'/>" required/>
          </div>

          <div>
            <label>End time</label>
            <input id="endAt" type="datetime-local" name="endAt"
                   value="<fmt:formatDate value='${promotion.endAt}' pattern='yyyy-MM-dd''T''HH:mm'/>" required/>
          </div>

          <div style="grid-column:1/-1;">
            <label>Description</label>
            <textarea name="description">${promotion.description}</textarea>
          </div>
        </div>

        <div style="margin-top:12px;display:flex;gap:10px;justify-content:flex-end;">
          <button class="btn btn-primary" type="submit">Update Promotion</button>
        </div>
      </form>

      <div style="margin-top:10px;color:var(--muted);font-size:13px;">
        Created by:
        <strong>${promotion.createdByName}</strong>
        <span class="mono">${promotion.createdByEmail}</span>
      </div>
    </div>
  </div>

  <!-- ADD DETAIL -->
  <div class="card">
    <div class="hd"><strong>Add discount to product</strong></div>
    <div class="bd">
      <form method="post" action="${pageContext.request.contextPath}/admin/discounts">
        <input type="hidden" name="action" value="addDetail"/>
        <input type="hidden" name="id" value="${promotion.promotionId}"/>

        <div class="grid">
          <div>
            <label>Product</label>
            <select name="productId" required>
              <c:forEach var="p" items="${products}">
                <option value="${p.productId}">${p.label}</option>
              </c:forEach>
            </select>
          </div>
          <div>
            <label>Discount percent (0 - 100)</label>
            <input type="number" step="0.01" min="0" max="100" name="discountPercent" required placeholder="10.00"/>
          </div>
        </div>

        <div style="margin-top:12px;display:flex;gap:10px;justify-content:flex-end;">
          <button class="btn btn-primary" type="submit">Add</button>
        </div>
      </form>
    </div>
  </div>

  <!-- DETAILS TABLE -->
  <div class="card">
    <div class="hd"><strong>Discount details (per product)</strong></div>
    <div class="bd" style="overflow:auto;">
      <table>
        <thead>
          <tr>
            <th style="width:90px;">Detail ID</th>
            <th>Product</th>
            <th style="width:200px;">Discount %</th>
            <th style="width:240px;">Action</th>
          </tr>
        </thead>
        <tbody>
          <c:if test="${empty details}">
            <tr><td colspan="4" style="padding:16px;text-align:center;color:var(--muted)">No details yet.</td></tr>
          </c:if>

          <c:forEach var="d" items="${details}">
            <tr>
              <td class="mono">#${d.detailId}</td>
              <td><strong>${d.productName}</strong> <span class="mono" style="color:var(--muted)"> (ID ${d.productId})</span></td>

              <td>
                <form method="post" action="${pageContext.request.contextPath}/admin/discounts" style="display:flex;gap:8px;align-items:center;">
                  <input type="hidden" name="action" value="updateDetail"/>
                  <input type="hidden" name="id" value="${promotion.promotionId}"/>
                  <input type="hidden" name="detailId" value="${d.detailId}"/>
                  <input type="number" step="0.01" min="0" max="100" name="discountPercent" value="${d.discountPercent}" required/>
                  <button class="btn btn-primary" type="submit">Save</button>
                </form>
              </td>

              <td>
                <div class="row-actions">
                  <form method="post" action="${pageContext.request.contextPath}/admin/discounts"
                        onsubmit="return confirm('Delete this detail?')">
                    <input type="hidden" name="action" value="deleteDetail"/>
                    <input type="hidden" name="id" value="${promotion.promotionId}"/>
                    <input type="hidden" name="detailId" value="${d.detailId}"/>
                    <button class="btn btn-danger" type="submit">Delete</button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>

</div>

<script>
  function validateTime(){
    const s = document.getElementById('startAt').value;
    const e = document.getElementById('endAt').value;
    if (s && e && s > e){
      alert("Start time cannot be after End time.");
      return false;
    }
    return true;
  }
</script>

</body>
</html>

