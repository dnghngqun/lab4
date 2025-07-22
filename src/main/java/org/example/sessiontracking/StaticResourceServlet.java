package org.example.sessiontracking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

@WebServlet(urlPatterns = {"/css/*", "/js/*", "/images/*"})
public class StaticResourceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String resourcePath = requestURI.substring(contextPath.length());

        // Xác định content type
        String contentType = getContentType(resourcePath);
        resp.setContentType(contentType);

        // Load resource từ webapp folder
        InputStream resourceStream = getServletContext().getResourceAsStream(resourcePath);

        if (resourceStream == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try (OutputStream out = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = resourceStream.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } finally {
            resourceStream.close();
        }
    }

    private String getContentType(String resourcePath) {
        if (resourcePath.endsWith(".css")) {
            return "text/css";
        } else if (resourcePath.endsWith(".js")) {
            return "application/javascript";
        } else if (resourcePath.endsWith(".png")) {
            return "image/png";
        } else if (resourcePath.endsWith(".jpg") || resourcePath.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (resourcePath.endsWith(".gif")) {
            return "image/gif";
        }
        return "application/octet-stream";
    }
}