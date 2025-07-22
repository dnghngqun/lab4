<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng Ký - SessionApp</title>
  <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<div class="container">
  <div class="card fade-in" style="max-width: 400px; margin: 5rem auto;">
    <h1>Đăng Ký Tài Khoản</h1>

    <c:if test="${param.error eq 'exists'}">
      <div class="alert alert-error">Tên đăng nhập đã tồn tại!</div>
    </c:if>

    <form action="register" method="post">
      <div class="form-group">
        <label for="username">Tên đăng nhập:</label>
        <input type="text" id="username" name="username" required>
      </div>

      <div class="form-group">
        <label for="password">Mật khẩu:</label>
        <input type="password" id="password" name="password" required>
      </div>

      <div class="form-group">
        <label for="fullName">Họ và tên:</label>
        <input type="text" id="fullName" name="fullName" required>
      </div>

      <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
      </div>

      <button type="submit" class="btn btn-success">Đăng Ký</button>
    </form>

    <div style="text-align: center; margin-top: 2rem;">
      <p>Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a></p>
      <p><a href="index.jsp">Về trang chủ</a></p>
    </div>
  </div>
</div>
</body>
</html>