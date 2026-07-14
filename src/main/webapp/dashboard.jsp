<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

// Get the fullname safely
String fullname = user.getFullname();
if(fullname == null || fullname.isEmpty()) {
    fullname = "User";
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Dashboard - Inventory Management</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    /* ============================================
       CSS VARIABLES & RESET
    ============================================ */
    :root {
        --primary: #4f46e5;
        --primary-light: #818cf8;
        --primary-dark: #3730a3;
        --secondary: #0ea5e9;
        --success: #22c55e;
        --warning: #f59e0b;
        --danger: #ef4444;
        --dark: #0f172a;
        --gray-900: #1e293b;
        --gray-800: #334155;
        --gray-700: #475569;
        --gray-600: #64748b;
        --gray-500: #94a3b8;
        --gray-400: #cbd5e1;
        --gray-300: #e2e8f0;
        --gray-200: #f1f5f9;
        --gray-100: #f8fafc;
        --white: #ffffff;
        --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
        --shadow: 0 4px 6px -1px rgba(0,0,0,0.07), 0 2px 4px -1px rgba(0,0,0,0.04);
        --shadow-md: 0 10px 15px -3px rgba(0,0,0,0.08), 0 4px 6px -2px rgba(0,0,0,0.03);
        --shadow-lg: 0 20px 25px -5px rgba(0,0,0,0.08), 0 10px 10px -5px rgba(0,0,0,0.02);
        --shadow-xl: 0 25px 50px -12px rgba(0,0,0,0.15);
        --radius: 16px;
        --radius-sm: 10px;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        background: var(--gray-200);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        min-height: 100vh;
        color: var(--dark);
    }

    /* ============================================
       PAGE WRAPPER
    ============================================ */
    .page-wrapper {
        display: flex;
        min-height: 100vh;
    }

    /* ============================================
       MAIN CONTENT
    ============================================ */
    .main-content {
        flex: 1;
        margin-left: 250px;
        padding: 28px 32px 40px;
        background: var(--gray-200);
        min-height: 100vh;
    }

    /* ============================================
       TOP BAR
    ============================================ */
    .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 28px;
        flex-wrap: wrap;
        gap: 16px;
    }

    .top-bar .greeting h1 {
        font-size: 26px;
        font-weight: 700;
        color: var(--dark);
        margin: 0;
        letter-spacing: -0.5px;
    }

    .top-bar .greeting h1 span {
        color: var(--primary);
    }

    .top-bar .greeting p {
        color: var(--gray-600);
        font-size: 14px;
        margin: 4px 0 0 0;
    }

    .top-bar .greeting p i {
        color: var(--success);
        font-size: 10px;
        margin-right: 4px;
    }

    .top-bar .top-actions {
        display: flex;
        align-items: center;
        gap: 14px;
    }

    .top-bar .top-actions .search-box {
        position: relative;
        background: var(--white);
        border-radius: var(--radius-sm);
        padding: 0 16px;
        display: flex;
        align-items: center;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--gray-300);
        transition: var(--transition);
    }

    .top-bar .top-actions .search-box:focus-within {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.12);
    }

    .top-bar .top-actions .search-box input {
        border: none;
        padding: 10px 12px 10px 0;
        font-size: 14px;
        background: transparent;
        outline: none;
        width: 200px;
        color: var(--dark);
    }

    .top-bar .top-actions .search-box input::placeholder {
        color: var(--gray-500);
    }

    .top-bar .top-actions .search-box i {
        color: var(--gray-500);
        font-size: 16px;
        margin-right: 8px;
    }

    .top-bar .top-actions .user-profile {
        display: flex;
        align-items: center;
        gap: 12px;
        background: var(--white);
        padding: 6px 16px 6px 6px;
        border-radius: 50px;
        box-shadow: var(--shadow-sm);
        border: 1px solid var(--gray-300);
        cursor: pointer;
        transition: var(--transition);
    }

    .top-bar .top-actions .user-profile:hover {
        border-color: var(--primary);
        box-shadow: var(--shadow-md);
    }

    .top-bar .top-actions .user-profile .avatar {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--primary), var(--primary-light));
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        font-size: 16px;
    }

    .top-bar .top-actions .user-profile .info {
        display: flex;
        flex-direction: column;
        line-height: 1.3;
    }

    .top-bar .top-actions .user-profile .info .name {
        font-weight: 600;
        font-size: 14px;
        color: var(--dark);
    }

    .top-bar .top-actions .user-profile .info .role {
        font-size: 12px;
        color: var(--gray-600);
    }

    .top-bar .top-actions .user-profile .info .role i {
        color: var(--success);
        font-size: 8px;
    }

    /* Notification Bell */
    .top-bar .top-actions .notification-bell {
        position: relative;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: var(--white);
        border: 1px solid var(--gray-300);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: var(--transition);
        box-shadow: var(--shadow-sm);
    }

    .top-bar .top-actions .notification-bell:hover {
        border-color: var(--primary);
        box-shadow: var(--shadow-md);
    }

    .top-bar .top-actions .notification-bell i {
        font-size: 18px;
        color: var(--gray-700);
    }

    .top-bar .top-actions .notification-bell .badge-dot {
        position: absolute;
        top: 6px;
        right: 6px;
        width: 8px;
        height: 8px;
        background: var(--danger);
        border-radius: 50%;
        border: 2px solid var(--white);
    }

    /* ============================================
       QUICK ACTIONS
    ============================================ */
    .quick-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 28px;
    }

    .quick-actions .btn {
        padding: 12px 24px;
        border-radius: var(--radius-sm);
        font-weight: 600;
        font-size: 14px;
        transition: var(--transition);
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border: none;
    }

    .quick-actions .btn:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .quick-actions .btn-primary {
        background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        color: white;
    }

    .quick-actions .btn-success {
        background: linear-gradient(135deg, var(--success), #16a34a);
        color: white;
    }

    .quick-actions .btn-info {
        background: linear-gradient(135deg, var(--secondary), #0284c7);
        color: white;
    }

    .quick-actions .btn-warning {
        background: linear-gradient(135deg, var(--warning), #d97706);
        color: white;
    }

    /* ============================================
       MAIN GRID - CHART + LOW STOCK
    ============================================ */
    .dashboard-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 24px;
        margin-bottom: 28px;
    }

    .card {
        background: var(--white);
        border-radius: var(--radius);
        border: none;
        box-shadow: var(--shadow);
        overflow: hidden;
        transition: var(--transition);
    }

    .card:hover {
        box-shadow: var(--shadow-md);
    }

    .card-header {
        background: var(--white);
        border-bottom: 1px solid var(--gray-200);
        padding: 18px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .card-header .title {
        font-weight: 600;
        color: var(--dark);
        font-size: 16px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .card-header .title i {
        color: var(--primary);
    }

    .card-header .badge-custom {
        background: var(--gray-200);
        color: var(--gray-700);
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
    }

    .card-body {
        padding: 24px;
    }

    /* Chart Container */
    .chart-container {
        position: relative;
        height: 260px;
    }

    /* ============================================
       LOW STOCK ITEMS
    ============================================ */
    .stock-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 14px 16px;
        border-radius: var(--radius-sm);
        margin-bottom: 10px;
        transition: var(--transition);
        border-left: 3px solid transparent;
    }

    .stock-item:hover {
        background: var(--gray-100);
        transform: translateX(4px);
    }

    .stock-item.danger {
        border-left-color: var(--danger);
        background: rgba(239, 68, 68, 0.04);
    }

    .stock-item.warning {
        border-left-color: var(--warning);
        background: rgba(245, 158, 11, 0.04);
    }

    .stock-item .stock-info .name {
        font-weight: 500;
        color: var(--dark);
        font-size: 14px;
    }

    .stock-item .stock-info .category {
        font-size: 12px;
        color: var(--gray-500);
    }

    .stock-item .stock-count {
        font-weight: 600;
        color: var(--dark);
        font-size: 14px;
        background: var(--gray-200);
        padding: 4px 14px;
        border-radius: 20px;
    }

    .stock-item.danger .stock-count {
        color: var(--danger);
        background: rgba(239, 68, 68, 0.1);
    }

    .stock-item.warning .stock-count {
        color: var(--warning);
        background: rgba(245, 158, 11, 0.1);
    }

    /* ============================================
       RECENT PRODUCTS TABLE
    ============================================ */
    .table-wrapper {
        overflow-x: auto;
    }

    .table {
        margin: 0;
        font-size: 14px;
    }

    .table thead th {
        background: var(--gray-100);
        color: var(--gray-700);
        font-weight: 600;
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
        border-bottom: 2px solid var(--gray-300);
        padding: 14px 18px;
        white-space: nowrap;
    }

    .table tbody td {
        padding: 14px 18px;
        vertical-align: middle;
        border-bottom: 1px solid var(--gray-200);
        color: var(--gray-800);
    }

    .table tbody tr:hover {
        background: var(--gray-100);
    }

    .table tbody tr:last-child td {
        border-bottom: none;
    }

    .product-cell {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .product-cell .product-icon {
        width: 38px;
        height: 38px;
        border-radius: var(--radius-sm);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        flex-shrink: 0;
    }

    .product-cell .product-icon.blue { background: rgba(79, 70, 229, 0.1); color: var(--primary); }
    .product-cell .product-icon.green { background: rgba(34, 197, 94, 0.1); color: var(--success); }
    .product-cell .product-icon.orange { background: rgba(245, 158, 11, 0.1); color: var(--warning); }
    .product-cell .product-icon.purple { background: rgba(14, 165, 233, 0.1); color: var(--secondary); }

    .product-cell .product-name {
        font-weight: 500;
        color: var(--dark);
    }

    .product-cell .product-sku {
        font-size: 12px;
        color: var(--gray-500);
    }

    .status-badge {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }

    .status-badge.in-stock {
        background: rgba(34, 197, 94, 0.12);
        color: var(--success);
    }

    .status-badge.low-stock {
        background: rgba(245, 158, 11, 0.12);
        color: var(--warning);
    }

    .status-badge.out-of-stock {
        background: rgba(239, 68, 68, 0.12);
        color: var(--danger);
    }

    .price-text {
        font-weight: 600;
        color: var(--dark);
    }

    /* ============================================
       RESPONSIVE
    ============================================ */
    @media (max-width: 1200px) {
        .dashboard-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 992px) {
        .main-content {
            margin-left: 0;
            padding: 20px;
        }

        .top-bar {
            flex-direction: column;
            align-items: stretch;
        }

        .top-bar .top-actions {
            flex-wrap: wrap;
        }

        .top-bar .top-actions .search-box {
            flex: 1;
        }

        .top-bar .top-actions .search-box input {
            width: 100%;
        }
    }

    @media (max-width: 768px) {
        .quick-actions .btn {
            flex: 1;
            min-width: 120px;
            justify-content: center;
        }

        .card-body {
            padding: 16px;
        }

        .table thead th,
        .table tbody td {
            padding: 10px 12px;
            font-size: 13px;
        }
    }

    @media (max-width: 480px) {
        .top-bar .greeting h1 {
            font-size: 20px;
        }

        .top-bar .top-actions .user-profile .info {
            display: none;
        }

        .top-bar .top-actions .user-profile {
            padding: 6px;
        }

        .main-content {
            padding: 14px;
        }
    }

    /* ============================================
       ANIMATIONS
    ============================================ */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .card {
        animation: fadeInUp 0.5s ease forwards;
        opacity: 0;
    }

    .card:nth-child(1) { animation-delay: 0.05s; }
    .card:nth-child(2) { animation-delay: 0.1s; }
</style>

</head>

<body>

<div class="page-wrapper">
    
    <!-- Include Sidebar -->
    <%@ include file="sidebar.jsp" %>
    
    <!-- Main Content -->
    <div class="main-content">
        
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="greeting">
                <h1>Dashboard <span>.</span></h1>
                <p><i class="bi bi-circle-fill"></i> Welcome back, <strong><%= fullname %></strong></p>
            </div>
            <div class="top-actions">
                <!-- Search -->
                <div class="search-box">
                    <i class="bi bi-search"></i>
                    <input type="text" placeholder="Search products..." id="searchInput">
                </div>
                
                <!-- Notification Bell -->
                <div class="notification-bell">
                    <i class="bi bi-bell"></i>
                    <span class="badge-dot"></span>
                </div>
                
                <!-- User Profile -->
                <div class="user-profile">
                    <div class="avatar">
                        <%= fullname.charAt(0) %>
                    </div>
                    <div class="info">
                        <span class="name"><%= fullname %></span>
                        <span class="role"><i class="bi bi-circle-fill"></i> Administrator</span>
                    </div>
                    <i class="bi bi-chevron-down" style="color: var(--gray-500); font-size: 14px;"></i>
                </div>
            </div>
        </div>
       
               
        <!-- Dashboard Grid -->
        <div class="dashboard-grid">
            
            <!-- Chart Card -->
            <div class="card">
                <div class="card-header">
                    <span class="title">
                        <i class="bi bi-graph-up"></i> Inventory Overview
                    </span>
                    <span class="badge-custom">Last 30 Days</span>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="inventoryChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Low Stock Alerts -->
            <div class="card">
                <div class="card-header">
                    <span class="title">
                        <i class="bi bi-exclamation-triangle" style="color: var(--danger);"></i> Low Stock Alerts
                    </span>
                   
                </div>
                <div class="card-body" style="padding: 18px 20px;">
                    <div class="stock-item danger">
                        <div class="stock-info">
                            <div class="name">Printer Paper</div>
                            <div class="category">Office Supplies</div>
                        </div>
                        <div class="stock-count">3 Left</div>
                    </div>
                    
                    <div class="stock-item warning">
                        <div class="stock-info">
                            <div class="name">Ink Cartridge</div>
                            <div class="category">Printing Supplies</div>
                        </div>
                        <div class="stock-count">5 Left</div>
                    </div>
                    
                    <div class="stock-item danger">
                        <div class="stock-info">
                            <div class="name">Laptop Bag</div>
                            <div class="category">Accessories</div>
                        </div>
                        <div class="stock-count">2 Left</div>
                    </div>
                    
                    <div class="stock-item warning">
                        <div class="stock-info">
                            <div class="name">USB Cable</div>
                            <div class="category">Electronics</div>
                        </div>
                        <div class="stock-count">4 Left</div>
                    </div>
                    
                    <div style="margin-top: 12px; text-align: center;">
                        <a href="ViewProductsServlet" class="btn btn-outline-primary btn-sm" style="border-radius: var(--radius-sm); font-weight: 500;">
                            View All Low Stock <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Products Table -->
        <div class="card">
            <div class="card-header">
                <span class="title">
                    <i class="bi bi-clock-history"></i> Recent Products
                </span>
                <a href="ViewProductsServlet" style="color: var(--primary); text-decoration: none; font-weight: 500; font-size: 14px;">
                    View All <i class="bi bi-arrow-right"></i>
                </a>
            </div>
            <div class="card-body" style="padding: 0;">
                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Category</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="product-cell">
                                        <div class="product-icon blue">
                                            <i class="bi bi-laptop"></i>
                                        </div>
                                        <div>
                                            <div class="product-name">HP Laptop</div>
                                            <div class="product-sku">SKU: HP-001</div>
                                        </div>
                                    </div>
                                </td>
                                <td>Electronics</td>
                                <td><strong>20</strong> units</td>
                                <td class="price-text">KES 65,000</td>
                                <td><span class="status-badge in-stock">In Stock</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="product-cell">
                                        <div class="product-icon green">
                                            <i class="bi bi-keyboard"></i>
                                        </div>
                                        <div>
                                            <div class="product-name">Keyboard</div>
                                            <div class="product-sku">SKU: KB-001</div>
                                        </div>
                                    </div>
                                </td>
                                <td>Accessories</td>
                                <td><strong>5</strong> units</td>
                                <td class="price-text">KES 1,500</td>
                                <td><span class="status-badge low-stock">Low Stock</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="product-cell">
                                        <div class="product-icon orange">
                                            <i class="bi bi-mouse"></i>
                                        </div>
                                        <div>
                                            <div class="product-name">Wireless Mouse</div>
                                            <div class="product-sku">SKU: MS-001</div>
                                        </div>
                                    </div>
                                </td>
                                <td>Accessories</td>
                                <td><strong>45</strong> units</td>
                                <td class="price-text">KES 900</td>
                                <td><span class="status-badge in-stock">In Stock</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="product-cell">
                                        <div class="product-icon purple">
                                            <i class="bi bi-printer"></i>
                                        </div>
                                        <div>
                                            <div class="product-name">Printer</div>
                                            <div class="product-sku">SKU: PR-001</div>
                                        </div>
                                    </div>
                                </td>
                                <td>Electronics</td>
                                <td><strong>3</strong> units</td>
                                <td class="price-text">KES 12,000</td>
                                <td><span class="status-badge low-stock">Low Stock</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ============================================
    // CHART INITIALIZATION
    // ============================================
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('inventoryChart').getContext('2d');
        
        const gradient = ctx.createLinearGradient(0, 0, 0, 260);
        gradient.addColorStop(0, 'rgba(79, 70, 229, 0.2)');
        gradient.addColorStop(0.5, 'rgba(79, 70, 229, 0.05)');
        gradient.addColorStop(1, 'rgba(79, 70, 229, 0)');
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                datasets: [{
                    label: 'Products Added',
                    data: [8, 15, 12, 22, 18, 30, 25],
                    borderColor: '#4f46e5',
                    backgroundColor: gradient,
                    tension: 0.4,
                    fill: true,
                    borderWidth: 2.5,
                    pointBackgroundColor: '#4f46e5',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6,
                }, {
                    label: 'Products Sold',
                    data: [5, 10, 8, 18, 14, 25, 20],
                    borderColor: '#22c55e',
                    backgroundColor: 'rgba(34, 197, 94, 0.05)',
                    tension: 0.4,
                    fill: false,
                    borderWidth: 2.5,
                    borderDash: [6, 4],
                    pointBackgroundColor: '#22c55e',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        labels: {
                            usePointStyle: true,
                            pointStyle: 'circle',
                            padding: 20,
                            font: {
                                size: 12,
                                weight: '500'
                            },
                            color: '#64748b'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(15, 23, 42, 0.9)',
                        titleColor: '#ffffff',
                        bodyColor: '#e2e8f0',
                        borderColor: 'rgba(255,255,255,0.1)',
                        borderWidth: 1,
                        cornerRadius: 12,
                        padding: 12,
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.parsed.y + ' items';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.04)',
                            drawBorder: false
                        },
                        ticks: {
                            font: {
                                size: 11
                            },
                            color: '#94a3b8',
                            stepSize: 5
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            font: {
                                size: 11
                            },
                            color: '#94a3b8'
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });
    });

    // ============================================
    // SEARCH FUNCTIONALITY
    // ============================================
    document.getElementById('searchInput').addEventListener('keyup', function(e) {
        if (e.key === 'Enter') {
            const searchTerm = this.value.trim();
            if (searchTerm) {
                window.location.href = 'ViewProductsServlet?search=' + encodeURIComponent(searchTerm);
            }
        }
    });

    // ============================================
    // NOTIFICATION BELL
    // ============================================
    document.querySelector('.notification-bell').addEventListener('click', function() {
        console.log('Notifications clicked');
    });

    // ============================================
    // USER PROFILE CLICK
    // ============================================
    document.querySelector('.user-profile').addEventListener('click', function() {
        console.log('User profile clicked');
    });
</script>

</body>
</html>