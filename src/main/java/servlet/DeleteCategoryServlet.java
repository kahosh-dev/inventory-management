package servlet;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteCategoryServlet")
public class DeleteCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid category ID");
                response.sendRedirect("CategoryServlet");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            
            CategoryDAO dao = new CategoryDAO();
            boolean success = dao.deleteCategoryById(id);
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "Category deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete category. It may be in use.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid category ID format");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting category: " + e.getMessage());
        }
        
        // Redirect to CategoryServlet to refresh the list
        response.sendRedirect("CategoryServlet");
    }
}