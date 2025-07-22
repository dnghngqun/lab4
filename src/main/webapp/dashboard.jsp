<%@ page import="org.example.sessiontracking.User" %>
<%@ page import="org.example.sessiontracking.CartBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    User currentUser = (User) session.getAttribute("user");
    CartBean cartBean = (CartBean) session.getAttribute("cartBean");
    if (cartBean == null) {
        cartBean = new CartBean();
        session.setAttribute("cartBean", cartBean);
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SessionApp</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<%@ include file="header.jsp" %>

<main class="container">
    <c:if test="${param.loginSuccess eq 'true'}">
        <div class="alert alert-success">Đăng nhập thành công! Chào mừng bạn quay lại.</div>
    </c:if>

    <div class="card user-info fade-in">
        <h2>Thông tin người dùng</h2>
        <p><strong>Tên đăng nhập:</strong> ${sessionScope.user.username}</p>
        <p><strong>Họ và tên:</strong> ${sessionScope.user.fullName}</p>
        <p><strong>Email:</strong> ${sessionScope.user.email}</p>
        <p><strong>Thời gian đăng nhập:</strong> ${sessionScope.user.loginTime}</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
            <h4>Giỏ hàng</h4>
            <p>Số sản phẩm: <span id="cartCount"><%= cartBean.getItemCount() %></span></p>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-clock"></i></div>
            <h4>Thời gian online</h4>
            <p id="onlineTime">0 giây</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-user"></i></div>
            <h4>Session ID</h4>
            <p style="font-size: 0.8rem; word-break: break-all;"><%= session.getId() %></p>
        </div>
    </div>

    <div class="card">
        <h3>Hoạt động gần đây</h3>
        <p>Bạn đã đăng nhập thành công vào lúc <%= new java.util.Date(currentUser.getLoginTime()) %></p>
        <div style="margin-top: 1rem;">
            <a href="products" class="btn">Xem sản phẩm</a>
            <a href="cart" class="btn btn-success">Xem giỏ hàng</a>
        </div>
    </div>
</main>

<script src="js/app.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Check if we just reloaded to avoid infinite loop
        const hasReloaded = sessionStorage.getItem('dashboardReloaded');

        // Sync cart sau khi login thành công hoặc khi có cart trong localStorage
        const isLoginSuccess = window.location.search.includes('loginSuccess=true');
        const localCart = getCartFromLocalStorage();

        if ((isLoginSuccess || localCart.length > 0) && !hasReloaded) {
            syncCartWithServer().then(() => {
                // Mark that we're about to reload to prevent infinite loop
                sessionStorage.setItem('dashboardReloaded', 'true');
                setTimeout(() => {
                    location.reload();
                }, 500);
            });
        } else {
            // Clear the reload flag after successful load
            sessionStorage.removeItem('dashboardReloaded');
        }

        updateCartBadge();
    });

    // Update online time
    let startTime = <%= currentUser.getLoginTime() %>;
    setInterval(() => {
        let onlineSeconds = Math.floor((Date.now() - startTime) / 1000);
        document.getElementById('onlineTime').textContent = onlineSeconds + ' giây';
    }, 1000);
</script>
</body>
</html>