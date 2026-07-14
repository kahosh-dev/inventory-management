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
import java.util.List;

@WebServlet("/ViewSuppliersServlet")
public class ViewSuppliersServlet extends HttpServlet {
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
            System.out.println("=== ViewSuppliersServlet doGet called ===");
            
            SupplierDAO dao = new SupplierDAO();
            String keyword = request.getParameter("keyword");
            
            List<Supplier> suppliers;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                suppliers = dao.searchSuppliers(keyword.trim());
                System.out.println("Search results: " + suppliers.size());
            } else {
                suppliers = dao.getAllSuppliers();
                System.out.println("All suppliers: " + suppliers.size());
            }
            
            dao.closeConnection();
            
            // Set suppliers as request attribute
            request.setAttribute("suppliers", suppliers);
            
            // Forward to viewSuppliers.jsp (NOT redirect)
            request.getRequestDispatcher("viewSuppliers.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading suppliers: " + e.getMessage());
            response.sendRedirect("viewSuppliers.jsp");
        }
    }
}