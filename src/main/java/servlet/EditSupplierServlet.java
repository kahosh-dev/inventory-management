package servlet;

import dao.SupplierDAO;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EditSupplierServlet")
public class EditSupplierServlet extends HttpServlet {
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
            Supplier supplier = dao.getSupplierById(id);
            dao.closeConnection();
            
            if (supplier != null) {
                request.setAttribute("supplier", supplier);
                request.getRequestDispatcher("editSupplier.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Supplier not found");
                response.sendRedirect("ViewSuppliersServlet");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid supplier ID format");
            response.sendRedirect("ViewSuppliersServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading supplier: " + e.getMessage());
            response.sendRedirect("ViewSuppliersServlet");
        }
    }
}