package org.example.sessiontracking;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/remove", "/cart/clear", "/cart/sync"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();
        HttpSession session = req.getSession();

        // Lấy hoặc tạo CartBean
        CartBean cartBean = (CartBean) session.getAttribute("cartBean");
        if (cartBean == null) {
            cartBean = new CartBean();
            session.setAttribute("cartBean", cartBean);
        }

        switch (action) {
            case "/cart/add":
                addToCart(req, resp, cartBean);
                break;
            case "/cart/sync":
                syncCart(req, resp, cartBean);
                break;
        }
    }

    private void addToCart(HttpServletRequest req, HttpServletResponse resp, CartBean cartBean) throws IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        Product product = ProductServlet.getProduct(productId);

        if (product != null) {
            cartBean.addProduct(product);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"status\":\"success\",\"cartSize\":" + cartBean.getItemCount() + "}");
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Product not found\"}");
        }
    }

    private void syncCart(HttpServletRequest req, HttpServletResponse resp, CartBean cartBean) throws IOException {
        try {
            StringBuilder jsonBuilder = new StringBuilder();
            try (BufferedReader reader = req.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }

            ObjectMapper mapper = new ObjectMapper();
            JsonNode cartArray = mapper.readTree(jsonBuilder.toString());

            List<Product> localProducts = new ArrayList<>();
            for (JsonNode item : cartArray) {
                int productId = item.get("id").asInt();
                Product product = ProductServlet.getProduct(productId);
                if (product != null) {
                    localProducts.add(product);
                }
            }

            cartBean.syncWithLocalStorage(localProducts);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"status\":\"success\",\"cartSize\":" + cartBean.getItemCount() + "}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();
        HttpSession session = req.getSession();

        CartBean cartBean = (CartBean) session.getAttribute("cartBean");
        if (cartBean == null) {
            cartBean = new CartBean();
            session.setAttribute("cartBean", cartBean);
        }

        switch (action) {
            case "/cart/clear":
                cartBean.clear();
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            case "/cart/remove":
                String indexStr = req.getParameter("index");
                if (indexStr != null) {
                    int index = Integer.parseInt(indexStr);
                    cartBean.removeProduct(index);
                }
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
        }

        RequestDispatcher dispatcher = req.getRequestDispatcher("/cart.jsp");
        dispatcher.forward(req, resp);
    }
}