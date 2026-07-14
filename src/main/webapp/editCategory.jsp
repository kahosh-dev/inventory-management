<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

Integer categoryId = (Integer) request.getAttribute("categoryId");
String categoryName = (String) request.getAttribute("categoryName");

if(categoryId == null || categoryName == null) {
    response.sendRedirect("CategoryServlet");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Edit Category - Inventory Management</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
        background: #f1f5f9;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }
    
    .form-container {
        max-width: 600px;
        width: 100%;
        margin: 0 auto;
        animation: slideUp 0.5s ease;
    }
    
    @keyframes slideUp {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .page-header {
        text-align: center;
        margin-bottom: 30px;
    }
    
    .page-header .icon-wrapper {
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
    
    .page-header h2 {
        font-weight: 700;
        color: #0f172a;
        font-size: 26px;
        margin-bottom: 5px;
    }
    
    .page-header p {
        color: #94a3b8;
        font-size: 14px;
        margin: 0;
    }
    
    .form-card {
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
    }
    
    .form-card .card-header {
        text-align: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f1f5f9;
    }
    
    .form-card .card-header h4 {
        font-weight: 600;
        color: #0f172a;
        margin: 0;
    }
    
    .form-card .card-header h4 i { color: #3b82f6; margin-right: 8px; }
    
    .form-group { margin-bottom: 22px; }
    
    .form-group label {
        display: block;
        font-weight: 600;
        color: #1e293b;
        font-size: 14px;
        margin-bottom: 6px;
    }
    
    .form-group label i { color: #3b82f6; margin-right: 6px; width: 20px; }
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
    }
    
    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
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
    
    .btn-cancel:hover { background: #e2e8f0; color: #0f172a; transform: translateY(-2px); }
    
    .btn-group-actions { display: flex; gap: 12px; }
    .btn-group-actions .btn-cancel { width: auto; padding: 12px 30px; margin-top: 0; }
    
    .category-preview {
        background: #f8fafc;
        border-radius: 12px;
        padding: 16px 20px;
        margin-bottom: 25px;
        border: 1px dashed #e2e8f0;
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .category-preview .preview-icon {
        width: 50px;
        height: 50px;
        background: #eef2ff;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: #4f46e5;
        flex-shrink: 0;
    }
    
    .category-preview .preview-info { flex: 1; }
    .category-preview .preview-info .label {
        font-size: 12px;
        color: #94a3b8;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    
    .category-preview .preview-info .name {
        font-weight: 600;
        color: #0f172a;
        font-size: 16px;
    }
    
    .alert {
        padding: 14px 18px;
        border-radius: 12px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
    }
    
    .alert-danger {
        background: #fee2e2;
        color: #991b1b;
        border-left: 4px solid #ef4444;
    }
    
    .alert i { font-size: 20px; }
    
    @media (max-width: 768px) {
        .form-card { padding: 25px; }
        .btn-group-actions { flex-direction: column; }
        .btn-group-actions .btn-cancel { width: 100%; }
        .page-header h2 { font-size: 22px; }
        .page-header .icon-wrapper { width: 60px; height: 60px; font-size: 28px; }
        .category-preview { flex-direction: column; text-align: center; }
    }
</style>

</head>

<body>

<div class="form-container">
    
    <div class="page-header">
        <div class="icon-wrapper">
            <i class="bi bi-tags"></i>
        </div>
        <h2>Edit Category</h2>
        <p>Update category information</p>
    </div>
    
    <div class="form-card">
        <div class="card-header">
            <h4><i class="bi bi-pencil-square"></i> Category Details</h4>
        </div>
        
        <%
        String error = (String) request.getAttribute("error");
        if(error != null) {
        %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-circle-fill"></i>
            <%= error %>
        </div>
        <%
        }
        %>
        
        <div class="category-preview">
            <div class="preview-icon">
                <i class="bi bi-folder"></i>
            </div>
            <div class="preview-info">
                <div class="label">Editing Category</div>
                <div class="name"><%= categoryName %></div>
            </div>
        </div>
        
        <form action="UpdateCategoryServlet" method="post">
            
            <input type="hidden" name="id" value="<%= categoryId %>">
            
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
                        class="form-control" 
                        value="<%= categoryName %>"
                        placeholder="Enter category name"
                        required
                        autofocus
                    >
                </div>
                <small class="text-muted" style="display: block; margin-top: 5px;">
                    <i class="bi bi-info-circle"></i> Category name must be unique
                </small>
            </div>
            
            <div class="btn-group-actions">
                <button type="submit" class="btn-submit">
                    <i class="bi bi-check-circle"></i>
                    Update Category
                </button>
                <a href="CategoryServlet" class="btn-cancel">
                    <i class="bi bi-x-circle"></i>
                    Cancel
                </a>
            </div>
            
        </form>
        
    </div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>