<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="java.util.*"%>

<%
User user = (User) session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

Map<String, Object> reportData = (Map<String, Object>) request.getAttribute("reportData");
if(reportData == null) {
    reportData = new HashMap<>();
}

int totalProducts = reportData.containsKey("totalProducts") ? (int) reportData.get("totalProducts") : 0;
int lowStockCount = reportData.containsKey("lowStockCount") ? (int) reportData.get("lowStockCount") : 0;
int totalCategories = reportData.containsKey("totalCategories") ? (int) reportData.get("totalCategories") : 0;
int totalSuppliers = reportData.containsKey("totalSuppliers") ? (int) reportData.get("totalSuppliers") : 0;
List<Map<String, Object>> recentProducts = (List<Map<String, Object>>) reportData.get("recentProducts");
List<Map<String, Object>> categoryDistribution = (List<Map<String, Object>>) reportData.get("categoryDistribution");

if(recentProducts == null) recentProducts = new ArrayList<>();
if(categoryDistribution == null) categoryDistribution = new ArrayList<>();

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
<title>Reports - Inventory Management</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    :root {
        --primary: #4f46e5;
        --success: #22c55e;
        --warning: #f59e0b;
        --danger: #ef4444;
        --gray-200: #f1f5f9;
        --gray-600: #64748b;
        --gray-700: #475569;
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
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 28px;
    }
    
    .stat-card {
        background: var(--white);
        border-radius: var(--radius);
        padding: 20px 24px;
        box-shadow: var(--shadow);
        transition: var(--transition);
        border-top: 3px solid transparent;
    }
    
    .stat-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); }
    .stat-card.blue { border-top-color: var(--primary); }
    .stat-card.green { border-top-color: var(--success); }
    .stat-card.orange { border-top-color: var(--warning); }
    .stat-card.red { border-top-color: var(--danger); }
    
    .stat-card .stat-label {
        font-size: 13px;
        font-weight: 500;
        color: var(--gray-600);
        margin-bottom: 4px;
    }
    
    .stat-card .stat-value {
        font-size: 28px;
        font-weight: 700;
        color: var(--dark);
    }
    
    .report-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
        margin-bottom: 28px;
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
        color: var(--dark);
        font-size: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .card-header i { color: var(--primary); margin-right: 8px; }
    .card-body { padding: 24px; }
    
    .chart-container { position: relative; height: 220px; }
    
    .table-wrapper { overflow-x: auto; }
    
    .table {
        margin: 0;
        font-size: 14px;
    }
    
    .table thead th {
        background: var(--gray-200);
        color: var(--gray-700);
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
    
    .btn-export {
        padding: 8px 18px;
        border-radius: var(--radius-sm);
        background: var(--primary);
        color: white;
        border: none;
        font-weight: 500;
        font-size: 13px;
        transition: var(--transition);
        cursor: pointer;
    }
    
    .btn-export:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }
    
    .btn-export i { margin-right: 6px; }
    
    @media (max-width: 1200px) {
        .stats-grid { grid-template-columns: repeat(2, 1fr); }
        .report-grid { grid-template-columns: 1fr; }
    }
    
    @media (max-width: 992px) { .main-content { margin-left: 0; } }
    
    @media (max-width: 768px) {
        .main-content { padding: 16px; }
        .stats-grid { grid-template-columns: 1fr; }
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
                <h1>Reports <span>.</span></h1>
                <p><i class="bi bi-circle-fill" style="color: #22c55e; font-size: 10px;"></i> Inventory Analytics & Reports</p>
            </div>
            <div>
                <button class="btn-export" onclick="window.print()">
                    <i class="bi bi-printer"></i> Print Report
                </button>
                <button class="btn-export" style="background: #22c55e; margin-left: 8px;" onclick="exportData()">
                    <i class="bi bi-file-earmark-excel"></i> Export
                </button>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card blue">
                <div class="stat-label"><i class="bi bi-box-seam"></i> Total Products</div>
                <div class="stat-value"><%= totalProducts %></div>
            </div>
            <div class="stat-card red">
                <div class="stat-label"><i class="bi bi-exclamation-triangle"></i> Low Stock Items</div>
                <div class="stat-value"><%= lowStockCount %></div>
            </div>
            <div class="stat-card green">
                <div class="stat-label"><i class="bi bi-tags"></i> Categories</div>
                <div class="stat-value"><%= totalCategories %></div>
            </div>
            <div class="stat-card orange">
                <div class="stat-label"><i class="bi bi-truck"></i> Active Suppliers</div>
                <div class="stat-value"><%= totalSuppliers %></div>
            </div>
        </div>
        
        <div class="report-grid">
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-pie-chart"></i> Category Distribution</span>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="categoryChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-bar-chart"></i> Monthly Activity</span>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="monthlyChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <span><i class="bi bi-clock-history"></i> Recent Product Activity</span>
                <span class="badge bg-light text-dark"><%= recentProducts.size() %> Items</span>
            </div>
            <div class="card-body" style="padding: 0;">
                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Category</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if(recentProducts.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-3">No recent products found</td>
                            </tr>
                            <%
                            } else {
                                for(Map<String, Object> product : recentProducts) {
                                    String status = (String) product.get("status");
                                    String statusClass = "";
                                    if("In Stock".equals(status)) statusClass = "in-stock";
                                    else if("Low Stock".equals(status)) statusClass = "low-stock";
                                    else statusClass = "out-of-stock";
                            %>
                            <tr>
                                <td><strong><%= product.get("name") %></strong></td>
                                <td><span class="badge bg-light text-dark"><%= product.get("category") %></span></td>
                                <td><%= product.get("quantity") %></td>
                                <td>KES <%= product.get("price") %></td>
                                <td><span class="badge bg-<%= "In Stock".equals(status) ? "success" : "warning" %>"><%= status %></span></td>
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
    // Category Distribution Chart
    const ctx1 = document.getElementById('categoryChart').getContext('2d');
    new Chart(ctx1, {
        type: 'doughnut',
        data: {
            labels: ['Electronics', 'Accessories', 'Office Supplies', 'Furniture', 'Others'],
            datasets: [{
                data: [35, 25, 20, 12, 8],
                backgroundColor: ['#4f46e5', '#22c55e', '#f59e0b', '#0ea5e9', '#ef4444'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 12,
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                }
            },
            cutout: '65%'
        }
    });

    // Monthly Activity Chart
    const ctx2 = document.getElementById('monthlyChart').getContext('2d');
    new Chart(ctx2, {
        type: 'bar',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'Products Added',
                data: [12, 19, 15, 22, 18, 30],
                backgroundColor: 'rgba(79, 70, 229, 0.6)',
                borderColor: '#4f46e5',
                borderWidth: 1
            }, {
                label: 'Products Sold',
                data: [8, 14, 10, 18, 14, 25],
                backgroundColor: 'rgba(34, 197, 94, 0.6)',
                borderColor: '#22c55e',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        pointStyle: 'circle',
                        padding: 12
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(0,0,0,0.05)' }
                },
                x: {
                    grid: { display: false }
                }
            }
        }
    });

    function exportData() {
        alert('Export functionality coming soon!');
        // You can implement CSV/Excel export here
    }
</script>

</body>
</html>