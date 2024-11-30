<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit My Information</title>
</head>
<body>
    <h1>Edit Your Information</h1>
    <form method="post" action="/member/edit">
        <label for="nickname">Nickname:</label>
        <input type="text" id="nickname" name="nickname" value="${user.nickname}" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="${user.email}" required>
        <br>
        <label for="password">Password (leave blank to keep current):</label>
        <input type="password" id="password" name="password">
        <br>
        <button type="submit">Update</button>
    </form>
</body>
</html>
