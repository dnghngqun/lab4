<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="header">
  <nav class="nav container">
    <div class="logo">SessionApp</div>
    <ul class="nav-links">
      <li><a href="index.jsp">Trang Chủ</a></li>
      <li><a href="products">Sản Phẩm</a></li>
      <c:if test="${not empty sessionScope.user}">
        <li>
          <a href="cart">Giỏ Hàng
            <span class="cart-badge"><%= (cartBean != null) ? cartBean.getItemCount() : 0 %></span>
          </a>
        </li>
        <li><a href="dashboard.jsp">Dashboard</a></li>
        <li><a href="logout" class="btn btn-danger">Đăng Xuất</a></li>
      </c:if>
      <c:if test="${empty sessionScope.user}">
        <li><a href="login.jsp">Đăng Nhập</a></li>
        <li><a href="register.jsp">Đăng Ký</a></li>
      </c:if>
    </ul>
  </nav>
</header>