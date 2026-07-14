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

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            String userIdParam = request.getParameter("userId");
            
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid user ID");
                response.sendRedirect("UserManagementServlet");
                return;
            }
            
            int userId = Integer.parseInt(userIdParam);
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            
            if (username == null || username.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Username is required!");
                response.sendRedirect("EditUserServlet?id=" + userId);
                return;
            }
            
            UserDAO dao = new UserDAO();
            
            // Check if username exists for other users
            User existingUser = dao.getUserById(userId);
            if (existingUser != null && !existingUser.getUsername().equals(username.trim())) {
                if (dao.usernameExists(username.trim())) {
                    session.setAttribute("errorMessage", "Username already exists!");
                    response.sendRedirect("EditUserServlet?id=" + userId);
                    return;
                }
            }
            
            User user = new User();
            user.setId(userId);
            user.setUsername(username.trim());
            user.setFullname(username.trim()); // Use username as fullname
            user.setEmail(email != null ? email.trim() : "");
            user.setRole(role != null ? role : "User");
            user.setStatus(status != null ? status : "Active");
            
            boolean success = dao.updateUser(user);
            
            if (success) {
                session.setAttribute("successMessage", "User updated successfully!");
                response.sendRedirect("UserManagementServlet");
            } else {
                session.setAttribute("errorMessage", "Failed to update user");
                response.sendRedirect("EditUserServlet?id=" + userId);
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid user ID format");
            response.sendRedirect("UserManagementServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect("UserManagementServlet");
        }
    }
}