package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.User;
import util.DBConnection;

public class UserDAO {

    private Connection connection;
    
    public UserDAO() {
        try {
            this.connection = DBConnection.getConnection();
            if (this.connection != null) {
                System.out.println("UserDAO: Connected!");
            }
        } catch (Exception e) {
            System.err.println("UserDAO: Connection failed!");
            e.printStackTrace();
        }
    }

    public boolean addUser(User user) {
        if (connection == null) {
            System.err.println("UserDAO: No connection!");
            return false;
        }
        
        String sql = "INSERT INTO users (username, password, fullname, email, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullname() != null ? user.getFullname() : user.getUsername());
            ps.setString(4, user.getEmail() != null ? user.getEmail() : "");
            ps.setString(5, user.getRole() != null ? user.getRole() : "User");
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "Active");
            
            int result = ps.executeUpdate();
            ps.close();
            
            System.out.println("UserDAO: Added user, result=" + result);
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("UserDAO: SQL Error - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean usernameExists(String username) {
        if (connection == null) return false;
        
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        if (connection == null) return users;
        
        String sql = "SELECT * FROM users ORDER BY username ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullname(rs.getString("fullname") != null ? rs.getString("fullname") : rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                users.add(user);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(int userId) {
        User user = null;
        if (connection == null) return null;
        
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullname(rs.getString("fullname") != null ? rs.getString("fullname") : rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateUser(User user) {
        if (connection == null) return false;
        
        String sql = "UPDATE users SET username = ?, fullname = ?, email = ?, role = ?, status = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFullname() != null ? user.getFullname() : user.getUsername());
            ps.setString(3, user.getEmail() != null ? user.getEmail() : "");
            ps.setString(4, user.getRole() != null ? user.getRole() : "User");
            ps.setString(5, user.getStatus() != null ? user.getStatus() : "Active");
            ps.setInt(6, user.getId());
            
            int result = ps.executeUpdate();
            ps.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        if (connection == null) return false;
        
        String sql = "DELETE FROM users WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            int result = ps.executeUpdate();
            ps.close();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User login(String username, String password) {
        if (connection == null) return null;
        
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullname(rs.getString("fullname") != null ? rs.getString("fullname") : rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                rs.close();
                ps.close();
                return user;
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Only call this when completely done with the DAO
    public void closeConnection() {
        // Don't close the static connection here - let DBConnection manage it
    }
}