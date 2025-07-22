<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SessionApp - Ứng dụng quản lý phiên</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<header class="header">
    <nav class="nav container">
        <div class="logo">SessionApp</div>
        <ul class="nav-links">
            <li><a href="index.jsp">Trang Chủ</a></li>
            <li><a href="products">Sản Phẩm</a></li>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <li><a href="cart">Giỏ Hàng</a></li>
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li><a href="logout" class="btn btn-danger">Đăng Xuất</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="login.jsp" class="btn">Đăng Nhập</a></li>
                    <li><a href="register.jsp" class="btn btn-success">Đăng Ký</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</header>

<main class="container">
    <c:if test="${param.logout eq 'true'}">
        <div class="alert alert-success">Đăng xuất thành công!</div>
    </c:if>

    <div class="card fade-in" style="text-align: center;">
        <h1>Chào mừng đến với SessionApp</h1>
        <p style="font-size: 1.2rem; margin: 2rem 0;">
            Ứng dụng demo quản lý phiên làm việc với Java Servlet
        </p>

        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <div style="margin: 2rem 0;">
                    <h2>Xin chào, ${sessionScope.user.fullName}!</h2>
                    <p>Bạn đã đăng nhập thành công.</p>
                    <div style="margin-top: 2rem;">
                        <a href="dashboard.jsp" class="btn">Vào Dashboard</a>
                        <a href="products" class="btn btn-success">Xem Sản Phẩm</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div style="margin: 2rem 0;">
                    <p>Vui lòng đăng nhập để sử dụng đầy đủ tính năng</p>
                    <div style="margin-top: 2rem;">
                        <a href="login.jsp" class="btn">Đăng Nhập</a>
                        <a href="register.jsp" class="btn btn-success">Đăng Ký</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-users"></i></div>
            <h4>Quản lý phiên</h4>
            <p>Theo dõi và quản lý phiên người dùng</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
            <h4>Giỏ hàng</h4>
            <p>Quản lý sản phẩm trong session</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-code"></i></div>
            <h4>Java Servlet</h4>
            <p>Xây dựng với công nghệ Java EE</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-palette"></i></div>
            <h4>UI Modern</h4>
            <p>Thiết kế hiện đại với hiệu ứng mượt mà</p>
        </div>
    </div>
</main>

<script src="js/app.js"></script>
</body>
</html>