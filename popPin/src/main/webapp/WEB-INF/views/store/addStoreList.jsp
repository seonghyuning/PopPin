<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>팝업스토어 신청 목록</title>
<link rel="stylesheet" href="/resources/css/list.css">
</head>

<body>
	<%@ include file="../includes/header.jsp"%>
	<h3 id="addstorelist">팝업스토어 신청 목록</h3>
	<table class="table" id="tableBody">
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
		<tbody>
			<c:forEach var="store" items="${stores}">
				<tr>
					<td>${store.storeId}</td>
					<!-- #번호 -->
					<td>
						<form action="/store/approveReject" method="get"
							style="display: inline;">
							<input type="hidden" name="storeId" value="${store.storeId}" />
							<button type="submit" class="move"
								style="background: none; border: none; color: blue; cursor: pointer;">
								${store.name}</button>
						</form>
					</td>
					<!-- 이름 -->
					<td><fmt:formatDate value="${store.startDate}"
							pattern="yyyy-MM-dd" /></td>
					<!-- 시작일 -->
					<td><fmt:formatDate value="${store.endDate}"
							pattern="yyyy-MM-dd" /></td>
					<!-- 종료일 -->
					<td>${store.createdBy}</td>
					<!-- 작성자 -->
					<td>대기</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>

</html>