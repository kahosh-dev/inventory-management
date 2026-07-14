package servlet;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateCategoryServlet")
public class UpdateCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get parameters
            String idParam = request.getParameter("id");
            String categoryName = request.getParameter("categoryName");
            
            // Validate ID
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid category ID");
                response.sendRedirect("CategoryServlet");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            
            // Validate category name
            if (categoryName == null || categoryName.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Category name is required!");
                response.sendRedirect("EditCategoryServlet?id=" + id);
                return;
            }
            
            CategoryDAO dao = new CategoryDAO();
            boolean success = dao.updateCategory(id, categoryName.trim());
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "Category updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update category. Name may already exist.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid category ID format");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating category: " + e.getMessage());
        }
        
        response.sendRedirect("CategoryServlet");
    }
}