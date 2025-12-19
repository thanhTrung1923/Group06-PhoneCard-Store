<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>Admin - Order Detail</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <style>
    :root{
      --bg:#f6f7fb; --card:#fff; --text:#0f172a; --muted:#64748b; --border:#e2e8f0;
      --primary:#2563eb; --primary2:#1d4ed8;
      --shadow:0 10px 30px rgba(15,23,42,.08); --radius:16px;

      --ok:#16a34a; --warn:#d97706; --bad:#dc2626;
      --okBg:#dcfce7; --warnBg:#ffedd5; --badBg:#fee2e2;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:linear-gradient(180deg,#fff 0%,var(--bg) 45%);color:var(--text)}
    a{color:inherit;text-decoration:none}
    .wrap{max-width:1200px;margin:26px auto;padding:0 18px 40px}

    .topbar{display:flex;align-items:flex-end;justify-content:space-between;gap:12px;margin-bottom:14px}
    .title{display:flex;flex-direction:column;gap:6px}
    .title h1{margin:0;font-size:22px}
    .title p{margin:0;font-size:13px;color:var(--muted)}

    .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#fff;color:var(--text);
         cursor:pointer;font-weight:800;transition:.15s;white-space:nowrap}
    .btn:hover{transform:translateY(-1px);border-color:rgba(37,99,235,.35)}
    .btn-primary{background:linear-gradient(180deg,var(--primary),var(--primary2));border-color:rgba(37,99,235,.45);color:#fff}
    .btn-ghost{background:#f8fafc}
    .btn-danger{border-color:rgba(220,38,38,.28);background:rgba(220,38,38,.06);color:#b91c1c}

    .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}
    .card-hd{padding:16px;border-bottom:1px solid var(--border);background:#fbfcff;display:flex;justify-content:space-between;gap:12px;align-items:center}
    .card-hd strong{font-size:14px}
    .card-bd{padding:16px}

    .grid{display:grid;grid-template-columns: 1.2fr .8fr;gap:12px}
    @media(max-width:980px){.grid{grid-template-columns:1fr}}

    .box{border:1px solid var(--border);border-radius:14px;padding:14px;background:#fff}
    .box h3{margin:0 0 10px;font-size:14px}
    .kv{display:grid;grid-template-columns: 160px 1fr;gap:8px 12px}
    .k{color:var(--muted);font-size:13px}
    .v{font-size:14px}
    .mono{font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace}

    .alert{padding:10px 12px;border-radius:12px;border:1px solid #fecaca;background:#fff1f2;color:#991b1b;margin-bottom:12px;font-size:13px}
    .ok{padding:10px 12px;border-radius:12px;border:1px solid #bbf7d0;background:#dcfce7;color:#14532d;margin-bottom:12px;font-size:13px}

    .badge{display:inline-flex;align-items:center;gap:8px;padding:6px 10px;border-radius:999px;font-weight:900;font-size:12px;border:1px solid var(--border)}
    .dot{width:8px;height:8px;border-radius:50%}
    .paid{background:var(--okBg);border-color:rgba(22,163,74,.22)} .paid .dot{background:var(--ok)}
    .cancel{background:var(--warnBg);border-color:rgba(217,119,6,.22)} .cancel .dot{background:var(--warn)}
    .refund{background:var(--badBg);border-color:rgba(220,38,38,.22)} .refund .dot{background:var(--bad)}

    .formRow{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
    select{padding:10px;border-radius:12px;border:1px solid var(--border);background:#fff}

    .table-wrap{margin-top:12px;border-radius:14px;border:1px solid var(--border);overflow:auto;background:#fff}
    table{width:100%;border-collapse:collapse;min-width:960px}
    thead th{position:sticky;top:0;background:#f8fafc;border-bottom:1px solid var(--border);padding:12px;text-align:left;
             font-size:12px;color:var(--muted);text-transform:uppercase;letter-spacing:.08em;white-space:nowrap}
    tbody td{padding:12px;border-bottom:1px solid #f1f5f9;font-size:14px;vertical-align:middle}
    tbody tr:hover{background:#f8fafc}
    .right{text-align:right}
    .muted{color:var(--muted);font-size:13px}
  </style>
</head>

<body>
<div class="wrap">

  <div class="topbar">
    <div class="title">
      <h1>Order Detail</h1>
      <p>View order info and update order status</p>
    </div>

    <div style="display:flex;gap:10px;flex-wrap:wrap;">
      <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/orders?action=list">← Back to List</a>
    </div>
  </div>

  <div class="card">
    <div class="card-hd">
      <strong>Order #<span class="mono">${order.orderId}</span></strong>
      <div>
        <c:choose>
          <c:when test="${order.status == 'PAID'}"><span class="badge paid"><span class="dot"></span>PAID</span></c:when>
          <c:when test="${order.status == 'CANCELLED'}"><span class="badge cancel"><span class="dot"></span>CANCELLED</span></c:when>
          <c:when test="${order.status == 'REFUNDED'}"><span class="badge refund"><span class="dot"></span>REFUNDED</span></c:when>
          <c:otherwise><span class="badge"><span class="dot"></span>${order.status}</span></c:otherwise>
        </c:choose>
      </div>
    </div>

    <div class="card-bd">

      <!-- Messages -->
      <c:if test="${param.msg == 'updated'}">
        <div class="ok">Updated successfully!</div>
      </c:if>
      <c:if test="${param.msg == 'failed'}">
        <div class="alert">Update failed (order not found or status is final / invalid).</div>
      </c:if>
      <c:if test="${param.msg == 'invalid_status'}">
        <div class="alert">Invalid status!</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert">Error: ${error}</div>
      </c:if>

      <div class="grid">

        <!-- Left: Customer & Order Info -->
        <div class="box">
          <h3>Customer & Order Info</h3>
          <div class="kv">
            <div class="k">Customer name</div>
            <div class="v"><strong>${order.customerFullName}</strong></div>

            <div class="k">Email</div>
            <div class="v muted">${order.customerEmail}</div>

            <div class="k">Phone</div>
            <div class="v muted">${order.customerPhone}</div>

            <div class="k">User ID</div>
            <div class="v mono">${order.userId}</div>

            <div class="k">Total amount</div>
            <div class="v mono">
              <fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
            </div>

            <div class="k">Created at</div>
            <div class="v muted">${order.createdAt}</div>

            <div class="k">Paid at</div>
            <div class="v muted"><c:out value="${order.paidAt}"/></div>

            <div class="k">Cancelled at</div>
            <div class="v muted"><c:out value="${order.cancelledAt}"/></div>
          </div>
        </div>

        <!-- Right: Update Status -->
        <div class="box">
          <h3>Update Status</h3>

          <form class="formRow" method="post" action="${pageContext.request.contextPath}/admin/orders">
            <input type="hidden" name="action" value="updateStatus"/>
            <input type="hidden" name="id" value="${order.orderId}"/>

            <label style="font-weight:900;">Status</label>
            <select name="status" required>
              <option value="PAID" ${order.status=='PAID' ? 'selected':''}>PAID</option>
              <option value="CANCELLED" ${order.status=='CANCELLED' ? 'selected':''}>CANCELLED</option>
              <option value="REFUNDED" ${order.status=='REFUNDED' ? 'selected':''}>REFUNDED</option>
            </select>

            <button class="btn btn-primary" type="submit" onclick="return confirm('Update status for this order?')">
              Update
            </button>
          </form>

<!--          <div class="muted" style="margin-top:10px;line-height:1.5">
            Notes:
            <ul style="margin:8px 0 0 18px;">
              <li>If order is CANCELLED/REFUNDED (final), update may be rejected.</li>
              <li>PaidAt/CancelledAt will be updated automatically by DAO.</li>
            </ul>
          </div>-->
        </div>

      </div>

      <!-- Items -->
      <div style="margin-top:14px;">
        <div class="box" style="padding-bottom:10px;">
          <h3>Order Items</h3>

          <div class="table-wrap">
            <table>
              <thead>
              <tr>
                <th style="width:90px;">Item ID</th>
                <th>Product</th>
                <th style="width:90px;" class="right">Qty</th>
                <th style="width:140px;" class="right">Unit Price</th>
                <th style="width:140px;" class="right">Final Price</th>
                <th style="width:140px;" class="right">Buy @ Sale</th>
                <th style="width:120px;" class="right">Profit</th>
                <th style="width:160px;">Assigned Serial</th>
              </tr>
              </thead>

              <tbody>
              <c:if test="${empty items}">
                <tr>
                  <td colspan="8" style="padding:16px;text-align:center;color:var(--muted)">
                    No items found.
                  </td>
                </tr>
              </c:if>

              <c:forEach var="it" items="${items}">
                <tr>
                  <td class="mono">#${it.itemId}</td>
                  <td>
                    <strong>${it.productName}</strong>
                    <div class="muted">Product ID: <span class="mono">${it.productId}</span></div>
                  </td>
                  <td class="right mono">${it.quantity}</td>
                  <td class="right mono">
                    <fmt:formatNumber value="${it.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                  </td>
                  <td class="right mono">
                    <fmt:formatNumber value="${it.finalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                  </td>
                  <td class="right mono">
                    <fmt:formatNumber value="${it.buyPriceAtSale}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                  </td>
                  <td class="right mono">
                    <fmt:formatNumber value="${it.profit}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                  </td>
                  <td class="mono">
                    <c:choose>
                      <c:when test="${not empty it.assignedSerial}">${it.assignedSerial}</c:when>
                      <c:otherwise><span class="muted">N/A</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>

        </div>
      </div>

    </div>
  </div>

</div>
</body>
</html>
