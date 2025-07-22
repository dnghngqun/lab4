<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - SessionApp</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<header class="header">
    <nav class="nav container">
        <div class="logo">SessionApp</div>
        <ul class="nav-links">
            <li><a href="index.jsp">Trang Chủ</a></li>
            <li><a href="products">Sản Phẩm</a></li>
            <li><a href="cart">Giỏ Hàng <span class="cart-badge">${sessionScope.cart != null ? sessionScope.cart.size() : 0}</span></a></li>
            <li><a href="logout" class="btn btn-danger">Đăng Xuất</a></li>
        </ul>
    </nav>
</header>

<main class="container">
    <div class="card fade-in">
        <h1>Giỏ hàng của bạn</h1>

        <c:choose>
            <c:when test="${empty sessionScope.cart}">
                <div style="text-align: center; padding: 3rem;">
                    <h3>Giỏ hàng trống</h3>
                    <p>Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                    <a href="products" class="btn">Mua sắm ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:set var="total" value="0" />
                <div class="cart-items">
                    <c:forEach items="${sessionScope.cart}" var="product" varStatus="status">
                        <div class="cart-item">
                            <img src="${product.imageUrl}" alt="${product.name}"
                                 style="width: 80px; height: 60px; object-fit: cover; border-radius: 8px;"
                                 onerror="this.src='https://via.placeholder.com/80x60?text=No+Image'">
                            <div style="flex: 1; margin-left: 1rem;">
                                <h4>${product.name}</h4>
                                <p class="product-price">$${product.price}</p>
                            </div>
                            <button onclick="removeFromCart(${status.index})" class="btn btn-danger">Xóa</button>
                        </div>
                        <c:set var="total" value="${total + product.price}" />
                    </c:forEach>
                </div>

                <div style="border-top: 2px solid #e1e1e1; padding-top: 1rem; margin-top: 1rem;">
                    <h3>Tổng số sản phẩm: ${sessionScope.cart.size()}</h3>
                    <h3 style="color: #667eea;">Tổng tiền: $${total}</h3>
                    <div style="margin-top: 1rem;">
                        <button onclick="clearCart()" class="btn btn-danger">Xóa tất cả</button>
                        <button class="btn btn-success" onclick="alert('Tính năng thanh toán sẽ được phát triển!')">
                            Thanh toán
                        </button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script src="js/app.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Force sync when cart page loads
        syncCartWithServer();

        // Update badge based on actual server cart
        const serverCartSize = ${sessionScope.cart != null ? sessionScope.cart.size() : 0};
        const localCart = getCartFromLocalStorage();

        // If server cart is empty but localStorage has items, sync again
        if (serverCartSize === 0 && localCart.length > 0) {
            console.log('Server cart empty, re-syncing...');
            setTimeout(() => {
                syncCartWithServer();
                setTimeout(() => window.location.reload(), 1000);
            }, 500);
        }
    });
</script>
</body>
</html>
