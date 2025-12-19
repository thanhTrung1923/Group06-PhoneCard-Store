<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Quản lý đơn hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <style>
        :root{
            --bg:#f6f7fb;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --border:#e2e8f0;
            --primary:#2563eb;
            --primary2:#1d4ed8;
            --shadow: 0 10px 30px rgba(15,23,42,.08);
            --radius: 16px;

            --success:#16a34a;
            --warn:#d97706;
            --danger:#dc2626;

            --successBg:#dcfce7;
            --warnBg:#ffedd5;
            --dangerBg:#fee2e2;
        }

        *{box-sizing:border-box}
        body{
            margin:0;
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            background: linear-gradient(180deg, #ffffff 0%, var(--bg) 45%);
            color: var(--text);
        }

        a{color:inherit; text-decoration:none}
        .wrap{
            max-width: 1200px;
            margin: 26px auto;
            padding: 0 18px 40px;
        }

        .topbar{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            margin-bottom:14px;
        }
        .title{
            display:flex; flex-direction:column; gap:6px;
        }
        .title h1{
            margin:0;
            font-size: 22px;
            letter-spacing:.2px;
        }
        .title p{
            margin:0;
            font-size: 13px;
            color: var(--muted);
        }

        .card{
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow:hidden;
        }

        .card-hd{
            padding: 16px 16px 12px;
            border-bottom: 1px solid var(--border);
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            background: #fbfcff;
        }
        .card-hd .hd-left{ display:flex; flex-direction:column; gap:4px; }
        .card-hd .hd-left strong{ font-size:14px; }
        .card-hd .hd-left span{ font-size:12px; color:var(--muted); }

        .card-bd{ padding: 16px; }

        .alert{
            padding: 10px 12px;
            border-radius: 12px;
            border: 1px solid #fecaca;
            background: #fff1f2;
            color: #991b1b;
            margin-bottom: 12px;
            font-size: 13px;
        }

        /* Filter form */
        .filters{
            display:grid;
            grid-template-columns: 190px 1fr 160px 160px auto auto;
            gap: 10px;
            align-items:end;
        }
        @media (max-width: 980px){
            .filters{ grid-template-columns: 1fr 1fr; }
        }
        .field{ display:flex; flex-direction:column; gap:6px; }
        .label{ font-size:12px; color: var(--muted); }

        select, input{
            width:100%;
            padding: 10px 10px;
            border-radius: 12px;
            border: 1px solid var(--border);
            outline:none;
            background: #ffffff;
            color: var(--text);
        }
        input::placeholder{ color: rgba(100,116,139,.75); }

        .btn{
            padding: 10px 14px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: #ffffff;
            color: var(--text);
            cursor:pointer;
            font-weight:700;
            transition: .15s;
            white-space:nowrap;
        }
        .btn:hover{ transform: translateY(-1px); border-color: rgba(37,99,235,.35); }
        .btn-primary{
            background: linear-gradient(180deg, var(--primary), var(--primary2));
            border-color: rgba(37,99,235,.45);
            color:#fff;
        }
        .btn-ghost{
            background: #f8fafc;
        }

        /* Table */
        .table-wrap{
            margin-top: 14px;
            border-radius: 14px;
            border: 1px solid var(--border);
            overflow:auto;
            background: #ffffff;
        }
        table{
            width:100%;
            border-collapse: collapse;
            min-width: 920px;
        }
        thead th{
            position: sticky;
            top: 0;
            z-index: 1;
            background: #f8fafc;
            border-bottom: 1px solid var(--border);
            font-size: 12px;
            color: var(--muted);
            text-align:left;
            padding: 12px 12px;
            text-transform: uppercase;
            letter-spacing: .08em;
            white-space:nowrap;
        }
        thead th a{
            color: inherit;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            gap:6px;
        }
        thead th a:hover{ text-decoration: underline; }

        tbody td{
            padding: 12px 12px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
            vertical-align: middle;
        }
        tbody tr:hover{ background: #f8fafc; }

        .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace; }
        .muted{ color: var(--muted); font-size: 13px; }
        .right{ text-align:right; }

        /* Badge */
        .badge{
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding: 6px 10px;
            border-radius: 999px;
            font-weight: 800;
            font-size: 12px;
            border: 1px solid var(--border);
            background: #ffffff;
        }
        .dot{ width:8px; height:8px; border-radius:50%; background: #94a3b8; }

        .paid{ background: var(--successBg); border-color: rgba(22,163,74,.22); }
        .paid .dot{ background: var(--success); }

        .cancel{ background: var(--warnBg); border-color: rgba(217,119,6,.22); }
        .cancel .dot{ background: var(--warn); }

        .refund{ background: var(--dangerBg); border-color: rgba(220,38,38,.22); }
        .refund .dot{ background: var(--danger); }

        /* Actions */
        .link{
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding: 8px 10px;
            border-radius: 12px;
            border: 1px solid rgba(37,99,235,.25);
            background: rgba(37,99,235,.08);
            color: #1d4ed8;
            font-weight: 800;
            font-size: 13px;
        }
        .link:hover{ background: rgba(37,99,235,.12); border-color: rgba(37,99,235,.35); }

        /* Pagination */
        .pager{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 12px;
            margin-top: 12px;
        }
        .pages{ display:flex; gap: 8px; flex-wrap: wrap; }
        .page{
            padding: 8px 12px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: #ffffff;
            font-weight: 800;
            font-size: 13px;
            color: var(--text);
        }
        .page.active{
            background: rgba(37,99,235,.12);
            border-color: rgba(37,99,235,.35);
            color: #1d4ed8;
        }
        .hint{ font-size: 12px; color: var(--muted); }
        .empty{
            padding: 18px;
            text-align:center;
            color: var(--muted);
        }
    </style>
</head>

<body>
<div class="wrap">

    <div class="topbar">
        <div class="title">
            <h1>Quản lý đơn hàng</h1>
            <p>Tìm kiếm, lọc và xem danh sách đơn hàng</p>
        </div>
    </div>

    <div class="card">
        <div class="card-hd">
            <div class="hd-left">
                <strong>Danh sách đơn hàng</strong>
                <span>Lọc theo trạng thái, từ khóa và khoảng thời gian</span>
            </div>
        </div>

        <div class="card-bd">

            <c:if test="${not empty error}">
                <div class="alert">Lỗi: ${error}</div>
            </c:if>

            <c:if test="${not empty dateError}">
                <div class="alert">${dateError}</div>
            </c:if>

            <form id="filterForm" method="get" action="${pageContext.request.contextPath}/admin/orders">
                <input type="hidden" name="action" value="list"/>

                <!-- hidden sort/dir/page -->
                <input type="hidden" name="sort" value="${sort}"/>
                <input type="hidden" name="dir" value="${dir}"/>
                <!-- Khi search/filter thì luôn về trang 1 -->
                <input type="hidden" name="page" value="1"/>

                <div class="filters">
                    <div class="field"
                        <div class="label">Trạng thái</div>
                        <select name="status">
                            <option value="">Tất cả</option>
                            <option value="PAID"      ${status=='PAID' ? 'selected' : ''}>Đã thanh toán</option>
                            <option value="CANCELLED" ${status=='CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                            <option value="REFUNDED"  ${status=='REFUNDED' ? 'selected' : ''}>Đã hoàn tiền</option>
                        </select>
                    </div>

                    <div class="field">
                        <div class="label">Từ khóa</div>
                        <input type="text" name="keyword" value="${keyword}"
                               placeholder="Mã đơn / Email / SĐT / Tên khách hàng"/>
                    </div>

                    <div class="field">
                        <div class="label">Từ ngày</div>
                        <input id="fromDate" type="date" name="fromDate" value="${fromDate}"/>
                    </div>

                    <div class="field">
                        <div class="label">Đến ngày</div>
                        <input id="toDate" type="date" name="toDate" value="${toDate}"/>
                    </div>

                    <button class="btn btn-primary" type="submit">Tìm kiếm</button>
                    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/orders?action=list">Đặt lại</a>
                </div>
            </form>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th style="width:110px;">
                            <a href="#" onclick="return sortBy('orderId')">Mã đơn <span id="s_orderId"></span></a>
                        </th>
                        <th>
                            <a href="#" onclick="return sortBy('customer')">Khách hàng <span id="s_customer"></span></a>
                        </th>
                        <th>
                            <a href="#" onclick="return sortBy('email')">Email <span id="s_email"></span></a>
                        </th>
                        <th style="width:140px;">
                            <a href="#" onclick="return sortBy('phone')">SĐT <span id="s_phone"></span></a>
                        </th>
                        <th style="width:120px;" class="right">
                            <a href="#" onclick="return sortBy('total')">Tổng tiền <span id="s_total"></span></a>
                        </th>
                        <th style="width:130px;">
                            <a href="#" onclick="return sortBy('status')">Trạng thái <span id="s_status"></span></a>
                        </th>
                        <th style="width:80px;" class="right">
                            <a href="#" onclick="return sortBy('items')">Số SP <span id="s_items"></span></a>
                        </th>
                        <th style="width:180px;">
                            <a href="#" onclick="return sortBy('created')">Ngày tạo <span id="s_created"></span></a>
                        </th>
                        
                    </tr>
                    </thead>

                    <tbody>
                    <c:if test="${empty orders}">
                        <tr><td colspan="9" class="empty">Không có đơn hàng nào.</td></tr>
                    </c:if>

                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td class="mono">#${o.orderId}</td>
                            <td>${o.customerFullName}</td>
                            <td class="muted">${o.customerEmail}</td>
                            <td class="muted">${o.customerPhone}</td>
                            <td class="right mono">${o.totalAmount}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 'PAID'}">
                                        <span class="badge paid"><span class="dot"></span>Đã thanh toán</span>
                                    </c:when>
                                    <c:when test="${o.status == 'CANCELLED'}">
                                        <span class="badge cancel"><span class="dot"></span>Đã hủy</span>
                                    </c:when>
                                    <c:when test="${o.status == 'REFUNDED'}">
                                        <span class="badge refund"><span class="dot"></span>Đã hoàn tiền</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge"><span class="dot"></span>${o.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="right mono">${o.itemCount}</td>
                            <td class="muted">${o.createdAt}</td>
                            
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pager">
                    <div class="hint">Trang ${page} / ${totalPages}</div>
                    <div class="pages">
                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${p == page}">
                                    <span class="page active">${p}</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="page"
                                       href="${pageContext.request.contextPath}/admin/orders?action=list&status=${status}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&page=${p}&sort=${sort}&dir=${dir}">
                                        ${p}
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
  // ===== From/To validate (client-side)
  const fromEl = document.getElementById("fromDate");
  const toEl   = document.getElementById("toDate");
  const form   = document.getElementById("filterForm");

  function validateRange() {
    const from = fromEl ? fromEl.value : "";
    const to   = toEl ? toEl.value : "";
    if (from && to && from > to) {
      alert("Ngày 'Từ ngày' không được lớn hơn 'Đến ngày'.");
      return false;
    }
    return true;
  }

  if (form) {
    form.addEventListener("submit", function(e){
      if (!validateRange()) e.preventDefault();
    });
  }

  // ===== Sorting (server-side)
  const currentSort = "${sort}";
  const currentDir  = "${dir}";

  function sortBy(col){
    const f = document.getElementById("filterForm");
    const sortInput = f.querySelector("input[name='sort']");
    const dirInput  = f.querySelector("input[name='dir']");
    const pageInput = f.querySelector("input[name='page']");

    let nextDir = "asc";
    if (currentSort === col) nextDir = (currentDir === "asc" ? "desc" : "asc");

    sortInput.value = col;
    dirInput.value = nextDir;
    pageInput.value = "1"; // đổi sort => quay về trang 1
    f.submit();
    return false;
  }

  function setArrow(col){
    if (currentSort !== col) return;
    const el = document.getElementById("s_" + col);
    if (!el) return;
    el.textContent = (currentDir === "asc" ? "▲" : "▼");
  }
  ["orderId","customer","email","phone","total","status","items","created"].forEach(setArrow);
</script>

</body>
</html>