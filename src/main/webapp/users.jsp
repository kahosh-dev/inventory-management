<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="java.util.*"%>

<%
User currentUser = (User) session.getAttribute("user");

if(currentUser == null){
    response.sendRedirect("login.jsp");
    return;
}

List<User> users = (List<User>) request.getAttribute("users");
if(users == null) {
    users = new ArrayList<>();
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
<title>Users - Inventory Management</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    :root {
        --primary: #4f46e5;
        --success: #22c55e;
        --warning: #f59e0b;
        --danger: #ef4444;
        --gray-100: #f8fafc;
        --gray-200: #f1f5f9;
        --gray-600: #64748b;
        --dark: #0f172a;
        --white: #ffffff;
        --shadow: 0 4px 6px -1px rgba(0,0,0,0.07);
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
        text-decoration: none;
        color: white;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .top-bar .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
    }
    
    .card {
        background: var(--white);
        border-radius: var(--radius);
        border: none;
        box-shadow: var(--shadow);
        overflow: hidden;
    }
    
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
        width: 100%;
    }
    
    .table thead th {
        background: var(--gray-100);
        color: var(--gray-600);
        font-weight: 600;
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
        padding: 14px 18px;
        border-bottom: 2px solid #e2e8f0;
    }
    
    .table tbody td {
        padding: 14px 18px;
        vertical-align: middle;
        border-bottom: 1px solid var(--gray-200);
        color: var(--dark);
    }
    
    .table tbody tr:hover { background: var(--gray-100); }
    .table tbody tr:last-child td { border-bottom: none; }
    
    .user-cell {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--primary), #818cf8);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        font-size: 16px;
        flex-shrink: 0;
    }
    
    .status-badge {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }
    
    .status-badge.active { background: rgba(34, 197, 94, 0.12); color: #16a34a; }
    .status-badge.inactive { background: rgba(239, 68, 68, 0.12); color: #dc2626; }
    
    .role-badge {
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        display: inline-block;
    }
    
    .role-badge.admin { background: rgba(79, 70, 229, 0.12); color: var(--primary); }
    .role-badge.manager { background: rgba(14, 165, 233, 0.12); color: #0284c7; }
    .role-badge.user { background: rgba(34, 197, 94, 0.12); color: #16a34a; }
    
    .btn-action {
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 13px;
        border: none;
        transition: var(--transition);
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 4px;
    }
    
    .btn-action:hover { transform: translateY(-2px); }
    .btn-action.edit { background: rgba(79, 70, 229, 0.1); color: var(--primary); }
    .btn-action.edit:hover { background: var(--primary); color: white; }
    .btn-action.delete { background: rgba(239, 68, 68, 0.1); color: var(--danger); }
    .btn-action.delete:hover { background: var(--danger); color: white; }
    
    .empty-state {
        text-align: center;
        padding: 60px 20px;
    }
    
    .empty-state i {
        font-size: 64px;
        color: #cbd5e1;
        margin-bottom: 20px;
    }
    
    .empty-state h5 { color: var(--dark); font-weight: 600; margin-bottom: 8px; }
    .empty-state p { color: var(--gray-600); font-size: 14px; margin-bottom: 20px; }
    
    .empty-state .btn-primary {
        background: var(--primary);
        color: white;
        border: none;
        padding: 10px 24px;
        border-radius: var(--radius-sm);
        font-weight: 600;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: var(--transition);
    }
    
    .empty-state .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
    }
    
    .badge-count {
        background: #eef2ff;
        color: #4f46e5;
        padding: 4px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
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
    
    .alert-success { background: #dcfce7; color: #166534; border-left: 4px solid #22c55e; }
    .alert-danger { background: #fee2e2; color: #991b1b; border-left: 4px solid #ef4444; }
    .alert i { font-size: 20px; }
    
    @media (max-width: 992px) { .main-content { margin-left: 0; } }
    
    @media (max-width: 768px) {
        .main-content { padding: 16px; }
        .top-bar { flex-direction: column; align-items: stretch; }
        .top-bar .btn-primary { text-align: center; justify-content: center; }
        .table thead th,
        .table tbody td { padding: 10px 12px; font-size: 13px; }
    }
</style>

</head>

<body>

<div class="page-wrapper">
    
    <%@ include file="sidebar.jsp" %>
    
    <div class="main-content">
        
        <div class="top-bar">
            <div>
                <h1>Users <span>.</span></h1>
                <p><i class="bi bi-circle-fill" style="color: #22c55e; font-size: 10px;"></i> Manage system users</p>
            </div>
            <div>
                <a href="addUser.jsp" class="btn-primary">
                    <i class="bi bi-plus-circle"></i> Add User
                </a>
            </div>
        </div>
        
        <%
        if(successMessage != null) {
        %>
        <div class="alert alert-success">
            <i class="bi bi-check-circle-fill"></i>
            <%= successMessage %>
        </div>
        <%
        }
        if(errorMessage != null) {
        %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-circle-fill"></i>
            <%= errorMessage %>
        </div>
        <%
        }
        %>
        
        <div class="card">
            <div class="card-header">
                <span><i class="bi bi-people"></i> All Users</span>
                <span class="badge-count"><%= users.size() %> Users</span>
            </div>
            <div class="card-body">
                <div class="table-wrapper">
                    <%
                    if(users.isEmpty()) {
                    %>
                    <div class="empty-state">
                        <i class="bi bi-people"></i>
                        <h5>No Users Found</h5>
                        <p>Start by adding your first user to the system.</p>
                        <a href="addUser.jsp" class="btn-primary">
                            <i class="bi bi-plus-circle"></i> Add User
                        </a>
                    </div>
                    <%
                    } else {
                    %>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for(User user : users) {
                                String roleClass = user.getRole() != null ? user.getRole().toLowerCase() : "user";
                                String statusClass = user.getStatus() != null ? user.getStatus().toLowerCase() : "inactive";
                            %>
                            <tr>
                                <td>
                                    <div class="user-cell">
                                        <div class="user-avatar"><%= user.getFullname() != null ? user.getFullname().charAt(0) : 'U' %></div>
                                        <div>
                                            <div class="fw-semibold"><%= user.getFullname() != null ? user.getFullname() : "N/A" %></div>
                                            <div class="text-muted small">ID: #<%= user.getId() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td><%= user.getUsername() != null ? user.getUsername() : "N/A" %></td>
                                <td><%= user.getEmail() != null && !user.getEmail().isEmpty() ? user.getEmail() : "N/A" %></td>
                                <td><span class="role-badge <%= roleClass %>"><%= user.getRole() != null ? user.getRole() : "User" %></span></td>
                                <td><span class="status-badge <%= statusClass %>"><%= user.getStatus() != null ? user.getStatus() : "Inactive" %></span></td>
                                <td>
                                    <button class="btn-action edit" onclick="editUser(<%= user.getId() %>)">
                                        <i class="bi bi-pencil"></i> Edit
                                    </button>
                                    <button class="btn-action delete" onclick="deleteUser(<%= user.getId() %>)">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>
                                </td>
                            </tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                    <%
                    }
                    %>
                </div>
            </div>
        </div>
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function editUser(id) {
        window.location.href = 'EditUserServlet?id=' + id;
    }
    
    function deleteUser(id) {
        if(confirm('Are you sure you want to delete this user?')) {
            window.location.href = 'DeleteUserServlet?id=' + id;
        }
    }
</script>

</body>
</html>