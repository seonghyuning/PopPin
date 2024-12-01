<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검색</title>
</head>

<nav id="header">
	<a href="/store/list" id="logo">
		<img id="logoimg" src="/resources/img/Logo.png" alt="로고">
	</a>
    <!-- 검색 폼 -->
    <form action="/store/search" method="get">
        <input type="search" name="keyword" id="searchBar" placeholder="지역, 팝업스토어 이름 입력" value="${param.keyword}">
        <button type="submit" style="display: none;"></button>
    </form>
    <div>
        <a href="/store/mapSearch" id="mapBtn">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-map" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M15.817.113A.5.5 0 0 1 16 .5v14a.5.5 0 0 1-.402.49l-5 1a.5.5 0 0 1-.196 0L5.5 15.01l-4.902.98A.5.5 0 0 1 0 15.5v-14a.5.5 0 0 1 .402-.49l5-1a.5.5 0 0 1 .196 0L10.5.99l4.902-.98a.5.5 0 0 1 .415.103M10 1.91l-4-.8v12.98l4 .8zm1 12.98 4-.8V1.11l-4 .8zm-6-.8V1.11l-4 .8v12.98z"/>
            </svg>
            맵으로 검색
        </a>
        <a href="/member/mypage"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-fill" viewBox="0 0 16 16">
                <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
              </svg>마이페이지</a>
        <!-- 로그인 상태에 따라 버튼 표시 -->
        <sec:authorize access="isAuthenticated()">
            <!-- 로그인 상태 -->
            <button type="button" class="loginBtn" onclick="window.location.href='/member/logout'">로그아웃</button>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <!-- 비로그인 상태 -->
            <button type="button" class="loginBtn" onclick="window.location.href='/member/login'">회원가입 / 로그인</button>
        </sec:authorize>
    </div>
</nav>
</html>
