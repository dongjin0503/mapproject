<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>알림</title>
<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 800px;
	margin: 40px auto;
	padding: 30px;
}

.container h2 {
	margin: 0 0 30px;
	text-align: center;
	font-size: 26px;
}

.notification-card {
	position: relative;
	display: flow-root;
	max-width: 420px;
	margin: 0 auto 15px;
	padding: 20px;
	padding-right: 50px;
	border: 1px solid #c8d8f0;
	border-radius: 8px;
	background-color: #f2f6ff;
}

.notification-card p {
	font-size: 14px;
	color: #666;
	margin: 0 0 12px;
	line-height: 1.6;
	overflow-wrap: anywhere;
}

.notification-message {
	font-size: 16px;
	font-weight: bold;
	color: black;
	margin-bottom: 12px;
	line-height: 1.6;
	overflow-wrap: anywhere;
}

.notification-card button {
	padding: 10px 16px;
	border-radius: 5px;
	font-size: 14px;
	cursor: pointer;
}

.delete-x {
	position: absolute;
	top: 12px;
	right: 12px;
	width: 28px;
	height: 28px;
	padding: 0;
	border: none;
	border-radius: 50%;
	background-color: transparent;
	color: #777;
	font-size: 16px;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
}

.delete-x:hover {
	background-color: #e5e7eb;
	color: black;
}
.view-btn {
	display: block;
	margin: 20px auto 0;
	background-color: white;
	color: black;
	border: 1px solid #c8d8f0;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<h2>알림</h2>

		<c:forEach var="notification" items="${notifications}">
			<div class="notification-card">


				<form action="/notification/delete" method="post">
					<input type="hidden" name="notificationId"
						value="${notification.notificationId}">

					<button type="submit" class="delete-x"
						onclick="return confirm('알림을 삭제하시겠습니까?');">
							<i class="fa-solid fa-xmark"></i>
						</button>
				</form>

				<div class="notification-message">${notification.message}</div>
				<p>
					알림 시간 :
					<fmt:formatDate value="${notification.regdate}"
						pattern="yyyy.MM.dd HH:mm" />
				</p>

				<c:if
					test="${notification.targetType == 'PARTY' and notification.targetId != null}">
					<button type="button" class="view-btn"
						onclick="location.href='/party/detail?partyId=${notification.targetId}'">
						모임 보기</button>
				</c:if>
			</div>
		</c:forEach>

		<c:if test="${empty notifications}">
			<p>받은 알림이 없습니다.</p>
		</c:if>

	</div>
</body>
</html>