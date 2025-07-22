package org.example.sessiontracking;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class SessionFilter implements Filter {

    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/index.jsp", "/login.jsp", "/register.jsp", "/login", "/register",
            "/css/", "/js/", "/images/", "/error.jsp", "/products",
            "/favicon.ico"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Set UTF-8 encoding
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Check if path is public
        boolean isPublicPath = PUBLIC_PATHS.stream().anyMatch(path::startsWith);

        if (!isPublicPath) {
            HttpSession session = req.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            // Check session timeout
            User user = (User) session.getAttribute("user");
            if (user != null && user.isSessionExpired()) {
                session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/login.jsp?timeout=true");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}