<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
:root { 
--line: #9ca3af;
--line-strong: #4b5563;
--fill: #f3f4f6;
--fill-strong: #e5e7eb;
--text: #374151;
--text-dim: #9ca3af;
--accent: #111827;
}

* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
	color: var(--text);
	background: #fff;
}

/* ---------- 전체 영역 ---------- */
.wrap {
	width: 1100px;
	margin: 24px auto 40px;
}

.layout {
	display: flex;
	align-items: flex-start;
	gap: 20px;
}

/* ---------- 왼쪽 ---------- */
.left {
	flex: none;
	width: 200px;
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.box {
	border: 1.5px solid var(--line);
	border-radius: 6px;
	background: #fff;
}

/* 프로필 카드 */
.profile {
	padding: 20px 14px;
	text-align: center;
}

.avatar {
	width: 64px;
	height: 64px;
	margin: 0 auto 10px;
}

.avatar i {
	display: block;
	font-size: 64px;
	line-height: 64px;
	color: var(--line-strong);
}

.nickname {
	font-size: 14px;
	font-weight: 700;
	color: var(--accent);
}

/* 세로 메뉴 */
.menu a {
	display: block;
	padding: 11px 14px;
	border-left: 2px solid transparent;
	font-size: 12.5px;
	color: var(--text-dim);
	text-decoration: none;
}

.menu a:hover {
	background: var(--fill);
}

.menu a.active {
	border-left-color: var(--accent);
	font-weight: 700;
	color: var(--accent);
}
.right { flex: 1; min-width: 0; padding: 20px; }
.section-title {
  font-size: 18px; font-weight: 700; color: var(--accent);
  padding-bottom: 15px; border-bottom: 1px solid var(--line);
}
.content-list { margin-top: 20px; max-height: 500px; overflow-y: auto; }
.content-list table { width: 100%; border-collapse: collapse; }
.content-list th, .content-list td {
  padding: 12px 8px; border-bottom: 1px solid var(--fill-strong);
  text-align: center; font-size: 13px;
}
.content-list th { background: var(--fill); font-weight: 700; }
.content-list th:nth-child(2), .content-list td:nth-child(2) { text-align: left; }
.content-list a { color: var(--text); text-decoration: none; }
.content-list a:hover { text-decoration: underline; }
</style>

</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="wrap">
		<div class="layout">
			<div class="left">
				<div class="box profile">
					<div class="avatar">
						<i class="fa-solid fa-circle-user"></i>
					</div>
					<div class="nickname">${member.username}</div>
				</div>
				<div class="box menu">
					<a href="/member/mypage"> 내 정보</a>
					<a href="/member/edit"> 개인정보 수정 </a>
					<a href="/member/bookmark"> 북마크 </a>
					<a href="/member/myContent"> 내가 쓴 글 </a>
					<a href="/member/participationHistory" class="active"> 참여 기록 </a>
				</div>
			</div>
			<div class="right">
				<div class="section-title">참여한 파티</div>
				<div class="content-list">
					<table>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>모임 날짜</th>
							</tr>
						</thead>
						<c:choose>
							<c:when test="${empty partyList}">
								<tr><td colspan="3">참여한 모임이 없습니다.</td></tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="i" items="${partyList}">
									<tr>
										<td>${i.partyId}</td>
										<td class="title"><a href="/party/detail?partyId=${i.partyId}"><c:out value="${i.title}" /></a></td>
										<td><fmt:formatDate value="${i.meetDate}" pattern="yyyy.MM.dd HH:mm" /></td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</table>
				</div>

				<div class="section-title" style="margin-top: 30px;">참여한 챌린지</div>
				<div class="content-list">
					<table>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>참여일</th>
							</tr>
						</thead>
						<c:choose>
							<c:when test="${empty challengeList}">
								<tr><td colspan="3">참여한 챌린지가 없습니다.</td></tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="i" items="${challengeList}">
									<tr>
										<td>${i.challenge_id }</td>
										<td class="title"><a href="/challenge/detail?challenge_id=${i.challenge_id}"><c:out value="${i.title}" /></a></td>
										<td>${i.joined_at}</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>