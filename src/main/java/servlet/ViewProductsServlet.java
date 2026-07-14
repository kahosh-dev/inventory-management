package servlet;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewProductsServlet")
public class ViewProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            ProductDAO dao = new ProductDAO();
            List<Product> products = dao.getAllProducts();
            dao.closeConnection();
            
            // Set products as request attribute
            request.setAttribute("products", products);
            
            // Forward to viewProducts.jsp
            request.getRequestDispatcher("viewProducts.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading products: " + e.getMessage());
            response.sendRedirect("viewProducts.jsp");
        }
    }
}