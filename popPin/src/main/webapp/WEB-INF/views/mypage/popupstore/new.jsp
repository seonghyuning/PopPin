<!-- 김정은, 자카소스코드 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Poppin</title>
<link rel="stylesheet" href="/resources/css/style.css">
<style>
#imagePreviewContainer img {
	width: 200px;
	height: 200px;
	object-fit: cover;
	border: 1px solid #ccc;
	margin: 5px;
}
</style>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
                    // 미리보기 기능 구현
                    function previewImages(event) {
                        const files = event.target.files; // 사용자가 선택한 파일들
                        const previewContainer = document.getElementById("imagePreviewContainer");

                        previewContainer.innerHTML = ""; // 기존 미리보기 초기화

                        for (let file of files) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const img = document.createElement("img");
                                img.src = e.target.result; // 파일 내용을 미리보기로 설정
                                previewContainer.appendChild(img);
                            };
                            reader.readAsDataURL(file); // 파일 읽기
                        }
                    }

                    function sample5_execDaumPostcode() {
                        new daum.Postcode({
                            oncomplete: function (data) {
                                var addr = data.address; // 최종 주소 변수

                                // 주소 정보를 해당 필드에 넣는다.
                                document.getElementById("location").value = addr;
                            }
                        }).open();
                    }
                </script>
</head>

<body>
	<form action="/mypage/popupstore/new" method="post" class="loginForm"
		enctype="multipart/form-data">
		<a href="/mypage/popupstore/manage" id="backButton"> <svg
				xmlns="http://www.w3.org/2000/svg" width="16" height="16"
				fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
                            <path fill-rule="evenodd"
					d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8" />
                        </svg>돌아가기
		</a>
		<h1 id="registerTitle">팝업 스토어 등록</h1>

		<label for="userName">스토어 이름*</label> <input type="text" id="name"
			name="name" placeholder="오징어 게임 스토어" required> <label
			for="location">주소*</label> <input type="text" id="location"
			name="location" placeholder="주소"> <input type="button"
			onclick="sample5_execDaumPostcode()" value="주소 검색"><br>

		<label for="nickName">설명*</label> <input type="text" id="description"
			name="description" placeholder="시즌2 프리미어를 앞두고..." required> <label
			for="startDate">시작날짜*</label> <input type="date" id="startDate"
			name="startDate" required> <label for="endDate">종료날짜</label>
		<input type="date" id="endDate" name="endDate"> <label
			for="image">사진 업로드*</label> <input type="file" id="images"
			name="images" multiple onchange="previewImages(event)" required>

		<!-- 미리보기 영역 -->
		<div id="imagePreviewContainer"></div>

		<button type="submit" class="loginBtn" id="registerBtn">등록 완료</button>
	</form>
</body>

</html>