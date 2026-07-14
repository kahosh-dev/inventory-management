<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="model.User"%>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product - Inventory Management</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

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
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    /* Main Container */
    .page-wrapper {
        width: 100%;
        padding: 20px;
    }
    
    .form-container {
        max-width: 580px;
        margin: 0 auto;
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        animation: slideUp 0.5s ease;
    }
    
    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    /* Header */
    .form-header {
        text-align: center;
        margin-bottom: 35px;
    }
    
    .form-header .icon-wrapper {
        width: 70px;
        height: 70px;
        background: linear-gradient(135deg, #2563eb, #4f46e5);
        border-radius: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 15px;
        color: white;
        font-size: 32px;
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
    }
    
    .form-header h2 {
        font-weight: 700;
        color: #0f172a;
        font-size: 26px;
        margin-bottom: 5px;
    }
    
    .form-header p {
        color: #94a3b8;
        font-size: 14px;
        margin: 0;
    }
    
    /* Form Groups */
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
        width: 18px;
    }
    
    .form-group .required {
        color: #ef4444;
        margin-left: 2px;
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
    
    /* Input with icon */
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
    }
    
    .input-group-custom .form-control {
        padding-left: 44px;
    }
    
    /* Button */
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
    
    /* Footer Links */
    .form-footer {
        text-align: center;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid #f1f5f9;
    }
    
    .form-footer a {
        color: #64748b;
        text-decoration: none;
        font-size: 14px;
        transition: color 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    
    .form-footer a:hover {
        color: #3b82f6;
    }
    
    .form-footer .back-link {
        color: #3b82f6;
        font-weight: 500;
    }
    
    .form-footer .back-link:hover {
        color: #2563eb;
        text-decoration: underline;
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
    
    /* Responsive */
    @media (max-width: 640px) {
        .form-container {
            padding: 25px 20px;
            border-radius: 16px;
        }
        
        .form-header h2 {
            font-size: 22px;
        }
        
        .form-header .icon-wrapper {
            width: 60px;
            height: 60px;
            font-size: 28px;
        }
        
        .btn-submit {
            padding: 12px;
            font-size: 15px;
        }
    }
</style>

</head>

<body>

<div class="page-wrapper">
    <div class="form-container">
        
        <!-- Header -->
        <div class="form-header">
            <div class="icon-wrapper">
                <i class="bi bi-plus-circle"></i>
            </div>
            <h2>Add New Product</h2>
            <p>Fill in the details to add a new product to inventory</p>
        </div>
        
        <!-- Display Message (if any) -->
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
        
        <!-- Form -->
        <form action="ProductServlet" method="post">
            
            <!-- Product Name -->
            <div class="form-group">
                <label>
                    <i class="bi bi-box-seam"></i> Product Name
                    <span class="required">*</span>
                </label>
                <div class="input-group-custom">
                    <span class="input-icon"><i class="bi bi-box"></i></span>
                    <input 
                        type="text" 
                        name="productName" 
                        class="form-control" 
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
                        placeholder="Enter category (e.g., Electronics, Office Supplies)"
                        required
                    >
                </div>
            </div>
            
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
                        min="1"
                        step="1"
                        class="form-control" 
                        placeholder="Enter quantity in stock"
                        required
                    >
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
                        placeholder="Enter price per unit"
                        required
                    >
                </div>
            </div>
            
            <!-- Submit Button -->
            <button type="submit" class="btn-submit">
                <i class="bi bi-plus-circle"></i>
                Save Product
            </button>
            
        </form>
        
        <!-- Footer -->
        <div class="form-footer">
            <a href="dashboard.jsp" class="back-link">
                <i class="bi bi-arrow-left"></i>
                Back to Dashboard
            </a>
            <span style="color:#e2e8f0; margin: 0 8px;">|</span>
            <a href="ViewProductsServlet">
                <i class="bi bi-card-list"></i>
                View All Products
            </a>
        </div>
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>