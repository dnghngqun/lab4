package org.example.sessiontracking;

import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet(urlPatterns = {"/register", "/login", "/logout", "/profile"})
public class AuthServlet extends HttpServlet {
    private static final ConcurrentHashMap<String, User> users = new ConcurrentHashMap<>();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        switch (action) {
            case "/register":
                handleRegister(req, resp);
                break;
            case "/login":
                handleLogin(req, resp);
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        switch (action) {
            case "/logout":
                handleLogout(req, resp);
                break;
            case "/profile":
                handleProfile(req, resp);
                break;
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");

        if (users.containsKey(username)) {
            resp.sendRedirect("register.jsp?error=exists");
            return;
        }

        User user = new User(username, password, fullName, email);
        users.put(username, user);
        resp.sendRedirect("login.jsp?registered=true");
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = users.get(username);
        if (user != null && user.getPassword().equals(password)) {
            user.setLoginTime(System.currentTimeMillis());

            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(60); // 1 phút

            // Tạo CartBean mới cho session
            CartBean cartBean = new CartBean();
            session.setAttribute("cartBean", cartBean);

            // Set cookie
            Cookie cookie = new Cookie("username", username);
            cookie.setMaxAge(60 * 60 * 24); // 1 ngày
            cookie.setPath("/");
            resp.addCookie(cookie);

            resp.sendRedirect("dashboard.jsp?loginSuccess=true");
        } else {
            resp.sendRedirect("login.jsp?error=invalid");
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    resp.addCookie(cookie);
                }
            }
        }

        resp.sendRedirect("index.jsp?logout=true");
    }

    private void handleProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        resp.setContentType("application/json; charset=UTF-8");
        Jsonb jsonb = JsonbBuilder.create();
        String json = jsonb.toJson(user);
        resp.getWriter().write(json);
    }
}