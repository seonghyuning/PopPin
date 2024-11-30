<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>팝업스토어 신청 목록</title>
    <link rel="stylesheet" href="/resources/css/list.css">
</head>
<body>

<h1>팝업스토어 신청 목록</h1>

<table class="table">
    <thead>
        <tr>
            <th>#번호</th>
            <th>이름</th>
            <th>시작일</th>
            <th>종료일</th>
            <th>작성자</th>
            <th>상태</th>
        </tr>
    </thead>
    <c:forEach items="${pendingStores}" var="store">
        <tr>
            <td><c:out value="${store.storeId}" /></td>
            <td><form action="/store/approveReject" method="get" style="display:inline;">
                    <input type="hidden" name="storeId" value="${store.storeId}" />
                    <button type="submit" class="move" style="background:none; border:none; color:blue; cursor:pointer;">
                        <c:out value="${store.name}" />
                    </button>
                </form>
            </td>
            <td><fmt:formatDate value="${store.startDate}" pattern="yyyy-MM-dd" /></td>
            <td><fmt:formatDate value="${store.endDate}" pattern="yyyy-MM-dd" /></td>
            <td><c:out value="${store.createdBy}" /></td>
            <td>
                <c:choose>
                    <c:when test="${store.status == 0}">대기</c:when>
                    <c:when test="${store.status == 1}">승인</c:when>
                    <c:when test="${store.status == 2}">거절</c:when>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>
