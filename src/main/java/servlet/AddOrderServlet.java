package servlet;

import dao.OrderDAO;
import dao.SupplierDAO;
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

@WebServlet("/AddOrderServlet")
public class AddOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String orderDateStr = request.getParameter("orderDate");
            String deliveryDateStr = request.getParameter("deliveryDate");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String status = request.getParameter("status");
            String paymentStatus = request.getParameter("paymentStatus");
            String notes = request.getParameter("notes");
            
            // Validate
            if (supplierId <= 0 || orderDateStr == null || orderDateStr.isEmpty()) {
                request.setAttribute("error", "Supplier and Order Date are required!");
                request.getRequestDispatcher("addOrder.jsp").forward(request, response);
                return;
            }
            
            // Create Order object
            Order order = new Order();
            order.setSupplierId(supplierId);
            
            // Parse dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date orderDate = sdf.parse(orderDateStr);
            order.setOrderDate(orderDate);
            
            if (deliveryDateStr != null && !deliveryDateStr.isEmpty()) {
                Date deliveryDate = sdf.parse(deliveryDateStr);
                order.setDeliveryDate(deliveryDate);
            }
            
            order.setTotalAmount(totalAmount);
            order.setStatus(status != null ? status : "Pending");
            order.setPaymentStatus(paymentStatus != null ? paymentStatus : "Unpaid");
            order.setNotes(notes);
            
            // Generate order number
            String orderNumber = "ORD-" + System.currentTimeMillis();
            order.setOrderNumber(orderNumber);
            
            // Save to database
            OrderDAO dao = new OrderDAO();
            boolean success = dao.createOrder(order);
            dao.closeConnection();
            
            if (success) {
                session.setAttribute("successMessage", "Order created successfully!");
                response.sendRedirect("OrderServlet");
            } else {
                request.setAttribute("error", "Failed to create order. Please try again.");
                request.getRequestDispatcher("addOrder.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("addOrder.jsp").forward(request, response);
        }
    }
}