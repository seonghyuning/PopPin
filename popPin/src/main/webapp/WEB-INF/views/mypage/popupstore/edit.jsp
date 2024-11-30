<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>팝업스토어 수정</title>
                <link rel="stylesheet" href="/resources/css/style.css">
                <style>

                </style>
                <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
                <script>
                    function previewImages(input) {
                        const previewContainer = document.getElementById("previewContainer");
                        previewContainer.innerHTML = "";

                        if (input.files) {
                            Array.from(input.files).forEach(file => {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    const img = document.createElement("img");
                                    img.src = e.target.result;
                                    previewContainer.appendChild(img);
                                };
                                reader.readAsDataURL(file);
                            });
                        }
                    }

                    function removeImage(button) {
                        const imageWrapper = button.parentElement;
                        const imageId = button.dataset.id;

                        const hiddenField = document.getElementById(`hiddenImage-${imageId}`);
                        if (hiddenField) hiddenField.remove();

                        imageWrapper.remove();
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
                <div class="edit-container">
                    <h1>팝업스토어 수정</h1>
                    <form class="loginForm" action="/mypage/popupstore/edit" method="post"
                        enctype="multipart/form-data">
                        <input type="hidden" name="storeId" value="${popupStore.storeId}" />

                        <label for="userName">스토어 이름</label>
                        <input type="text" id="name" name="name" value="${popupStore.name}" required />

                        <label for="location">위치</label>
                        <input type="text" id="location" name="location" placeholder="주소">
                        <input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"><br>

                        <label for="description">설명</label>
                        <input type="text" id="description" name="description" value="${popupStore.description}"
                            required></input>

                        <label for="startDate">시작 날짜</label>
                        <input type="date" id="startDate" name="startDate" value="${popupStore.startDate}" required />

                        <label for="endDate">종료 날짜</label>
                        <input type="date" id="endDate" name="endDate" value="${popupStore.endDate}" />

                        <label for="images">현재 이미지</label>
                        <div id="currentImages">
                            <c:forEach var="image" items="${images}">
                                <div class="image-wrapper">
                                    <img src="${image.filePath}" alt="이미지" />
                                    <input type="hidden" name="existingImages" value="${image.imageId}"
                                        id="hiddenImage-${image.imageId}" />
                                    <button type="button" data-id="${image.imageId}"
                                        onclick="removeImage(this)">X</button>
                                </div>
                            </c:forEach>
                        </div>

                        <label for="newImages">새 이미지 업로드</label>
                        <input type="file" id="newImages" name="newImages" multiple onchange="previewImages(this)" />

                        <div id="previewContainer"></div>

                        <button type="submit" class="loginBtn">수정 완료</button>
                    </form>
                    <a href="/mypage/popupstore/manage">뒤로가기</a>
                </div>
            </body>

            </html>