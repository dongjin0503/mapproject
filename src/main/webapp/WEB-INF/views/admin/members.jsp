<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
* { box-sizing:border-box; }

.container { width:1200px; max-width:calc(100% - 40px); margin:auto; font-family:"Noto Sans KR","Malgun Gothic",Arial,sans-serif; color:#1c2535; background:#fff; padding:25px 0; }
a { text-decoration:none; color:inherit; }
.page-title { margin:0 0 18px; font-size:22px; font-weight:700; color:#1c2535; }

/* 카드 */
.box { background:#fff; border:1px solid #d5dce7; border-radius:10px; margin-bottom:14px; overflow:hidden; box-shadow:0 2px 10px rgba(28,37,53,.05); }

/* 상단: 검색 + 총 인원 */
.board-tools { display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:10px; }
.search-box form { display:flex; gap:6px; }
.search-box input[type=text] { width:320px; height:38px; padding:0 12px; border:1px solid #d5dce7; border-radius:6px; background:#fff; font-size:13px; }
.search-box input[type=text]:focus { outline:none; border-color:#1c2535; }
.search-box input[type=submit] { height:38px; padding:0 16px; border:1px solid #1c2535; border-radius:6px; background:#fff; color:#1c2535; font-size:13px; cursor:pointer; }
.search-box input[type=submit]:hover { background:#1c2535; color:#fff; }
.total { width:100px; margin-right:1px; font-size:13px; color:#5a6678; line-height:1; padding-bottom:4px; text-align:center; }
.total b { color:#1c2535; font-size:15px; }

/* 표 */
.board-list table { width:100%; border-collapse:collapse; table-layout:fixed; font-size:13px; }
.board-list th { height:44px; background:#f3f5f9; color:#5a6678; font-weight:bold; border-bottom:1px solid #d5dce7; }
.board-list th:nth-child(1) { width:140px; }
.board-list th:nth-child(2) { width:140px; }
.board-list th:nth-child(3) { width:110px; }
.board-list th:nth-child(4) { width:150px; }
.board-list th:nth-child(5) { width:auto; }
.board-list th:nth-child(6) { width:100px; }
.board-list th:nth-child(7) { width:100px; }
.board-list td { height:46px; padding:0 10px; border-bottom:1px solid #e8ecf3; color:#39465c; text-align:center; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.board-list td:nth-child(1) { color:#1c2535; font-weight:bold; }
.board-list td:nth-child(6) { color:#8995a9; }
.board-list tr:last-child td { border-bottom:none; }
.board-list tr:hover td { background:#f9fafc; }
.board-list td[colspan] { padding:60px 0; color:#8995a9; text-align:center; }

/* 버튼, 관리자 표시 */
.board-list form { margin:0; }
.btn-sm { display:inline-block; padding:6px 14px; border:1px solid #d5dce7; border-radius:6px; background:#fff; color:#39465c; font-size:12px; cursor:pointer; }
.btn-sm:hover { border-color:#1c2535; }
.btn-sm.del { color:#e91717; border-color:#ffd6d6; background:#fff0f0; }
.btn-sm.del:hover { background:#e91717; border-color:#e91717; color:#fff; }
.admin-tag { display:inline-block; padding:4px 12px; border-radius:999px; background:#f3f5f9; color:#5a6678; font-size:12px; font-weight:bold; }
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<h2 class="page-title">회원 관리</h2>

		<div class="board-tools">
			<div class="search-box">
				<form action="/admin/members">
					<input type="text" name="keyword" value="${keyword}" placeholder="아이디 / 닉네임 / 이름">
					<input type="submit" value="검색">
				</form>
			</div>
			<div class="total">총 <b>${list.size()}</b>명</div>
		</div>

		<div class="box board-list">
			<table>
				<tr>
					<th>아이디</th>
					<th>닉네임</th>
					<th>이름</th>
					<th>전화번호</th>
					<th>이메일</th>
					<th>가입일</th>
					<th>관리</th>
				</tr>
				<c:forEach var="m" items="${list}">
					<tr>
						<td>${m.id}</td>
						<td>${m.username}</td>
						<td>${m.name}</td>
						<td>${m.phone}</td>
						<td>${m.email}</td>
						<td><fmt:formatDate value="${m.regdate}" pattern="yy.MM.dd" /></td>
						<td>
							<c:choose>
								<c:when test="${m.id == 'admin'}">
									<span class="admin-tag">관리자</span>
								</c:when>
								<c:otherwise>
									<form action="/admin/memberDelete" method="post"
										onsubmit="return confirm('정말 탈퇴시킬까요?');">
										<input type="hidden" name="id" value="${m.id}">
										<button type="submit" class="btn-sm del">탈퇴</button>
									</form>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty list}">
					<tr>
						<td colspan="7">검색 결과가 없습니다.</td>
					</tr>
				</c:if>
			</table>
		</div>
	</div>

	<script>
		var msg = "${msg}";
		if (msg === "ok") {
			alert("탈퇴 처리했습니다.");
		} else if (msg === "admin") {
			alert("관리자 계정은 탈퇴시킬 수 없습니다.");
		}
	</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>