<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>My Page</title>
</head>
<body>
    <h1>Welcome, ${user.nickname}!</h1>
    <p>Username: ${user.username}</p>
    <p>Email: ${user.email}</p>
    <p>Nickname: ${user.nickname}</p>
    <a href="/member/edit">Edit My Information</a>
</body>
</html>
