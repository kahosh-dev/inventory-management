package dao;

import model.Order;
import model.OrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    private Connection connection;
    
    public OrderDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/inventory_db?useSSL=false&serverTimezone=UTC";
            String username = "root";
            String password = "y0bra254"; // Change this to your MySQL password
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("OrderDAO: Database connected successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Create order
    public boolean createOrder(Order order) {
        String sql = "INSERT INTO orders (order_number, supplier_id, order_date, delivery_date, status, total_amount, payment_status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, order.getOrderNumber());
            ps.setInt(2, order.getSupplierId());
            ps.setDate(3, new java.sql.Date(order.getOrderDate().getTime()));
            ps.setDate(4, order.getDeliveryDate() != null ? new java.sql.Date(order.getDeliveryDate().getTime()) : null);
            ps.setString(5, order.getStatus());
            ps.setDouble(6, order.getTotalAmount());
            ps.setString(7, order.getPaymentStatus());
            ps.setString(8, order.getNotes());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    order.setOrderId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all orders
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, s.supplier_name FROM orders o LEFT JOIN suppliers s ON o.supplier_id = s.id ORDER BY o.order_date DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setSupplierId(rs.getInt("supplier_id"));
                order.setSupplierName(rs.getString("supplier_name"));
                order.setOrderDate(rs.getDate("order_date"));
                order.setDeliveryDate(rs.getDate("delivery_date"));
                order.setStatus(rs.getString("status"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setNotes(rs.getString("notes"));
                orders.add(order);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // Delete order
    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
 // Add these methods to OrderDAO.java

 // Get order by ID
 public Order getOrderById(int orderId) {
     Order order = null;
     String sql = "SELECT o.*, s.supplier_name FROM orders o LEFT JOIN suppliers s ON o.supplier_id = s.id WHERE o.order_id = ?";
     
     try (PreparedStatement ps = connection.prepareStatement(sql)) {
         ps.setInt(1, orderId);
         ResultSet rs = ps.executeQuery();
         
         if (rs.next()) {
             order = new Order();
             order.setOrderId(rs.getInt("order_id"));
             order.setOrderNumber(rs.getString("order_number"));
             order.setSupplierId(rs.getInt("supplier_id"));
             order.setSupplierName(rs.getString("supplier_name"));
             order.setOrderDate(rs.getDate("order_date"));
             order.setDeliveryDate(rs.getDate("delivery_date"));
             order.setStatus(rs.getString("status"));
             order.setTotalAmount(rs.getDouble("total_amount"));
             order.setPaymentStatus(rs.getString("payment_status"));
             order.setNotes(rs.getString("notes"));
         }
     } catch (SQLException e) {
         e.printStackTrace();
     }
     return order;
 }

 // Update order
 public boolean updateOrder(Order order) {
     String sql = "UPDATE orders SET status = ?, payment_status = ?, notes = ? WHERE order_id = ?";
     
     try (PreparedStatement ps = connection.prepareStatement(sql)) {
         ps.setString(1, order.getStatus());
         ps.setString(2, order.getPaymentStatus());
         ps.setString(3, order.getNotes());
         ps.setInt(4, order.getOrderId());
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     }
 }

 // Delete order
 public boolean deleteOrder1(int orderId) {
     String sql = "DELETE FROM orders WHERE order_id = ?";
     try (PreparedStatement ps = connection.prepareStatement(sql)) {
         ps.setInt(1, orderId);
         return ps.executeUpdate() > 0;
     } catch (SQLException e) {
         e.printStackTrace();
         return false;
     }
 }
}