<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>

<%
User user = (User) session.getAttribute("user");
String successMessage = (String) request.getAttribute("successMessage");
String productName = (String) request.getAttribute("productName");

if(successMessage == null) {
    successMessage = "Product saved successfully!";
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Success - Inventory Management</title>

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
            radial-gradient(ellipse at 20% 50%, rgba(34, 197, 94, 0.15) 0%, transparent 50%),
            radial-gradient(ellipse at 80% 50%, rgba(34, 197, 94, 0.05) 0%, transparent 50%);
        z-index: 0;
        animation: pulse 4s ease-in-out infinite;
    }
    
    @keyframes pulse {
        0%, 100% { opacity: 0.5; }
        50% { opacity: 1; }
    }
    
    /* Confetti Animation */
    .confetti-container {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        pointer-events: none;
        z-index: 0;
        overflow: hidden;
    }
    
    .confetti {
        position: absolute;
        width: 10px;
        height: 10px;
        opacity: 0.8;
        animation: confettiFall linear infinite;
    }
    
    @keyframes confettiFall {
        0% {
            transform: translateY(-10vh) rotate(0deg);
            opacity: 1;
        }
        100% {
            transform: translateY(110vh) rotate(720deg);
            opacity: 0;
        }
    }
    
    /* Success Container */
    .success-wrapper {
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
            transform: translateY(30px) scale(0.95);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }
    
    /* Success Card */
    .success-card {
        background: white;
        border-radius: 20px;
        padding: 45px 35px 35px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
        text-align: center;
        position: relative;
        overflow: hidden;
    }
    
    .success-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #22c55e, #16a34a, #22c55e);
        background-size: 200% 100%;
        animation: shimmer 3s ease-in-out infinite;
    }
    
    @keyframes shimmer {
        0%, 100% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
    }
    
    /* Success Icon */
    .success-icon {
        width: 90px;
        height: 90px;
        background: #dcfce7;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        font-size: 44px;
        color: #22c55e;
        animation: successPulse 2s ease-in-out infinite;
    }
    
    @keyframes successPulse {
        0%, 100% { 
            transform: scale(1);
            box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.3);
        }
        50% { 
            transform: scale(1.05);
            box-shadow: 0 0 0 20px rgba(34, 197, 94, 0);
        }
    }
    
    .success-icon i {
        animation: none;
    }
    
    /* Success Code */
    .success-code {
        color: #22c55e;
        font-weight: 700;
        font-size: 14px;
        letter-spacing: 3px;
        text-transform: uppercase;
        margin-bottom: 5px;
        background: #dcfce7;
        display: inline-block;
        padding: 4px 16px;
        border-radius: 20px;
    }
    
    /* Success Title */
    .success-title {
        font-weight: 700;
        color: #0f172a;
        font-size: 24px;
        margin: 10px 0 12px;
    }
    
    .success-title i {
        color: #22c55e;
        margin-right: 8px;
    }
    
    /* Success Message */
    .success-message {
        color: #475569;
        font-size: 15px;
        line-height: 1.6;
        margin-bottom: 25px;
        padding: 16px 20px;
        background: #f8fafc;
        border-radius: 12px;
        border-left: 4px solid #22c55e;
        text-align: left;
    }
    
    .success-message i {
        color: #22c55e;
        margin-right: 8px;
    }
    
    /* Product Preview */
    .product-preview {
        background: #f8fafc;
        border-radius: 12px;
        padding: 16px 20px;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 15px;
        text-align: left;
        border: 1px dashed #e2e8f0;
    }
    
    .product-preview .preview-icon {
        width: 50px;
        height: 50px;
        background: #dcfce7;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: #22c55e;
        flex-shrink: 0;
    }
    
    .product-preview .preview-info {
        flex: 1;
    }
    
    .product-preview .preview-info .label {
        font-size: 12px;
        color: #94a3b8;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    
    .product-preview .preview-info .name {
        font-weight: 600;
        color: #0f172a;
        font-size: 16px;
    }
    
    .product-preview .preview-info .name i {
        color: #22c55e;
        font-size: 14px;
    }
    
    /* Checkmark Animation */
    .checkmark {
        display: inline-block;
        animation: checkmark 0.5s ease;
    }
    
    @keyframes checkmark {
        0% { transform: scale(0); opacity: 0; }
        50% { transform: scale(1.3); }
        100% { transform: scale(1); opacity: 1; }
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
    
    .action-buttons .btn-success {
        background: linear-gradient(135deg, #22c55e, #16a34a);
        border: none;
    }
    
    .action-buttons .btn-success:hover {
        background: linear-gradient(135deg, #16a34a, #15803d);
    }
    
    .action-buttons .btn-primary {
        background: #3b82f6;
        border: none;
    }
    
    .action-buttons .btn-primary:hover {
        background: #2563eb;
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
    
    .action-buttons .btn-info {
        background: #0ea5e9;
        border: none;
        color: white;
    }
    
    .action-buttons .btn-info:hover {
        background: #0284c7;
    }
    
    /* Footer */
    .success-footer {
        text-align: center;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid #f1f5f9;
    }
    
    .success-footer p {
        color: #94a3b8;
        font-size: 13px;
        margin: 0;
    }
    
    .success-footer .version {
        color: #cbd5e1;
        font-size: 12px;
    }
    
    /* Responsive */
    @media (max-width: 480px) {
        .success-card {
            padding: 30px 20px 25px;
        }
        
        .success-icon {
            width: 70px;
            height: 70px;
            font-size: 34px;
        }
        
        .success-title {
            font-size: 20px;
        }
        
        .action-buttons .btn {
            min-width: 100%;
            padding: 12px 20px;
        }
        
        .success-message {
            font-size: 14px;
        }
        
        .product-preview {
            flex-direction: column;
            text-align: center;
        }
    }
</style>

</head>

<body>

<!-- Confetti Animation -->
<div class="confetti-container" id="confettiContainer"></div>

<div class="success-wrapper">
    
    <!-- Success Card -->
    <div class="success-card">
        
        <!-- Success Icon -->
        <div class="success-icon">
            <i class="bi bi-check-circle-fill checkmark"></i>
        </div>
        
        <!-- Success Code -->
        <div class="success-code">
            <i class="bi bi-check-circle"></i>
            Success
        </div>
        
        <!-- Success Title -->
        <div class="success-title">
            <i class="bi bi-check-circle-fill"></i>
            Operation Successful
        </div>
        
        <!-- Success Message -->
        <div class="success-message">
            <i class="bi bi-info-circle-fill"></i>
            <%= successMessage %>
        </div>
        
        <!-- Product Preview -->
        <%
        if(productName != null && !productName.isEmpty()) {
        %>
        <div class="product-preview">
            <div class="preview-icon">
                <i class="bi bi-box-seam"></i>
            </div>
            <div class="preview-info">
                <div class="label">Product Added</div>
                <div class="name">
                    <i class="bi bi-check-circle-fill"></i>
                    <%= productName %>
                </div>
            </div>
        </div>
        <%
        }
        %>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="addProduct.jsp" class="btn btn-success">
                <i class="bi bi-plus-circle"></i>
                Add Another
            </a>
            <a href="ViewProductsServlet" class="btn btn-primary">
                <i class="bi bi-box-seam"></i>
                View Products
            </a>
            <a href="dashboard.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-grid-1x2-fill"></i>
                Dashboard
            </a>
        </div>
        
        <!-- Footer -->
        <div class="success-footer">
            <p>&copy; 2024 Inventory Pro. All rights reserved.</p>
            <div class="version">v2.0.1</div>
        </div>
        
    </div>
    
</div>

<script>
    // Confetti Generator
    function createConfetti() {
        const container = document.getElementById('confettiContainer');
        const colors = ['#22c55e', '#16a34a', '#3b82f6', '#f59e0b', '#8b5cf6', '#ef4444', '#ec4899', '#06b6d4'];
        const shapes = ['■', '●', '▲', '★', '♦'];
        
        for(let i = 0; i < 30; i++) {
            const confetti = document.createElement('div');
            confetti.className = 'confetti';
            confetti.textContent = shapes[Math.floor(Math.random() * shapes.length)];
            confetti.style.left = Math.random() * 100 + '%';
            confetti.style.color = colors[Math.floor(Math.random() * colors.length)];
            confetti.style.fontSize = (Math.random() * 15 + 8) + 'px';
            confetti.style.animationDuration = (Math.random() * 3 + 2) + 's';
            confetti.style.animationDelay = (Math.random() * 3) + 's';
            confetti.style.opacity = Math.random() * 0.5 + 0.3;
            container.appendChild(confetti);
        }
    }
    
    // Auto-redirect to dashboard after 10 seconds
    let countdown = 10;
    let redirectTimer = setInterval(function() {
        countdown--;
        if(countdown <= 0) {
            clearInterval(redirectTimer);
            window.location.href = 'dashboard.jsp';
        }
    }, 1000);
    
    // Initialize confetti
    document.addEventListener('DOMContentLoaded', function() {
        createConfetti();
        console.log('Redirecting to dashboard in ' + countdown + ' seconds...');
    });
    
    // Prevent duplicate form submissions
    document.addEventListener('DOMContentLoaded', function() {
        // Disable all action buttons temporarily to prevent double submission
        const buttons = document.querySelectorAll('.action-buttons .btn');
        buttons.forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                // Allow navigation, prevent multiple rapid clicks
                if(btn.dataset.clicked) {
                    e.preventDefault();
                    return;
                }
                btn.dataset.clicked = 'true';
                setTimeout(function() {
                    btn.dataset.clicked = '';
                }, 3000);
            });
        });
    });
</script>

</body>

</html>