<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

List<Product> products = (List<Product>) request.getAttribute("products");
if(products == null) {
    products = new java.util.ArrayList<Product>();
}

String successMessage = (String) session.getAttribute("successMessage");
String errorMessage = (String) session.getAttribute("errorMessage");
session.removeAttribute("successMessage");
session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>View Products - Inventory Management</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    :root {
        --primary: #4f46e5;
        --success: #22c55e;
        --warning: #f59e0b;
        --danger: #ef4444;
        --gray-200: #f1f5f9;
        --gray-600: #64748b;
        --dark: #0f172a;
        --white: #ffffff;
        --shadow: 0 4px 6px -1px rgba(0,0,0,0.07);
        --radius: 16px;
        --radius-sm: 10px;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
        background: var(--gray-200);
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        min-height: 100vh;
        color: var(--dark);
    }
    
    .page-wrapper { display: flex; min-height: 100vh; }
    
    .main-content {
        flex: 1;
        margin-left: 250px;
        padding: 28px 32px 40px;
        background: var(--gray-200);
        min-height: 100vh;
    }
    
    .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 28px;
        flex-wrap: wrap;
        gap: 16px;
    }
    
    .top-bar h1 {
        font-size: 26px;
        font-weight: 700;
        color: var(--dark);
        margin: 0;
    }
    
    .top-bar h1 span { color: var(--primary); }
    .top-bar p { color: var(--gray-600); font-size: 14px; margin: 4px 0 0 0; }
    
    .top-bar .btn-primary {
        background: var(--primary);
        border: none;
        padding: 10px 24px;
        border-radius: var(--radius-sm);
        font-weight: 600;
        transition: var(--transition);
        text-decoration: none;
        color: white;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .top-bar .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
    }
    
    .search-section {
        background: var(--white);
        padding: 16px 24px;
        border-radius: var(--radius);
        margin-bottom: 24px;
        box-shadow: var(--shadow);
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
        border-radius: var(--radius-sm);
        font-size: 14px;
        transition: var(--transition);
        background: #f8fafc;
        outline: none;
    }
    
    .search-section .search-wrapper input:focus {
        border-color: var(--primary);
        background: white;
        box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
    }
    
    .search-section .btn-search {
        padding: 10px 24px;
        background: var(--primary);
        color: white;
        border: none;
        border-radius: var(--radius-sm);
        font-weight: 500;
        transition: var(--transition);
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .search-section .btn-search:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
    }
    
    .search-section .btn-clear {
        padding: 10px 20px;
        background: #f1f5f9;
        color: #64748b;
        border: 2px solid #e2e8f0;
        border-radius: var(--radius-sm);
        font-weight: 500;
        transition: var(--transition);
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    
    .search-section .btn-clear:hover { background: #e2e8f0; color: #0f172a; }
    
    .card {
        background: var(--white);
        border-radius: var(--radius);
        border: none;
        box-shadow: var(--shadow);
        overflow: hidden;
    }
    
    .card-header {
        background: var(--white);
        border-bottom: 1px solid var(--gray-200);
        padding: 16px 24px;
        font-weight: 600;
        font-size: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .card-header i { color: var(--primary); margin-right: 8px; }
    .card-body { padding: 0; }
    
    .table-wrapper { overflow-x: auto; }
    
    .table {
        margin: 0;
        font-size: 14px;
        width: 100%;
    }
    
    .table thead th {
        background: #f8fafc;
        color: #64748b;
        font-weight: 600;
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
        padding: 14px 18px;
        border-bottom: 2px solid #e2e8f0;
    }
    
    .table tbody td {
        padding: 14px 18px;
        vertical-align: middle;
        border-bottom: 1px solid #f1f5f9;
        color: #0f172a;
    }
    
    .table tbody tr:hover { background: #f8fafc; }
    .table tbody tr:last-child td { border-bottom: none; }
    
    .product-cell {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .product-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        flex-shrink: 0;
    }
    
    .product-icon.blue { background: #eef2ff; color: #4f46e5; }
    .product-icon.green { background: #dcfce7; color: #16a34a; }
    .product-icon.orange { background: #fef3c7; color: #d97706; }
    .product-icon.purple { background: #f3e8ff; color: #7c3aed; }
    
    .product-name-text { font-weight: 500; color: #0f172a; }
    .product-sku { font-size: 12px; color: #94a3b8; }
    
    .badge-status {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }
    
    .badge-status.in-stock { background: #dcfce7; color: #166534; }
    .badge-status.low-stock { background: #fef3c7; color: #92400e; }
    .badge-status.out-of-stock { background: #fee2e2; color: #991b1b; }
    
    .btn-action {
        padding: 6px 12px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 500;
        transition: var(--transition);
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
    
    .empty-state i {
        font-size: 64px;
        color: #cbd5e1;
        margin-bottom: 20px;
    }
    
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
    
    .badge-count {
        background: #eef2ff;
        color: #4f46e5;
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
    }
    
    @media (max-width: 992px) { .main-content { margin-left: 0; } }
    
    @media (max-width: 768px) {
        .main-content { padding: 16px; }
        .top-bar { flex-direction: column; align-items: stretch; }
        .top-bar .btn-primary { text-align: center; justify-content: center; }
        .search-section { flex-direction: column; }
        .search-section .search-wrapper { width: 100%; }
        .search-section .btn-search,
        .search-section .btn-clear { width: 100%; justify-content: center; }
        .table thead th,
        .table tbody td { padding: 10px 12px; font-size: 13px; }
    }
</style>

</head>

<body>

<div class="page-wrapper">
    
    <%@ include file="sidebar.jsp" %>
    
    <div class="main-content">
        
        <div class="top-bar">
            <div>
                <h1>View Products <span>.</span></h1>
                <p><i class="bi bi-circle-fill" style="color: #22c55e; font-size: 10px;"></i> Manage and track all your inventory items</p>
            </div>
            <div>
                <a href="addProduct.jsp" class="btn-primary">
                    <i class="bi bi-plus-circle"></i> Add Product
                </a>
            </div>
        </div>
        
        <!-- Alerts -->
        <%
        if(successMessage != null) {
        %>
        <div class="alert alert-success">
            <i class="bi bi-check-circle-fill"></i>
            <%= successMessage %>
        </div>
        <%
        }
        if(errorMessage != null) {
        %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-circle-fill"></i>
            <%= errorMessage %>
        </div>
        <%
        }
        %>
        
        <!-- Search -->
        <div class="search-section">
            <form action="ViewProductsServlet" method="get" style="display: flex; gap: 12px; flex: 1; flex-wrap: wrap;">
                <div class="search-wrapper">
                    <span class="search-icon"><i class="bi bi-search"></i></span>
                    <input 
                        type="text" 
                        name="search" 
                        placeholder="Search products by name, category, or SKU..."
                        value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
                    >
                </div>
                <button type="submit" class="btn-search">
                    <i class="bi bi-search"></i> Search
                </button>
                <a href="ViewProductsServlet" class="btn-clear">
                    <i class="bi bi-x-circle"></i> Clear
                </a>
            </form>
        </div>
        
        <!-- Products Table -->
        <div class="card">
            <div class="card-header">
                <span><i class="bi bi-list-ul"></i> Product List</span>
                <span class="badge-count"><%= products.size() %> Products</span>
            </div>
            <div class="card-body">
                <div class="table-wrapper">
                    <%
                    if(products.isEmpty()) {
                    %>
                    <div class="empty-state">
                        <i class="bi bi-box-seam"></i>
                        <h5>No Products Found</h5>
                        <p>Start by adding your first product to inventory.</p>
                        <a href="addProduct.jsp" class="btn btn-primary" style="background: var(--primary); border: none; padding: 10px 24px; border-radius: var(--radius-sm); color: white; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                            <i class="bi bi-plus-circle"></i> Add Product
                        </a>
                    </div>
                    <%
                    } else {
                    %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Category</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            String[] colors = {"blue", "green", "orange", "purple"};
                            String[] icons = {"bi bi-laptop", "bi bi-box", "bi bi-tag", "bi bi-archive"};
                            int index = 0;
                            
                            for(Product p : products) {
                                String color = colors[index % colors.length];
                                String icon = icons[index % icons.length];
                                index++;
                                
                                String statusClass = "";
                                String statusText = "";
                                if(p.getQuantity() <= 0) {
                                    statusClass = "out-of-stock";
                                    statusText = "Out of Stock";
                                } else if(p.getQuantity() <= 5) {
                                    statusClass = "low-stock";
                                    statusText = "Low Stock";
                                } else {
                                    statusClass = "in-stock";
                                    statusText = "In Stock";
                                }
                            %>
                            <tr>
                                <td>
                                    <div class="product-cell">
                                        <div class="product-icon <%= color %>">
                                            <i class="<%= icon %>"></i>
                                        </div>
                                        <div>
                                            <div class="product-name-text"><%= p.getProductName() %></div>
                                            <div class="product-sku">SKU: #<%= p.getId() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-light text-dark"><%= p.getCategory() %></span></td>
                                <td><strong><%= p.getQuantity() %></strong> units</td>
                                <td class="fw-semibold">KES <%= String.format("%.2f", p.getPrice()) %></td>
                                <td><span class="badge-status <%= statusClass %>"><%= statusText %></span></td>
                                <td>
                                    <div class="action-group">
                                        <a href="EditProductServlet?id=<%= p.getId() %>" class="btn-action btn-edit">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a href="DeleteProductServlet?id=<%= p.getId() %>" 
                                           class="btn-action btn-delete"
                                           onclick="return confirm('Are you sure you want to delete \'<%= p.getProductName() %>\'?');">
                                            <i class="bi bi-trash"></i> Delete
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
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>