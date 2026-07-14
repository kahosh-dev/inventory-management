package servlet;

import dao.ProductDAO;
import dao.CategoryDAO;
import dao.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            SupplierDAO supplierDAO = new SupplierDAO();
            
            // Get statistics - use try-catch to handle null connections
            int totalProducts = 0;
            int lowStockCount = 0;
            int totalCategories = 0;
            int totalSuppliers = 0;
            
            try {
                totalProducts = productDAO.getProductCount();
                lowStockCount = productDAO.getLowStockCount();
                totalCategories = categoryDAO.getCategoryCount();
                totalSuppliers = supplierDAO.getActiveSuppliersCount();
            } catch (Exception e) {
                System.err.println("Error getting stats: " + e.getMessage());
            }
            
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("lowStockCount", lowStockCount);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("totalSuppliers", totalSuppliers);
            
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            response.sendRedirect("dashboard.jsp");
        }
    }
}