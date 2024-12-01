<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>팝업스토어 수정</title>
    <script>
        function confirmUpdate() {
            return confirm("정말 수정하시겠습니까?");
        }
    </script>
</head>
<body>

<h1>팝업스토어 수정</h1>
<form action="/mypage/popupstore/edit" method="post" onsubmit="return confirmUpdate();">
    <input type="hidden" name="storeId" value="${popupStore.storeId}" />
    <div>
        <label for="name">이름:</label>
        <input type="text" id="name" name="name" value="${popupStore.name}" required>
    </div>
    <div>
        <label for="location">위치:</label>
        <input type="text" id="location" name="location" value="${popupStore.location}" required>
    </div>
    <div>
        <label for="description">설명:</label>
        <textarea id="description" name="description" rows="5" required>${popupStore.description}</textarea>
    </div>
    <div>
        <label for="startDate">시작 날짜:</label>
        <input type="date" id="startDate" name="startDate" value="${popupStore.startDate}" required>
    </div>
    <div>
        <label for="endDate">종료 날짜:</label>
        <input type="date" id="endDate" name="endDate" value="${popupStore.endDate}" required>
    </div>
    <button type="submit">수정 완료</button>
    <a href="/mypage/popupstore/manage">뒤로가기</a>
</form>

</body>
</html>
