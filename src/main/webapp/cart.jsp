<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:useBean id="cartBean" class="org.example.sessiontracking.CartBean" scope="session"/>

<%
    if (session.getAttribute("cartBean") == null) {
        session.setAttribute("cartBean", new org.example.sessiontracking.CartBean());
    }
    org.example.sessiontracking.CartBean cart = (org.example.sessiontracking.CartBean) session.getAttribute("cartBean");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - SessionApp</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<%@ include file="header.jsp" %>

<main class="container">
    <div class="card fade-in">
        <h1>Giỏ hàng của bạn</h1>

        <% if (cart.getItemCount() == 0) { %>
        <div class="alert alert-error">
            <p>Giỏ hàng trống! <a href="<%= request.getContextPath() %>/products">Mua sắm ngay</a></p>
        </div>
        <% } else { %>
        <div class="cart-items">
            <%
                java.util.List<org.example.sessiontracking.Product> items = cart.getItems();
                for (int i = 0; i < items.size(); i++) {
                    org.example.sessiontracking.Product product = items.get(i);
            %>
            <div class="cart-item">
                <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>"
                     style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px; margin-right: 15px;">

                <div style="flex-grow: 1;">
                    <h4><%= product.getName() %></h4>
                    <p style="color: var(--text-light);"><%= product.getDescription() %></p>
                    <strong style="color: var(--primary-dark);">$<%= product.getPrice() %></strong>
                </div>

                <button onclick="removeFromCart(<%= i %>)" class="btn btn-danger">Xóa</button>
            </div>
            <% } %>

            <div style="text-align: right; margin-top: 20px; padding-top: 20px; border-top: 2px solid #eee;">
                <h3>Tổng tiền: $<%= String.format("%.2f", cart.getTotalPrice()) %></h3>
                <div style="margin-top: 15px;">
                    <button onclick="clearCart()" class="btn btn-warning">Xóa tất cả</button>
                    <button class="btn btn-success" style="margin-left: 10px;">Thanh toán</button>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</main>

<script src="js/app.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Force sync when cart page loads
        const user = document.querySelector('.nav-links a[href="logout"]');
        if (user) {
            syncCartWithServer();
        }

        const serverCartSize = <%= cart.getItemCount() %>;
        const localCart = getCartFromLocalStorage();

        // If server cart is empty but localStorage has items, sync again
        if (serverCartSize === 0 && localCart.length > 0) {
            console.log('Server cart empty, re-syncing...');
            setTimeout(() => {
                syncCartWithServer();
                setTimeout(() => window.location.reload(), 1000);
            }, 500);
        }

        // Update badge
        updateCartBadge();
    });
</script>
</body>
</html>