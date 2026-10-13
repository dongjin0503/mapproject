<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
.site-header {
	position: sticky;
	top: 0;
	z-index: 1000;

	--line: #9ca3af;
	--line-strong: #4b5563;
	--fill: #f3f4f6;
	--fill-strong: #e5e7eb;
	--text: #374151;
	--accent: #111827;

	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 4px 24px;
	border-bottom: 1.5px solid var(--line);
	background: #fff;
	font-family: Arial, "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
}

.site-header * {
	box-sizing: border-box;
}

.sh-left {
	display: flex;
	align-items: center;
	gap: 30px;
}

.sh-logo {
	display: block;
	text-decoration: none;
}

.sh-logo img {
	display: block;
	height: 80px;
}

.sh-logo:hover {
	opacity: 0.75;
}

.sh-nav {
	display: flex;
	align-items: center;
	gap: 22px;
}

.sh-nav a {
	font-size: 13.5px;
	font-weight: 600;
	color: var(--text);
	text-decoration: none;
	padding-bottom: 16px;
	border-bottom: 2px solid transparent;
}

.sh-nav a:hover, .sh-nav a.active {
	color: var(--accent);
	border-bottom-color: var(--accent);
}

.sh-right {
	display: flex;
	align-items: center;
	gap: 10px;
}

.sh-btn {
	display: inline-block;
	padding: 6px 14px;
	border: 1px solid var(--line);
	border-radius: 6px;
	background: #fff;
	font-size: 13px;
	font-weight: 600;
	color: var(--text);
	text-decoration: none;
	cursor: pointer;
}

.sh-btn:hover {
	background: var(--fill);
}

.sh-avatar {
	display: block;
	text-decoration: none;
}

.sh-avatar i {
	display: block;
	font-size: 30px;
	line-height: 30px;
	color: var(--line-strong);
}

.sh-avatar:hover i {
	color: var(--accent);
}

.sh-notification {
	position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
	width: 36px;
	height: 36px;
	text-decoration: none;
}

#notification-count {
	position: absolute;
	top: -3px;
	right: -3px;
	min-width: 18px;
	height: 18px;
	padding: 0 5px;
	border-radius: 9px;
	background-color: red;
	color: white;
	font-size: 11px;
	line-height: 18px;
	text-align: center;
	display: none;
}

.sh-notification i {
	font-size: 20px;
	color: var(--line-strong);
}

.sh-notification:hover i {
	color: var(--accent);
}
</style>

<div class="site-header">
	<div class="sh-left">
		<a class="sh-logo" href="/"><img src="/images/logo.png" alt="짠내맵"></a>
		<%-- ★ 이미지 로고 --%>
		<nav class="sh-nav">
			<a href="/map/main">지도</a> <a href="/party/list">파티원모집</a> <a
				href="/challenge/list">챌린지</a> <a href="/ledger/list">가계부</a> <a
				href="/FreeBoard/freeboard">자유게시판</a> <a href="#">Q&amp;A게시판</a>

			<%-- ★ 관리자 버튼: admin 계정일 때만 --%>
			<c:if test="${sessionScope.loginId == 'admin'}">
				<a href="/admin/dashboard">관리자</a>
			</c:if>
		</nav>
	</div>

	<div class="sh-right">
		<c:choose>
			<c:when test="${not empty sessionScope.loginId}">

				<a class="sh-notification" href="/member/logout" title="로그아웃"> <i
					class="fa-solid fa-right-from-bracket"></i>
				</a>

				<a class="sh-notification" href="/notification/list" title="알림"
					id="notification-link"> <i class="fa-solid fa-bell"></i> <span
					id="notification-count"></span>
				</a>

				<a class="sh-avatar" href="/member/mypage" title="마이페이지"> <i
					class="fa-solid fa-circle-user"></i>
				</a>

			</c:when>
			<c:otherwise>
				<a class="sh-btn" href="/member/login">로그인</a>
			</c:otherwise>
		</c:choose>
	</div>
</div>

<script>
	// ★ 지금 주소가 메뉴 주소로 시작하면 그 메뉴에 밑줄(active)
	(function() {
		var path = location.pathname; // 지금 페이지 주소 (예: /party/list)
		var links = document.querySelectorAll(".sh-nav a");
		for (var i = 0; i < links.length; i++) {
			var href = links[i].getAttribute("href"); // 메뉴 주소 (예: /party)
			if (href !== "#" && path.indexOf(href) === 0) { // 지금 주소가 메뉴 주소로 시작하면
				links[i].classList.add("active");
			}
		}
	})();
	fetch("/notification/count")
	.then(response => response.text())
	.then(count => {

		count = Number(count);

		const notificationCount =
				document.getElementById("notification-count");

		const notificationLink =
				document.getElementById("notification-link");

		if (count > 0) {
			notificationCount.textContent = count;
			notificationCount.style.display = "block";
		}

		notificationLink.addEventListener("click", function(e) {

			if (count === 0) {
				e.preventDefault();
				alert("새로운 알림이 없습니다.");
			}
		});
	});
</script>
