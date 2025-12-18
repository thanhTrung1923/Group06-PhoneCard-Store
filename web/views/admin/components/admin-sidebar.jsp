<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    :root {
        --sidebar-width: 260px;
        --sidebar-bg: #212529;
        --primary-color: #4e73df;
    }
    
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
        overflow-y: auto; /* Cho phép cuộn nếu menu dài */
    }
    
    .sidebar-brand {
        padding: 1rem;
        font-size: 1.2rem;
        font-weight: bold;
        text-transform: uppercase;
        text-align: center;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        margin-bottom: 1rem;
    }
    
    .nav-link {
        color: rgba(255,255,255,0.8);
        padding: 0.8rem 1.5rem;
        display: flex;
        align-items: center;
        text-decoration: none;
        transition: all 0.3s;
        border-left: 4px solid transparent;
    }
    
    .nav-link:hover {
        color: #fff;
        background-color: rgba(255,255,255,0.1);
    }

    /* Class active để tô màu mục đang chọn */
    .nav-link.active {
        color: #fff;
        background-color: rgba(255,255,255,0.15);
        border-left-color: var(--primary-color);
        font-weight: bold;
    }
    
    .nav-link i { width: 25px; margin-right: 10px; text-align: center; }
    
    /* Responsive: Ẩn sidebar trên mobile (nếu cần xử lý sau) */
    @media (max-width: 768px) {
        .sidebar { margin-left: -260px; }
    }
</style>

<nav class="sidebar">
    <div class="sidebar-brand">
        <i class="fa-solid fa-sim-card text-primary"></i> Card Store
    </div>
    
    <div class="nav flex-column">
        <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fa-solid fa-gauge-high"></i> Dashboard
        </a>

        <div class="text-white-50 px-3 mt-3 mb-1 small text-uppercase">Management</div>

        <a class="nav-link ${activePage == 'products' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/admin/products">
            <i class="fa-solid fa-box-open"></i> Product Manager
        </a>

        <a class="nav-link ${activePage == 'inventory' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/admin/inventory">
            <i class="fa-solid fa-warehouse"></i> Inventory (Kho)
        </a>

        <a class="nav-link ${activePage == 'orders' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/admin/orders">
            <i class="fa-solid fa-cart-shopping"></i> Order Manager
        </a>
            
        <a class="nav-link ${activePage == 'orders' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/admin/supplier">
            <i class="fa-solid fa-handshake"></i> Supplier Manager
        </a>

        <a class="nav-link ${activePage == 'discounts' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/admin/discounts">
            <i class="fa-solid fa-tags"></i> Discount Manager
        </a>

        <a class="nav-link ${activePage == 'users' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/admin/users">
            <i class="fa-solid fa-users"></i> User Manager
        </a>
        
        <div class="mt-5">
            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </div>
    </div>
</nav>