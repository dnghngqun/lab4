package org.example.sessiontracking;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@WebServlet(urlPatterns = {"/products", "/product/add", "/product/edit", "/product/delete"})
public class ProductServlet extends HttpServlet {
    private static final ConcurrentHashMap<Integer, Product> products = new ConcurrentHashMap<>();
    private static final AtomicInteger productIdCounter = new AtomicInteger(1);

    static {
        products.put(1, new Product(1, "iPhone 15", 999.99, "Latest iPhone",
                "https://cdn2.cellphones.com.vn/x/media/catalog/product/i/p/iphone-15-plus-256gb_3.png"));
        products.put(2, new Product(2, "Samsung Galaxy S24", 899.99, "Latest Samsung",
                "https://samcenter.vn/images/thumbs/0008920_xanh-blue.png"));
        productIdCounter.set(3);
    }

    public static Product getProduct(int id) {
        return products.get(id);
    }

    public static ConcurrentHashMap<Integer, Product> getAllProducts() {
        return products;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        if ("/products".equals(action)) {
            req.setAttribute("products", products.values());
            RequestDispatcher dispatcher = req.getRequestDispatcher("/products.jsp");
            dispatcher.forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        switch (action) {
            case "/product/add":
                addProduct(req, resp);
                break;
            case "/product/edit":
                editProduct(req, resp);
                break;
            case "/product/delete":
                deleteProduct(req, resp);
                break;
        }
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        double price = Double.parseDouble(req.getParameter("price"));
        String description = req.getParameter("description");
        String imageUrl = req.getParameter("imageUrl");

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = "https://via.placeholder.com/300x200?text=No+Image";
        }

        int id = productIdCounter.getAndIncrement();
        Product product = new Product(id, name, price, description, imageUrl);
        products.put(id, product);

        resp.sendRedirect(req.getContextPath() + "/products");
    }

    private void editProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        double price = Double.parseDouble(req.getParameter("price"));
        String description = req.getParameter("description");
        String imageUrl = req.getParameter("imageUrl");

        Product product = products.get(id);
        if (product != null) {
            product.setName(name);
            product.setPrice(price);
            product.setDescription(description);
            product.setImageUrl(imageUrl != null && !imageUrl.trim().isEmpty() ?
                    imageUrl : "https://via.placeholder.com/300x200?text=No+Image");
        }

        resp.sendRedirect(req.getContextPath() + "/products");
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        products.remove(id);
        resp.sendRedirect(req.getContextPath() + "/products");
    }
}