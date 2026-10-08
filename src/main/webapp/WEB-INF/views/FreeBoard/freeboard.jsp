<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판</title>

<style>

* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: "Noto Sans KR", "Malgun Gothic", Arial, sans-serif;
	color: #1c2535;
	background-color: #fff;
}

/* 전체 컨테이너 */
.container {
	width: 1200px;
	max-width: calc(100% - 40px);
	margin: auto;
}

/* 게시판 전체 */
.board-container {
	padding: 25px 0;
}

/* =========================
   카테고리
========================= */
.category {
	display: flex;
	gap: 8px;
	margin-bottom: 16px;
}

.category input[type=button] {
	padding: 8px 20px;
	border: 1px solid #d5dce7;
	border-radius: 20px;
	background: white;
	color: #39465c;
	font-size: 13px;
	cursor: pointer;
}

.category input[type=button]:hover {
	border-color: #1c2535;
}

.category input[type=button].active {
	background: #1c2535;
	color: white;
	border-color: #1c2535;
}

/* =========================
   검색 및 글쓰기
========================= */
.board-tools {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 14px;
}

.search-box form {
	display: flex;
	gap: 6px;
}

.search-box input[type=text] {
	width: 280px;
	height: 38px;
	padding: 0 12px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background: white;
	font-size: 13px;
}

.search-box input[type=text]:focus {
	outline: none;
	border-color: #1c2535;
}

.search-box input[type=submit] {
	height: 38px;
	padding: 0 16px;
	border: 1px solid #1c2535;
	border-radius: 6px;
	background: white;
	color: #1c2535;
	font-size: 13px;
	cursor: pointer;
}

.search-box input[type=submit]:hover {
	background: #1c2535;
	color: white;
}

.write-btn {
	height: 38px;
	padding: 0 22px;
	background: #1c2535;
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 13px;
	font-weight: bold;
	cursor: pointer;
}

.write-btn:hover {
	background: #2d3a52;
}

/* =========================
   게시글 목록
========================= */
.board-list {
	background: white;
	border: 1px solid #d5dce7;
	border-radius: 10px;
	overflow: hidden;
	box-shadow: 0 2px 10px rgba(28, 37, 53, 0.05);
}

.board-list table {
	width: 100%;
	border-collapse: collapse;
	table-layout: fixed;
	font-size: 13px;
}

.board-list th {
	height: 44px;
	background: #f3f5f9;
	color: #5a6678;
	font-weight: bold;
	border-bottom: 1px solid #d5dce7;
}

.board-list th:nth-child(1) {
	width: 70px;
}

.board-list th:nth-child(2) {
	width: 90px;
}

.board-list th:nth-child(3) {
	text-align: left;
	padding-left: 15px;
}

.board-list th:nth-child(4) {
	width: 130px;
}

.board-list th:nth-child(5) {
	width: 80px;
}

.board-list th:nth-child(6) {
	width: 110px;
}

.board-list td {
	height: 46px;
	padding: 0 10px;
	border-bottom: 1px solid #e8ecf3;
	color: #8995a9;
	text-align: center;
}
.board-list td:nth-child(4) {
	white-space: nowrap; /* 작성자 컬럼 줄바꿈 방지 */
}

.board-list tr:last-child td {
	border-bottom: none;
}

.board-list tr:hover td {
	background: #f9fafc;
}

.board-list td:nth-child(2) {
	color: #2457d6;
	font-size: 12px;
}

.board-list td.title {
	text-align: left;
	padding-left: 15px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.board-list td.title a {
	color: #1c2535;
	font-size: 14px;
	text-decoration: none;
}

.board-list td.title a:hover {
	color: #2457d6;
}

/* 게시글이 없을 때 */
.board-list td[colspan] {
	padding: 60px 0;
	text-align: center;
}

/* 댓글 개수 */
.board-list td.title .reply-count {
	color: #2457d6;
	font-weight: bold;
	font-size: 12px;
	margin-left: 6px;
}

/* =========================
   페이지네이션
========================= */
.pagination {
	display: flex;
	justify-content: center;
	gap: 6px;
	margin-top: 24px;
}

.pagination a {
	min-width: 34px;
	padding: 7px 10px;
	text-align: center;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background: white;
	text-decoration: none;
	color: #39465c;
	font-size: 13px;
}

.pagination a:hover {
	border-color: #1c2535;
}

.pagination .active {
	background: #1c2535;
	color: white;
	border-color: #1c2535;
}

/* 총 게시물 수 */
.board-container > span {
	display: block;
	margin-top: 12px;
	text-align: center;
	color: #8995a9;
	font-size: 12px;
}
.meBadge {
	margin-left: 6px;
	padding: 1px 8px;
	border-radius: 10px;
	background-color: #e8eefc;
	color: #2457d6;
	font-size: 11px;
	font-weight: bold;
}
.myRow { background-color: #f3f6ff; }

</style>
</head>

<body>
	<!-- 1. 공통 헤더 -->
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<div class="container">

		<!-- 자유게시판 전체 -->
		<div class="board-container">

			<!-- 2. 카테고리 -->
			<div class="category">
				<input type="button" class="${empty category ? 'active' : ''}" value="전체" onclick="goCategory('')">
				<input type="button" class="${category == '공지' ? 'active' : ''}" value="공지" onclick="goCategory('공지')">
				<input type="button" class="${category == '자유' ? 'active' : ''}" value="자유" onclick="goCategory('자유')">
				<input type="button" class="${category == '질문' ? 'active' : ''}" value="질문" onclick="goCategory('질문')">
				<input type="button" class="${category == '정보' ? 'active' : ''}" value="정보" onclick="goCategory('정보')">
			</div>
			<!-- 3. 검색 및 글쓰기 -->
			<div class="board-tools">

				<div class="search-box">
				
					<form action="/FreeBoard/freeboard">
					<input type="hidden" name="category" value="<c:out value='${category}'/>">
						<input type="text" name="search" value="<c:out value='${search}'/>" placeholder="제목으로 게시글 검색">
						<input type="submit" value="검색">
					</form>
				</div>
				
				<div class="write-box">
					<input type="button" class="write-btn" value="글쓰기"
						onclick="location.href='/FreeBoard/write'">
				</div>
			</div>


			<!-- 4. 게시글 목록 -->
			<div class="board-list">
				<table>
					<tr>
						<th>번호</th>
						<th>카테고리</th>
						<th>제목</th>
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
							<c:forEach var="i" items="${list}">
								<tr>
									<td>${i.postId}</td>
									<td>${i.contentCategory}</td>
									<td class="title"><a href="/FreeBoard/detail?postId=${i.postId}&cpage=${cpage}"><c:out value="${i.title}"/></a>
										<c:if test="${i.replyCount > 0}"><span class="reply-count">[${i.replyCount}]</span></c:if>
									</td>
									<td><c:out value="${i.username}"/>
										<c:if test="${i.memberId == loginId}"><span class="meBadge">나</span></c:if>
									</td>
									<td>${i.viewCount}</td>
									<td><fmt:formatDate value="${i.createdAt}" pattern="yyyy.MM.dd"/></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</table>
			</div>

			<!-- 페이지네이션 -->
			<div class="pagination" id="navigation" data-search="<c:out value='${search}'/>" data-category="<c:out value='${category}'/>"></div>
			<script>
				let recordTotalCount = ${recordTotalCount};
				let recordCountPerPage = ${recordCountPerPage};
				let naviCountPerPage = ${naviCountPerPage};
				let currentPage = ${cpage};

				let pageTotalCount = Math.ceil(recordTotalCount / recordCountPerPage);

				let startNavi = Math.floor((currentPage - 1)/ naviCountPerPage) * naviCountPerPage + 1;
				let endNavi = startNavi + naviCountPerPage - 1;
				if (endNavi > pageTotalCount) {
					endNavi = pageTotalCount;
				}

				let needPrev = startNavi > 1;
				let needNext = endNavi < pageTotalCount;

				let navi = document.getElementById("navigation");
				let searchWord = navi.dataset.search;
				let categoryWord = navi.dataset.category;
				// 카테고리 버튼: 검색어는 유지하고 1페이지부터
				function goCategory(c) {
					location.href = "/FreeBoard/freeboard?category=" + encodeURIComponent(c) + "&search=" + encodeURIComponent(searchWord);
				}
				function addLink(text, page, active) {
					let a = document.createElement("a");
					a.setAttribute("href", "/FreeBoard/freeboard?cpage=" + page + "&search=" + encodeURIComponent(searchWord) + "&category=" + encodeURIComponent(categoryWord));
					a.textContent = text;
					if (active)
						a.classList.add("active");
					navi.append(a);
				}

				if (needPrev)
					addLink("<", startNavi - 1, false);

				for (let i = startNavi; i <= endNavi; i++) {
					addLink(i, i, i === currentPage);
				}

				if (needNext)
					addLink(">", endNavi + 1, false);
			</script>
			<span>총 게시물 수: ${recordTotalCount }</span>
		</div>
	</div>

</body>
</html>