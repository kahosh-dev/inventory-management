<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="model.Product"%>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

Product p = (Product) request.getAttribute("product");

if(p == null) {
    response.sendRedirect("ViewProductsServlet");
    return;
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Edit Product - Inventory Management</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    /* Reset and Base */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        background: #f1f5f9;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        min-height: 100vh;
    }
    
    /* Main Container */
    .page-wrapper {
        display: flex;
        min-height: 100vh;
    }
    
    .main-content {
        flex: 1;
        margin-left: 250px;
        padding: 30px;
        background: #f1f5f9;
    }
    
    /* Page Header */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: white;
        padding: 20px 25px;
        border-radius: 15px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .page-header h2 {
        font-weight: 700;
        color: #0f172a;
        margin: 0;
        font-size: 24px;
    }
    
    .page-header h2 i {
        color: #3b82f6;
        margin-right: 10px;
    }
    
    .page-header p {
        color: #64748b;
        margin: 4px 0 0 0;
        font-size: 14px;
    }
    
    .page-header .product-id-badge {
        background: #eef2ff;
        color: #4f46e5;
        padding: 8px 18px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
    }
    
    .page-header .product-id-badge i {
        margin-right: 6px;
    }
    
    /* Form Card */
    .form-card {
        max-width: 700px;
        background: white;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
        margin: 0 auto;
    }
    
    .form-card .card-header {
        background: white;
        border-bottom: 1px solid #f1f5f9;
        padding: 20px 28px;
        font-weight: 600;
        color: #0f172a;
        font-size: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .form-card .card-header i {
        color: #3b82f6;
        margin-right: 8px;
    }
    
    .form-card .card-body {
        padding: 28px;
    }
    
    /* Form Styles */
    .form-group {
        margin-bottom: 22px;
    }
    
    .form-group label {
        display: block;
        font-weight: 600;
        color: #1e293b;
        font-size: 14px;
        margin-bottom: 6px;
    }
    
    .form-group label i {
        color: #3b82f6;
        margin-right: 6px;
        width: 20px;
    }
    
    .form-group .required {
        color: #ef4444;
    }
    
    .form-group .field-hint {
        font-size: 12px;
        color: #94a3b8;
        margin-top: 4px;
        font-weight: 400;
    }
    
    .input-group-custom {
        position: relative;
    }
    
    .input-group-custom .input-icon {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: #94a3b8;
        font-size: 18px;
        z-index: 1;
    }
    
    .input-group-custom .form-control {
        padding-left: 44px;
    }
    
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
    
    .form-control:hover {
        border-color: #94a3b8;
    }
    
    .form-control::placeholder {
        color: #94a3b8;
        font-size: 13px;
    }
    
    .form-control:disabled {
        background: #f1f5f9;
        cursor: not-allowed;
    }
    
    /* Form Row for side-by-side fields */
    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }
    
    /* Buttons */
    .btn-submit {
        width: 100%;
        padding: 14px;
        background: linear-gradient(135deg, #2563eb, #4f46e5);
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        margin-top: 10px;
    }
    
    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
    }
    
    .btn-submit:active {
        transform: translateY(0);
    }
    
    .btn-submit i {
        font-size: 18px;
    }
    
    .btn-cancel {
        width: 100%;
        padding: 12px;
        background: #f1f5f9;
        color: #475569;
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        font-size: 15px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        text-decoration: none;
        margin-top: 10px;
    }
    
    .btn-cancel:hover {
        background: #e2e8f0;
        color: #0f172a;
        transform: translateY(-2px);
    }
    
    .btn-group-actions {
        display: flex;
        gap: 12px;
    }
    
    .btn-group-actions .btn-cancel {
        width: auto;
        padding: 12px 30px;
        margin-top: 0;
    }
    
    /* Alert Messages */
    .alert {
        padding: 14px 18px;
        border-radius: 12px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
    }
    
    .alert-success {
        background: #dcfce7;
        color: #166534;
        border-left: 4px solid #22c55e;
    }
    
    .alert-danger {
        background: #fee2e2;
        color: #991b1b;
        border-left: 4px solid #ef4444;
    }
    
    .alert i {
        font-size: 20px;
    }
    
    /* Product Preview */
    .product-preview {
        background: #f8fafc;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 25px;
        border: 1px dashed #e2e8f0;
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .product-preview .preview-icon {
        width: 50px;
        height: 50px;
        background: linear-gradient(135deg, #eef2ff, #e0e7ff);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: #4f46e5;
        flex-shrink: 0;
    }
    
    .product-preview .preview-info {
        flex: 1;
    }
    
    .product-preview .preview-info .name {
        font-weight: 600;
        color: #0f172a;
        font-size: 16px;
    }
    
    .product-preview .preview-info .details {
        font-size: 13px;
        color: #64748b;
    }
    
    /* Responsive */
    @media (max-width: 1200px) {
        .main-content {
            margin-left: 0;
        }
    }
    
    @media (max-width: 768px) {
        .main-content {
            padding: 15px;
        }
        
        .page-header {
            flex-direction: column;
            text-align: center;
            gap: 12px;
        }
        
        .form-row {
            grid-template-columns: 1fr;
        }
        
        .form-card .card-body {
            padding: 20px;
        }
        
        .btn-group-actions {
            flex-direction: column;
        }
        
        .btn-group-actions .btn-cancel {
            width: 100%;
        }
        
        .product-preview {
            flex-direction: column;
            text-align: center;
        }
    }
</style>

</head>

<body>

<div class="page-wrapper">
    
    <!-- Include Sidebar -->
    <%@ include file="sidebar.jsp" %>
    
    <!-- Main Content -->
    <div class="main-content">
        
        <!-- Page Header -->
        <div class="page-header">
            <div>
                <h2><i class="bi bi-pencil-square"></i> Edit Product</h2>
                <p>Update product information</p>
            </div>
            <div class="product-id-badge">
                <i class="bi bi-hash"></i>
                Product ID: <%= p.getId() %>
            </div>
        </div>
        
        <!-- Form Card -->
        <div class="form-card">
            <div class="card-header">
                <span><i class="bi bi-box-seam"></i> Product Details</span>
                <span class="badge bg-primary rounded-pill">Edit Mode</span>
            </div>
            <div class="card-body">
                
                <!-- Display Messages -->
                <%
                String message = (String) request.getAttribute("message");
                String error = (String) request.getAttribute("error");
                
                if(message != null) {
                %>
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill"></i>
                    <%= message %>
                </div>
                <%
                }
                if(error != null) {
                %>
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <%= error %>
                </div>
                <%
                }
                %>
                
                <!-- Product Preview -->
                <div class="product-preview">
                    <div class="preview-icon">
                        <i class="bi bi-box"></i>
                    </div>
                    <div class="preview-info">
                        <div class="name"><%= p.getProductName() %></div>
                        <div class="details">
                            <i class="bi bi-tags"></i> <%= p.getCategory() %> &nbsp;|&nbsp;
                            <i class="bi bi-cash"></i> KES <%= String.format("%.2f", p.getPrice()) %> &nbsp;|&nbsp;
                            <i class="bi bi-hash"></i> <%= p.getQuantity() %> units
                        </div>
                    </div>
                </div>
                
                <!-- Edit Form -->
                <form action="UpdateProductServlet" method="post">
                    
                    <!-- Hidden ID -->
                    <input type="hidden" name="id" value="<%= p.getId() %>">
                    
                    <!-- Product Name -->
                    <div class="form-group">
                        <label>
                            <i class="bi bi-box"></i> Product Name
                            <span class="required">*</span>
                        </label>
                        <div class="input-group-custom">
                            <span class="input-icon"><i class="bi bi-pencil"></i></span>
                            <input 
                                type="text" 
                                name="productName" 
                                class="form-control" 
                                value="<%= p.getProductName() %>"
                                placeholder="Enter product name"
                                required
                            >
                        </div>
                    </div>
                    
                    <!-- Category -->
                    <div class="form-group">
                        <label>
                            <i class="bi bi-tags"></i> Category
                            <span class="required">*</span>
                        </label>
                        <div class="input-group-custom">
                            <span class="input-icon"><i class="bi bi-folder"></i></span>
                            <input 
                                type="text" 
                                name="category" 
                                class="form-control" 
                                value="<%= p.getCategory() %>"
                                placeholder="Enter category (e.g., Electronics)"
                                required
                            >
                        </div>
                    </div>
                    
                    <!-- Row: Quantity & Price -->
                    <div class="form-row">
                        <!-- Quantity -->
                        <div class="form-group">
                            <label>
                                <i class="bi bi-hash"></i> Quantity
                                <span class="required">*</span>
                            </label>
                            <div class="input-group-custom">
                                <span class="input-icon"><i class="bi bi-sort-numeric-up"></i></span>
                                <input 
                                    type="number" 
                                    name="quantity" 
                                    class="form-control" 
                                    value="<%= p.getQuantity() %>"
                                    min="0"
                                    step="1"
                                    placeholder="Enter quantity"
                                    required
                                >
                            </div>
                            <div class="field-hint">
                                <i class="bi bi-info-circle"></i> Current stock: <%= p.getQuantity() %> units
                            </div>
                        </div>
                        
                        <!-- Price -->
                        <div class="form-group">
                            <label>
                                <i class="bi bi-currency-dollar"></i> Price
                                <span class="required">*</span>
                            </label>
                            <div class="input-group-custom">
                                <span class="input-icon"><i class="bi bi-cash"></i></span>
                                <input 
                                    type="number" 
                                    step="0.01" 
                                    min="0.01"
                                    name="price" 
                                    class="form-control" 
                                    value="<%= p.getPrice() %>"
                                    placeholder="Enter price"
                                    required
                                >
                            </div>
                            <div class="field-hint">
                                <i class="bi bi-info-circle"></i> Current price: KES <%= String.format("%.2f", p.getPrice()) %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="btn-group-actions">
                        <button type="submit" class="btn-submit">
                            <i class="bi bi-check-circle"></i>
                            Update Product
                        </button>
                        
                        <a href="ViewProductsServlet" class="btn-cancel">
                            <i class="bi bi-x-circle"></i>
                            Cancel
                        </a>
                    </div>
                    
                </form>
                
            </div>
        </div>
        
    </div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-focus first input field
    document.addEventListener('DOMContentLoaded', function() {
        const firstInput = document.querySelector('input[name="productName"]');
        if(firstInput) {
            firstInput.focus();
        }
    });
    
    // Confirm before updating
    document.querySelector('form').addEventListener('submit', function(e) {
        const productName = document.querySelector('input[name="productName"]').value;
        if(!confirm('Are you sure you want to update "' + productName + '"?')) {
            e.preventDefault();
        }
    });
</script>

</body>

</html>