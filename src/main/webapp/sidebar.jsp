<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .sidebar-wrapper {
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        width: 250px;
        background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
        padding: 0;
        z-index: 1000;
        overflow-y: auto;
        box-shadow: 4px 0 15px rgba(0,0,0,0.2);
    }
    
    .sidebar-wrapper::-webkit-scrollbar { width: 4px; }
    .sidebar-wrapper::-webkit-scrollbar-thumb { background: #475569; border-radius: 10px; }
    
    .sidebar-header {
        padding: 25px 20px 20px 20px;
        text-align: center;
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }
    
    .sidebar-header h3 {
        color: white;
        font-weight: 700;
        margin: 0;
        font-size: 22px;
        letter-spacing: 1px;
    }
    
    .sidebar-header h3 i { color: #3b82f6; margin-right: 8px; }
    .sidebar-header .subtitle { color: #94a3b8; font-size: 12px; margin-top: 4px; letter-spacing: 2px; }
    
    .sidebar-divider {
        border: 0;
        height: 1px;
        background: linear-gradient(to right, transparent, rgba(255,255,255,0.1), transparent);
        margin: 10px 20px;
    }
    
    .sidebar-menu { padding: 10px 12px; }
    
    .menu-item {
        display: flex;
        align-items: center;
        padding: 12px 16px;
        margin-bottom: 4px;
        border-radius: 10px;
        color: #cbd5e1;
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 14px;
        font-weight: 500;
        position: relative;
    }
    
    .menu-item:hover {
        background: rgba(59, 130, 246, 0.15);
        color: white;
        transform: translateX(5px);
    }
    
    .menu-item.active {
        background: rgba(59, 130, 246, 0.2);
        color: white;
    }
    
    .menu-item.active::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 3px;
        height: 60%;
        background: #3b82f6;
        border-radius: 0 4px 4px 0;
    }
    
    .menu-item i {
        margin-right: 12px;
        font-size: 18px;
        width: 22px;
        text-align: center;
        color: #94a3b8;
    }
    
    .menu-item:hover i { color: white; }
    .menu-item.active i { color: #60a5fa; }
    
    .menu-label {
        color: #64748b;
        font-size: 11px;
        letter-spacing: 2px;
        text-transform: uppercase;
        padding: 20px 16px 8px 16px;
        font-weight: 600;
    }
    
    .sidebar-scroll {
        height: calc(100vh - 180px);
        overflow-y: auto;
        padding-bottom: 80px;
    }
    
    .logout-section {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        padding: 20px 12px;
        border-top: 1px solid rgba(255,255,255,0.05);
        background: linear-gradient(180deg, transparent, rgba(15, 23, 42, 0.95));
    }
    
    .logout-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 12px 16px;
        border-radius: 10px;
        background: rgba(239, 68, 68, 0.15);
        color: #fca5a5;
        text-decoration: none;
        transition: all 0.3s ease;
        font-weight: 600;
        font-size: 14px;
        gap: 10px;
    }
    
    .logout-btn:hover {
        background: #ef4444;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3);
    }
    
    .logout-btn i { font-size: 18px; }
</style>

<div class="sidebar-wrapper">
    <div class="sidebar-header">
        <h3><i class="bi bi-box-seam"></i>Inventory</h3>
        <div class="subtitle">MANAGEMENT SYSTEM</div>
    </div>
    
    <hr class="sidebar-divider">
    
    <div class="sidebar-scroll">
        <div class="sidebar-menu">
            <div class="menu-label">Main Menu</div>
            
            <a href="dashboard.jsp" class="menu-item active">
                <i class="bi bi-grid-1x2-fill"></i> Dashboard
            </a>
            <a href="addProduct.jsp" class="menu-item">
                <i class="bi bi-plus-circle"></i> Add Product
            </a>
            <a href="ViewProductsServlet" class="menu-item">
                <i class="bi bi-box-seam"></i> View Products
            </a>
            <a href="CategoryServlet" class="menu-item">
                <i class="bi bi-tags"></i> Categories
            </a>
            <a href="ViewSuppliersServlet" class="menu-item">
                <i class="bi bi-truck"></i> Suppliers
            </a>
            <a href="OrderServlet" class="menu-item">
                <i class="bi bi-cart"></i> Orders
            </a>
            <a href="UserManagementServlet" class="menu-item">
                <i class="bi bi-people"></i>
                Users
            </a>
        </div>
    </div>
    
    <div class="logout-section">
        <a href="LogoutServlet" class="logout-btn">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </div>
</div>