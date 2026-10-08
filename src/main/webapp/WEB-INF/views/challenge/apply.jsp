<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<style>
		* {
		box-sizing : border-box;
		}
		
		div {
		border : 1px solid black;
		}
		
		.container {
		margin : auto;
		width : 800px;
		height : 1000px;
		}
	</style>
</head>
<body>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<div class = "container">
		<div>
		<Span> ${ch.title }</Span> <br>
		<span> 기간 참여자수</span> <br>
		<span> ${ch.start_date } ~ ${ch.end_date }</span>
		<span> ${ch.member_count } 명</span> <br>
		</div>
		
		<form action="/challenge/applyOk" method ="post">
		<input type ="hidden" name = "challenge_id" value = "${ch.challenge_id}">
		<span> 나의 목표 금액 / 목표치 *</span> 
		<br>
		<input name ="goal" type ="text" placeholder ="예 : 이번 달 배달비 3만원 이하"  required>
		<br>
		<span> 참여 다짐 한마디 * </span>
		<br>
		<input name = "pledge" type ="text" placeholder ="함께 절약할 목표나 각오를 적어주세요" required>
		<br>
		<span> 인증 주기</span>
		<br>
		<input name = "cycle" value = "daily" type ="radio"> 매일  
		<input name = "cycle" value = "weekly" type ="radio"> 주 2~3회 
		<br>
		<input type ="checkbox" required> 
		<span> 챌린지 규칙(인증 미제출 시 처리 방식 등)에 동의합니다</span>
		<br>
		<button type ="button"> <a href= "/challenge/list"> 취소 </a></button>
		<button type ="submit"> 참여 신청</button>
		</form>
		</div>
</body>
</html>