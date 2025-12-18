<%-- 
    Document   : list
    Created on : Dec 14, 2025, 2:03:17 AM
    Author     : DuyThai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Discount Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        :root{
            --bg:#f6f7fb; --card:#fff; --text:#0f172a; --muted:#64748b; --border:#e2e8f0;
            --primary:#2563eb; --primary2:#1d4ed8; --shadow:0 10px 30px rgba(15,23,42,.08); --radius:16px;
            --ok:#16a34a; --warn:#d97706; --bad:#dc2626;
            --okBg:#dcfce7; --warnBg:#ffedd5; --badBg:#fee2e2;
        }
        *{box-sizing:border-box}
        body{margin:0;font-family:system-ui;background:linear-gradient(180deg,#fff 0%,var(--bg) 45%);color:var(--text)}
        .wrap{max-width:1200px;margin:26px auto;padding:0 18px 40px}
        .top{display:flex;align-items:flex-end;justify-content:space-between;gap:12px;margin-bottom:14px}
        h1{margin:0;font-size:22px}
        .sub{margin:6px 0 0;color:var(--muted);font-size:13px}

        .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}
        .hd{padding:14px 16px;border-bottom:1px solid var(--border);background:#fbfcff;display:flex;justify-content:space-between;align-items:center}
        .bd{padding:16px}

        .filters{display:grid;grid-template-columns:1fr 220px 220px auto auto;gap:10px;align-items:end}
        @media (max-width:980px){.filters{grid-template-columns:1fr 1fr}}
        label{display:block;font-size:12px;color:var(--muted);margin-bottom:6px}
        input,select{width:100%;padding:10px;border-radius:12px;border:1px solid var(--border);background:#fff}
        .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;cursor:pointer}
        .btn-primary{background:linear-gradient(180deg,var(--primary),var(--primary2));border-color:rgba(37,99,235,.45);color:#fff}
        .btn-ghost{background:#f8fafc}
        .alert{padding:10px 12px;border-radius:12px;border:1px solid #fecaca;background:#fff1f2;color:#991b1b;margin-bottom:12px;font-size:13px}

        .table-wrap{margin-top:14px;border-radius:14px;border:1px solid var(--border);overflow:auto}
        table{width:100%;border-collapse:collapse;min-width:980px}
        thead th{position:sticky;top:0;background:#f8fafc;border-bottom:1px solid var(--border);padding:12px;text-align:left;
                 font-size:12px;color:var(--muted);text-transform:uppercase;letter-spacing:.08em}
        tbody td{padding:12px;border-bottom:1px solid #f1f5f9;font-size:14px;vertical-align:middle}
        tbody tr:hover{background:#f8fafc}
        .mono{font-family:ui-monospace, Menlo, Consolas, monospace;}
        .muted{color:var(--muted);font-size:13px}

        .badge{display:inline-flex;align-items:center;gap:8px;padding:6px 10px;border-radius:999px;font-weight:800;font-size:12px;border:1px solid var(--border)}
        .dot{width:8px;height:8px;border-radius:50%}
        .run{background:var(--okBg);border-color:rgba(22,163,74,.22)} .run .dot{background:var(--ok)}
        .up{background:var(--warnBg);border-color:rgba(217,119,6,.22)} .up .dot{background:var(--warn)}
        .exp{background:var(--badBg);border-color:rgba(220,38,38,.22)} .exp .dot{background:var(--bad)}

        .link{display:inline-flex;align-items:center;padding:8px 10px;border-radius:12px;border:1px solid rgba(37,99,235,.25);
              background:rgba(37,99,235,.08);color:#1d4ed8;font-weight:800;font-size:13px;text-decoration:none}
        .link:hover{background:rgba(37,99,235,.12);border-color:rgba(37,99,235,.35)}

        .pager{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:12px}
        .pages{display:flex;gap:8px;flex-wrap:wrap}
        .page{padding:8px 12px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;font-size:13px;color:var(--text);text-decoration:none}
        .page.active{background:rgba(37,99,235,.12);border-color:rgba(37,99,235,.35);color:#1d4ed8}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div>
            <h1>Discount Management</h1>
            <div class="sub">List promotions/discount campaigns (promotions + promotion_details)</div>
        </div>
        <!-- Step sau: nút Create -->
        <!-- <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/discounts?action=create">+ New Promotion</a> -->
    </div>

    <div class="card">
        <div class="hd">
            <strong>Promotions</strong>
            <span class="muted">Filter and view details</span>
        </div>

        <div class="bd">
            <c:if test="${not empty error}">
                <div class="alert">Error: ${error}</div>
            </c:if>

            <form method="get" action="${pageContext.request.contextPath}/admin/discounts">
                <input type="hidden" name="action" value="list"/>

                <div class="filters">
                    <div>
                        <label>Keyword</label>
                        <input name="keyword" value="${keyword}" placeholder="Promotion name or ID"/>
                    </div>

                    <div>
                        <label>Time Status</label>
                        <select name="timeStatus">
                            <option value="ALL"      ${timeStatus=='ALL' ? 'selected':''}>All</option>
                            <option value="UPCOMING" ${timeStatus=='UPCOMING' ? 'selected':''}>Upcoming</option>
                            <option value="RUNNING"  ${timeStatus=='RUNNING' ? 'selected':''}>Running</option>
                            <option value="EXPIRED"  ${timeStatus=='EXPIRED' ? 'selected':''}>Expired</option>
                        </select>
                    </div>

                    <div>
                        <label>Active Flag</label>
                        <select name="isActive">
                            <option value="ALL" ${isActive=='ALL' ? 'selected':''}>All</option>
                            <option value="1"   ${isActive=='1' ? 'selected':''}>Active</option>
                            <option value="0"   ${isActive=='0' ? 'selected':''}>Inactive</option>
                        </select>
                    </div>

                    <button class="btn btn-primary" type="submit">Search</button>
                    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/discounts?action=list">Reset</a>
                </div>
            </form>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th style="width:110px;">ID</th>
                        <th>Promotion Name</th>
                        <th style="width:190px;">Start</th>
                        <th style="width:190px;">End</th>
                        <th style="width:140px;">Time Status</th>
                        <th style="width:110px;">Active</th>
                        <th style="width:120px;">Products</th>
                        <th style="width:220px;">Created By</th>
                        <th style="width:120px;">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty promotions}">
                        <tr><td colspan="9" class="muted" style="padding:18px;text-align:center;">No promotions found.</td></tr>
                    </c:if>

                    <c:forEach var="p" items="${promotions}">
                        <tr>
                            <td class="mono">#${p.promotionId}</td>
                            <td>
                                <strong>${p.promotionName}</strong>
                            </td>
                            <td class="muted">${p.startAt}</td>
                            <td class="muted">${p.endAt}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${now lt p.startAt}">
                                        <span class="badge up"><span class="dot"></span>UPCOMING</span>
                                    </c:when>
                                    <c:when test="${now ge p.startAt and now le p.endAt}">
                                        <span class="badge run"><span class="dot"></span>RUNNING</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge exp"><span class="dot"></span>EXPIRED</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${p.activeFlag}"><span class="badge run"><span class="dot"></span>YES</span></c:when>
                                    <c:otherwise><span class="badge exp"><span class="dot"></span>NO</span></c:otherwise>
                                </c:choose>
                            </td>

                            <td class="mono">${p.productCount}</td>
                            <td>
                                <div><strong>${p.createdByName}</strong></div>
                                <div class="muted">${p.createdByEmail}</div>
                            </td>
                            <td>
                                <!-- Step sau: detail/edit -->
                                <a class="link" href="${pageContext.request.contextPath}/admin/discounts?action=detail&id=${p.promotionId}">View</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pager">
                    <div class="muted">Page ${page} / ${totalPages}</div>
                    <div class="pages">
                        <c:forEach var="pg" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${pg == page}">
                                    <span class="page active">${pg}</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="page" href="${pageContext.request.contextPath}/admin/discounts?action=list
                                        &keyword=${keyword}
                                        &timeStatus=${timeStatus}
                                        &isActive=${isActive}
                                        &page=${pg}">
                                        ${pg}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

        </div>
    </div>
</div>

<!-- tạo biến now cho JSP (để tính UPCOMING/RUNNING/EXPIRED bằng JSTL) -->
<jsp:useBean id="now" class="java.util.Date" />
</body>
</html>
