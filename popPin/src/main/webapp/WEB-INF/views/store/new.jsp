<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 팝업스토어 추가 폼 -->
    <form action="/store/new" method="post">
	    <input type="text" name="name" placeholder="스토어 이름" required><br/>
	    <input type="text" name="location" placeholder="위치" required><br/>
	    <textarea name="description" placeholder="상세 정보" required></textarea><br/>
	    <input type="date" name="startDate" required><br/>
	    <input type="date" name="endDate" required><br/>
	    <button type="submit">Store 등록</button>
	</form>
</body>
</html>