<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 챌린지 상세 페이지 </title>
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
	--note: #2563eb;
	width: 600px;
	margin: 24px auto;
	font-family: Arial, "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
	color: var(--text);
}

.container .box {
	border: 1.5px solid var(--line);
	border-radius: 6px;
	background: #fff;
	padding: 14px;
	margin-bottom: 14px;
}

/* 카테고리 칩 */
.cat {
	display: inline-block;
	padding: 2px 8px;
	margin-bottom: 6px;
	border: 1px solid var(--line);
	border-radius: 10px;
	font-size: 11px;
	color: var(--text);
	background: var(--fill);
}

.title {
	font-size: 17px;
	font-weight: 700;
	color: var(--accent);
	margin-bottom: 8px;
}

.info {
	display: flex;
	gap: 20px;
	font-size: 12px;
	color: var(--dim);
	line-height: 1.6;
	margin-bottom: 14px;
}

.info b {
	font-size: 13px;
	color: var(--text);
}

/* 참여하기 + 북마크 한 줄 */
.actions {
	display: flex;
	gap: 10px;
	align-items: center;
}

.btn-primary, .state {
	flex: 1;
	display: block;
	text-align: center;
	padding: 9px 16px;
	border-radius: 4px;
	font-size: 12.5px;
	text-decoration: none;
}

.btn-primary {
	background: var(--accent);
	border: 1.5px solid var(--accent);
	color: #fff;
}

.state {
	background: var(--fill);
	border: 1.5px solid var(--line);
	color: var(--text);
}

.state.end { color: var(--dim); }

/* 북마크 버튼 */
.bookmark-btn {
	flex: none;
	width: 38px;
	height: 38px;
	border: 1.5px solid var(--line-strong);
	border-radius: 4px;
	background: #fff;
	font-size: 16px;
	color: #f59e0b;
	cursor: pointer;
}

/* 나의 챌린지 박스 */
.myBox {
	margin-top: 12px;
	padding: 10px 12px;
	background: var(--fill);
	border: 1px solid var(--fill-strong);
	border-radius: 6px;
	font-size: 12px;
	line-height: 1.7;
}

.sec-label {
	font-size: 10px;
	letter-spacing: .4px;
	color: var(--dim);
	margin-bottom: 8px;
}

.desc {
	font-size: 13px;
	line-height: 1.7;
	white-space: pre-line;
}

/* 댓글 한 줄 */
.reply {
	padding: 8px 0;
	font-size: 13px;
	border-bottom: 1px solid var(--fill-strong);
}

.reply b { margin-right: 6px; }

/* 대댓글 들여쓰기 */
.reply.re { margin-left: 34px; }

.time {
	font-size: 12px;
	color: var(--dim);
	margin-left: 4px;
}

.reply button {
	padding: 2px 8px;
	border: 1px solid var(--line);
	border-radius: 4px;
	background: #fff;
	color: var(--text);
	font-size: 11px;
	cursor: pointer;
}

/* 답글 버튼은 파란 글씨 */
.reply .replyBtn {
	border: none;
	background: none;
	color: var(--note);
}

/* 답글/수정 폼: 처음엔 숨김 */
.reReplyForm { display: none; margin-top: 6px; }
.editForm { display: none; margin-top: 6px; }
.delForm { display: inline; }

.reReplyForm input[type=text],
.editForm input[type=text] {
	width: 60%;
	border: 1.5px solid var(--line);
	border-radius: 4px;
	padding: 6px 8px;
	font-size: 12px;
}

/* 댓글 입력줄 */
.replyWrite {
	display: flex;
	gap: 8px;
	margin-top: 14px;
}

.replyWrite input[type=text] {
	flex: 1;
	border: 1.5px solid var(--line);
	border-radius: 4px;
	padding: 8px 10px;
	font-size: 12px;
}

.replyWrite button {
	padding: 7px 16px;
	border: 1.5px solid var(--accent);
	border-radius: 4px;
	background: var(--accent);
	color: #fff;
	font-size: 12.5px;
	cursor: pointer;
}
</style>
</head>
<body>
		
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<div class = "container">
				<div class="box">
				
				<c:if test="${not empty ch.category}"><span class="cat">${ch.category}</span></c:if>
			<div class="title">${ch.title}</div>

			<div class="info">
				<div>⏳ 기간<br><b>${ch.start_date} ~ ${ch.end_date}</b></div>
				<div>👥 참여자수<br><b>${ch.member_count}명</b></div>
			</div>

			<div class="actions">
				<c:choose>
					<c:when test="${joined}">
						<span class="state">참여중</span>
					</c:when>
					<c:when test="${ch.status == '종료'}">
						<span class="state end">종료됨</span>
					</c:when>
					<c:otherwise>
						<a class="btn-primary" href="/challenge/apply?challenge_id=${ch.challenge_id}">참여하기</a>
					</c:otherwise>
				</c:choose>
				<button type="button" class="bookmark-btn" data-id="${ch.challenge_id}">☆</button>
			</div>

			<c:if test="${joined and not empty my.goal}">
				<div class="myBox">
					<b>나의 챌린지</b><br>
					목표 : ${my.goal}<br>
					다짐 : ${my.pledge}<br>
					<c:if test="${not empty my.cert_cycle}">인증주기 : ${my.cert_cycle}</c:if>
				</div>
			</c:if>
		</div>

		<div class="box">
			<div class="sec-label">챌린지 내용</div>
			<div class="desc">${ch.description}</div>
		</div>
		<div class ="box">
			<div class="sec-label">댓글 · 참여자 응원/인증</div>
		<c:forEach var ="r" items="${replyList}">
		<c:choose>
			<c:when test ="${empty r.parent_reply_id }">
			<div class = "reply">
			<b>${r.username }</b> ${r.content } <span class ="time"> ${r.created_at }</span>
			<button type ="button" class ="replyBtn"> 답글 </button>
			
			<c:if test = "${r.member_id == sessionScope.loginId }">
			<button type ="button" class = "editBtn"> 수정</button>
			
			<form class = "delForm" action ="/challenge/replyDelete" method ="post">
			<input type = "hidden" name ="challenge_reply_id" value="${r.challenge_reply_id}">
			<input type = "hidden" name ="challenge_id" value = "${ch.challenge_id }">
			<button type ="submit"> 삭제</button>
			</form>
			
			<form class = "editForm" action = "/challenge/replyUpdate" method = "post">
			<input type ="hidden" name ="challenge_reply_id" value="${r.challenge_reply_id }">
			<input type ="hidden" name ="challenge_id" value ="${ch.challenge_id }">
			<input type ="text" name = "content"  value ="${r.content }" required>
			<button type ="submit"> 저장 </button>
			</form>
			</c:if>
			
			
			<form class="reReplyForm" action="/challenge/replyOk" method="post">
			<input type ="hidden" name = "challenge_id" value="${ch.challenge_id }">
			<input type ="hidden" name = "parent_reply_id" value="${r.challenge_reply_id }">
			<input type ="text" name = "content" placeholder ="답글을 입력하세요.">
			<button type ="submit"> 등록</button>
			</form>
			
 			</div>
			</c:when>
			<c:otherwise>
			<div class ="reply re">
			<b>${r.username }</b> ${r.content }<span class ="time"> ${r.created_at }</span>
			<c:if test = "${r.member_id == sessionScope.loginId }">
			<button type ="button" class = "editBtn"> 수정</button>
			
			<form class = "delForm" action ="/challenge/replyDelete" method ="post">
			<input type = "hidden" name ="challenge_reply_id" value="${r.challenge_reply_id}">
			<input type = "hidden" name ="challenge_id" value = "${ch.challenge_id }">
			<button type ="submit"> 삭제</button>
			</form>
			
			<form class = "editForm" action = "/challenge/replyUpdate" method = "post">
			<input type ="hidden" name ="challenge_reply_id" value="${r.challenge_reply_id }">
			<input type ="hidden" name ="challenge_id" value ="${ch.challenge_id }">
			<input type ="text" name = "content"  value ="${r.content }" required>
			<button type ="submit"> 저장 </button>
			</form>
			</c:if>
			
			</div>
			</c:otherwise>
		</c:choose>
		</c:forEach>
		<form class="replyWrite" action="/challenge/replyOk" method="post">
		<input type ="hidden" name ="challenge_id" value = "${ch.challenge_id }">		
		<input name ="content" type ="text" placeholder = "댓글입력" required> 
		<button type = "submit"> 등록 </button>
		</form>
		
		</div>
		</div>
	
	<script>
		$(".replyBtn").on("click", function(){
			$(this).closest(".reply").find(".reReplyForm").toggle();	
		})
		
		$(".editBtn").on("click", function(){
			$(this).closest(".reply").find(".editForm").toggle();
		})
		
	    $(".delForm").on("submit", function(){
		return confirm("정말 삭제할까요?");
		});
		
		// 이 챌린지를 북마크했으면 ★ 로 표시
		$.get("/member/bookmarkIds", { contentType : "CHALLENGE" }, function(ids) {
			$(".bookmark-btn").each(function() {
				if (ids.includes($(this).data("id"))) {
					$(this).text("★");
				}
			});
		});

		// 클릭하면 북마크 켜기/끄기
		$(document).on("click", ".bookmark-btn", function() {
			var btn = $(this);
			$.post("/member/bookmarkToggle", { contentType : "CHALLENGE", contentId : btn.data("id") }, function(r) {
				if (r === "login") {
					location.href = "/member/login";
				} else if (r === "added") {
					btn.text("★");
				} else {
					btn.text("☆");
				}
			});
		});
	</script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>