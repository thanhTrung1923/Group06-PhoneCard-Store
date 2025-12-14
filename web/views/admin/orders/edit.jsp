<%-- 
    Document   : edit
    Created on : Dec 14, 2025, 2:03:59 AM
    Author     : DuyThai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Order Status</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{--bg:#f6f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--border:#e2e8f0;--primary:#2563eb;
              --shadow:0 10px 30px rgba(15,23,42,.08);--radius:16px}
        body{margin:0;font-family:system-ui;background:linear-gradient(180deg,#fff 0%,var(--bg) 45%);color:var(--text)}
        .wrap{max-width:720px;margin:26px auto;padding:0 18px 40px}
        .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}
        .hd{padding:14px 16px;border-bottom:1px solid var(--border);background:#fbfcff}
        .bd{padding:16px}
        label{font-size:12px;color:var(--muted);display:block;margin-bottom:6px}
        select{width:100%;padding:10px;border-radius:12px;border:1px solid var(--border);background:#fff}
        .row{display:flex;gap:10px;justify-content:flex-end;margin-top:14px}
        .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;cursor:pointer}
        .btn-primary{background:var(--primary);border-color:rgba(37,99,235,.35);color:#fff}
        .muted{color:var(--muted)}
        .mono{font-family:ui-monospace, Menlo, Consolas, monospace;}
        .info{padding:10px 12px;border-radius:12px;border:1px solid var(--border);background:#f8fafc;margin-bottom:12px}
    </style>
</head>
<body>
<div class="wrap">

    <a class="btn" href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.orderId}">← Back</a>

    <div style="height:12px"></div>

    <div class="card">
        <div class="hd"><strong>Update Status — Order #<span class="mono">${order.orderId}</span></strong></div>
        <div class="bd">

            <div class="info">
                <div class="muted">Customer: <strong>${order.customerFullName}</strong></div>
                <div class="muted">Current status: <strong>${order.status}</strong></div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin/orders">
                <input type="hidden" name="action" value="updateStatus"/>
                <input type="hidden" name="id" value="${order.orderId}"/>

                <label>New Status</label>
                <select name="status">
                    <option value="PAID"      ${order.status=='PAID' ? 'selected' : ''}>PAID</option>
                    <option value="CANCELLED" ${order.status=='CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                    <option value="REFUNDED"  ${order.status=='REFUNDED' ? 'selected' : ''}>REFUNDED</option>
                </select>

                <div class="row">
                    <a class="btn" href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.orderId}">Cancel</a>
                    <button class="btn btn-primary" type="submit"
                            onclick="return confirm('Confirm update status?');">
                        Save
                    </button>
                </div>
            </form>

        </div>
    </div>

</div>
</body>
</html>
