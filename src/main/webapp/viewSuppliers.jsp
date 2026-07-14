<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Supplier" %>
<%@ page import="model.User" %>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

// Get suppliers from request attribute
List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");

// If suppliers is null, create empty list - NO REDIRECT
if(suppliers == null) {
    suppliers = new java.util.ArrayList<Supplier>();
    System.out.println("Suppliers is null, creating empty list");
}

String successMessage = (String) session.getAttribute("successMessage");
String errorMessage = (String) session.getAttribute("errorMessage");
session.removeAttribute("successMessage");
session.removeAttribute("errorMessage");

System.out.println("Suppliers in JSP: " + suppliers.size());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>View Suppliers - Inventory Management</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
        background: #f1f5f9;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        min-height: 100vh;
    }
    
    .page-wrapper { display: flex; min-height: 100vh; }
    
    .main-content {
        flex: 1;
        margin-left: 250px;
        padding: 30px;
        background: #f1f5f9;
    }
    
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: white;
        padding: 20px 25px;
        border-radius: 15px;
        margin-bottom: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        flex-wrap: wrap;
        gap: 15px;
    }
    
    .page-header .header-left h2 {
        font-weight: 700;
        color: #0f172a;
        margin: 0;
        font-size: 24px;
    }
    
    .page-header .header-left h2 i { color: #3b82f6; margin-right: 10px; }
    .page-header .header-left p { color: #64748b; margin: 4px 0 0 0; font-size: 14px; }
    
    .page-header .header-actions { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; }
    
    .page-header .header-actions .btn {
        padding: 10px 20px;
        border-radius: 10px;
        font-weight: 500;
        font-size: 14px;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .page-header .header-actions .btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.12); }
    .page-header .header-actions .btn-primary { background: #3b82f6; border: none; }
    .page-header .header-actions .btn-primary:hover { background: #2563eb; }
    .page-header .header-actions .btn-success { background: #22c55e; border: none; }
    .page-header .header-actions .btn-success:hover { background: #16a34a; }
    
    .badge-count {
        background: #eef2ff;
        color: #4f46e5;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 500;
    }
    
    .search-section {
        background: white;
        padding: 18px 25px;
        border-radius: 15px;
        margin-bottom: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        display: flex;
        gap: 12px;
        align-items: center;
        flex-wrap: wrap;
    }
    
    .search-section .search-wrapper {
        flex: 1;
        position: relative;
        min-width: 200px;
    }
    
    .search-section .search-wrapper .search-icon {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: #94a3b8;
        font-size: 18px;
    }
    
    .search-section .search-wrapper input {
        width: 100%;
        padding: 10px 16px 10px 44px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 14px;
        transition: all 0.3s ease;
        background: #f8fafc;
    }
    
    .search-section .search-wrapper input:focus {
        outline: none;
        border-color: #3b82f6;
        background: white;
        box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
    }
    
    .search-section .btn-search {
        padding: 10px 24px;
        background: #3b82f6;
        color: white;
        border: none;
        border-radius: 10px;
        font-weight: 500;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .search-section .btn-search:hover {
        background: #2563eb;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }
    
    .search-section .btn-clear {
        padding: 10px 20px;
        background: #f1f5f9;
        color: #64748b;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    
    .search-section .btn-clear:hover { background: #e2e8f0; color: #0f172a; }
    
    .table-card {
        background: white;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
    }
    
    .table-card .table-header {
        padding: 18px 24px;
        border-bottom: 1px solid #f1f5f9;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 10px;
    }
    
    .table-card .table-header .title {
        font-weight: 600;
        color: #0f172a;
        font-size: 16px;
    }
    
    .table-card .table-header .title i { color: #3b82f6; margin-right: 8px; }
    
    .table { margin-bottom: 0; }
    
    .table thead th {
        background: #f8fafc;
        color: #475569;
        font-weight: 600;
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
        border-bottom: 2px solid #e2e8f0;
        padding: 14px 18px;
        white-space: nowrap;
    }
    
    .table tbody td {
        padding: 14px 18px;
        vertical-align: middle;
        border-bottom: 1px solid #f1f5f9;
        color: #0f172a;
        font-size: 14px;
    }
    
    .table tbody tr:hover { background: #f8fafc; }
    .table tbody tr:last-child td { border-bottom: none; }
    
    .supplier-info { display: flex; align-items: center; gap: 12px; }
    
    .supplier-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        flex-shrink: 0;
    }
    
    .supplier-icon.blue { background: #eef2ff; color: #4f46e5; }
    .supplier-icon.green { background: #dcfce7; color: #16a34a; }
    .supplier-icon.orange { background: #fef3c7; color: #d97706; }
    .supplier-icon.purple { background: #f3e8ff; color: #7c3aed; }
    
    .supplier-name-text { font-weight: 500; color: #0f172a; }
    .supplier-contact { font-size: 12px; color: #94a3b8; }
    
    .badge-status {
        padding: 4px 12px;
        border-radius: 12px;
        font-weight: 500;
        font-size: 12px;
        display: inline-block;
    }
    
    .badge-status.active { background: #dcfce7; color: #166534; }
    .badge-status.inactive { background: #fee2e2; color: #991b1b; }
    
    .btn-action {
        padding: 6px 12px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        text-decoration: none;
        cursor: pointer;
    }
    
    .btn-action:hover { transform: translateY(-2px); }
    
    .btn-edit { background: #eef2ff; color: #4f46e5; }
    .btn-edit:hover { background: #4f46e5; color: white; }
    .btn-delete { background: #fee2e2; color: #ef4444; }
    .btn-delete:hover { background: #ef4444; color: white; }
    
    .action-group { display: flex; gap: 6px; flex-wrap: wrap; }
    
    .empty-state {
        text-align: center;
        padding: 60px 20px;
    }
    
    .empty-state i { font-size: 64px; color: #cbd5e1; margin-bottom: 20px; }
    .empty-state h5 { color: #0f172a; font-weight: 600; margin-bottom: 8px; }
    .empty-state p { color: #94a3b8; font-size: 14px; margin-bottom: 20px; }
    
    .alert {
        padding: 14px 18px;
        border-radius: 12px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
    }
    
    .alert-success { background: #dcfce7; color: #166534; border-left: 4px solid #22c55e; }
    .alert-danger { background: #fee2e2; color: #991b1b; border-left: 4px solid #ef4444; }
    .alert i { font-size: 20px; }
    
    .toast-container {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        max-width: 350px;
    }
    
    .toast {
        background: white;
        border-radius: 12px;
        padding: 16px 20px;
        margin-bottom: 10px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.15);
        display: flex;
        align-items: center;
        gap: 12px;
        animation: slideIn 0.5s ease;
        border-left: 4px solid #22c55e;
    }
    
    .toast.error { border-left-color: #ef4444; }
    .toast i { font-size: 24px; }
    .toast .toast-message { flex: 1; font-size: 14px; color: #0f172a; }
    .toast .toast-close {
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: #94a3b8;
    }
    
    @keyframes slideIn {
        from { opacity: 0; transform: translateX(100px); }
        to { opacity: 1; transform: translateX(0); }
    }
    
    @media (max-width: 992px) { .main-content { margin-left: 0; } }
    
    @media (max-width: 768px) {
        .main-content { padding: 15px; }
        .page-header { flex-direction: column; text-align: center; }
        .page-header .header-actions { justify-content: center; width: 100%; }
        .search-section { flex-direction: column; }
        .search-section .search-wrapper { width: 100%; }
        .search-section .btn-search,
        .search-section .btn-clear { width: 100%; justify-content: center; }
    }
</style>

</head>

<body>

<div class="page-wrapper">
    
    <%@ include file="sidebar.jsp" %>
    
    <div class="main-content">
        
        <!-- Toast Container -->
        <div class="toast-container" id="toastContainer">
            <%
            if(successMessage != null && !successMessage.isEmpty()) {
            %>
            <div class="toast" id="successToast">
                <i class="bi bi-check-circle-fill" style="color: #22c55e;"></i>
                <span class="toast-message"><%= successMessage %></span>
                <button class="toast-close" onclick="this.parentElement.remove()">×</button>
            </div>
            <%
            }
            if(errorMessage != null && !errorMessage.isEmpty()) {
            %>
            <div class="toast error" id="errorToast">
                <i class="bi bi-exclamation-circle-fill" style="color: #ef4444;"></i>
                <span class="toast-message"><%= errorMessage %></span>
                <button class="toast-close" onclick="this.parentElement.remove()">×</button>
            </div>
            <%
            }
            %>
        </div>
        
        <div class="page-header">
            <div class="header-left">
                <h2><i class="bi bi-truck"></i> View Suppliers</h2>
                <p>Manage and track all your suppliers</p>
            </div>
            <div class="header-actions">
                <span class="badge-count">
                    <i class="bi bi-truck"></i>
                    Total: <strong><%= suppliers.size() %></strong> Suppliers
                </span>
                <a href="addSupplier.jsp" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i>
                    Add Supplier
                </a>
                <a href="dashboard.jsp" class="btn btn-success">
                    <i class="bi bi-grid-1x2-fill"></i>
                    Dashboard
                </a>
            </div>
        </div>
        
        <div class="search-section">
            <form action="ViewSuppliersServlet" method="get" style="display: flex; gap: 12px; flex: 1; flex-wrap: wrap;">
                <div class="search-wrapper">
                    <span class="search-icon"><i class="bi bi-search"></i></span>
                    <input 
                        type="text" 
                        name="keyword" 
                        placeholder="Search suppliers by name, contact, email..."
                        value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>"
                    >
                </div>
                <button type="submit" class="btn-search">
                    <i class="bi bi-search"></i>
                    Search
                </button>
                <a href="ViewSuppliersServlet" class="btn-clear">
                    <i class="bi bi-x-circle"></i>
                    Clear
                </a>
            </form>
        </div>
        
        <div class="table-card">
            <div class="table-header">
                <div class="title">
                    <i class="bi bi-list-ul"></i>
                    Supplier List
                </div>
            </div>
            
            <div class="table-responsive">
                
                <%
                if(suppliers.isEmpty()) {
                %>
                <div class="empty-state">
                    <i class="bi bi-truck"></i>
                    <h5>No Suppliers Found</h5>
                    <p>Start by adding your first supplier to the system.</p>
                    <a href="addSupplier.jsp" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i>
                        Add Supplier
                    </a>
                </div>
                <%
                } else {
                %>
                
                <table class="table">
                    <thead>
                        <tr>
                            <th>Supplier</th>
                            <th>Contact</th>
                            <th>Email / Phone</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        String[] colors = {"blue", "green", "orange", "purple"};
                        int colorIndex = 0;
                        
                        for(Supplier s : suppliers) {
                            String color = colors[colorIndex % colors.length];
                            colorIndex++;
                        %>
                        <tr>
                            <td>
                                <div class="supplier-info">
                                    <div class="supplier-icon <%= color %>">
                                        <i class="bi bi-building"></i>
                                    </div>
                                    <div>
                                        <div class="supplier-name-text"><%= s.getSupplierName() %></div>
                                        <div class="supplier-contact">ID: #<%= s.getId() %></div>
                                    </div>
                                </div>
                            </td>
                            <td><%= s.getContactPerson() != null && !s.getContactPerson().isEmpty() ? s.getContactPerson() : "N/A" %></td>
                            <td>
                                <div><small><i class="bi bi-envelope"></i> <%= s.getEmail() != null && !s.getEmail().isEmpty() ? s.getEmail() : "N/A" %></small></div>
                                <div><small><i class="bi bi-phone"></i> <%= s.getPhone() != null && !s.getPhone().isEmpty() ? s.getPhone() : "N/A" %></small></div>
                            </td>
                            <td>
                                <span class="badge bg-light text-dark">
                                    <i class="bi bi-tags"></i>
                                    <%= s.getCategory() != null && !s.getCategory().isEmpty() ? s.getCategory() : "General" %>
                                </span>
                            </td>
                            <td>
                                <span class="badge-status <%= s.getStatus().toLowerCase() %>">
                                    <i class="bi <%= s.getStatus().equals("Active") ? "bi-check-circle" : "bi-x-circle" %>"></i>
                                    <%= s.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <div class="action-group">
                                    <a href="EditSupplierServlet?id=<%= s.getId() %>" class="btn-action btn-edit">
                                        <i class="bi bi-pencil"></i>
                                        Edit
                                    </a>
                                    <a href="DeleteSupplierServlet?id=<%= s.getId() %>" 
                                       class="btn-action btn-delete"
                                       onclick="return confirm('Are you sure you want to delete \'<%= s.getSupplierName() %>\'? This action cannot be undone.');">
                                        <i class="bi bi-trash"></i>
                                        Delete
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
                
                <%
                }
                %>
                
            </div>
        </div>
        
    </div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-dismiss toast notifications after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const toasts = document.querySelectorAll('.toast');
        toasts.forEach(function(toast) {
            setTimeout(function() {
                if(toast) {
                    toast.style.opacity = '0';
                    toast.style.transform = 'translateX(100px)';
                    setTimeout(function() {
                        if(toast) toast.remove();
                    }, 500);
                }
            }, 5000);
        });
    });
</script>

</body>
</html>