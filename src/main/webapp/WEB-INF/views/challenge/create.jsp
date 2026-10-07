<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챌린지 개설</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
	
	<style>
	* {
	box-sizing : border-box;
	}
	.container {
	margin : auto;
	width : 800px;
	height : 900px; 
	}
	div {
	border : 1px solid black;
	}
	</style>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="container"> 
	<h2> 챌린지 개설 </h2>
	<form action = "/challenge/createOk" method = "post">
	<p> 제목 <input type ="text" name ="title" > </p>
	<p> 시작일 <input type ="date" name = "start_date"> </p>
	<p> 종료일 <input type = "date" name = "end_date"> </p>
	<p> 설명 <br>
	<textarea name = "description" rows="5" cols ="50"> </textarea></p>
	<button type ="button"  onclick ="history.back()">취소 </button>
	<button type = "submit" > 개설 </button>
	</form> 
	</div>
</body>
</html>