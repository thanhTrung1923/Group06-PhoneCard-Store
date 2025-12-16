<%-- 
    Document   : list
    Created on : Dec 14, 2025, 2:03:17 AM
    Author     : DuyThai
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Discount Management</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <style>
    :root{
      --bg:#f6f7fb; --card:#fff; --text:#0f172a; --muted:#64748b; --border:#e2e8f0;
      --primary:#2563eb; --shadow:0 10px 30px rgba(15,23,42,.08); --radius:16px;
      --ok:#16a34a; --bad:#dc2626; --warn:#d97706;
      --okBg:#dcfce7; --badBg:#fee2e2; --warnBg:#ffedd5;
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui;background:linear-gradient(180deg,#fff 0%,var(--bg) 45%);color:var(--text)}
    .wrap{max-width:1280px;margin:22px auto;padding:0 16px 40px}
    h1{margin:0;font-size:22px}
    .sub{margin:6px 0 0;color:var(--muted);font-size:13px}

    .card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);box-shadow:var(--shadow);overflow:hidden}
    .hd{padding:14px 16px;border-bottom:1px solid var(--border);background:#fbfcff;display:flex;justify-content:space-between;align-items:center}
    .bd{padding:16px}

    .alert{padding:10px 12px;border-radius:12px;border:1px solid #fecaca;background:#fff1f2;color:#991b1b;margin-bottom:12px;font-size:13px}
    label{display:block;font-size:12px;color:var(--muted);margin-bottom:6px}
    input,select{width:100%;padding:10px;border-radius:12px;border:1px solid var(--border);background:#fff}

    .filters{display:grid;grid-template-columns: 1.5fr 1fr 1fr auto auto;gap:10px;align-items:end}
    @media(max-width:1000px){.filters{grid-template-columns:1fr 1fr}}

    .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;cursor:pointer}
    .btn-primary{background:linear-gradient(180deg,var(--primary),#1d4ed8);border-color:rgba(37,99,235,.45);color:#fff}
    .btn-ghost{background:#f8fafc}

    .pill{border:1px solid var(--border);background:#fff;border-radius:999px;padding:8px 12px;font-size:13px;color:var(--muted)}
    .table-wrap{margin-top:14px;border-radius:14px;border:1px solid var(--border);overflow:auto}
    table{width:100%;border-collapse:collapse;min-width:1120px}
    thead th{position:sticky;top:0;background:#f8fafc;border-bottom:1px solid var(--border);padding:12px;text-align:left;
             font-size:12px;color:var(--muted);text-transform:uppercase;letter-spacing:.08em;white-space:nowrap}
    tbody td{padding:12px;border-bottom:1px solid #f1f5f9;font-size:14px;vertical-align:middle}
    tbody tr:hover{background:#f8fafc}
    th a{color:inherit;text-decoration:none;display:inline-flex;gap:6px;align-items:center}
    th a:hover{text-decoration:underline}

    .badge{display:inline-flex;align-items:center;gap:8px;padding:6px 10px;border-radius:999px;font-weight:800;font-size:12px;border:1px solid var(--border)}
    .dot{width:8px;height:8px;border-radius:50%}

    .ts-exp{background:var(--badBg);border-color:rgba(220,38,38,.22)} .ts-exp .dot{background:var(--bad)}
    .ts-on{background:var(--okBg);border-color:rgba(22,163,74,.22)} .ts-on .dot{background:var(--ok)}
    .ts-up{background:var(--warnBg);border-color:rgba(217,119,6,.22)} .ts-up .dot{background:var(--warn)}

    .act-yes{background:var(--okBg);border-color:rgba(22,163,74,.22)} .act-yes .dot{background:var(--ok)}
    .act-no{background:var(--badBg);border-color:rgba(220,38,38,.22)} .act-no .dot{background:var(--bad)}

    .link{display:inline-flex;align-items:center;padding:8px 10px;border-radius:12px;border:1px solid rgba(37,99,235,.25);
          background:rgba(37,99,235,.08);color:#1d4ed8;font-weight:800;font-size:13px;text-decoration:none}
    .link:hover{background:rgba(37,99,235,.12);border-color:rgba(37,99,235,.35)}

    .pager{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:12px}
    .pages{display:flex;gap:8px;flex-wrap:wrap}
    .page{padding:8px 12px;border-radius:12px;border:1px solid var(--border);background:#fff;font-weight:800;font-size:13px;color:var(--text);text-decoration:none}
    .page.active{background:rgba(37,99,235,.12);border-color:rgba(37,99,235,.35);color:#1d4ed8}
    .muted{color:var(--muted);font-size:13px}
  </style>
</head>

<body>
<div class="wrap">
  <div>
    <h1>Discount Management</h1>
    <div class="sub">List promotions/discount campaigns (promotions + promotion_details)</div>
  </div>

  <div class="card" style="margin-top:14px;">
    <div class="hd">
      <strong>Promotions</strong>
      <span class="pill">Total: <strong>${total}</strong></span>
    </div>

    <div class="bd">
      <c:if test="${not empty error}">
        <div class="alert">Error: ${error}</div>
      </c:if>

      <form id="filterForm" method="get" action="${pageContext.request.contextPath}/admin/discounts">
        <input type="hidden" name="action" value="list"/>
        <input type="hidden" name="page" value="1"/>
        <input type="hidden" name="sort" value="${sort}"/>
        <input type="hidden" name="dir" value="${dir}"/>
        <input type="hidden" name="size" value="${size}"/>

        <div class="filters">
          <div>
            <label>Keyword</label>
            <input name="keyword" value="${param.keyword}" placeholder="Promotion name or ID"/>
          </div>

          <div>
            <label>Time Status</label>
            <select name="timeStatus">
              <option value="" ${empty timeStatus ? 'selected':''}>All</option>
              <option value="UPCOMING" ${timeStatus=='UPCOMING'?'selected':''}>UPCOMING</option>
              <option value="ONGOING"  ${timeStatus=='ONGOING'?'selected':''}>ONGOING</option>
              <option value="EXPIRED"  ${timeStatus=='EXPIRED'?'selected':''}>EXPIRED</option>
            </select>
          </div>

          <div>
            <label>Active Flag</label>
            <select name="active">
              <option value="" ${empty active ? 'selected':''}>All</option>
              <option value="1" ${active=='1'?'selected':''}>YES</option>
              <option value="0" ${active=='0'?'selected':''}>NO</option>
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
              <th><a href="#" onclick="return sortBy('id')">ID <span id="s_id"></span></a></th>
              <th><a href="#" onclick="return sortBy('name')">PROMOTION NAME <span id="s_name"></span></a></th>
              <th><a href="#" onclick="return sortBy('start')">START <span id="s_start"></span></a></th>
              <th><a href="#" onclick="return sortBy('end')">END <span id="s_end"></span></a></th>
              <th><a href="#" onclick="return sortBy('time')">TIME STATUS <span id="s_time"></span></a></th>
              <th><a href="#" onclick="return sortBy('active')">ACTIVE <span id="s_active"></span></a></th>
              <th><a href="#" onclick="return sortBy('discount')">DISCOUNT % <span id="s_discount"></span></a></th>
              <th><a href="#" onclick="return sortBy('products')">PRODUCTS <span id="s_products"></span></a></th>
              <th><a href="#" onclick="return sortBy('createdBy')">CREATED BY <span id="s_createdBy"></span></a></th>
              <th>ACTION</th>
            </tr>
          </thead>

          <tbody>
            <c:if test="${empty rows}">
              <tr><td colspan="10" style="padding:18px;text-align:center;color:var(--muted)">No promotions found.</td></tr>
            </c:if>

            <c:forEach var="p" items="${rows}">
              <tr>
                <td>#${p.promotionId}</td>

                <td><strong>${p.promotionName}</strong></td>

                <td class="muted">
                  <fmt:formatDate value="${p.startAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </td>

                <td class="muted">
                  <fmt:formatDate value="${p.endAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${p.timeStatus == 'ONGOING'}">
                      <span class="badge ts-on"><span class="dot"></span>ONGOING</span>
                    </c:when>
                    <c:when test="${p.timeStatus == 'UPCOMING'}">
                      <span class="badge ts-up"><span class="dot"></span>UPCOMING</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge ts-exp"><span class="dot"></span>EXPIRED</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${p.active}">
                      <span class="badge act-yes"><span class="dot"></span>YES</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge act-no"><span class="dot"></span>NO</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${p.productCount == 0 || p.maxDiscountPercent == null}">
                      <span class="muted">—</span>
                    </c:when>
                    <c:when test="${p.minDiscountPercent eq p.maxDiscountPercent}">
                      ${p.maxDiscountPercent}%
                    </c:when>
                    <c:otherwise>
                      ${p.minDiscountPercent}% - ${p.maxDiscountPercent}%
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>${p.productCount}</td>

                <td>
                  <div><strong>${p.createdByName}</strong></div>
                  <div class="muted">${p.createdByEmail}</div>
                </td>

                <td>
                  <a class="link" href="${pageContext.request.contextPath}/admin/discounts?action=detail&id=${p.promotionId}">View</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <c:if test="${totalPages > 1}">
        <div class="pager">
          <div class="pill">Page <strong>${page}</strong> / ${totalPages}</div>
          <div class="pages">
            <c:forEach var="pg" begin="1" end="${totalPages}">
              <c:choose>
                <c:when test="${pg == page}">
                  <span class="page active">${pg}</span>
                </c:when>
                <c:otherwise>
                  <a class="page"
                     href="${pageContext.request.contextPath}/admin/discounts?action=list
                      &page=${pg}&size=${size}
                      &keyword=${param.keyword}&timeStatus=${param.timeStatus}&active=${param.active}
                      &sort=${sort}&dir=${dir}">
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

<script>
  const currentSort = "${sort}";
  const currentDir  = "${dir}";

  function sortBy(col){
    const f = document.getElementById("filterForm");
    const sortInput = f.querySelector("input[name='sort']");
    const dirInput  = f.querySelector("input[name='dir']");
    let nextDir = "asc";
    if (currentSort === col) nextDir = (currentDir === "asc" ? "desc" : "asc");
    sortInput.value = col;
    dirInput.value  = nextDir;
    f.submit();
    return false;
  }

  function setArrow(col){
    if (currentSort !== col) return;
    const el = document.getElementById("s_" + col);
    if (!el) return;
    el.textContent = (currentDir === "asc" ? "▲" : "▼");
  }
  ["id","name","start","end","time","active","discount","products","createdBy"].forEach(setArrow);
</script>
</body>
</html>
