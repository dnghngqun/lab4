<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng Nhập - SessionApp</title>
  <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<div class="container">
  <div class="card fade-in" style="max-width: 400px; margin: 5rem auto;">
    <h1>Đăng Nhập</h1>

    <c:if test="${param.error eq 'invalid'}">
      <div class="alert alert-error">Tên đăng nhập hoặc mật khẩu không đúng!</div>
    </c:if>

    <c:if test="${param.timeout eq 'true'}">
      <div class="alert alert-error">Phiên làm việc đã hết hạn, vui lòng đăng nhập lại!</div>
    </c:if>

    <c:if test="${param.registered eq 'true'}">
      <div class="alert alert-success">Đăng ký thành công! Vui lòng đăng nhập.</div>
    </c:if>

    <form action="login" method="post" onsubmit="handleLoginSubmit(event)">
      <div class="form-group">
        <label for="username">Tên đăng nhập:</label>
        <input type="text" id="username" name="username" required>
      </div>

      <div class="form-group">
        <label for="password">Mật khẩu:</label>
        <input type="password" id="password" name="password" required>
      </div>

      <button type="submit" class="btn">Đăng Nhập</button>
    </form>

    <div style="text-align: center; margin-top: 2rem;">
      <p>Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></p>
      <p><a href="index.jsp">Về trang chủ</a></p>
    </div>
  </div>
</div>

<script src="js/app.js"></script>
<script>
  function handleLoginSubmit(event) {
    // Lưu localStorage cart trước khi submit
    const localCart = getCartFromLocalStorage();
    if (localCart.length > 0) {
      sessionStorage.setItem('pendingSyncCart', JSON.stringify(localCart));
    }
  }

  // Check nếu đã login và có cart cần sync
  document.addEventListener('DOMContentLoaded', function() {
    const pendingCart = sessionStorage.getItem('pendingSyncCart');
    if (pendingCart && window.location.search.includes('error')) {
      // Login failed, keep pending cart
      return;
    }

    // Clear pending cart if on login page
    sessionStorage.removeItem('pendingSyncCart');
  });
</script>
</body>
</html>