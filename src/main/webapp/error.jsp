<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - SessionApp</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<div class="container">
    <div class="card fade-in" style="max-width: 500px; margin: 5rem auto; text-align: center;">
        <h1 style="color: var(--danger-red);">Oops! Có lỗi xảy ra</h1>

        <div style="font-size: 4rem; margin: 2rem 0; color: var(--danger-red);">
            <i class="fas fa-exclamation-triangle"></i>
        </div>

        <p>Xin lỗi, đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn.</p>

        <div style="margin: 2rem 0;">
            <a href="index.jsp" class="btn">Về trang chủ</a>
            <button onclick="history.back()" class="btn btn-warning">Quay lại</button>
        </div>
    </div>
</div>
</body>
</html>