package servlet;

import dao.OrderDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/UpdateOrderServlet")
public class UpdateOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");
            String notes = request.getParameter("notes");
            
            OrderDAO dao = new OrderDAO();
            Order order = dao.getOrderById(orderId);
            
            if (order != null) {
                order.setStatus(status);
                order.setPaymentStatus(paymentStatus);
                order.setNotes(notes);
                
                boolean success = dao.updateOrder(order);
                dao.closeConnection();
                
                if (success) {
                    session.setAttribute("successMessage", "Order updated successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to update order");
                }
            } else {
                session.setAttribute("errorMessage", "Order not found");
            }
            
            response.sendRedirect("OrderServlet");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating order: " + e.getMessage());
            response.sendRedirect("OrderServlet");
        }
    }
}