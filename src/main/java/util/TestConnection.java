package util;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/TestDB")
public class TestConnection extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        try {
            boolean connected = DBConnection.testConnection();
            if (connected) {
                out.println("<p style='color:green'>✅ Database connected successfully!</p>");
            } else {
                out.println("<p style='color:red'>❌ Database connection failed!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}