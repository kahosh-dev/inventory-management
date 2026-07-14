package servlet;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteOrderServlet")
public class DeleteOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            
            OrderDAO dao = new OrderDAO();
            boolean success = dao.deleteOrder(orderId);
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "Order deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete order");
            }
            
            response.sendRedirect("OrderServlet");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid order ID");
            response.sendRedirect("OrderServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting order: " + e.getMessage());
            response.sendRedirect("OrderServlet");
        }
    }
}