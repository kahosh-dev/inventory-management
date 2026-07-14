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

@WebServlet("/EditOrderServlet")
public class EditOrderServlet extends HttpServlet {
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
            Order order = dao.getOrderById(orderId);
            dao.closeConnection();
            
            if (order != null) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("editOrder.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Order not found");
                response.sendRedirect("OrderServlet");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid order ID");
            response.sendRedirect("OrderServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading order: " + e.getMessage());
            response.sendRedirect("OrderServlet");
        }
    }
}