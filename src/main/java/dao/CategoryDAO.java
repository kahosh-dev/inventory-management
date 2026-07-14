package dao;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    private Connection connection;
    
    public CategoryDAO() {
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
            System.err.println("Database connection failed! Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Get all categories as Strings
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT category_name FROM categories ORDER BY category_name ASC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                String categoryName = rs.getString("category_name");
                categories.add(categoryName);
                System.out.println("Loaded category: " + categoryName);
            }
            
            System.out.println("Total categories loaded: " + categories.size());
            
        } catch (SQLException e) {
            System.err.println("Error getting categories: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // Get all categories as Category objects with IDs
    public List<Category> getAllCategoryObjects() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name FROM categories ORDER BY category_name ASC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                categories.add(category);
                System.out.println("Loaded category: ID=" + category.getCategoryId() + ", Name=" + category.getCategoryName());
            }
            
            System.out.println("Total categories loaded: " + categories.size());
            
        } catch (SQLException e) {
            System.err.println("Error getting categories: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // Get all categories with IDs as String array
    public List<String[]> getAllCategoriesWithIds() {
        List<String[]> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name FROM categories ORDER BY category_name ASC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                String[] category = new String[2];
                category[0] = String.valueOf(rs.getInt("category_id"));
                category[1] = rs.getString("category_name");
                categories.add(category);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting categories: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // Get category by ID
    public Category getCategoryById(int id) {
        Category category = null;
        String sql = "SELECT category_id, category_name FROM categories WHERE category_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting category by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return category;
    }
    
    // Get category name by ID
    public String getCategoryNameById(int id) {
        String sql = "SELECT category_name FROM categories WHERE category_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("category_name");
            }
        } catch (SQLException e) {
            System.err.println("Error getting category name: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    // Get category ID by name
    public int getCategoryIdByName(String name) {
        String sql = "SELECT category_id FROM categories WHERE category_name = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("category_id");
            }
        } catch (SQLException e) {
            System.err.println("Error getting category ID: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }
    
    // Check if category exists by name
    public boolean categoryExists(String categoryName) {
        String sql = "SELECT COUNT(*) FROM categories WHERE category_name = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Add new category
    public boolean addCategory(String categoryName) {
        if (categoryExists(categoryName)) {
            System.out.println("Category already exists: " + categoryName);
            return false;
        }
        
        String sql = "INSERT INTO categories (category_name) VALUES (?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            int result = ps.executeUpdate();
            System.out.println("Insert result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error adding category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Add new category from Category object
    public boolean addCategory(Category category) {
        return addCategory(category.getCategoryName());
    }
    
    // Update category
    public boolean updateCategory(int id, String newName) {
        // Check if new name already exists (excluding current category)
        String checkSql = "SELECT COUNT(*) FROM categories WHERE category_name = ? AND category_id != ?";
        
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setString(1, newName);
            checkPs.setInt(2, id);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("Category name already exists: " + newName);
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        String sql = "UPDATE categories SET category_name = ? WHERE category_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setInt(2, id);
            int result = ps.executeUpdate();
            System.out.println("Update result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete category by ID
    public boolean deleteCategoryById(int id) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            int result = ps.executeUpdate();
            System.out.println("Delete result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete category by name
    public boolean deleteCategoryByName(String name) {
        String sql = "DELETE FROM categories WHERE category_name = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            int result = ps.executeUpdate();
            System.out.println("Delete result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get category count
    public int getCategoryCount() {
        String sql = "SELECT COUNT(*) FROM categories";
        
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