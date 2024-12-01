<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Store Detail</title>
</head>
<body>

<h1>Store Detail</h1>
<p><strong>Store ID:</strong> <c:out value="${store.storeId}" /></p>
<p><strong>Name:</strong> <c:out value="${store.name}" /></p>
<p><strong>Location:</strong> <c:out value="${store.location}" /></p>
<p><strong>Description:</strong> <c:out value="${store.description}" /></p>
<p><strong>Start Date:</strong> <fmt:formatDate value="${store.startDate}" pattern="yyyy-MM-dd" /></p>
<p><strong>End Date:</strong> <fmt:formatDate value="${store.endDate}" pattern="yyyy-MM-dd" /></p>
<p><strong>Created By:</strong> <c:out value="${store.createdBy}" /></p>
<form action="/store/approveReject" method="post" style="display:inline;">
    <input type="hidden" name="storeId" value="${store.storeId}" />
    <input type="hidden" name="status" value="1" /> <!-- 승인 상태 -->
    <button type="submit">승인</button>
</form>

<form action="/store/approveReject" method="post" style="display:inline;">
    <input type="hidden" name="storeId" value="${store.storeId}" />
    <input type="hidden" name="status" value="2" /> <!-- 거절 상태 -->
    <button type="submit">거절</button>
</form>

</body>
</html>
