package servlet;

import java.io.IOException;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String productName = request.getParameter("productName");
        String category = request.getParameter("category");

        int quantity = Integer.parseInt(request.getParameter("quantity"));

        double price = Double.parseDouble(request.getParameter("price"));

        Product product = new Product();

        product.setProductName(productName);
        product.setCategory(category);
        product.setQuantity(quantity);
        product.setPrice(price);

        ProductDAO dao = new ProductDAO();

        boolean status = dao.addProduct(product);

        if(status){

            response.sendRedirect("success.jsp");

        }else{

            response.sendRedirect("error.jsp");

        }

    }

}