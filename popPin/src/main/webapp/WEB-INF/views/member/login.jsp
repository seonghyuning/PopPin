

<%-- <!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>

</head>
<body>
	<!-- 로그인 실패 메시지 -->
	<c:if test="${param.error == 'true'}">
		<p style="color: red;">Invalid email or password. Please try
			again.</p>
	</c:if>

	<!-- 권한 부족 메시지 -->
	<c:if test="${param.error == 'unauthorized'}">
		<p style="color: red;">Access denied. Please log in to use this
			page.</p>
	</c:if>

	<h1>Login Page</h1>
	<div class="form-container">
		<form method="post" action="/member/login">
			<label for="username">Username:</label> <input type="text"
				id="username" name="username" required> <label
				for="password">Password:</label> <input type="password"
				id="password" name="password" required>

			<button type="submit">Login</button>
		</form>
		<div class="links">
			<a href="/member/register">Sign Up</a> | <a
				href="/member/forgot-password">Forgot Password</a>
		</div>
	</div>
</body>
</html> --%>




<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
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
	
	<!-- 로그인 실패 메시지 -->
	<c:if test="${param.error == 'true'}">
		<p style="color: red;">Invalid email or password. Please try
			again.</p>
	</c:if>

	<!-- 권한 부족 메시지 -->
	<c:if test="${param.error == 'unauthorized'}">
		<p style="color: red;">Access denied. Please log in to use this
			page.</p>
	</c:if>
	
	
    <form method="post" action="/member/login" class="loginForm">
        <h1 id="registerTitle">로그인</h1>
        <label for="userName">아이디*</label>
        <input type="text" name="username" id="userName">

        <label for="password">비밀번호*</label>
        <input type="password" name="password" id="password" required>

        <p>회원 아니신가요? <a href="/member/register" style="text-decoration: underline;"><strong>회원 가입하기</strong></a></p> 
        <br>
        <button type="submit" class="loginBtn" id="registerBtn">로그인하기</button>
    </form>
</body>
</html>