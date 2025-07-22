<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý sản phẩm - SessionApp</title>
  <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<header class="header">
  <nav class="nav container">
    <div class="logo">SessionApp</div>
    <ul class="nav-links">
      <li><a href="index.jsp">Trang Chủ</a></li>
      <li><a href="products">Sản Phẩm</a></li>
      <c:if test="${not empty sessionScope.user}">
        <li><a href="cart">Giỏ Hàng</a></li>
        <li><a href="logout" class="btn btn-danger">Đăng Xuất</a></li>
      </c:if>
    </ul>
  </nav>
</header>

<main class="container">
  <div class="card fade-in">
    <h1>Quản lý sản phẩm</h1>

    <c:if test="${not empty sessionScope.user}">
      <button onclick="openAddModal()" class="btn btn-success">Thêm sản phẩm mới</button>
    </c:if>
  </div>

  <div class="product-grid">
    <c:forEach items="${products}" var="product">
      <div class="product-card slide-up">
        <img src="${product.imageUrl}" alt="${product.name}" class="product-image"
             onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
        <div class="product-info">
          <h3 class="product-name">${product.name}</h3>
          <p class="product-price">$${product.price}</p>
          <p class="product-description">${product.description}</p>

          <c:if test="${not empty sessionScope.user}">
            <div style="display: flex; gap: 10px; margin-top: 1rem;">
              <button onclick="addToCart(${product.id}, '${product.name}')" class="btn">Thêm vào giỏ</button>
              <button onclick="openEditModal(${product.id}, '${product.name}', ${product.price}, '${product.description}', '${product.imageUrl}')"
                      class="btn">Sửa</button>
              <form action="product/delete" method="post" style="display: inline;"
                    onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">
                <input type="hidden" name="id" value="${product.id}">
                <button type="submit" class="btn btn-danger">Xóa</button>
              </form>
            </div>
          </c:if>
        </div>
      </div>
    </c:forEach>
  </div>
</main>

<!-- Modal thêm sản phẩm -->
<div id="addModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal('addModal')">&times;</span>
    <h2>Thêm sản phẩm mới</h2>
    <form action="product/add" method="post">
      <div class="form-group">
        <label>Tên sản phẩm:</label>
        <input type="text" name="name" required>
      </div>
      <div class="form-group">
        <label>Giá:</label>
        <input type="number" step="0.01" name="price" required>
      </div>
      <div class="form-group">
        <label>Mô tả:</label>
        <textarea name="description" rows="3"></textarea>
      </div>
      <div class="form-group">
        <label>URL hình ảnh:</label>
        <input type="url" name="imageUrl" placeholder="https://example.com/image.jpg">
      </div>
      <button type="submit" class="btn btn-success">Thêm sản phẩm</button>
    </form>
  </div>
</div>

<!-- Modal sửa sản phẩm -->
<div id="editModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal('editModal')">&times;</span>
    <h2>Sửa sản phẩm</h2>
    <form action="product/edit" method="post">
      <input type="hidden" id="editId" name="id">
      <div class="form-group">
        <label>Tên sản phẩm:</label>
        <input type="text" id="editName" name="name" required>
      </div>
      <div class="form-group">
        <label>Giá:</label>
        <input type="number" step="0.01" id="editPrice" name="price" required>
      </div>
      <div class="form-group">
        <label>Mô tả:</label>
        <textarea id="editDescription" name="description" rows="3"></textarea>
      </div>
      <div class="form-group">
        <label>URL hình ảnh:</label>
        <input type="url" id="editImageUrl" name="imageUrl">
      </div>
      <button type="submit" class="btn">Cập nhật sản phẩm</button>
    </form>
  </div>
</div>

<script src="js/app.js"></script>
</body>
</html>