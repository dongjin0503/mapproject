<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> Q&A 게시판 </title>
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
.btn-primary { height:38px; padding:0 22px; background:#1c2535; color:#fff; border:none; border-radius:6px; font-size:13px; font-weight:bold; cursor:pointer; }
.btn-primary:hover { background:#2d3a52; }
.btn-cancel { display:inline-flex; align-items:center; height:38px; padding:0 22px; border:1px solid #d5dce7; border-radius:6px; background:#fff; color:#39465c; font-size:13px; }
.btn-cancel:hover { border-color:#1c2535; }
.btn-sm { display:inline-block; padding:6px 14px; border:1px solid #d5dce7; border-radius:6px; background:#fff; color:#39465c; font-size:12px; cursor:pointer; }
.btn-sm:hover { border-color:#1c2535; }
.btn-sm.del { color:#e91717; border-color:#ffd6d6; background:#fff0f0; }
.btn-sm.primary { background:#1c2535; color:#fff; border-color:#1c2535; }
.btn-list { display:inline-block; margin:0 0 14px; padding:9px 18px; border:1px solid #d5dce7; border-radius:6px; background:#fff; color:#39465c; font-size:13px; }

/* 목록: 검색과 질문하기 */
.board-tools { display:flex; justify-content:space-between; align-items:center; margin-bottom:14px; }
.search-box form { display:flex; gap:6px; }
.search-box input[type=text] { width:280px; height:38px; padding:0 12px; border:1px solid #d5dce7; border-radius:6px; background:#fff; font-size:13px; }
.search-box input[type=text]:focus { outline:none; border-color:#1c2535; }
.search-box input[type=submit] { height:38px; padding:0 16px; border:1px solid #1c2535; border-radius:6px; background:#fff; color:#1c2535; font-size:13px; cursor:pointer; }
.search-box input[type=submit]:hover { background:#1c2535; color:#fff; }
.write-btn { height:38px; padding:0 22px; background:#1c2535; color:#fff; border:none; border-radius:6px; font-size:13px; font-weight:bold; cursor:pointer; }
.write-btn:hover { background:#2d3a52; }

/* 목록: 표 */
.board-list table { width:100%; border-collapse:collapse; table-layout:fixed; font-size:13px; }
.board-list th { height:44px; background:#f3f5f9; color:#5a6678; font-weight:bold; border-bottom:1px solid #d5dce7; }
.board-list th:nth-child(1) { width:70px; }
.board-list th:nth-child(2) { text-align:left; padding-left:15px; }
.board-list th:nth-child(3) { width:100px; }
.board-list th:nth-child(4) { width:150px; }
.board-list th:nth-child(5) { width:80px; }
.board-list th:nth-child(6) { width:110px; }
.board-list td { height:46px; padding:0 10px; border-bottom:1px solid #e8ecf3; color:#8995a9; text-align:center; }
.board-list tr:last-child td { border-bottom:none; }
.board-list tr:hover td { background:#f9fafc; }
.board-list td.title { text-align:left; padding-left:15px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.board-list td.title a { color:#1c2535; font-size:14px; }
.board-list td.title a:hover { color:#2457d6; }
.board-list td:nth-child(4) { white-space:nowrap; }
.board-list td[colspan] { padding:60px 0; text-align:center; }
.st { font-weight:bold; color:#8995a9; }
.st.done { color:#16a34a; }

/* 글쓰기, 수정 폼 */
.box > form { padding:22px; }
.field { margin-bottom:18px; }
.lbl { font-size:13px; font-weight:bold; margin-bottom:8px; color:#39465c; }
.lbl em { color:#e91717; font-style:normal; }
.field input[type="text"] { width:100%; height:42px; padding:0 12px; border:1px solid #d5dce7; border-radius:6px; font-size:14px; }
.field input[type="text"]:focus, textarea:focus { outline:none; border-color:#1c2535; }
.field textarea { min-height:280px; }
.agree { display:flex; align-items:center; gap:8px; margin-bottom:18px; font-size:14px; cursor:pointer; }
.agree input { width:16px; height:16px; margin:0; }
.btns { display:flex; justify-content:flex-end; gap:8px; }

/* 상세: 제목 카드 */
.box > .ttl { padding:20px 22px 8px; font-size:20px; font-weight:bold; }
.info { padding:0 22px 16px; font-size:12px; color:#8995a9; display:flex; gap:14px; border-bottom:1px solid #e8ecf3; }
.desc { padding:22px; min-height:140px; white-space:pre-wrap; line-height:1.7; font-size:14px; }
.box .btns { margin:0; padding:12px 22px; border-top:1px solid #e8ecf3; }

/* 상세: 답변 */
.sec-label { padding:14px 22px; font-size:13px; font-weight:bold; color:#5a6678; border-bottom:1px solid #d5dce7; background:#f3f5f9; }
.box > p { padding:24px 22px; margin:0; color:#8995a9; font-size:13px; }
.reply { padding:16px 22px; border-bottom:1px solid #e8ecf3; }
.r-top { display:flex; align-items:center; gap:8px; margin-bottom:6px; }
.r-top b { font-size:13px; }
.time { font-size:11px; color:#8995a9; }
.r-body { white-space:pre-wrap; line-height:1.6; font-size:14px; }
.r-act { display:flex; justify-content:flex-end; gap:6px; margin-top:8px; }

textarea { width:100%; padding:12px; border:1px solid #d5dce7; border-radius:6px; font-family:inherit; font-size:14px; resize:vertical; }
.reply-edit-form { margin-top:10px; }
.reply-edit-form textarea { min-height:80px; margin-bottom:6px; }
.reply-edit-form .r-act { margin-top:0; }
.reply-write { padding:16px 22px; background:#f3f5f9; }
.reply-write textarea { min-height:90px; margin-bottom:8px; }
.reply-write .r-act { margin-top:0; }

.lock { color:#5a6678; font-size:12px; margin-right:6px; }

</style>
</head>

<body>
	
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	
		<div class="container">

		<h2 class="page-title">Q&A 게시판</h2>

		<div class="board-tools">
			<div class="search-box">
				<form action="/qna/list" method="get">
					<input type="text" name="keyword" value="<c:out value='${keyword}'/>" placeholder="제목으로 게시글 검색">
					<input type="submit" value="검색">
				</form>
			</div>
			<div class="write-box">
				<input type="button" class="write-btn" value="질문하기" onclick="location.href='/qna/write'">
			</div>
		</div>

		<div class="board-list box">
			<table>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>답변</th>
					<th>작성자</th>
					<th>조회 수</th>
					<th>작성일</th>
				</tr>
				<c:choose>
					<c:when test="${empty list}">
						<tr>
							<td colspan="6">표시할 내용이 없습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="q" items="${list}">
							<tr>
								<td>${q.qna_id}</td>
								<td class="title">
									<c:if test="${q.secret == 'Y'}"><i class="fa-solid fa-lock lock"></i></c:if>
									<a href="/qna/detail?qna_id=${q.qna_id}"><c:out value="${q.title}"/></a>
								</td>
								<c:choose>
									<c:when test="${q.reply_count > 0}">
										<td class="st done">답변완료</td>
									</c:when>
									<c:otherwise>
										<td class="st">답변대기</td>
									</c:otherwise>
								</c:choose>
								<td><c:out value="${q.username}"/></td>
								<td>${q.view_count}</td>
								<td><fmt:formatDate value="${q.write_date}" pattern="yy.MM.dd HH:mm"/></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</table>
		</div>

	</div>	
</body>
</html>