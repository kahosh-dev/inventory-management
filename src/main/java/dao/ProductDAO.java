package dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO {
    
    private Connection connection;
    
    public ProductDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/inventory_db?useSSL=false&serverTimezone=UTC";
            String username = "root";
            String password = "y0bra254"; // CHANGE THIS - if your MySQL has a password, put it here
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("ProductDAO: Database connected successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("ProductDAO: MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("ProductDAO: Database connection failed!");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // ============================================
    // CHECK CONNECTION HELPER
    // ============================================
    private boolean isConnected() {
        try {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
    
    // ============================================
    // GET ALL PRODUCTS
    // ============================================
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return products;
        }
        
        String sql = "SELECT * FROM products ORDER BY id DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getDouble("price"));
                product.setStatus(rs.getString("status"));
                products.add(product);
            }
            
        } catch (SQLException e) {
            System.err.println("ProductDAO: Error getting products - " + e.getMessage());
            e.printStackTrace();
        }
        
        return products;
    }
    
    // ============================================
    // PRODUCT COUNT METHODS
    // ============================================
    
    // Get total product count
    public int getProductCount() {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return 0;
        }
        
        String sql = "SELECT COUNT(*) FROM products";
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
    
    // Get low stock count (products with quantity <= 5)
    public int getLowStockCount() {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return 0;
        }
        
        String sql = "SELECT COUNT(*) FROM products WHERE quantity <= 5 AND quantity > 0";
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
    
    // Get out of stock count
    public int getOutOfStockCount() {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return 0;
        }
        
        String sql = "SELECT COUNT(*) FROM products WHERE quantity <= 0";
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
    
    // ============================================
    // GET RECENT PRODUCTS
    // ============================================
    
    // Get recent products
    public List<Map<String, Object>> getRecentProducts(int limit) {
        List<Map<String, Object>> products = new ArrayList<>();
        
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return products;
        }
        
        String sql = "SELECT id, product_name, category, quantity, price, status FROM products ORDER BY id DESC LIMIT ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("product_name"));
                product.put("category", rs.getString("category"));
                product.put("quantity", rs.getInt("quantity"));
                product.put("price", rs.getDouble("price"));
                product.put("status", rs.getString("status") != null ? rs.getString("status") : "In Stock");
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    // ============================================
    // CATEGORY DISTRIBUTION
    // ============================================
    
    // Get category distribution
    public List<Map<String, Object>> getCategoryDistribution() {
        List<Map<String, Object>> distribution = new ArrayList<>();
        
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return distribution;
        }
        
        String sql = "SELECT category, COUNT(*) as count FROM products WHERE category IS NOT NULL AND category != '' GROUP BY category ORDER BY count DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("category", rs.getString("category"));
                item.put("count", rs.getInt("count"));
                distribution.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distribution;
    }
    
    // ============================================
    // CRUD OPERATIONS
    // ============================================
    
    // Add product
    public boolean addProduct(Product product) {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return false;
        }
        
        String sql = "INSERT INTO products (product_name, category, quantity, price, status) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getCategory());
            ps.setInt(3, product.getQuantity());
            ps.setDouble(4, product.getPrice());
            ps.setString(5, product.getStatus() != null ? product.getStatus() : "In Stock");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get product by ID
    public Product getProductById(int id) {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return null;
        }
        
        Product product = null;
        String sql = "SELECT * FROM products WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getDouble("price"));
                product.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }
    
    // Update product
    public boolean updateProduct(Product product) {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return false;
        }
        
        String sql = "UPDATE products SET product_name = ?, category = ?, quantity = ?, price = ?, status = ? WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getCategory());
            ps.setInt(3, product.getQuantity());
            ps.setDouble(4, product.getPrice());
            ps.setString(5, product.getStatus());
            ps.setInt(6, product.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete product
    public boolean deleteProduct(int id) {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return false;
        }
        
        String sql = "DELETE FROM products WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Search products
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return products;
        }
        
        String sql = "SELECT * FROM products WHERE product_name LIKE ? OR category LIKE ? ORDER BY product_name ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getDouble("price"));
                product.setStatus(rs.getString("status"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    // ============================================
    // DASHBOARD METHODS
    // ============================================
    
    // Get total value of inventory
    public double getTotalInventoryValue() {
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return 0;
        }
        
        String sql = "SELECT SUM(quantity * price) as total FROM products";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get products by category
    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        
        if (!isConnected()) {
            System.err.println("ProductDAO: No database connection!");
            return products;
        }
        
        String sql = "SELECT * FROM products WHERE category = ? ORDER BY product_name ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getDouble("price"));
                product.setStatus(rs.getString("status"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    // ============================================
    // CLOSE CONNECTION
    // ============================================
    
    // Close connection
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("ProductDAO: Connection closed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}