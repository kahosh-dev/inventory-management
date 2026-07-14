package servlet;

import java.io.IOException;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    ProductDAO dao = new ProductDAO();

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Product product = dao.getProductById(id);

        request.setAttribute("product", product);

        request.getRequestDispatcher("editProduct.jsp")
               .forward(request, response);
    }

}