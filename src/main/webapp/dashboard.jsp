<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SessionApp</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<header class="header">
    <nav class="nav container">
        <div class="logo">SessionApp</div>
        <ul class="nav-links">
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="products">Sản Phẩm</a></li>
            <li><a href="cart">Giỏ Hàng</a></li>
            <li><a href="profile" target="_blank">Profile JSON</a></li>
            <li><a href="logout" class="btn btn-danger">Đăng Xuất</a></li>
        </ul>
    </nav>
</header>

<main class="container">
    <div class="card fade-in">
        <h1>Chào mừng, ${sessionScope.user.fullName}!</h1>
        <p>Bạn đã đăng nhập thành công vào hệ thống.</p>

        <div class="user-info" style="background: #f8f9fa; padding: 1rem; border-radius: 8px; margin: 1rem 0;">
            <h3>Thông tin tài khoản:</h3>
            <p><strong>Tên đăng nhập:</strong> ${sessionScope.user.username}</p>
            <p><strong>Họ và tên:</strong> ${sessionScope.user.fullName}</p>
            <p><strong>Email:</strong> ${sessionScope.user.email}</p>
            <p><strong>Thời gian đăng nhập:</strong>
                <script>
                    document.write(new Date(${sessionScope.user.loginTime}).toLocaleString('vi-VN'));
                </script>
            </p>
        </div>

        <div style="margin-top: 2rem;">
            <a href="products" class="btn">Quản lý sản phẩm</a>
            <a href="cart" class="btn btn-success">Xem giỏ hàng</a>
            <a href="profile" class="btn" target="_blank">Xuất JSON</a>
        </div>
    </div>
</main>
</body>
</html>