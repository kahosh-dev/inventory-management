<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Login - Inventory Management System</title>

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
            radial-gradient(ellipse at 10% 20%, rgba(59, 130, 246, 0.15) 0%, transparent 50%),
            radial-gradient(ellipse at 90% 80%, rgba(79, 70, 229, 0.15) 0%, transparent 50%);
        z-index: 0;
        animation: pulse 8s ease-in-out infinite;
    }
    
    @keyframes pulse {
        0%, 100% { opacity: 0.5; }
        50% { opacity: 1; }
    }
    
    /* Login Container */
    .login-wrapper {
        position: relative;
        z-index: 1;
        width: 100%;
        max-width: 420px;
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
    
    /* Logo/Header */
    .login-header {
        text-align: center;
        margin-bottom: 30px;
    }
    
    .login-header .logo-icon {
        width: 70px;
        height: 70px;
        background: linear-gradient(135deg, #2563eb, #4f46e5);
        border-radius: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 15px;
        color: white;
        font-size: 34px;
        box-shadow: 0 8px 30px rgba(37, 99, 235, 0.4);
        transition: transform 0.3s ease;
    }
    
    .login-header .logo-icon:hover {
        transform: scale(1.05) rotate(-5deg);
    }
    
    .login-header h1 {
        color: white;
        font-weight: 700;
        font-size: 28px;
        letter-spacing: 1px;
        margin: 0;
    }
    
    .login-header .subtitle {
        color: #94a3b8;
        font-size: 14px;
        margin-top: 5px;
        letter-spacing: 3px;
    }
    
    /* Login Card */
    .login-card {
        background: white;
        border-radius: 20px;
        padding: 40px 35px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }
    
    .login-card .card-title {
        font-weight: 600;
        color: #0f172a;
        font-size: 20px;
        margin-bottom: 5px;
    }
    
    .login-card .card-subtitle {
        color: #94a3b8;
        font-size: 14px;
        margin-bottom: 25px;
    }
    
    /* Form Styles */
    .form-group {
        margin-bottom: 20px;
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
        transition: color 0.3s ease;
    }
    
    .input-group-custom .form-control {
        padding-left: 44px;
        padding-right: 44px;
    }
    
    .input-group-custom .toggle-password {
        position: absolute;
        right: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: #94a3b8;
        font-size: 18px;
        cursor: pointer;
        z-index: 1;
        transition: color 0.3s ease;
        background: none;
        border: none;
    }
    
    .input-group-custom .toggle-password:hover {
        color: #3b82f6;
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
    
    .form-control:focus + .input-icon,
    .form-control:focus ~ .input-icon {
        color: #3b82f6;
    }
    
    /* Remember Me & Forgot Password */
    .form-options {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }
    
    .form-options .form-check {
        margin: 0;
    }
    
    .form-options .form-check-input {
        border: 2px solid #e2e8f0;
        border-radius: 4px;
        cursor: pointer;
    }
    
    .form-options .form-check-input:checked {
        background-color: #3b82f6;
        border-color: #3b82f6;
    }
    
    .form-options .form-check-label {
        font-size: 14px;
        color: #475569;
        cursor: pointer;
    }
    
    .form-options .forgot-link {
        color: #3b82f6;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        transition: color 0.3s ease;
    }
    
    .form-options .forgot-link:hover {
        color: #2563eb;
        text-decoration: underline;
    }
    
    /* Submit Button */
    .btn-login {
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
        position: relative;
        overflow: hidden;
    }
    
    .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 30px rgba(37, 99, 235, 0.4);
    }
    
    .btn-login:active {
        transform: translateY(0);
    }
    
    .btn-login i {
        font-size: 18px;
    }
    
    .btn-login .spinner {
        display: none;
        width: 20px;
        height: 20px;
        border: 2px solid rgba(255, 255, 255, 0.3);
        border-top: 2px solid white;
        border-radius: 50%;
        animation: spin 0.8s linear infinite;
    }
    
    @keyframes spin {
        to { transform: rotate(360deg); }
    }
    
    .btn-login.loading .spinner {
        display: inline-block;
    }
    
    .btn-login.loading .btn-text {
        display: none;
    }
    
    /* Footer */
    .login-footer {
        text-align: center;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid #f1f5f9;
    }
    
    .login-footer p {
        color: #94a3b8;
        font-size: 13px;
        margin: 0;
    }
    
    .login-footer .version {
        color: #cbd5e1;
        font-size: 12px;
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
        animation: shake 0.5s ease;
    }
    
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-10px); }
        75% { transform: translateX(10px); }
    }
    
    .alert-danger {
        background: #fee2e2;
        color: #991b1b;
        border-left: 4px solid #ef4444;
    }
    
    .alert-success {
        background: #dcfce7;
        color: #166534;
        border-left: 4px solid #22c55e;
    }
    
    .alert i {
        font-size: 20px;
    }
    
    /* Responsive */
    @media (max-width: 480px) {
        .login-card {
            padding: 30px 20px;
        }
        
        .login-header h1 {
            font-size: 24px;
        }
        
        .login-header .logo-icon {
            width: 60px;
            height: 60px;
            font-size: 28px;
        }
        
        .form-options {
            flex-direction: column;
            gap: 10px;
            align-items: flex-start;
        }
    }
</style>

</head>

<body>

<div class="login-wrapper">
    
    <!-- Header -->
    <div class="login-header">
        <div class="logo-icon">
            <i class="bi bi-box-seam"></i>
        </div>
        <h1>Inventory Pro</h1>
        <div class="subtitle">MANAGEMENT SYSTEM</div>
    </div>
    
    <!-- Login Card -->
    <div class="login-card">
        <div class="card-title">
            <i class="bi bi-person-circle" style="color: #3b82f6;"></i>
            Sign In
        </div>
        <div class="card-subtitle">Enter your credentials to access the dashboard</div>
        
        <!-- Display Error Messages -->
        <%
        String error = (String) request.getAttribute("error");
        String message = (String) request.getAttribute("message");
        
        if(error != null) {
        %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-circle-fill"></i>
            <%= error %>
        </div>
        <%
        }
        if(message != null) {
        %>
        <div class="alert alert-success">
            <i class="bi bi-check-circle-fill"></i>
            <%= message %>
        </div>
        <%
        }
        %>
        
        <!-- Login Form -->
        <form action="LoginServlet" method="post" id="loginForm">
            
            <!-- Username -->
            <div class="form-group">
                <label>
                    <i class="bi bi-person"></i> Username
                </label>
                <div class="input-group-custom">
                    <span class="input-icon"><i class="bi bi-person"></i></span>
                    <input 
                        type="text" 
                        name="username" 
                        class="form-control" 
                        placeholder="Enter your username"
                        required
                        autofocus
                    >
                </div>
            </div>
            
            <!-- Password -->
            <div class="form-group">
                <label>
                    <i class="bi bi-lock"></i> Password
                </label>
                <div class="input-group-custom">
                    <span class="input-icon"><i class="bi bi-lock"></i></span>
                    <input 
                        type="password" 
                        name="password" 
                        class="form-control" 
                        placeholder="Enter your password"
                        id="passwordInput"
                        required
                    >
                    <button type="button" class="toggle-password" id="togglePassword" title="Toggle password visibility">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
            </div>
            
            <!-- Options -->
            <div class="form-options">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                    <label class="form-check-label" for="rememberMe">Remember me</label>
                </div>
                <a href="#" class="forgot-link">Forgot password?</a>
            </div>
            
            <!-- Login Button -->
            <button type="submit" class="btn-login" id="loginBtn">
                <span class="spinner"></span>
                <span class="btn-text">
                    <i class="bi bi-box-arrow-in-right"></i>
                    Sign In
                </span>
            </button>
            
        </form>
        
        <!-- Footer -->
        <div class="login-footer">
            <p>&copy; 2024 Inventory Pro. All rights reserved.</p>
            <div class="version">v2.0.1</div>
        </div>
        
    </div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Toggle Password Visibility
    document.getElementById('togglePassword').addEventListener('click', function() {
        const passwordInput = document.getElementById('passwordInput');
        const icon = this.querySelector('i');
        
        if(passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.className = 'bi bi-eye-slash';
        } else {
            passwordInput.type = 'password';
            icon.className = 'bi bi-eye';
        }
    });
    
    // Loading State on Submit
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('loginBtn');
        btn.classList.add('loading');
        btn.disabled = true;
    });
    
    // Enter key to submit
    document.addEventListener('keydown', function(e) {
        if(e.key === 'Enter') {
            const activeElement = document.activeElement;
            if(activeElement && (activeElement.name === 'username' || activeElement.name === 'password')) {
                document.getElementById('loginForm').submit();
            }
        }
    });
</script>

</body>

</html>