package servlet;

import java.io.IOException;
import java.util.List;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet("/SearchProductServlet")
public class SearchProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        List<Product> products = dao.searchProducts(keyword);

        request.setAttribute("products", products);

        request.getRequestDispatcher("viewProducts.jsp")
               .forward(request, response);
    }
}