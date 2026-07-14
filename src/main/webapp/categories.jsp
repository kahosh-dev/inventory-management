<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="java.util.*" %>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

// Get categories from request attribute
List<String> categories = (List<String>) request.getAttribute("categories");
List<String[]> categoriesWithIds = (List<String[]>) request.getAttribute("categoriesWithIds");

if(categories == null) {
    categories = new ArrayList<String>();
}
if(categoriesWithIds == null) {
    categoriesWithIds = new ArrayList<String[]>();
}

// Get messages from session
String successMessage = (String) session.getAttribute("successMessage");
String errorMessage = (String) session.getAttribute("errorMessage");

// Clear session messages
session.removeAttribute("successMessage");
session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Categories - Inventory Management</title>

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
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        flex-wrap: wrap;
        gap: 15px;
    }
    
    .page-header h2 {
        font-weight: 700;
        color: #0f172a;
        margin: 0;
        font-size: 24px;
    }
    
    .page-header h2 i { color: #3b82f6; margin-right: 10px; }
    .page-header p { color: #64748b; margin: 4px 0 0 0; font-size: 14px; }
    
    .page-header .header-stats {
        display: flex;
        gap: 20px;
        align-items: center;
        flex-wrap: wrap;
    }
    
    .page-header .stat-badge {
        background: #eef2ff;
        color: #4f46e5;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
    }
    
    .page-header .stat-badge i { margin-right: 6px; }
    
    .content-grid {
        display: grid;
        grid-template-columns: 1fr 1.5fr;
        gap: 25px;
    }
    
    .card {
        background: white;
        border-radius: 15px;
        border: none;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
        transition: all 0.3s ease;
    }
    
    .card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
    
    .card-header {
        background: white;
        border-bottom: 1px solid #f1f5f9;
        padding: 18px 24px;
        font-weight: 600;
        color: #0f172a;
        font-size: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .card-header i { color: #3b82f6; margin-right: 8px; }
    
    .card-header .badge-count {
        background: #f1f5f9;
        color: #475569;
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
    }
    
    .card-body { padding: 24px; }
    .card-body.p-0 { padding: 0; }
    
    .form-group { margin-bottom: 20px; }
    
    .form-group label {
        display: block;
        font-weight: 600;
        color: #1e293b;
        font-size: 14px;
        margin-bottom: 6px;
    }
    
    .form-group label i { color: #3b82f6; margin-right: 6px; }
    .form-group .required { color: #ef4444; }
    
    .input-group-custom { position: relative; }
    
    .input-group-custom .input-icon {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: #94a3b8;
        font-size: 18px;
        z-index: 1;
    }
    
    .input-group-custom .form-control { padding-left: 44px; }
    
    .form-control {
        width: 100%;
        padding: 12px 16px;
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        font-size: 14px;
        transition: all 0.3s ease;
        background: #f8fafc;
        color: #0f172a;
    }
    
    .form-control:focus {
        outline: none;
        border-color: #3b82f6;
        background: white;
        box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
    }
    
    .form-control::placeholder { color: #94a3b8; font-size: 13px; }
    
    .btn-submit {
        width: 100%;
        padding: 12px;
        background: linear-gradient(135deg, #2563eb, #4f46e5);
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }
    
    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
    }
    
    .btn-action {
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        cursor: pointer;
        text-decoration: none;
    }
    
    .btn-action:hover { transform: translateY(-2px); }
    
    .btn-edit { background: #eef2ff; color: #4f46e5; }
    .btn-edit:hover { background: #4f46e5; color: white; }
    .btn-delete { background: #fee2e2; color: #ef4444; }
    .btn-delete:hover { background: #ef4444; color: white; }
    
    .table { margin-bottom: 0; }
    
    .table thead th {
        background: #f8fafc;
        color: #475569;
        font-weight: 600;
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
        border-bottom: 2px solid #e2e8f0;
        padding: 12px 16px;
    }
    
    .table tbody td {
        padding: 12px 16px;
        vertical-align: middle;
        border-bottom: 1px solid #f1f5f9;
        color: #0f172a;
        font-size: 14px;
    }
    
    .table tbody tr:hover { background: #f8fafc; }
    .table tbody tr:last-child td { border-bottom: none; }
    
    .category-info {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .category-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        flex-shrink: 0;
    }
    
    .category-icon.blue { background: #eef2ff; color: #4f46e5; }
    .category-icon.green { background: #dcfce7; color: #16a34a; }
    .category-icon.orange { background: #fef3c7; color: #d97706; }
    .category-icon.purple { background: #f3e8ff; color: #7c3aed; }
    .category-icon.red { background: #fee2e2; color: #dc2626; }
    
    .category-name { font-weight: 500; color: #0f172a; }
    .category-count { font-size: 13px; color: #64748b; }
    
    .empty-state {
        text-align: center;
        padding: 40px 20px;
    }
    
    .empty-state i {
        font-size: 48px;
        color: #cbd5e1;
        margin-bottom: 15px;
    }
    
    .empty-state h5 { color: #0f172a; font-weight: 600; margin-bottom: 8px; }
    .empty-state p { color: #94a3b8; font-size: 14px; margin: 0; }
    
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
        transition: color 0.3s ease;
    }
    
    .toast .toast-close:hover { color: #0f172a; }
    
    @keyframes slideIn {
        from { opacity: 0; transform: translateX(100px); }
        to { opacity: 1; transform: translateX(0); }
    }
    
    @media (max-width: 1200px) { .content-grid { grid-template-columns: 1fr; } }
    @media (max-width: 992px) { .main-content { margin-left: 0; } }
    
    @media (max-width: 768px) {
        .page-header { flex-direction: column; text-align: center; }
        .page-header .header-stats { justify-content: center; }
        .main-content { padding: 15px; }
        .card-body { padding: 16px; }
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
            <div>
                <h2><i class="bi bi-tags"></i> Categories</h2>
                <p>Manage your product categories</p>
            </div>
            <div class="header-stats">
                <span class="stat-badge">
                    <i class="bi bi-folder"></i>
                    Total: <strong><%= categories.size() %></strong> Categories
                </span>
                <a href="dashboard.jsp" class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
            </div>
        </div>
        
        <div class="content-grid">
            
            <!-- Add Category Form -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-plus-circle"></i> Add New Category</span>
                </div>
                <div class="card-body">
                    
                    <form action="CategoryServlet" method="post" id="categoryForm">
                        <div class="form-group">
                            <label>
                                <i class="bi bi-folder"></i> Category Name
                                <span class="required">*</span>
                            </label>
                            <div class="input-group-custom">
                                <span class="input-icon"><i class="bi bi-tag"></i></span>
                                <input 
                                    type="text" 
                                    name="categoryName" 
                                    id="categoryName"
                                    class="form-control" 
                                    placeholder="Enter category name (e.g., Electronics)"
                                    required
                                    autofocus
                                >
                            </div>
                            <small class="text-muted" style="display: block; margin-top: 5px;">
                                <i class="bi bi-info-circle"></i> Category name must be unique
                            </small>
                        </div>
                        
                        <button type="submit" class="btn-submit" id="saveBtn">
                            <i class="bi bi-plus-circle"></i>
                            Save Category
                        </button>
                    </form>
                </div>
            </div>
            
            <!-- Categories List -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-list-ul"></i> Categories List</span>
                    <span class="badge-count"><%= categories.size() %> Items</span>
                </div>
                <div class="card-body p-0">
                    
                    <%
                    if(categories.isEmpty()) {
                    %>
                    <div class="empty-state">
                        <i class="bi bi-folder-open"></i>
                        <h5>No Categories Found</h5>
                        <p>Start by adding your first category using the form.</p>
                    </div>
                    <%
                    } else {
                    %>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                String[] colors = {"blue", "green", "orange", "purple", "red"};
                                String[] icons = {"bi bi-laptop", "bi bi-box", "bi bi-tag", "bi bi-folder", "bi bi-archive"};
                                int index = 0;
                                
                                if(categoriesWithIds != null && !categoriesWithIds.isEmpty()) {
                                    for(String[] categoryData : categoriesWithIds) {
                                        String catId = categoryData[0];
                                        String categoryName = categoryData[1];
                                        String color = colors[index % colors.length];
                                        String icon = icons[index % icons.length];
                                        index++;
                                %>
                                <tr>
                                    <td>
                                        <div class="category-info">
                                            <div class="category-icon <%= color %>">
                                                <i class="<%= icon %>"></i>
                                            </div>
                                            <div>
                                                <div class="category-name"><%= categoryName %></div>
                                                <div class="category-count">ID: #<%= catId %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="EditCategoryServlet?id=<%= catId %>" class="btn-action btn-edit">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a href="DeleteCategoryServlet?id=<%= catId %>" 
                                           class="btn-action btn-delete"
                                           onclick="return confirm('Are you sure you want to delete category "<%= categoryName %>"? This action cannot be undone.');">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                    for(String category : categories) {
                                        String color = colors[index % colors.length];
                                        String icon = icons[index % icons.length];
                                        int catId = index + 1;
                                        index++;
                                %>
                                <tr>
                                    <td>
                                        <div class="category-info">
                                            <div class="category-icon <%= color %>">
                                                <i class="<%= icon %>"></i>
                                            </div>
                                            <div>
                                                <div class="category-name"><%= category %></div>
                                                <div class="category-count">ID: #<%= catId %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="EditCategoryServlet?id=<%= catId %>" class="btn-action btn-edit">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a href="DeleteCategoryServlet?id=<%= catId %>" 
                                           class="btn-action btn-delete"
                                           onclick="return confirm('Are you sure you want to delete category "<%= category %>"? This action cannot be undone.');">
                                            <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                                <%
                                    }
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <%
                    }
                    %>
                    
                </div>
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
    
    // Form submission with loading state
    document.getElementById('categoryForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('saveBtn');
        const originalText = btn.innerHTML;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
        btn.disabled = true;
        
        setTimeout(function() {
            btn.innerHTML = originalText;
            btn.disabled = false;
        }, 10000);
    });
    
    // Enter key to submit form
    document.getElementById('categoryName').addEventListener('keypress', function(e) {
        if(e.key === 'Enter') {
            e.preventDefault();
            document.getElementById('categoryForm').submit();
        }
    });
</script>

</body>
</html>