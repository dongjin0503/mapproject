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
* { box-sizing: border-box; }

.container {
	--line: #9ca3af;
	--line-strong: #4b5563;
	--fill: #f3f4f6;
	--fill-strong: #e5e7eb;
	--text: #374151;
	--dim: #9ca3af;
	--accent: #111827;
	margin: 0 auto;
	width: 900px;
	min-height: 800px;
	padding: 20px;
	font-family: Arial, "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
	color: var(--text);
}

.container h2 {
	margin: 0 0 16px;
	font-size: 19px;
	color: var(--accent);
}

/* 필터 칩 + 개설 버튼 한 줄 */
.top {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 14px;
}

/* 필터 칩 */
.filter {
	padding: 4px 12px;
	border: 1.2px solid var(--line);
	border-radius: 14px;
	background: #fff;
	color: var(--text);
	font-size: 11px;
	cursor: pointer;
	margin-right: 6px;
}

.filter:hover { background: var(--fill); }

.filter.on {
	background: var(--accent);
	border-color: var(--accent);
	color: #fff;
}

/* 개설 버튼 */
.btn {
	display: inline-block;
	padding: 7px 16px;
	border: 1.5px solid var(--accent);
	border-radius: 4px;
	background: var(--accent);
	color: #fff;
	font-size: 12.5px;
	text-decoration: none;
	cursor: pointer;
	transition: background-color 0.2s;
}

.btn:hover { background: #333; }

/* 카드 3칸 */
.cards {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 16px;
}

.card {
	border: 1.5px solid var(--line);
	border-radius: 6px;
	background: #fff;
	padding: 14px;
	position: relative;
	transition: transform 0.25s ease, box-shadow 0.25s ease;
}

/* 마우스를 올리면 커지고 그림자 */
.card:hover {
	transform: scale(1.05);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
	z-index: 20;
}

.card h3 {
	margin: 0 0 4px;
	padding-right: 30px;
	font-size: 15px;
	color: var(--accent);
}

.period {
	font-size: 12px;
	color: var(--dim);
}

/* 진행바 */
.bar {
	height: 8px;
	background: var(--fill-strong);
	border-radius: 4px;
	overflow: hidden;
	margin: 12px 0 4px;
}

.bar .fill {
	height: 100%;
	width: 0%;
	background: var(--line-strong);
	transition: width 0.6s ease;
}

.meta {
	font-size: 11px;
	color: var(--dim);
}

/* 상세보기 버튼 */
.detail {
	display: block;
	text-align: center;
	padding: 7px 16px;
	margin-top: 12px;
	border: 1.5px solid var(--line-strong);
	border-radius: 4px;
	background: #fff;
	color: var(--accent);
	font-size: 12.5px;
	text-decoration: none;
}

.detail:hover { background: var(--fill); }

.empty {
	padding: 40px 0;
	text-align: center;
	color: var(--dim);
	font-size: 13px;
}

/* 북마크 버튼 (팀원 코드 그대로) */
.bookmark-btn {
	position: absolute;
	top: 12px;
	right: 12px;
	border: none;
	background: none;
	font-size: 22px;
	color: #f59e0b;
	cursor: pointer;
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
		<p class="empty">등록된 챌린지가 없어요</p>
	</c:if>
	
	<div class ="cards" >
	
		<c:forEach var="ch" items="${list}">
	    <div class ="card" data-status ="${ch.status }" data-id="${ch.challenge_id}">
		<button type="button" class="bookmark-btn" data-id="${ch.challenge_id}">☆</button>
		
			<h3> ${ch.title }</h3>
			<div class="period">${ch.start_date } ~ ${ch.end_date }</div>
			<div class="bar"><div class="fill"></div></div>
			<div class ="meta">
			<span class ="dday"> D-${ch.d_day } </span>
			<span> · 참여자 <span class="cnt">${ch.member_count }</span>명 </span>
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

		});
		// 북마크한 챌린지는 ★로 표시
		$.get("/member/bookmarkIds", { contentType: "CHALLENGE" }, function(ids) {
			$(".bookmark-btn").each(function() {
				if (ids.includes($(this).data("id"))) $(this).text("★");
			});
		});

		// 클릭하면 토글
		$(document).on("click", ".bookmark-btn", function() {
			let btn = $(this);
			$.post("/member/bookmarkToggle", { contentType: "CHALLENGE", contentId: btn.data("id") }, function(r) {
				if (r === "login") location.href = "/member/login";
				else btn.text(r === "added" ? "★" : "☆");
			});
		});
		
		// 진행률/참여자수/D-day 를 서버에서 받아와 카드에 반영
		function refreshProgress() {
			$.ajax({
				url : "/challenge/ajax/progress",
				type : "get",
				dataType : "json",
				success : function(list) {
					// list 는 [{challenge_id:3, progress:54, ...}, {...}] 형태
					for (var i = 0; i < list.length; i++) {
						var item = list[i];

						// data-id 가 같은 카드 하나를 찾는다
						var card = $(".card[data-id='" + item.challenge_id + "']");

						// 진행률 바 너비
						card.find(".fill").css("width", item.progress + "%");

						// 참여자 수
						card.find(".cnt").text(item.member_count);

						// D-day 글자 (종료면 '종료됨')
						if (item.status == "종료") {
							card.find(".dday").text("종료됨");
						} else {
							card.find(".dday").text("D-" + item.d_day);
						}
					}
				}
			});
		}

		refreshProgress();                     // 화면이 열리자마자 한 번 실행
		setInterval(refreshProgress, 5000);    // 그 뒤로 5초(5000ms)마다 계속 실행
	</script>
	</body>
</html>
