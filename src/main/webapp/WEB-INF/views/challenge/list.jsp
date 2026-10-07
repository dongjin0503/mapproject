<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챌린지</title>
<style>
	* {
	box-sizing: border-box;
}

.container {
	margin: auto;
	width: 1000px;
	min-height: 1000px;
	padding: 20px 0;
}

/* 상단 버튼들 */
.btn {
	display: inline-block;
	padding: 6px 12px;
	border: 1px solid black;
	border-radius: 6px;
	background: #fff;
	text-decoration: none;
	color: black;
	cursor: pointer;
}

button {
	padding: 6px 12px;
	border: 1px solid #999;
	border-radius: 16px;
	background: #fff;
	cursor: pointer;
}

/* 카드 목록 (가로 3칸) */
.cards {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 16px;
	margin-top: 16px;
}

.card {
	border: 1px solid #ddd;
	border-radius: 10px;
	padding: 16px;
}

.card h3 {
	margin: 10px 0 6px;
}

/* 상태 칩 (c:choose로 클래스 나눌 때 사용) */
.chip {
	display: inline-block;
	padding: 2px 10px;
	border-radius: 12px;
	font-size: 12px;
	color: #fff;
}

.chip.ing {
	background: #2e7d32;
}

.chip.wait {
	background: #1565c0;
}

.chip.end {
	background: #757575;
}
</style>
</head>

<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<h2>챌린지 목록</h2>
	<div class = "container">
	<button> 진행중 </button>
	<button> 모집중 </button>
	<button> 종료 </button>
	<a class="btn" href="/challenge/create">챌린지 개설</a>

	<c:if test="${empty list}">
		<p>등록된 챌린지가 없어요</p>
	</c:if>
	
	<div class ="cards">
	<c:forEach var="ch" items="${list}">
		<div class ="card">
			<span> ${ch.status}</span>
			<h3> ${ch.title }</h3>
			${ch.start_date } ~ ${ch.end_date }
			<div>
			D-${ch.d_day } · ${ch.member_count }명
			</div>
			<a href = "/challenge/detail?challenge_id=${ch.challenge_id }">상세보기</a>	
		</div>
	</c:forEach>
	</div>
	
	</div>
	</body>
</html>
