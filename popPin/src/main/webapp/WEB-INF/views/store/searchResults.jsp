<!-- 김성현, 자카소스코드 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Store List</title>
<link rel="stylesheet" href="/resources/css/list.css">
</head>
<body>

	<%@ include file="../includes/header.jsp"%>

	<!-- 카드 컨테이너 -->
	<div class="cardContainer">
		<c:forEach items="${stores}" var="store">
			<form action="/store/storeDetail" method="get"
				style="display: inline;">
				<button type="submit" id="nameBtn">
					<div class="card">
						<!-- 스토어에 해당하는 첫 번째 이미지 가져오기 -->
						<img src="/store/${store.imageId}" alt="팝업 이미지" class="cardImg">
						<div class="cardContent">
							<input type="hidden" name="storeId" value="${store.storeId}" />
							<h3>
								<c:out value="${store.name}" />
							</h3>
							<p>
								<c:out value="${store.location}" />
							</p>
							<span> <fmt:formatDate value="${store.startDate}"
									pattern="yyyy.MM.dd" /> ~ <fmt:formatDate
									value="${store.endDate}" pattern="yyyy.MM.dd" />
							</span>
						</div>
					</div>
				</button>
			</form>
		</c:forEach>
	</div>
</body>
</html>
