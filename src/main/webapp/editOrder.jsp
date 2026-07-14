<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="model.Order"%>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

Order order = (Order) request.getAttribute("order");
if(order == null) {
    response.sendRedirect("OrderServlet");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Edit Order - Inventory Management</title>

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
    
    .page-header .order-id-badge {
        background: #eef2ff;
        color: #4f46e5;
        padding: 8px 18px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
    }
    
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
    
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    
    .order-preview {
        background: #f8fafc;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 25px;
        border: 1px dashed #e2e8f0;
    }
    
    .order-preview .preview-row {
        display: flex;
        justify-content: space-between;
        padding: 6px 0;
        border-bottom: 1px solid #f1f5f9;
    }
    
    .order-preview .preview-row:last-child { border-bottom: none; }
    .order-preview .preview-label { color: #64748b; font-weight: 500; }
    .order-preview .preview-value { font-weight: 600; color: #0f172a; }
    
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
        text-decoration: none;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        margin-top: 10px;
        transition: all 0.3s ease;
    }
    
    .btn-cancel:hover { background: #e2e8f0; color: #0f172a; transform: translateY(-2px); }
    
    .btn-group-actions { display: flex; gap: 12px; }
    .btn-group-actions .btn-cancel { width: auto; padding: 12px 30px; margin-top: 0; }
    
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
                <h2><i class="bi bi-pencil-square"></i> Edit Order</h2>
                <p>Update order status and details</p>
            </div>
            <div class="order-id-badge">
                <i class="bi bi-hash"></i>
                Order: <%= order.getOrderNumber() %>
            </div>
        </div>
        
        <div class="form-card">
            <div class="card-header">
                <span><i class="bi bi-cart"></i> Order Details</span>
            </div>
            <div class="card-body">
                
                <div class="order-preview">
                    <div class="preview-row">
                        <span class="preview-label">Order #</span>
                        <span class="preview-value"><%= order.getOrderNumber() %></span>
                    </div>
                    <div class="preview-row">
                        <span class="preview-label">Supplier</span>
                        <span class="preview-value"><%= order.getSupplierName() != null ? order.getSupplierName() : "N/A" %></span>
                    </div>
                    <div class="preview-row">
                        <span class="preview-label">Order Date</span>
                        <span class="preview-value"><%= order.getOrderDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(order.getOrderDate()) : "N/A" %></span>
                    </div>
                    <div class="preview-row">
                        <span class="preview-label">Total Amount</span>
                        <span class="preview-value">KES <%= String.format("%.2f", order.getTotalAmount()) %></span>
                    </div>
                </div>
                
                <form action="UpdateOrderServlet" method="post">
                    
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="bi bi-circle"></i> Status</label>
                            <select name="status" class="form-control">
                                <option value="Pending" <%= order.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                                <option value="Shipped" <%= order.getStatus().equals("Shipped") ? "selected" : "" %>>Shipped</option>
                                <option value="Delivered" <%= order.getStatus().equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                <option value="Cancelled" <%= order.getStatus().equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="bi bi-credit-card"></i> Payment Status</label>
                            <select name="paymentStatus" class="form-control">
                                <option value="Unpaid" <%= order.getPaymentStatus().equals("Unpaid") ? "selected" : "" %>>Unpaid</option>
                                <option value="Paid" <%= order.getPaymentStatus().equals("Paid") ? "selected" : "" %>>Paid</option>
                                <option value="Partial" <%= order.getPaymentStatus().equals("Partial") ? "selected" : "" %>>Partial</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="bi bi-sticky"></i> Notes</label>
                        <textarea name="notes" class="form-control" rows="3"><%= order.getNotes() != null ? order.getNotes() : "" %></textarea>
                    </div>
                    
                    <div class="btn-group-actions">
                        <button type="submit" class="btn-submit">
                            <i class="bi bi-check-circle"></i>
                            Update Order
                        </button>
                        <a href="OrderServlet" class="btn-cancel">
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