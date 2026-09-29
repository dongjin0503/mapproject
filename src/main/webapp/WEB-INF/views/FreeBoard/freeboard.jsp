<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>짠내맵 - 자유게시판</title>

<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, sans-serif;
	color: #1c2535;
	background-color: #ffffff;
}

/* 전체 컨테이너 */
.container {
	width: 1200px;
	margin: auto;
}

/* 1. 상단 네비게이션 */
.header {
	height: 75px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	border-bottom: 1px solid #aab3c4;
}

.header-left {
	display: flex;
	align-items: center;
	gap: 30px;
}

.logo {
	font-size: 20px;
	font-weight: bold;
}

.nav {
	display: flex;
	gap: 25px;
}

.nav a {
	text-decoration: none;
	color: #1c2535;
	font-weight: bold;
	padding: 25px 0;
}

.nav .active {
	border-bottom: 2px solid #1c2535;
}

.header-right {
	display: flex;
	align-items: center;
	gap: 12px;
}

.logout-btn {
	padding: 8px 18px;
	background: white;
	border: 1px solid #aab3c4;
	border-radius: 5px;
	cursor: pointer;
}

.profile {
	width: 32px;
	height: 32px;
	border: 1px solid #aab3c4;
	background: #f0f3f8;
	border-radius: 50%;
}

/* 2. 게시판 전체 */
.board-container {
	padding: 25px 0;
}

/* 3. 카테고리 */
.category {
	display: flex;
	gap: 8px;
	margin-bottom: 15px;
}

.category button {
	padding: 8px 18px;
	border: 1px solid #aab3c4;
	border-radius: 20px;
	background: white;
	color: #39465c;
	cursor: pointer;
}

.category .active {
	background: #1c2535;
	color: white;
	border-color: #1c2535;
}

/* 4. 검색 및 글쓰기 */
.board-tools {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
}

.search-box input {
	width: 260px;
	height: 36px;
	padding: 10px;
	border: 1px solid #aab3c4;
	border-radius: 5px;
}

.write-btn {
	padding: 10px 20px;
	background: #1c2535;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

/* 5. 게시글 목록 */
.board-list {
	border: 1px solid #aab3c4;
	border-radius: 5px;
	overflow: hidden;
}

.board-row {
	display: flex;
	align-items: center;
	height: 43px;
	padding: 0 15px;
	border-bottom: 1px solid #e0e5ed;
	font-size: 13px;
}

.board-row:last-child {
	border-bottom: none;
}

.board-number {
	width: 40px;
	color: #8995a9;
	flex-shrink: 0;
}

.board-title {
	flex: 1;
	min-width: 0;
}

.board-title a {
	color: #1c2535;
	text-decoration: none;
}

.board-title a:hover {
	text-decoration: underline;
}

.reply-count {
	color: #2457d6;
	font-weight: bold;
	margin-left: 5px;
}

.board-writer {
	width: 90px;
	text-align: right;
	color: #8995a9;
}

.board-views {
	width: 75px;
	text-align: right;
	color: #8995a9;
}

.board-date {
	width: 55px;
	text-align: right;
	color: #8995a9;
}

.notice {
	background-color: #fafbfe;
}

/* 6. 페이지네이션 */
.pagination {
	display: flex;
	justify-content: center;
	gap: 8px;
	margin-top: 25px;
}

.pagination a {
	padding: 7px 12px;
	border: 1px solid #d5dce7;
	border-radius: 5px;
	text-decoration: none;
	color: #39465c;
}

.pagination .active {
	background: #1c2535;
	color: white;
}
</style>
</head>

<body>

	<div class="container">

		<!-- 1. 공통 헤더 -->
		<div class="header">

			<div class="header-left">

				<div class="logo">짠내맵</div>

				<div class="nav">
					<a href="#">지도</a> <a href="#">파티원모집</a> <a href="#">챌린지</a> <a
						href="#">가계부</a> <a href="#" class="active">자유게시판</a> <a href="#">Q&A게시판</a>
				</div>

			</div>

			<div class="header-right">
				<button class="logout-btn">로그아웃</button>
				<div class="profile"></div>
			</div>

		</div>


		<!-- 자유게시판 전체 -->
		<div class="board-container">

			<!-- 2. 카테고리 -->
			<div class="category">
				<input type="button" class="active" value="전체"> <input
					type="button" value="공지"> <input type="button" value="자유">
				<input type="button" value="질문"> <input type="button"
					value="정보">
			</div>


			<!-- 3. 검색 및 글쓰기 -->
			<div class="board-tools">

				<div class="search-box">
					<form action="#">
						<input type="text" placeholder="게시글 검색">
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
								<div>표시할 내용이 없습니다.</div>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="i" items="${list}">
								<tr>
									<td>${i.postId }</td>
									<td>카테고리</td>
									<td class="title"><a
										href="/FreeBoard/detail?postId=${i.postId}"> ${i.title}</a></td>
									<td>${i.memberId }</td>
									<td>${i.viewCount }</td>
									<td>${i.createAt}</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</table>
				<!-- 5. 페이지네이션 -->
				<div class="nav" id="navigation">${navi }</div>
			</div>
		</div>

	</div>

</body>
</html>