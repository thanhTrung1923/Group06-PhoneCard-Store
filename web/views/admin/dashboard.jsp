<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Card Phone Store</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --sidebar-width: 260px;
            --primary-color: #4e73df;
            --sidebar-bg: #212529; 
        }
        
        body {
            background-color: #f8f9fc;
            overflow-x: hidden;
        }

        /* --- SIDEBAR STYLING --- */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background-color: var(--sidebar-bg);
            color: #fff;
            padding-top: 1rem;
            z-index: 1000;
            transition: all 0.3s;
        }
        
        .sidebar-brand {
            padding: 1.5rem 1rem;
            font-size: 1.2rem;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 1rem;
        }
        
        .sidebar-brand i { color: var(--primary-color); }

        .nav-item { margin-bottom: 0.5rem; }
        
        .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 0.8rem 1.5rem;
            display: flex;
            align-items: center;
            font-size: 0.95rem;
            border-left: 4px solid transparent;
            transition: all 0.3s;
        }
        
        .nav-link:hover, .nav-link.active {
            color: #fff;
            background-color: rgba(255,255,255,0.1);
            border-left-color: var(--primary-color);
        }
        
        .nav-link i { width: 25px; margin-right: 10px; text-align: center; }

        /* --- MAIN CONTENT --- */
        .main-content {
            margin-left: var(--sidebar-width);
            padding: 2rem;
        }

        /* --- WIDGET CARDS --- */
        .dashboard-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            transition: transform 0.2s;
        }
        .dashboard-card:hover { transform: translateY(-5px); }
        .card-icon { font-size: 2rem; opacity: 0.4; }
        
        .text-xs { font-size: .8rem; font-weight: 700; text-transform: uppercase; letter-spacing: .05rem; }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="sidebar-brand">
            <i class="fa-solid fa-sim-card"></i> Card Store
        </div>
        
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fa-solid fa-gauge-high"></i> Dashboard
                </a>
            </li>

            <li class="nav-item"><hr class="dropdown-divider bg-light opacity-25 mx-3"></li>
            <div class="sidebar-heading text-white-50 px-3 mt-3 mb-1 small text-uppercase">Management</div>

            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin-products">
                    <i class="fa-solid fa-box-open"></i> Product Manager
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/inventory">
                    <i class="fa-solid fa-warehouse"></i> Inventory (Kho)
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                    <i class="fa-solid fa-cart-shopping"></i> Order Manager
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/discounts">
                    <i class="fa-solid fa-tags"></i> Discount Manager
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                    <i class="fa-solid fa-users"></i> User Manager
                </a>
            </li>
            
            <li class="nav-item mt-5">
                <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                </a>
            </li>
        </ul>
    </nav>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-dark mb-0">Bảng điều khiển</h3>
            <div class="dropdown">
                <button class="btn btn-white shadow-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    <i class="fa-solid fa-circle-user me-2 text-primary"></i> Admin
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="#">Profile</a></li>
                    <li><a class="dropdown-item" href="#">Settings</a></li>
                </ul>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card dashboard-card border-start border-4 border-primary h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs text-primary mb-1">Doanh thu (Hôm nay)</div>
                                <div class="h5 mb-0 fw-bold text-gray-800">
                                    <fmt:formatNumber value="${metrics.revenueToday}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fa-solid fa-calendar fa-2x text-gray-300 card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="card dashboard-card border-start border-4 border-warning h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs text-warning mb-1">Đơn hàng chờ xử lý</div>
                                <div class="h5 mb-0 fw-bold text-gray-800">${metrics.pendingOrders}</div>
                            </div>
                            <div class="col-auto">
                                <i class="fa-solid fa-clipboard-list fa-2x text-gray-300 card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6">
                <a href="${pageContext.request.contextPath}/admin/inventory?status=LOW" class="text-decoration-none">
                    <div class="card dashboard-card border-start border-4 border-danger h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs text-danger mb-1">Sản phẩm Sắp hết</div>
                                    <div class="h5 mb-0 fw-bold text-danger">${metrics.lowStock}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fa-solid fa-triangle-exclamation fa-2x text-gray-300 card-icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-xl-3 col-md-6">
                <div class="card dashboard-card border-start border-4 border-info h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs text-info mb-1">Khách hàng</div>
                                <div class="h5 mb-0 fw-bold text-gray-800">${metrics.totalUsers}</div>
                            </div>
                            <div class="col-auto">
                                <i class="fa-solid fa-users fa-2x text-gray-300 card-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 fw-bold text-primary">Doanh thu 7 ngày gần nhất</h6>
                    </div>
                    <div class="card-body">
                        <canvas id="revenueChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold text-primary">Lối tắt quản lý</h6>
                    </div>
                    <div class="card-body">
                        <div class="list-group list-group-flush">
                            <a href="${pageContext.request.contextPath}/admin-products?action=create" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                <span><i class="fa-solid fa-plus-circle me-2 text-success"></i> Nhập kho thủ công</span>
                                <i class="fa-solid fa-chevron-right text-muted small"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/import" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" data-bs-toggle="modal" data-bs-target="#importModal">
                                <span><i class="fa-solid fa-file-excel me-2 text-success"></i> Import Excel</span>
                                <i class="fa-solid fa-chevron-right text-muted small"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/products" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                <span><i class="fa-solid fa-box me-2 text-primary"></i> Thêm sản phẩm mới</span>
                                <i class="fa-solid fa-chevron-right text-muted small"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Demo Chart Data
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['12/12', '13/12', '14/12', '15/12', '16/12', '17/12', '18/12'],
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: [1200000, 1900000, 3000000, 5000000, 2300000, 3400000, 1500000],
                    borderColor: '#4e73df',
                    backgroundColor: 'rgba(78, 115, 223, 0.05)',
                    pointRadius: 3,
                    pointBackgroundColor: '#4e73df',
                    pointBorderColor: '#4e73df',
                    pointHoverRadius: 3,
                    pointHoverBackgroundColor: '#4e73df',
                    pointHoverBorderColor: '#4e73df',
                    pointHitRadius: 10,
                    pointBorderWidth: 2,
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { borderDash: [2] }
                    },
                    x: {
                        grid: { display: false }
                    }
                }
            }
        });
    </script>
</body>
</html>