package servlet;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EditCategoryServlet")
public class EditCategoryServlet extends HttpServlet {
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
            String categoryName = dao.getCategoryNameById(id);
            dao.closeConnection();
            
            if (categoryName != null) {
                request.setAttribute("categoryId", id);
                request.setAttribute("categoryName", categoryName);
                request.getRequestDispatcher("editCategory.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Category not found");
                response.sendRedirect("CategoryServlet");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid category ID format");
            response.sendRedirect("CategoryServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading category: " + e.getMessage());
            response.sendRedirect("CategoryServlet");
        }
    }
}