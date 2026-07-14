<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Add Supplier - Inventory Management</title>

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
    }
    
    .page-header h2 {
        font-weight: 700;
        color: #0f172a;
        margin: 0;
        font-size: 24px;
    }
    
    .page-header h2 i { color: #3b82f6; margin-right: 10px; }
    .page-header p { color: #64748b; margin: 4px 0 0 0; font-size: 14px; }
    
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
    }
    
    .form-card .card-header i { color: #3b82f6; margin-right: 8px; }
    .form-card .card-body { padding: 28px; }
    
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
    
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    
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
    
    @media (max-width: 992px) { .main-content { margin-left: 0; } }
    
    @media (max-width: 768px) {
        .main-content { padding: 15px; }
        .form-row { grid-template-columns: 1fr; }
        .form-card .card-body { padding: 20px; }
        .page-header { flex-direction: column; text-align: center; gap: 12px; }
        .btn-group-actions { flex-direction: column; }
        .btn-group-actions .btn-cancel { width: 100%; }
    }
</style>

</head>

<body>

<div class="page-wrapper">
    
    <%@ include file="sidebar.jsp" %>
    
    <div class="main-content">
        
        <div class="page-header">
            <div>
                <h2><i class="bi bi-truck"></i> Add Supplier</h2>
                <p>Register a new supplier in the system</p>
            </div>
        </div>
        
        <div class="form-card">
            <div class="card-header">
                <span><i class="bi bi-plus-circle"></i> Supplier Details</span>
            </div>
            <div class="card-body">
                
                <%
                String error = (String) session.getAttribute("errorMessage");
                if(error != null) {
                    session.removeAttribute("errorMessage");
                %>
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle-fill"></i>
                    <%= error %>
                </div>
                <%
                }
                %>
                
                <form action="AddSupplierServlet" method="post">
                    
                    <div class="form-group">
                        <label><i class="bi bi-building"></i> Supplier Name <span class="required">*</span></label>
                        <div class="input-group-custom">
                            <span class="input-icon"><i class="bi bi-building"></i></span>
                            <input type="text" name="supplierName" class="form-control" placeholder="Enter supplier name" required autofocus>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="bi bi-person"></i> Contact Person</label>
                        <div class="input-group-custom">
                            <span class="input-icon"><i class="bi bi-person"></i></span>
                            <input type="text" name="contactPerson" class="form-control" placeholder="Enter contact person name">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="bi bi-envelope"></i> Email</label>
                            <div class="input-group-custom">
                                <span class="input-icon"><i class="bi bi-envelope"></i></span>
                                <input type="email" name="email" class="form-control" placeholder="Enter email address">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="bi bi-phone"></i> Phone</label>
                            <div class="input-group-custom">
                                <span class="input-icon"><i class="bi bi-phone"></i></span>
                                <input type="tel" name="phone" class="form-control" placeholder="Enter phone number">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="bi bi-geo-alt"></i> Address</label>
                        <div class="input-group-custom">
                            <span class="input-icon"><i class="bi bi-geo-alt"></i></span>
                            <input type="text" name="address" class="form-control" placeholder="Enter address">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="bi bi-tags"></i> Category</label>
                            <div class="input-group-custom">
                                <span class="input-icon"><i class="bi bi-tags"></i></span>
                                <input type="text" name="category" class="form-control" placeholder="e.g., Electronics, Furniture">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="bi bi-circle"></i> Status</label>
                            <div class="input-group-custom">
                                <span class="input-icon"><i class="bi bi-circle"></i></span>
                                <select name="status" class="form-control">
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="btn-group-actions">
                        <button type="submit" class="btn-submit">
                            <i class="bi bi-check-circle"></i>
                            Save Supplier
                        </button>
                        <a href="ViewSuppliersServlet" class="btn-cancel">
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

</body>
</html>