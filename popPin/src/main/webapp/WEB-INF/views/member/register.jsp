<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <form method="post" action="/member/register" class="loginForm">
        <h1 id="registerTitle">회원가입</h1>
        <label for="userName">아이디*</label>
        <input type="text" name="username" id="userName" required>

        <label for="email">이메일*</label>
        <input type="email" name="email" id="email" required>

        <label for="nickName">닉네임</label>
        <input type="text" name="nickname" id="nickName" >

        <label for="password">비밀번호*</label>
        <input type="password" name="password" id="password" required>

        <label for="confirmPassword">비밀번호 확인*</label>
        <input type="password" name="confirm-password" id="confirmPassword" required>
        <p>이미 가입하셨나요 ? <a href="/member/login" style="text-decoration: underline;"><strong>로그인하기</strong></a></p> 
        <br>
        <button type="submit" class="loginBtn" id="registerBtn">가입 완료</button>
    </form>
</body>
</html>