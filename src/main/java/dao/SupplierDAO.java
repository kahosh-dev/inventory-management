package dao;

import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {
    
    private Connection connection;
    
    public SupplierDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/inventory_db?useSSL=false&serverTimezone=UTC";
            String username = "root";
            String password = "y0bra254"; // Change this to your MySQL password
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("=== Database connected successfully! ===");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Add new supplier
    public boolean addSupplier(Supplier supplier) {
        String sql = "INSERT INTO suppliers (supplier_name, contact_person, email, phone, address, category, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getContactPerson());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            ps.setString(6, supplier.getCategory());
            ps.setString(7, supplier.getStatus());
            
            int result = ps.executeUpdate();
            System.out.println("Supplier added: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error adding supplier: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all suppliers
    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers ORDER BY supplier_name ASC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setId(rs.getInt("id"));
                supplier.setSupplierName(rs.getString("supplier_name"));
                supplier.setContactPerson(rs.getString("contact_person"));
                supplier.setEmail(rs.getString("email"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setAddress(rs.getString("address"));
                supplier.setCategory(rs.getString("category"));
                supplier.setStatus(rs.getString("status"));
                supplier.setCreatedAt(rs.getString("created_at"));
                supplier.setUpdatedAt(rs.getString("updated_at"));
                suppliers.add(supplier);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting suppliers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return suppliers;
    }
    
    // Get supplier by ID
    public Supplier getSupplierById(int id) {
        Supplier supplier = null;
        String sql = "SELECT * FROM suppliers WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                supplier = new Supplier();
                supplier.setId(rs.getInt("id"));
                supplier.setSupplierName(rs.getString("supplier_name"));
                supplier.setContactPerson(rs.getString("contact_person"));
                supplier.setEmail(rs.getString("email"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setAddress(rs.getString("address"));
                supplier.setCategory(rs.getString("category"));
                supplier.setStatus(rs.getString("status"));
                supplier.setCreatedAt(rs.getString("created_at"));
                supplier.setUpdatedAt(rs.getString("updated_at"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting supplier by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return supplier;
    }
    
    // Update supplier
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE suppliers SET supplier_name = ?, contact_person = ?, email = ?, phone = ?, address = ?, category = ?, status = ? WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getContactPerson());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            ps.setString(6, supplier.getCategory());
            ps.setString(7, supplier.getStatus());
            ps.setInt(8, supplier.getId());
            
            int result = ps.executeUpdate();
            System.out.println("Supplier updated: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating supplier: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete supplier
    public boolean deleteSupplier(int id) {
        String sql = "DELETE FROM suppliers WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            int result = ps.executeUpdate();
            System.out.println("Supplier deleted: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting supplier: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Search suppliers
    public List<Supplier> searchSuppliers(String keyword) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE supplier_name LIKE ? OR contact_person LIKE ? OR email LIKE ? OR phone LIKE ? ORDER BY supplier_name ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setId(rs.getInt("id"));
                supplier.setSupplierName(rs.getString("supplier_name"));
                supplier.setContactPerson(rs.getString("contact_person"));
                supplier.setEmail(rs.getString("email"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setAddress(rs.getString("address"));
                supplier.setCategory(rs.getString("category"));
                supplier.setStatus(rs.getString("status"));
                suppliers.add(supplier);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching suppliers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return suppliers;
    }
    
    // Get active suppliers count
    public int getActiveSuppliersCount() {
        String sql = "SELECT COUNT(*) FROM suppliers WHERE status = 'Active'";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Close connection
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}