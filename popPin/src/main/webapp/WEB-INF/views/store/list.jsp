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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function toggleLike(storeId, button) {
    console.log("storeId:", storeId); // 디버깅 로그
    $.ajax({
        url: `/store/like/toggle`,
        type: 'POST',
        data: { storeId: storeId },
        success: function (response) {
            console.log("Toggle like response:", response);
         // 좋아요 상태 확인
            const isLiked = response.liked === true || response.liked === "true";

            // 좋아요 상태에 따라 하트 변경
            if (isLiked) {
                button.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="red" class="bi bi-suit-heart-fill" viewBox="0 0 16 16">
                        <path d="M4 1c2.21 0 4 1.755 4 3.92C8 2.755 9.79 1 12 1s4 1.755 4 3.92c0 3.263-3.234 4.414-7.608 9.608a.513.513 0 0 1-.784 0C3.234 9.334 0 8.183 0 4.92 0 2.755 1.79 1 4 1"/>
                    </svg>
                `;
            } else {
                button.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="gray" class="bi bi-suit-heart" viewBox="0 0 16 16">
                        <path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.6 7.6 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.38z"/>
                    </svg>
                `;
            }
         	// 페이지를 리다이렉트
            window.location.href = "/store/list";
        },
        error: function (xhr, status, error) {
            console.error("Error toggling like:", error);
        }
    });
}




</script>
</head>
<body>
	<%@ include file="../includes/header.jsp"%>

	<!-- 카드 컨테이너 -->
	<div class="cardContainer">
		<c:forEach items="${stores}" var="store">
			<div class="card">
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

					<!-- 좋아요 버튼 -->
					<button class="likeButton"
    onclick="toggleLike(${store.storeId}, this)"
    style="background: none; border: none; cursor: pointer;">
    <c:if test="${likedMap[store.storeId]}">
        <!-- 채워진 하트 -->
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="red" class="bi bi-suit-heart-fill" viewBox="0 0 16 16">
            <path d="M4 1c2.21 0 4 1.755 4 3.92C8 2.755 9.79 1 12 1s4 1.755 4 3.92c0 3.263-3.234 4.414-7.608 9.608a.513.513 0 0 1-.784 0C3.234 9.334 0 8.183 0 4.92 0 2.755 1.79 1 4 1"/>
        </svg>
    </c:if>
    <c:if test="${!likedMap[store.storeId]}">
        <!-- 비어있는 하트 -->
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="gray" class="bi bi-suit-heart" viewBox="0 0 16 16">
            <path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.6 7.6 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.38z"/>
        </svg>
    </c:if>
</button>

				</div>
			</div>
		</c:forEach>
	</div>
</body>
</html>
