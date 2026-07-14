package servlet;

import java.io.IOException;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet("/UpdateProductServlet")
public class UpdateProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    ProductDAO dao = new ProductDAO();

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Product p = new Product();

        p.setId(Integer.parseInt(request.getParameter("id")));
        p.setProductName(request.getParameter("productName"));
        p.setCategory(request.getParameter("category"));
        p.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        p.setPrice(Double.parseDouble(request.getParameter("price")));

        dao.updateProduct(p);

        response.sendRedirect("ViewProductsServlet");

    }

}