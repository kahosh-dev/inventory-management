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

@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {
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
            
            UserDAO dao = new UserDAO();
            User user = dao.getUserById(userId);
            
            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("editUser.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "User not found");
                response.sendRedirect("UserManagementServlet");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid user ID format");
            response.sendRedirect("UserManagementServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading user: " + e.getMessage());
            response.sendRedirect("UserManagementServlet");
        }
    }
}