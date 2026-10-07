<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챌린지</title>
   <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
* {
	box-sizing: border-box;
}

.container {
	margin: auto;
	width: 900px;
	min-height: 800px;
	padding: 20px 0;
}

/* 필터 칩 + 개설 버튼 한 줄 */
.top {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

/* 개설 버튼 (검정 바탕 + 흰 글씨) */
.btn {
	display: inline-block;
	padding: 6px 12px;
	border: 1px solid black;
	border-radius: 6px;
	background: black;
	color: white;
	text-decoration: none;
	cursor: pointer;
}

/* 필터 칩 (진행중/모집중/종료) */
.filter {
	padding: 6px 14px;
	border: 1px solid #999;
	border-radius: 16px;
	background: #fff;
	cursor: pointer;
}

.filter.on {
	background: #333;
	color: #fff;
}

/* 카드 목록 (280px 카드 3칸) */
.cards {
	display: grid;
	grid-template-columns: repeat(3, 280px);
	gap: 16px;
	margin-top: 16px;
}

.card {
	border: 1px solid #ddd;
	border-radius: 10px;
	padding: 16px;
}

.card h3 {
	margin: 0 0 6px;
}

/* 진행바 */
.bar {
	height: 8px;
	background: #eee;
	border-radius: 4px;
	overflow: hidden;
	margin: 12px 0 4px;
}

.bar .fill {
	height: 100%;
	width: 0%;
	background: #555;
}

/* 상세보기 버튼 (가로 꽉 참) */
.detail {
	display: block;
	text-align: center;
	padding: 8px;
	margin-top: 12px;
	border: 1px solid black;
	border-radius: 6px;
	text-decoration: none;
	color: black;
}
</style>
</head>

<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<div class = "container">
	<h2>챌린지 목록</h2>
	
	<div class="top">
	<div>
	<button type ="button" class = "filter" data-f="진행중"> 진행중 </button>
	<button type ="button" class = "filter" data-f="모집중"> 모집중 </button>
	<button type ="button" class = "filter" data-f="종료"> 종료 </button>
	</div>
	<a class="btn" href="/challenge/create">챌린지 개설</a>
	</div>
	<c:if test="${empty list}">
		<p>등록된 챌린지가 없어요</p>
	</c:if>
	
	<div class ="cards" >
	<c:forEach var="ch" items="${list}">
		<div class ="card" data-status ="${ch.status }">
			<h3> ${ch.title }</h3>
			${ch.start_date } ~ ${ch.end_date }
			<div class="bar"><div class="fill"></div></div>
			<div>
			D-${ch.d_day } · 참여자 ${ch.member_count }명
			</div>
			<a class = "detail" href = "/challenge/detail?challenge_id=${ch.challenge_id }" >상세보기</a>	
		</div>
	</c:forEach>
	</div>
	</div>
	
	<script>
		$(".filter").on("click", function(){
			
			if ($(this).hasClass("on")){
				$(this).removeClass("on");
				$(".card").show();
				return;
			}
			
			$(".filter").removeClass("on");
			$(this).addClass("on");
			
			$(".card").hide();
			
			$(".card[data-status='" + $(this).data("f") + "']").show();

		})
	</script>
	</body>
</html>
