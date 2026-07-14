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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid user ID");
                response.sendRedirect("UserManagementServlet");
                return;
            }
            
            int userId = Integer.parseInt(idParam);
            
            // Check if trying to delete yourself
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null && currentUser.getId() == userId) {
                session.setAttribute("errorMessage", "You cannot delete your own account!");
                response.sendRedirect("UserManagementServlet");
                return;
            }
            
            UserDAO dao = new UserDAO();
            boolean success = dao.deleteUser(userId);
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "User deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete user");
            }
            
            response.sendRedirect("UserManagementServlet");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid user ID format");
            response.sendRedirect("UserManagementServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting user: " + e.getMessage());
            response.sendRedirect("UserManagementServlet");
        }
    }
}