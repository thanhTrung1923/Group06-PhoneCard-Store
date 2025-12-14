<%-- 
    Document   : detail
    Created on : Dec 14, 2025, 2:03:31 AM
    Author     : DuyThai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Detail</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg:#f6f7fb; --card:#fff; --text:#0f172a; --muted:#64748b; --border:#e2e8f0;
            --primary:#2563eb; --shadow: 0 10px 30px rgba(15,23,42,.08); --radius:16px;
        }
        *{box-sizing:border-box}
        body{margin:0;font-family:system-ui;background:linear-gradient(180deg,#fff 0%,var(--bg) 45%);color:var(--text)}
        .wrap{max-width:1100px;margin:26px auto;padding:0 18px 40px}
        .top{display:flex;align-items:center;justify-content:space-between;gap:10px;margin-bottom:14px}
        .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;cursor:pointer}
        .btn-primary{background:var(--primary);border-color:rgba(37,99,235,.35);color:#fff}
        .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}
        .hd{padding:14px 16px;border-bottom:1px solid var(--border);background:#fbfcff;display:flex;justify-content:space-between;align-items:center}
        .bd{padding:16px}
        table{width:100%;border-collapse:collapse}
        td,th{padding:10px;border-bottom:1px solid #f1f5f9;text-align:left}
        th{font-size:12px;color:var(--muted);text-transform:uppercase;letter-spacing:.08em;background:#f8fafc}
        .muted{color:var(--muted)}
        .msg{padding:10px 12px;border:1px solid #bbf7d0;background:#dcfce7;color:#14532d;border-radius:12px;margin-bottom:12px}
        .mono{font-family:ui-monospace, Menlo, Consolas, monospace;}
        .grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
        @media (max-width:900px){.grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="wrap">

    <div class="top">
        <a class="btn" href="${pageContext.request.contextPath}/admin/orders?action=list">← Back</a>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/orders?action=edit&id=${order.orderId}">Update Status</a>
    </div>

    <c:if test="${msg == 'updated'}">
        <div class="msg">Updated successfully.</div>
    </c:if>

    <div class="grid">
        <div class="card">
            <div class="hd">
                <strong>Order #<span class="mono">${order.orderId}</span></strong>
                <span class="muted">${order.status}</span>
            </div>
            <div class="bd">
                <table>
                    <tr><td class="muted">Total</td><td class="mono">${order.totalAmount}</td></tr>
                    <tr><td class="muted">Created At</td><td>${order.createdAt}</td></tr>
                    <tr><td class="muted">Paid At</td><td>${order.paidAt}</td></tr>
                    <tr><td class="muted">Cancelled At</td><td>${order.cancelledAt}</td></tr>
                </table>
            </div>
        </div>

        <div class="card">
            <div class="hd"><strong>Customer Snapshot</strong></div>
            <div class="bd">
                <table>
                    <tr><td class="muted">Name</td><td>${order.customerFullName}</td></tr>
                    <tr><td class="muted">Email</td><td>${order.customerEmail}</td></tr>
                    <tr><td class="muted">Phone</td><td>${order.customerPhone}</td></tr>
                </table>
            </div>
        </div>
    </div>

    <div style="height:12px"></div>

    <div class="card">
        <div class="hd"><strong>Order Items</strong></div>
        <div class="bd" style="padding:0">
            <table>
                <thead>
                <tr>
                    <th>Item ID</th>
                    <th>Product</th>
                    <th>Qty</th>
                    <th class="mono">Unit</th>
                    <th class="mono">Final</th>
                    <th class="mono">Buy</th>
                    <th class="mono">Profit</th>
                    <th>Assigned Serial</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="it" items="${order.items}">
                    <tr>
                        <td class="mono">${it.itemId}</td>
                        <td>${it.productName}</td>
                        <td class="mono">${it.quantity}</td>
                        <td class="mono">${it.unitPrice}</td>
                        <td class="mono">${it.finalPrice}</td>
                        <td class="mono">${it.buyPriceAtSale}</td>
                        <td class="mono">${it.profit}</td>
                        <td class="mono">
                            <c:choose>
                                <c:when test="${not empty it.assignedSerial}">${it.assignedSerial}</c:when>
                                <c:otherwise><span class="muted">Not assigned</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
</body>
</html>

