<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Store Detail</title>
<link rel="stylesheet" href="/resources/css/list.css">
</head>

<body>
	<%@ include file="../includes/header.jsp"%>
	<h3 id="approveh3">팝업스토어 신청 처리</h3>
	<div class="approve_container">
		<p>
			팝업명:
			<c:out value="${store.name}" />
		</p>
		<p>
			작성자:
			<c:out value="${store.createdBy}" />
		</p>
		<p>
			기간:
			<fmt:formatDate value="${store.startDate}" pattern="yyyy.MM.dd" />
			~
			<fmt:formatDate value="${store.endDate}" pattern="yyyy.MM.dd" />
		</p>
		<p>
			상세 정보</br>
			<c:out value="${store.description}" />
		</p>
		</br>
	</div>
	<div id="approveBtn">
		<form action="/store/approveReject" method="post"
			style="display: inline;">
			<input type="hidden" name="storeId" value="${store.storeId}" /> <input
				type="hidden" name="status" value="1" />
			<!-- 승인 상태 -->
			<button type="submit">승인</button>
		</form>

		<form action="/store/approveReject" method="post"
			style="display: inline;">
			<input type="hidden" name="storeId" value="${store.storeId}" /> <input
				type="hidden" name="status" value="2" />
			<!-- 거절 상태 -->
			<button type="submit">거절</button>
		</form>
	</div>



</body>

</html>