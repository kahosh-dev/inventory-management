package servlet;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Handle GET requests - display categories
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            System.out.println("=== CategoryServlet doGet called ===");
            
            CategoryDAO dao = new CategoryDAO();
            
            // Get categories with IDs for edit/delete
            List<String[]> categoriesWithIds = dao.getAllCategoriesWithIds();
            
            // Get just category names for display
            List<String> categories = dao.getAllCategories();
            
            dao.closeConnection();
            
            System.out.println("Categories retrieved: " + categories.size());
            
            // Set attributes
            request.setAttribute("categories", categories);
            request.setAttribute("categoriesWithIds", categoriesWithIds);
            
            // Forward to categories.jsp
            request.getRequestDispatcher("categories.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading categories: " + e.getMessage());
            response.sendRedirect("categories.jsp");
        }
    }
    
    // Handle POST requests - add new category
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get category name from form
        String categoryName = request.getParameter("categoryName");
        
        // Validate input
        if (categoryName == null || categoryName.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Category name is required!");
            response.sendRedirect("categories.jsp");
            return;
        }
        
        try {
            System.out.println("=== CategoryServlet doPost called ===");
            System.out.println("Adding category: " + categoryName.trim());
            
            CategoryDAO dao = new CategoryDAO();
            
            // Check if category already exists
            if (dao.categoryExists(categoryName.trim())) {
                session.setAttribute("errorMessage", "Category '" + categoryName.trim() + "' already exists!");
                response.sendRedirect("categories.jsp");
                return;
            }
            
            // Add the category
            boolean success = dao.addCategory(categoryName.trim());
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "Category '" + categoryName.trim() + "' added successfully!");
                System.out.println("Category added successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to add category. Please try again.");
                System.out.println("Failed to add category!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error adding category: " + e.getMessage());
        }
        
        // Redirect to the servlet to load the updated list
        response.sendRedirect("CategoryServlet");
    }
}