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
	* {
	box-sizing : border-box;
	}
	
	div {
	border : 1px solid black;
	}
	
	.container{
	margin : auto;
	width : 800px;
	height : 1000px;
	}
	
	/* 댓글 한 줄 */
	.reply {
	padding : 8px;
	}
	
	/* 대댓글: 오른쪽으로 들여쓰기 */
	.reply.re {
	margin-left : 34px;
	}
	
	/* 작성 시간: 작고 연한 글씨 */
	.time {
	font-size : 12px;
	color : gray;
	}
	
	/* 답글 폼: 처음엔 숨김, 답글 버튼 누르면 보임 */
	.reReplyForm {
	display : none;
	}
	
	.editForm { display : none; }
	.delForm { display : inline; }
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
		
		<c:choose>
			<c:when test ="${joined}">
			<span> 참여중 </span>
			</c:when>
			
			<c:when test = "${ch.status == '종료' }">
			<span> 종료됨 </span>
			</c:when>
			
			<c:otherwise>
			<a href="/challenge/apply?challenge_id=${ch.challenge_id}"> 참여하기 </a>
			</c:otherwise>
		</c:choose>
		<button type="button" class="bookmark-btn" data-id="${ch.challenge_id}">☆</button>
		</div>
		<div>
		<span> ${ch.status } </span>
		<div> ${ch.description }</div>
		</div>
		<div>
		댓글 · 참여자 응원/인증 <br>
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
			
			
			<form class = "reReplyForm"  action = "/challenge/replyOk" method ="post">
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
		<form action = "/challenge/replyOk" method ="post">
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
</body>
</html>