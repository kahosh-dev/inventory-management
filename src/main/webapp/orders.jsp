<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="model.Order"%>
<%@ page import="java.util.*"%>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

List<Order> orders = (List<Order>) request.getAttribute("orders");
if(orders == null) {
    orders = new ArrayList<>();
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
<title>Orders - Inventory Management</title>

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
        --shadow: 0 4px 6px -1px rgba(0,0,0,0.07), 0 2px 4px -1px rgba(0,0,0,0.04);
        --shadow-md: 0 10px 15px -3px rgba(0,0,0,0.08), 0 4px 6px -2px rgba(0,0,0,0.03);
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
    }
    
    .top-bar .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }
    
    .card {
        background: var(--white);
        border-radius: var(--radius);
        border: none;
        box-shadow: var(--shadow);
        overflow: hidden;
        transition: var(--transition);
    }
    
    .card:hover { box-shadow: var(--shadow-md); }
    
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
    }
    
    .table thead th {
        background: var(--gray-200);
        color: var(--gray-600);
        font-weight: 600;
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
        padding: 12px 16px;
        border-bottom: 2px solid #e2e8f0;
    }
    
    .table tbody td {
        padding: 12px 16px;
        vertical-align: middle;
        border-bottom: 1px solid var(--gray-200);
    }
    
    .table tbody tr:hover { background: var(--gray-200); }
    
    .status-badge {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }
    
    .status-badge.pending { background: rgba(245, 158, 11, 0.12); color: #d97706; }
    .status-badge.shipped { background: rgba(14, 165, 233, 0.12); color: #0284c7; }
    .status-badge.delivered { background: rgba(34, 197, 94, 0.12); color: #16a34a; }
    .status-badge.cancelled { background: rgba(239, 68, 68, 0.12); color: #dc2626; }
    
    .payment-badge {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }
    
    .payment-badge.paid { background: rgba(34, 197, 94, 0.12); color: #16a34a; }
    .payment-badge.unpaid { background: rgba(239, 68, 68, 0.12); color: #dc2626; }
    
    .btn-action {
        padding: 4px 10px;
        border-radius: 6px;
        font-size: 12px;
        border: none;
        transition: var(--transition);
        cursor: pointer;
    }
    
    .btn-action:hover { transform: translateY(-2px); }
    .btn-action.edit { background: rgba(79, 70, 229, 0.1); color: var(--primary); }
    .btn-action.delete { background: rgba(239, 68, 68, 0.1); color: var(--danger); }
    
    .empty-state {
        text-align: center;
        padding: 60px 20px;
    }
    
    .empty-state i {
        font-size: 48px;
        color: #cbd5e1;
        margin-bottom: 16px;
    }
    
    .empty-state h5 { color: var(--dark); font-weight: 600; margin-bottom: 8px; }
    .empty-state p { color: var(--gray-600); font-size: 14px; }
    
    @media (max-width: 992px) { .main-content { margin-left: 0; } }
    
    @media (max-width: 768px) {
        .main-content { padding: 16px; }
        .top-bar { flex-direction: column; }
    }
</style>

</head>

<body>

<div class="page-wrapper">
    
    <%@ include file="sidebar.jsp" %>
    
    <div class="main-content">
        
        <div class="top-bar">
            <div>
                <h1>Orders <span>.</span></h1>
                <p><i class="bi bi-circle-fill" style="color: #22c55e; font-size: 10px;"></i> Manage purchase orders</p>
            </div>
            <div>
                <a href="addOrder.jsp" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> New Order
                </a>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <span><i class="bi bi-list-ul"></i> All Orders</span>
                <span class="badge bg-light text-dark"><%= orders.size() %> Orders</span>
            </div>
            <div class="card-body">
                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order #</th>
                                <th>Supplier</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if(orders.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <i class="bi bi-cart"></i>
                                        <h5>No Orders Found</h5>
                                        <p>Start by creating your first purchase order.</p>
                                    </div>
                                </td>
                            </tr>
                            <%
                            } else {
                                for(Order order : orders) {
                                    String statusClass = order.getStatus().toLowerCase();
                                    String paymentClass = order.getPaymentStatus().toLowerCase();
                            %>
                            <tr>
                                <td><strong>#<%= order.getOrderNumber() %></strong></td>
                                <td><%= order.getSupplierName() != null ? order.getSupplierName() : "N/A" %></td>
                                <td><%= order.getOrderDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(order.getOrderDate()) : "N/A" %></td>
                                <td><strong>KES <%= String.format("%.2f", order.getTotalAmount()) %></strong></td>
                                <td><span class="status-badge <%= statusClass %>"><%= order.getStatus() %></span></td>
                                <td><span class="payment-badge <%= paymentClass %>"><%= order.getPaymentStatus() %></span></td>
                                <td>
                                    <button class="btn-action edit" onclick="editOrder(<%= order.getOrderId() %>)">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn-action delete" onclick="deleteOrder(<%= order.getOrderId() %>)">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <%
                                }
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function editOrder(id) {
        window.location.href = 'EditOrderServlet?id=' + id;
    }
    
    function deleteOrder(id) {
        if(confirm('Are you sure you want to delete this order?')) {
            window.location.href = 'DeleteOrderServlet?id=' + id;
        }
    }
</script>

</body>
</html>