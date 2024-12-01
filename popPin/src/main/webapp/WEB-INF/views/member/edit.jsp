<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Poppin</title>
    <link rel="stylesheet" href="/resources/css/list.css">
</head>
<body>
    <%@ include file="../includes/header.jsp"%>
    <form method="post" action="/member/edit" class="loginForm">
        <h1 id="registerTitle">정보 수정</h1>
        <label for="nickName">닉네임</label>
        <input type="text" name="nickname" value="${user.nickname}" id="nickName">
        
        <label for="userName">이메일</label>
        <input type="text" name="email" value="${user.email}" id="userName">

        <label for="password">비밀번호</label>
        <input type="password" id="password" name="password" value="${password}">

        <br>
        <button type="submit" class="loginBtn" id="registerBtn">수정 완료</button>
    </form>
</body>
</html>