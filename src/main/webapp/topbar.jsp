<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>

<%
User user = (User) session.getAttribute("user");
%>

<style>
    /* Topbar Styles */
    .topbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 70px;
        background: white;
        border-bottom: 1px solid #e2e8f0;
        z-index: 1030;
        display: flex;
        align-items: center;
        padding: 0 25px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
    }
    
    /* Only show when sidebar is present */
    .topbar-with-sidebar {
        margin-left: 250px;
        width: calc(100% - 250px);
    }
    
    .topbar .brand {
        display: flex;
        align-items: center;
        gap: 12px;
        text-decoration: none;
        color: #0f172a;
        font-weight: 700;
        font-size: 20px;
        letter-spacing: 0.5px;
    }
    
    .topbar .brand .brand-icon {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, #2563eb, #4f46e5);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 20px;
        transition: transform 0.3s ease;
    }
    
    .topbar .brand .brand-icon:hover {
        transform: rotate(-5deg) scale(1.05);
    }
    
    .topbar .brand .brand-text {
        font-size: 18px;
        color: #0f172a;
    }
    
    .topbar .brand .brand-text span {
        color: #3b82f6;
    }
    
    .topbar .brand .brand-sub {
        font-size: 11px;
        color: #94a3b8;
        font-weight: 400;
        letter-spacing: 1px;
        display: block;
        margin-top: -2px;
    }
    
    /* Navigation Links */
    .topbar .nav-links {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-left: auto;
    }
    
    .topbar .nav-links .nav-link {
        padding: 8px 16px;
        border-radius: 10px;
        color: #475569;
        text-decoration: none;
        font-weight: 500;
        font-size: 14px;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: transparent;
        border: none;
        cursor: pointer;
    }
    
    .topbar .nav-links .nav-link:hover {
        background: #f1f5f9;
        color: #0f172a;
        transform: translateY(-1px);
    }
    
    .topbar .nav-links .nav-link.active {
        background: #eef2ff;
        color: #4f46e5;
    }
    
    .topbar .nav-links .nav-link i {
        font-size: 16px;
    }
    
    .topbar .nav-links .nav-link-primary {
        background: linear-gradient(135deg, #2563eb, #4f46e5);
        color: white;
        padding: 8px 20px;
    }
    
    .topbar .nav-links .nav-link-primary:hover {
        background: linear-gradient(135deg, #1d4ed8, #4338ca);
        color: white;
        box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
        transform: translateY(-2px);
    }
    
    .topbar .nav-links .nav-link-success {
        background: #22c55e;
        color: white;
        padding: 8px 20px;
    }
    
    .topbar .nav-links .nav-link-success:hover {
        background: #16a34a;
        color: white;
        box-shadow: 0 4px 15px rgba(34, 197, 94, 0.3);
        transform: translateY(-2px);
    }
    
    /* User Profile Section */
    .topbar .user-section {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-left: 15px;
        padding-left: 15px;
        border-left: 1px solid #e2e8f0;
    }
    
    .topbar .user-section .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: linear-gradient(135deg, #2563eb, #4f46e5);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        font-size: 16px;
        cursor: pointer;
        transition: all 0.3s ease;
        flex-shrink: 0;
    }
    
    .topbar .user-section .user-avatar:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
    }
    
    .topbar .user-section .user-info {
        display: flex;
        flex-direction: column;
        line-height: 1.3;
    }
    
    .topbar .user-section .user-info .user-name {
        font-weight: 600;
        color: #0f172a;
        font-size: 14px;
    }
    
    .topbar .user-section .user-info .user-role {
        font-size: 12px;
        color: #94a3b8;
    }
    
    .topbar .user-section .user-info .user-role i {
        font-size: 10px;
        color: #22c55e;
    }
    
    /* Mobile Toggle */
    .topbar .mobile-toggle {
        display: none;
        background: none;
        border: none;
        font-size: 24px;
        color: #0f172a;
        cursor: pointer;
        padding: 5px 10px;
        border-radius: 8px;
        transition: all 0.3s ease;
    }
    
    .topbar .mobile-toggle:hover {
        background: #f1f5f9;
    }
    
    /* Responsive */
    @media (max-width: 992px) {
        .topbar {
            padding: 0 15px;
        }
        
        .topbar-with-sidebar {
            margin-left: 0;
            width: 100%;
        }
        
        .topbar .nav-links {
            position: fixed;
            top: 70px;
            left: 0;
            right: 0;
            background: white;
            padding: 15px 20px;
            flex-direction: column;
            align-items: stretch;
            gap: 5px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: none;
            border-top: 1px solid #e2e8f0;
        }
        
        .topbar .nav-links.show {
            display: flex;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .topbar .nav-links .nav-link {
            padding: 12px 16px;
            justify-content: center;
            width: 100%;
        }
        
        .topbar .mobile-toggle {
            display: block;
        }
        
        .topbar .user-section {
            margin-left: auto;
            padding-left: 10px;
        }
        
        .topbar .user-section .user-info {
            display: none;
        }
        
        .topbar .brand .brand-text {
            font-size: 16px;
        }
        
        .topbar .brand .brand-sub {
            display: none;
        }
    }
    
    @media (max-width: 480px) {
        .topbar {
            height: 60px;
            padding: 0 12px;
        }
        
        .topbar .brand .brand-icon {
            width: 34px;
            height: 34px;
            font-size: 16px;
        }
        
        .topbar .brand .brand-text {
            font-size: 14px;
        }
        
        .topbar .user-section .user-avatar {
            width: 34px;
            height: 34px;
            font-size: 14px;
        }
        
        .topbar .nav-links {
            top: 60px;
            padding: 12px 15px;
        }
    }
</style>

<!-- Topbar -->
<nav class="topbar" id="topbar">
    
    <!-- Brand -->
    <a href="dashboard.jsp" class="brand">
        <div class="brand-icon">
            <i class="bi bi-box-seam"></i>
        </div>
        <div>
            <div class="brand-text">
                <span>Inventory</span>Pro
            </div>
            <div class="brand-sub">MANAGEMENT SYSTEM</div>
        </div>
    </a>
    
    <!-- Mobile Toggle -->
    <button class="mobile-toggle" id="mobileToggle" aria-label="Toggle navigation">
        <i class="bi bi-list"></i>
    </button>
    
    <!-- Navigation Links -->
    <div class="nav-links" id="navLinks">
        
        <!-- Dashboard Link -->
        <a href="dashboard.jsp" class="nav-link" id="navDashboard">
            <i class="bi bi-grid-1x2-fill"></i>
            Dashboard
        </a>
        
        <!-- Add Product Link -->
        <a href="addProduct.jsp" class="nav-link nav-link-primary" id="navAddProduct">
            <i class="bi bi-plus-circle"></i>
            Add Product
        </a>
        
        <!-- View Products Link -->
        <a href="ViewProductsServlet" class="nav-link" id="navViewProducts">
            <i class="bi bi-box-seam"></i>
            View Products
        </a>
        
        <!-- Categories Link -->
        <a href="categories.jsp" class="nav-link" id="navCategories">
            <i class="bi bi-tags"></i>
            Categories
        </a>
        
        <!-- User Section -->
        <div class="user-section">
            <div class="user-avatar" id="userAvatar" title="User Profile">
                <% 
                if(user != null && user.getFullname() != null && !user.getFullname().isEmpty()) {
                    out.print(user.getFullname().charAt(0));
                } else {
                    out.print("U");
                }
                %>
            </div>
            <div class="user-info">
                <div class="user-name">
                    <% if(user != null) { %>
                        <%= user.getFullname() != null ? user.getFullname() : "User" %>
                    <% } else { %>
                        Guest
                    <% } %>
                </div>
                <div class="user-role">
                    <i class="bi bi-circle-fill"></i>
                    <% if(user != null) { %>
                        Administrator
                    <% } else { %>
                        Not Logged In
                    <% } %>
                </div>
            </div>
        </div>
        
    </div>
    
</nav>

<script>
    // Mobile Toggle
    document.addEventListener('DOMContentLoaded', function() {
        const mobileToggle = document.getElementById('mobileToggle');
        const navLinks = document.getElementById('navLinks');
        
        if(mobileToggle) {
            mobileToggle.addEventListener('click', function() {
                navLinks.classList.toggle('show');
                const icon = this.querySelector('i');
                if(navLinks.classList.contains('show')) {
                    icon.className = 'bi bi-x-lg';
                } else {
                    icon.className = 'bi bi-list';
                }
            });
        }
        
        // Close mobile menu when clicking outside
        document.addEventListener('click', function(event) {
            const topbar = document.getElementById('topbar');
            if(topbar && !topbar.contains(event.target)) {
                navLinks.classList.remove('show');
                const icon = mobileToggle.querySelector('i');
                if(icon) {
                    icon.className = 'bi bi-list';
                }
            }
        });
        
        // Set active nav link based on current page
        const currentPath = window.location.pathname;
        const navLinksAll = document.querySelectorAll('.nav-links .nav-link');
        
        navLinksAll.forEach(function(link) {
            const href = link.getAttribute('href');
            if(href) {
                // Check if the current URL matches the link
                if(currentPath.endsWith(href) || 
                   (href === 'dashboard.jsp' && currentPath.endsWith('/') ) ||
                   (href === 'ViewProductsServlet' && currentPath.includes('ViewProductsServlet'))) {
                    link.classList.add('active');
                }
            }
        });
        
        // User avatar click - show profile options
        const userAvatar = document.getElementById('userAvatar');
        if(userAvatar) {
            userAvatar.addEventListener('click', function() {
                // You can implement dropdown menu here
                console.log('User profile clicked');
                // window.location.href = 'profile.jsp';
            });
        }
    });
    
    // Add class to topbar if sidebar exists
    document.addEventListener('DOMContentLoaded', function() {
        const topbar = document.getElementById('topbar');
        const sidebar = document.querySelector('.sidebar-wrapper');
        if(sidebar && topbar) {
            topbar.classList.add('topbar-with-sidebar');
        }
    });
</script>

<!-- Bootstrap Icons (if not already included) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">