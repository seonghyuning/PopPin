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
<title>My Page</title>
<link rel="stylesheet" href="/resources/css/list.css">
</head>
<style>
.edit-container {
   width: 50%;
   margin: auto;
   padding: 40px;
   background-color: #2c2c2c;
   border-radius: 10px;
   box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
   color: white;
}

h1 {
   text-align: center;
   color: #EC221F;
}

form label {
   display: block;
   margin-top: 20px;
   margin-bottom: 5px;
   font-weight: bold;
}

form input[type="text"], form input[type="date"], form textarea {
   width: 100%;
   padding: 10px;
   border: 1px solid #ccc;
   border-radius: 5px;
   margin-bottom: 15px;
}

form textarea {
   height: 100px;
   resize: none;
}

#currentImages {
   display: flex;
   flex-wrap: wrap;
   gap: 10px;
}

.image-wrapper {
   position: relative;
}

.image-wrapper img {
   width: 100px;
   height: 100px;
   object-fit: cover;
   border: 1px solid white;
}

.image-wrapper button {
   position: absolute;
   top: 5px;
   right: 5px;
   background-color: #EC221F;
   border: none;
   color: white;
   border-radius: 50%;
   cursor: pointer;
   padding: 5px;
}

#previewContainer img {
   width: 100px;
   height: 100px;
   object-fit: cover;
   margin: 5px;
}

a {
   display: inline-block;
   margin-top: 15px;
   color: white;
   text-decoration: none;
   font-size: 14px;
   text-align: center;
}
.cardActions{
   display: inline-flex;
   justify-content: center;
   margin-top: 10px;
   float:right;
}
#deleteBtn{
   margin-right: 3px;
}

.popTitle{
   margin-left: 9em;
}

#storeRegButton{
    margin-left: 40em;
    margin-top : 20px;
    width: 35em;
}
}

</style>
<body>
   <%@ include file="../../includes/header.jsp"%>
   <div class="myInfoContainer">
      <img src="/resources/img/루피.png" alt="" id="proImg">
      <div class="myInfoText">
         <h2 id="userName">${user.username}</h2>
         <p>닉네임: &emsp;${user.nickname}</p>
         <p>이메일: &emsp;${user.email}</p>
         <button class="loginBtn" id="editBtn"
            onclick="window.location.href='/member/edit'">내 정보 수정</button>
      </div>
   </div>
   <div class="listBtn">
      <button class="myPageFilterBtn"
         onclick="window.location.href='/member/mypage'">관심 팝업</button>
      <div id="middleLine"></div>
      <button class="myPageFilterBtn"
         onclick="window.location.href='/mypage/popupstore/manage'">신청 팝업</button>
   </div>
         <button class="loginBtn" id="storeRegButton"
         onclick="window.location.href='/mypage/popupstore/new'">내 팝업스토어 등록하기
         </button>

   <section class="popup-section">
      <h2 class="popTitle">대기 중인 팝업스토어</h2>
      <div class="cardListContainer">
         <c:forEach items="${popupStores}" var="store">
             <div class="cardListItem">
                  <!-- 이미지 출력 -->
                 <img src="/image/${store.imageId}" alt="팝업 이미지" class="cardListImg">
                    <div class="cardContent">
                     <h3 class="cardTitle" style="font-size: 20px; margin: 0;">
                         <a href="/store/storeDetail?storeId=${store.storeId}" style="color: white; text-decoration: none; font-size: inherit;">
                             ${store.name}
                         </a>
                     </h3>
                  <p class="locationText">
                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                        fill="currentColor" class="bi bi-geo-alt-fill"
                        viewBox="0 0 16 16">
                                <path
                           d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6" />
                            </svg>${store.location}
                  </p>
                  <span> <svg xmlns="http://www.w3.org/2000/svg" width="16"
                        height="16" fill="currentColor" class="bi bi-calendar-range"
                        viewBox="0 0 16 16">
                                <path
                           d="M9 7a1 1 0 0 1 1-1h5v2h-5a1 1 0 0 1-1-1M1 9h4a1 1 0 0 1 0 2H1z" />
                                <path
                           d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z" />
                            </svg> <fmt:formatDate value="${store.startDate}"
                        pattern="yyyy.MM.dd" /> ~ <fmt:formatDate
                        value="${store.endDate}" pattern="yyyy.MM.dd" />
                  </span></br>
                  <!-- 수정 및 삭제 버튼 -->
                  <div class="cardActions">
                     <button id="deleteBtn"
                        onclick="window.location.href='/mypage/popupstore/edit?storeId=${store.storeId}'">수정</button>
                     <form action="/mypage/popupstore/delete" method="post"
                        style="display: inline;">
                        <input type="hidden" name="storeId" value="${store.storeId}">
                        <button type="submit" id="deleteBtn"
                           onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                     </form>
                  </div>
               </div>
               
            </div>
         </c:forEach>
      </div>
   </section>

   <br/>
   <section class="popup-section">
      <h2 class="popTitle">승인된 팝업스토어</h2>
      <div class="cardListContainer">
         <c:forEach items="${apporovedStores}" var="store">
             <div class="cardListItem">
                  <!-- 이미지 출력 -->
                 <img src="/image/${store.imageId}" alt="팝업 이미지" class="cardListImg">
                    <div class="cardContent">
                     <h3 class="cardTitle" style="font-size: 20px; margin: 0;">
                         <a href="/store/storeDetail?storeId=${store.storeId}" style="color: white; text-decoration: none; font-size: inherit;">
                             ${store.name}
                         </a>
                     </h3>
                  <p class="locationText">
                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                        fill="currentColor" class="bi bi-geo-alt-fill"
                        viewBox="0 0 16 16">
                                <path
                           d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6" />
                            </svg>${store.location}
                  </p>
                  <span> <svg xmlns="http://www.w3.org/2000/svg" width="16"
                        height="16" fill="currentColor" class="bi bi-calendar-range"
                        viewBox="0 0 16 16">
                                <path
                           d="M9 7a1 1 0 0 1 1-1h5v2h-5a1 1 0 0 1-1-1M1 9h4a1 1 0 0 1 0 2H1z" />
                                <path
                           d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z" />
                            </svg> <fmt:formatDate value="${store.startDate}"
                        pattern="yyyy.MM.dd" /> ~ <fmt:formatDate
                        value="${store.endDate}" pattern="yyyy.MM.dd" />
                  </span></br>
                  <!-- 수정 및 삭제 버튼 -->
                  <div class="cardActions">
                     <button id="deleteBtn"
                        onclick="window.location.href='/mypage/popupstore/edit?storeId=${store.storeId}'">수정</button>
                     <form action="/mypage/popupstore/delete" method="post"
                        style="display: inline;">
                        <input type="hidden" name="storeId" value="${store.storeId}">
                        <button type="submit" id="deleteBtn"
                           onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                     </form>
                  </div>
               </div>
               
            </div>
         </c:forEach>
      </div>
   </section>

   <br/>
   <section class="popup-section">
      <h2 class="popTitle">거절된 팝업스토어</h2>
      <div class="cardListContainer">
         <c:forEach items="${rejectedStores}" var="store">
             <div class="cardListItem">
                  <!-- 이미지 출력 -->
                 <img src="/image/${store.imageId}" alt="팝업 이미지" class="cardListImg">
                    <div class="cardContent">
                     <h3 class="cardTitle" style="font-size: 20px; margin: 0;">
                         <a href="/store/storeDetail?storeId=${store.storeId}" style="color: white; text-decoration: none; font-size: inherit;">
                             ${store.name}
                         </a>
                     </h3>
                  <p class="locationText">
                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                        fill="currentColor" class="bi bi-geo-alt-fill"
                        viewBox="0 0 16 16">
                                <path
                           d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6" />
                            </svg>${store.location}
                  </p>
                  <span> <svg xmlns="http://www.w3.org/2000/svg" width="16"
                        height="16" fill="currentColor" class="bi bi-calendar-range"
                        viewBox="0 0 16 16">
                                <path
                           d="M9 7a1 1 0 0 1 1-1h5v2h-5a1 1 0 0 1-1-1M1 9h4a1 1 0 0 1 0 2H1z" />
                                <path
                           d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z" />
                            </svg> <fmt:formatDate value="${store.startDate}"
                        pattern="yyyy.MM.dd" /> ~ <fmt:formatDate
                        value="${store.endDate}" pattern="yyyy.MM.dd" />
                  </span></br>
                  <!-- 수정 및 삭제 버튼 -->
                  <div class="cardActions">
                     <button id="deleteBtn"
                        onclick="window.location.href='/mypage/popupstore/edit?storeId=${store.storeId}'">수정</button>
                     <form action="/mypage/popupstore/delete" method="post"
                        style="display: inline;">
                        <input type="hidden" name="storeId" value="${store.storeId}">
                        <button type="submit" id="deleteBtn"
                           onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                     </form>
                  </div>
               </div>
               
            </div>
         </c:forEach>
      </div>
   </section>
</body>
</html>
