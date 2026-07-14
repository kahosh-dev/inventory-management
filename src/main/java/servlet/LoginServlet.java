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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("LoginServlet doGet called - redirecting to login.jsp");
        response.sendRedirect("login.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== LoginServlet doPost called ===");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            System.out.println("Username or password is empty");
            request.setAttribute("error", "Username and password are required!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.login(username.trim(), password.trim());
            
            System.out.println("User found: " + (user != null));
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                System.out.println("User stored in session. Redirecting to dashboard.jsp");
                response.sendRedirect("dashboard.jsp");
            } else {
                System.out.println("Invalid credentials");
                request.setAttribute("error", "Invalid username or password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Login error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}