<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Store Detail</title>
    <script>
        function confirmDelete(storeId) {
            if (confirm("정말 삭제하시겠습니까?")) {
                document.getElementById("deleteForm").submit();
            }
        }
    </script>
</head>
<body>

<h1>Store Detail</h1>
<p>조회수: ${popupStore.views}</p></br>
<p><strong>Store ID:</strong> <c:out value="${popupStore.storeId}" /></p>
<p><strong>Name:</strong> <c:out value="${popupStore.name}" /></p>
<p><strong>Location:</strong> <c:out value="${popupStore.location}" /></p>
<p><strong>Description:</strong> <c:out value="${popupStore.description}" /></p>
<p><strong>Start Date:</strong> <fmt:formatDate value="${popupStore.startDate}" pattern="yyyy-MM-dd" /></p>
<p><strong>End Date:</strong> <fmt:formatDate value="${popupStore.endDate}" pattern="yyyy-MM-dd" /></p>
<p><strong>Created By:</strong> <c:out value="${popupStore.createdBy}" /></p>

<!-- 수정 버튼 -->
<form action="/mypage/popupstore/edit" method="get" style="display:inline;">
    <input type="hidden" name="storeId" value="${popupStore.storeId}" />
    <button type="submit">수정</button>
</form>

<!-- 삭제 버튼 -->
<form id="deleteForm" action="/mypage/popupstore/delete" method="post" style="display:inline;">
    <input type="hidden" name="storeId" value="${popupStore.storeId}" />
    <button type="button" onclick="confirmDelete(${popupStore.storeId})">삭제</button>
</form>

<!-- 돌아가기 버튼 -->
<a href="/mypage/popupstore/manage">돌아가기</a>

</body>
</html>
