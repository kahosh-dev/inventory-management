<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>

<%
User user = (User) session.getAttribute("user");
String errorMessage = (String) request.getAttribute("errorMessage");
if(errorMessage == null) {
    errorMessage = "An unexpected error occurred while processing your request.";
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Error - Inventory Management</title>

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
        min-height: 100vh;
        background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }
    
    /* Animated Background */
    body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: 
            radial-gradient(ellipse at 20% 50%, rgba(239, 68, 68, 0.15) 0%, transparent 50%),
            radial-gradient(ellipse at 80% 50%, rgba(239, 68, 68, 0.05) 0%, transparent 50%);
        z-index: 0;
        animation: pulse 4s ease-in-out infinite;
    }
    
    @keyframes pulse {
        0%, 100% { opacity: 0.5; }
        50% { opacity: 1; }
    }
    
    /* Error Container */
    .error-wrapper {
        position: relative;
        z-index: 1;
        width: 100%;
        max-width: 500px;
        margin: 0 auto;
        animation: slideUp 0.6s ease;
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
    
    /* Error Card */
    .error-card {
        background: white;
        border-radius: 20px;
        padding: 45px 35px 35px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
        text-align: center;
    }
    
    /* Error Icon */
    .error-icon {
        width: 90px;
        height: 90px;
        background: #fee2e2;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        font-size: 44px;
        color: #ef4444;
        animation: shake 2s ease-in-out infinite;
    }
    
    @keyframes shake {
        0%, 100% { transform: rotate(0); }
        5% { transform: rotate(-10deg); }
        10% { transform: rotate(10deg); }
        15% { transform: rotate(-10deg); }
        20% { transform: rotate(0); }
    }
    
    .error-icon i {
        animation: none;
    }
    
    /* Error Code */
    .error-code {
        color: #ef4444;
        font-weight: 700;
        font-size: 14px;
        letter-spacing: 3px;
        text-transform: uppercase;
        margin-bottom: 5px;
        background: #fee2e2;
        display: inline-block;
        padding: 4px 16px;
        border-radius: 20px;
    }
    
    /* Error Title */
    .error-title {
        font-weight: 700;
        color: #0f172a;
        font-size: 24px;
        margin: 10px 0 12px;
    }
    
    .error-title i {
        color: #ef4444;
        margin-right: 8px;
    }
    
    /* Error Message */
    .error-message {
        color: #475569;
        font-size: 15px;
        line-height: 1.6;
        margin-bottom: 25px;
        padding: 16px 20px;
        background: #f8fafc;
        border-radius: 12px;
        border-left: 4px solid #ef4444;
        text-align: left;
    }
    
    .error-message i {
        color: #ef4444;
        margin-right: 8px;
    }
    
    /* Error Details */
    .error-details {
        background: #f8fafc;
        border-radius: 12px;
        padding: 16px 20px;
        margin-bottom: 25px;
        text-align: left;
    }
    
    .error-details .detail-item {
        display: flex;
        justify-content: space-between;
        padding: 6px 0;
        font-size: 13px;
        border-bottom: 1px solid #f1f5f9;
    }
    
    .error-details .detail-item:last-child {
        border-bottom: none;
    }
    
    .error-details .detail-item .label {
        color: #64748b;
        font-weight: 500;
    }
    
    .error-details .detail-item .value {
        color: #0f172a;
        font-weight: 600;
    }
    
    /* Action Buttons */
    .action-buttons {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        justify-content: center;
        margin-top: 5px;
    }
    
    .action-buttons .btn {
        padding: 12px 28px;
        border-radius: 12px;
        font-weight: 600;
        font-size: 15px;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        min-width: 140px;
        justify-content: center;
    }
    
    .action-buttons .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
    }
    
    .action-buttons .btn-primary {
        background: #3b82f6;
        border: none;
    }
    
    .action-buttons .btn-primary:hover {
        background: #2563eb;
    }
    
    .action-buttons .btn-success {
        background: #22c55e;
        border: none;
    }
    
    .action-buttons .btn-success:hover {
        background: #16a34a;
    }
    
    .action-buttons .btn-danger {
        background: #ef4444;
        border: none;
    }
    
    .action-buttons .btn-danger:hover {
        background: #dc2626;
    }
    
    .action-buttons .btn-outline-secondary {
        background: transparent;
        border: 2px solid #e2e8f0;
        color: #475569;
    }
    
    .action-buttons .btn-outline-secondary:hover {
        background: #f1f5f9;
        border-color: #94a3b8;
        color: #0f172a;
    }
    
    /* Footer */
    .error-footer {
        text-align: center;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid #f1f5f9;
    }
    
    .error-footer p {
        color: #94a3b8;
        font-size: 13px;
        margin: 0;
    }
    
    .error-footer .version {
        color: #cbd5e1;
        font-size: 12px;
    }
    
    /* If user is not logged in */
    .login-prompt {
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #f1f5f9;
    }
    
    .login-prompt p {
        color: #94a3b8;
        font-size: 14px;
        margin-bottom: 12px;
    }
    
    /* Responsive */
    @media (max-width: 480px) {
        .error-card {
            padding: 30px 20px 25px;
        }
        
        .error-icon {
            width: 70px;
            height: 70px;
            font-size: 34px;
        }
        
        .error-title {
            font-size: 20px;
        }
        
        .action-buttons .btn {
            min-width: 100%;
            padding: 12px 20px;
        }
        
        .error-message {
            font-size: 14px;
        }
    }
</style>

</head>

<body>

<div class="error-wrapper">
    
    <!-- Error Card -->
    <div class="error-card">
        
        <!-- Error Icon -->
        <div class="error-icon">
            <i class="bi bi-exclamation-triangle-fill"></i>
        </div>
        
        <!-- Error Code -->
        <div class="error-code">
            <i class="bi bi-shield-exclamation"></i>
            Error 500
        </div>
        
        <!-- Error Title -->
        <div class="error-title">
            <i class="bi bi-x-circle-fill"></i>
            Operation Failed
        </div>
        
        <!-- Error Message -->
        <div class="error-message">
            <i class="bi bi-info-circle-fill"></i>
            <%= errorMessage %>
        </div>
        
        <!-- Error Details -->
        <div class="error-details">
            <div class="detail-item">
                <span class="label">Status</span>
                <span class="value text-danger">Failed</span>
            </div>
            <div class="detail-item">
                <span class="label">Timestamp</span>
                <span class="value"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></span>
            </div>
            <div class="detail-item">
                <span class="label">Action</span>
                <span class="value">Save Product</span>
            </div>
            <div class="detail-item">
                <span class="label">User</span>
                <span class="value"><%= user != null ? user.getFullname() : "Guest" %></span>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="javascript:history.back()" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i>
                Go Back
            </a>
            <a href="addProduct.jsp" class="btn btn-success">
                <i class="bi bi-plus-circle"></i>
                Try Again
            </a>
            <a href="dashboard.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-grid-1x2-fill"></i>
                Dashboard
            </a>
        </div>
        
        <!-- Login Prompt for Guests -->
        <%
        if(user == null) {
        %>
        <div class="login-prompt">
            <p><i class="bi bi-person"></i> Please log in to continue</p>
            <a href="login.jsp" class="btn btn-primary" style="padding: 10px 24px; border-radius: 12px; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                <i class="bi bi-box-arrow-in-right"></i>
                Login
            </a>
        </div>
        <%
        }
        %>
        
        <!-- Footer -->
        <div class="error-footer">
            <p>&copy; 2024 Inventory Pro. All rights reserved.</p>
            <div class="version">v2.0.1</div>
        </div>
        
    </div>
    
</div>

<script>
    // Auto-redirect to dashboard after 10 seconds
    let countdown = 10;
    const redirectTimer = setInterval(function() {
        countdown--;
        if(countdown <= 0) {
            clearInterval(redirectTimer);
            window.location.href = 'dashboard.jsp';
        }
    }, 1000);
    
    // Show countdown in console
    console.log('Redirecting to dashboard in ' + countdown + ' seconds...');
    
    // Prevent default back button behavior
    window.addEventListener('popstate', function(e) {
        // Optional: custom back behavior
    });
</script>

</body>

</html>