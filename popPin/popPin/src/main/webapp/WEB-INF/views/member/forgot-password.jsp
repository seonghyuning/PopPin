<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Forgot Password</title>
<style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center;
        }
        .form-container {
            width: 300px;
            margin: 20px auto;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 10px;
        }
        .form-container label {
            display: block;
            margin-bottom: 5px;
        }
        .form-container input {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form-container button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-container button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h1>Forgot Password</h1>
    <div class="form-container">
        <form method="post" action="/member/forgot-password">
            <label for="forgot-email">Enter your email:</label>
            <input type="email" id="forgot-email" name="email" required>
            
            <button type="submit">Reset Password</button>
        </form>
    </div>
</body>
</html>
