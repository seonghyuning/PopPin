<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>팝업스토어 등록</title>
    <link rel="stylesheet" href="/resources/css/style.css"> <!-- 필요시 스타일 추가 -->
</head>
<body>
    <h1>팝업스토어 등록</h1>

    <!-- Flash 메시지 출력 -->
    <c:if test="${not empty success}">
        <p style="color: green;">${success}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p style="color: red;">${error}</p>
    </c:if>

    <!-- 등록 폼 -->
 	<form action="/mypage/popupstore/new" method="post">
    <div>
        <label for="name">팝업스토어 이름:</label>
        <input type="text" id="name" name="name" required>
    </div>
    <div>
        <label for="location">위치:</label>
        <input type="text" id="location" name="location" required>
    </div>
    <div>
        <label for="description">설명:</label>
        <textarea id="description" name="description" rows="5" required></textarea>
    </div>
    <div>
        <label for="startDate">시작 날짜:</label>
        <input type="date" id="startDate" name="startDate" required>
    </div>
    <div>
        <label for="endDate">종료 날짜:</label>
        <input type="date" id="endDate" name="endDate" required>
    </div>
    <button type="submit">등록</button>
</form>

    <a href="/mypage/popupstore/manage">돌아가기</a>
</body>
</html>
