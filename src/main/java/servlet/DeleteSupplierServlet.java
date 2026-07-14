package servlet;

import dao.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteSupplierServlet")
public class DeleteSupplierServlet extends HttpServlet {
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
                session.setAttribute("errorMessage", "Invalid supplier ID");
                response.sendRedirect("ViewSuppliersServlet");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            
            SupplierDAO dao = new SupplierDAO();
            boolean success = dao.deleteSupplier(id);
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "Supplier deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete supplier.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid supplier ID format");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting supplier: " + e.getMessage());
        }
        
        response.sendRedirect("ViewSuppliersServlet");
    }
}