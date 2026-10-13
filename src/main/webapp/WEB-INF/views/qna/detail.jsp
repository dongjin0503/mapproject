<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q&A 게시글</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.3.1/css/all.css" crossorigin="anonymous" referrerpolicy="no-referrer">

<style>
* { box-sizing:border-box; }

.container { width:1200px; max-width:calc(100% - 40px); margin:auto; font-family:"Noto Sans KR","Malgun Gothic",Arial,sans-serif; color:#1c2535; background:#fff; padding:25px 0; }
a { text-decoration:none; color:inherit; }
.page-title { margin:0 0 18px; font-size:22px; font-weight:700; color:#1c2535; }

/* 카드 */
.box { background:#fff; border:1px solid #d5dce7; border-radius:10px; margin-bottom:14px; overflow:hidden; box-shadow:0 2px 10px rgba(28,37,53,.05); }

/* 버튼 */
.btn-sm { display:inline-block; padding:6px 14px; border:1px solid #d5dce7; border-radius:6px; background:#fff; color:#39465c; font-size:12px; cursor:pointer; }
.btn-sm:hover { border-color:#1c2535; }
.btn-sm.del { color:#e91717; border-color:#ffd6d6; background:#fff0f0; }
.btn-sm.primary { background:#1c2535; color:#fff; border-color:#1c2535; }
.btn-list { display:inline-block; margin:0 0 14px; padding:9px 18px; border:1px solid #d5dce7; border-radius:6px; background:#fff; color:#39465c; font-size:13px; }

/* 질문 카드 */
.box > .ttl { padding:20px 22px 8px; font-size:20px; font-weight:bold; }
.lock { color:#5a6678; font-size:12px; margin-right:6px; }
.info { padding:0 22px 16px; font-size:12px; color:#8995a9; display:flex; gap:14px; border-bottom:1px solid #e8ecf3; }
.desc { padding:22px; min-height:140px; white-space:pre-wrap; line-height:1.7; font-size:14px; }
.btns { display:flex; justify-content:flex-end; gap:8px; margin:0; padding:12px 22px; border-top:1px solid #e8ecf3; }

/* 답변 카드: 전체가 같은 회색 */
.box.answer { background:#f3f5f9; padding-bottom:14px; }
.sec-label { display:flex; justify-content:space-between; align-items:center; padding:12px 22px; font-size:13px; font-weight:bold; color:#5a6678; border-bottom:1px solid #e3e8f0; }
.state { display:inline-flex; align-items:center; gap:6px; padding:3px 10px; border-radius:12px; font-size:11px; font-weight:bold; }
.state i { width:6px; height:6px; border-radius:50%; }
.state.wait { background:#fff4e0; color:#b45309; }
.state.wait i { background:#f59e0b; }

/* 답변 한 개 */
.reply { padding:16px 22px 4px; }
.r-top { display:flex; align-items:center; gap:8px; margin-bottom:8px; }
.r-top b { font-size:13px; }
.chip { background:#1c2535; color:#fff; font-size:11px; font-weight:bold; padding:2px 8px; border-radius:10px; }
.time { font-size:12px; color:#8995a9; }
.r-act { margin-left:auto; display:flex; gap:12px; }
.txt { padding:0; border:none; background:none; font-size:12px; color:#8995a9; cursor:pointer; }
.txt:hover { color:#1c2535; }
.txt.del { color:#e91717; }
.bubble { background:#fff; border:1px solid #e3e8f0; border-radius:12px; padding:12px 16px; font-size:14px; line-height:1.6; white-space:pre-wrap; }

/* 답변 수정 입력 */
.reply-edit-form { margin-top:8px; }
textarea { width:100%; padding:12px; border:1px solid #d5dce7; border-radius:6px; background:#fff; font-family:inherit; font-size:14px; resize:vertical; }
textarea:focus { outline:none; border-color:#1c2535; }
.reply-edit-form textarea { min-height:80px; margin-bottom:6px; }
.reply-edit-form .save { display:flex; justify-content:flex-end; }

/* 답변 등록: 한 줄 */
.box > form.reply-write { display:flex; gap:10px; padding:12px 22px 0; }
.reply-write textarea { flex:1; height:44px; min-height:44px; resize:none; padding:11px 12px; }
.reply-write .btn-sm { padding:0 22px; font-size:13px; }
</style>
</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<h2 class="page-title">Q&A</h2>

		<!-- 질문 -->
		<div class="box">
			<div class="ttl">
				<c:if test="${qna.secret == 'Y'}"><i class="fa-solid fa-lock lock"></i></c:if>
				<c:out value="${qna.title}"/>
			</div>
			<div class="info">
				<span><c:out value="${qna.username}"/></span>
				<span><fmt:formatDate value="${qna.write_date}" pattern="yyyy.MM.dd HH:mm"/></span>
				<span>조회 ${qna.view_count}</span>
			</div>

			<div class="desc"><c:out value="${qna.contents}"/></div>

			<c:if test="${qna.writer == sessionScope.loginId}">
			<div class="btns">
				<a class="btn-sm" href="/qna/update?qna_id=${qna.qna_id}">수정</a>
				<a class="btn-sm del" href="/qna/delete?qna_id=${qna.qna_id}" onclick="return confirm('정말 삭제할까요?')">삭제</a>
			</div>
			</c:if>

			<c:if test="${sessionScope.loginId == 'admin' && qna.writer != sessionScope.loginId}">
			<div class="btns">
				<a class="btn-sm del" href="/qna/delete?qna_id=${qna.qna_id}" onclick="return confirm('관리자 권한으로 삭제할까요?')">삭제</a>
			</div>
			</c:if>
		</div>

		<!-- 답변 -->
		<div class="box answer">
			<div class="sec-label">
				<span>답변</span>
				<c:if test="${empty replyList}">
					<span class="state wait"><i></i>답변 대기 중</span>
				</c:if>
			</div>

			<c:forEach var="r" items="${replyList}">
			<div class="reply">
				<div class="r-top">
					<b><c:out value="${r.username}"/></b>
					<span class="chip">관리자</span>
					<span class="time"><fmt:formatDate value="${r.write_date}" pattern="yyyy.MM.dd HH:mm"/></span>

					<c:if test="${sessionScope.loginId == 'admin'}">
					<div class="r-act">
						<button type="button" class="txt btn-reply-edit">수정</button>
						<a class="txt del" href="/qna/replyDelete?qna_reply_id=${r.qna_reply_id}&qna_id=${qna.qna_id}" onclick="return confirm('답변을 삭제할까요?')">삭제</a>
					</div>
					</c:if>
				</div>

				<div class="bubble"><c:out value="${r.contents}"/></div>

				<c:if test="${sessionScope.loginId == 'admin'}">
				<form action="/qna/replyUpdateOk" method="post" class="reply-edit-form" style="display:none">
					<input type="hidden" name="qna_reply_id" value="${r.qna_reply_id}">
					<input type="hidden" name="parent_qna_id" value="${qna.qna_id}">
					<textarea name="contents" required>${r.contents}</textarea>
					<div class="save">
						<button type="submit" class="btn-sm primary">저장</button>
					</div>
				</form>
				</c:if>
			</div>
			</c:forEach>

			<c:if test="${sessionScope.loginId == 'admin'}">
			<form action="/qna/replyOk" method="post" class="reply-write">
				<input type="hidden" name="parent_qna_id" value="${qna.qna_id}">
				<textarea name="contents" placeholder="답변을 입력하세요" required></textarea>
				<button type="submit" class="btn-sm primary">등록</button>
			</form>
			</c:if>
		</div>

		<a class="btn-list" href="/qna/list">목록으로</a>

	</div>

	<script>
	$(".btn-reply-edit").click(function(){
		$(this).closest(".reply").find(".reply-edit-form").toggle();
	});
	</script>
</body>
</html>