package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    private static Connection connection = null;
    
    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/inventory_db?useSSL=false&serverTimezone=UTC";
                String username = "root";
                String password = "y0bra254"; // Change this to your MySQL password
                connection = DriverManager.getConnection(url, username, password);
                System.out.println("DBConnection: Connected successfully!");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("DBConnection: MySQL Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("DBConnection: Connection failed!");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
        return connection;
    }
    
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                connection = null;
                System.out.println("DBConnection: Connection closed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

	public static boolean testConnection() {
		// TODO Auto-generated method stub
		return false;
	}
}