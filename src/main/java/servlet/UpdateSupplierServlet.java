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

@WebServlet("/UpdateSupplierServlet")
public class UpdateSupplierServlet extends HttpServlet {
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
            // Get form data
            int id = Integer.parseInt(request.getParameter("id"));
            String supplierName = request.getParameter("supplierName");
            String contactPerson = request.getParameter("contactPerson");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String category = request.getParameter("category");
            String status = request.getParameter("status");
            
            // Validate required fields
            if (supplierName == null || supplierName.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Supplier name is required!");
                response.sendRedirect("EditSupplierServlet?id=" + id);
                return;
            }
            
            // Create Supplier object
            Supplier supplier = new Supplier();
            supplier.setId(id);
            supplier.setSupplierName(supplierName.trim());
            supplier.setContactPerson(contactPerson != null ? contactPerson.trim() : "");
            supplier.setEmail(email != null ? email.trim() : "");
            supplier.setPhone(phone != null ? phone.trim() : "");
            supplier.setAddress(address != null ? address.trim() : "");
            supplier.setCategory(category != null ? category.trim() : "General");
            supplier.setStatus(status != null ? status : "Active");
            
            // Update in database
            SupplierDAO dao = new SupplierDAO();
            boolean success = dao.updateSupplier(supplier);
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "Supplier '" + supplier.getSupplierName() + "' updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update supplier. Please try again.");
            }
            
            response.sendRedirect("ViewSuppliersServlet");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid supplier ID");
            response.sendRedirect("ViewSuppliersServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating supplier: " + e.getMessage());
            response.sendRedirect("ViewSuppliersServlet");
        }
    }
}