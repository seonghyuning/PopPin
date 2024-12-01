<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Page</title>
<link rel="stylesheet" href="/resources/css/list.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function removeLike(storeId) {
        console.log("Removing like for storeId:", storeId); // 디버깅 로그
        $.ajax({
            url: `/store/like/toggle`,
            type: 'POST',
            data: { storeId: storeId },
            success: function () {
                console.log("Like removed successfully for storeId:", storeId);
                // 페이지를 다시 로드하여 변경사항 반영
                window.location.reload();
            },
            error: function (xhr, status, error) {
                console.error("Error removing like:", error);
            }
        });
    }
</script>
</head>

<body>
	<%@ include file="../includes/header.jsp"%>
	<div class="myInfoContainer">
		<img src="Img/maple-leaf.jpg" alt="" id="proImg">
		<div class="myInfoText">
			<h2 id="userName">${user.username}</h2>
			<p>닉네임: &emsp;${user.nickname}</p>
			<p>이메일: &emsp;${user.email}</p>
			<button class="loginBtn" id="editBtn"
				onclick="window.location.href='/member/edit'">내 정보 수정</button>
		</div>
	</div>
		<div class="listBtn">
        <!-- 관리자인 경우에만 '신청 팝업 관리' 버튼을 보이게 함 -->
        <c:if test="${isAdmin}">
            <button class="myPageFilterBtn" onclick="window.location.href='/store/addstorelist'">신청 팝업 관리</button>
        </c:if>
        
        <!-- 일반 사용자는 '관심 팝업'과 '신청 팝업' 버튼을 그대로 보이도록 함 -->
        <c:if test="${!isAdmin}">
            <button class="myPageFilterBtn">관심 팝업</button>
            <div id="middleLine"></div>
            <button class="myPageFilterBtn" onclick="window.location.href='/mypage/popupstore/manage'">신청 팝업</button>
        </c:if>
    </div>
	<div class="cardContainer">
		<c:forEach items="${likedStores}" var="store">
			<div class="card" id="card-${store.storeId}">
				<!-- 스토어에 해당하는 첫 번째 이미지 가져오기 -->
				<c:choose>
					<c:when test="${not empty imagesMap[store.storeId]}">
						<c:forEach items="${imagesMap[store.storeId]}" var="image"
							begin="0" end="0">
							<img src="${image.filePath}" alt="${store.name}" class="cardImg">
						</c:forEach>
					</c:when>
					<c:otherwise>
						<img src="/resources/img/default.jpg" alt="기본 이미지" class="cardImg">
					</c:otherwise>
				</c:choose>
				<div class="cardContent">
					<h3>${store.name}</h3>
					<p>${store.location}</p>
					<span> <fmt:formatDate value="${store.startDate}"
							pattern="yyyy.MM.dd" /> ~ <fmt:formatDate
							value="${store.endDate}" pattern="yyyy.MM.dd" />
					</span>
					<!-- 항상 채워진 하트 버튼 -->
					<button class="likeButton" onclick="removeLike(${store.storeId})"
						style="background: none; border: none; cursor: pointer;">
						<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
							fill="red" class="bi bi-suit-heart-fill" viewBox="0 0 16 16">
                                            <path
								d="M4 1c2.21 0 4 1.755 4 3.92C8 2.755 9.79 1 12 1s4 1.755 4 3.92c0 3.263-3.234 4.414-7.608 9.608a.513.513 0 0 1-.784 0C3.234 9.334 0 8.183 0 4.92 0 2.755 1.79 1 4 1" />
                                        </svg>
					</button>
				</div>
			</div>
		</c:forEach>
	</div>
</body>

</html>
