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

        switch (action) {
            case "/cart/add":
                addToCart(req, resp);
                break;
            case "/cart/sync":
                syncCart(req, resp);
                break;
        }
    }

    private void addToCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        Product product = ProductServlet.getProduct(productId);

        if (product != null) {
            HttpSession session = req.getSession();
            @SuppressWarnings("unchecked")
            List<Product> cart = (List<Product>) session.getAttribute("cart");

            if (cart == null) {
                cart = new ArrayList<>();
                session.setAttribute("cart", cart);
            }
            cart.add(product);
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void syncCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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

            HttpSession session = req.getSession();
            List<Product> cart = new ArrayList<>();

            for (JsonNode item : cartArray) {
                int productId = item.get("id").asInt();
                Product product = ProductServlet.getProduct(productId);
                if (product != null) {
                    cart.add(product);
                }
            }

            session.setAttribute("cart", cart);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"status\":\"success\",\"cartSize\":" + cart.size() + "}");

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

        switch (action) {
            case "/cart/clear":
                session.removeAttribute("cart");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            case "/cart/remove":
                String indexStr = req.getParameter("index");
                if (indexStr != null) {
                    @SuppressWarnings("unchecked")
                    List<Product> cart = (List<Product>) session.getAttribute("cart");
                    if (cart != null) {
                        int index = Integer.parseInt(indexStr);
                        if (index >= 0 && index < cart.size()) {
                            cart.remove(index);
                        }
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
        }

        RequestDispatcher dispatcher = req.getRequestDispatcher("/cart.jsp");
        dispatcher.forward(req, resp);
    }
}