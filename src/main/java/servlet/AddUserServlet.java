package servlet;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddUserServlet")
public class AddUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        System.out.println("=== AddUserServlet called ===");
        
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            
            System.out.println("Username: " + username);
            System.out.println("Password: " + password);
            System.out.println("Email: " + email);
            System.out.println("Role: " + role);
            System.out.println("Status: " + status);
            
            if (username == null || username.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Username is required!");
                response.sendRedirect("addUser.jsp");
                return;
            }
            
            if (password == null || password.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Password is required!");
                response.sendRedirect("addUser.jsp");
                return;
            }
            
            UserDAO dao = new UserDAO();
            
            if (dao.usernameExists(username.trim())) {
                session.setAttribute("errorMessage", "Username already exists!");
                response.sendRedirect("addUser.jsp");
                return;
            }
            
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(password.trim());
            user.setFullname(username.trim());
            user.setEmail(email != null ? email.trim() : "");
            user.setRole(role != null ? role : "User");
            user.setStatus(status != null ? status : "Active");
            
            boolean success = dao.addUser(user);
            
            if (success) {
                System.out.println("User added successfully: " + username);
                session.setAttribute("successMessage", "User added successfully!");
                response.sendRedirect("UserManagementServlet");
            } else {
                System.out.println("Failed to add user: " + username);
                session.setAttribute("errorMessage", "Failed to add user.");
                response.sendRedirect("addUser.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect("addUser.jsp");
        }
    }
}