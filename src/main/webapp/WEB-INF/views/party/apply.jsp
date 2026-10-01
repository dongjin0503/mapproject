<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="ko_KR" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 신청</title>
<style>
* {
	box-sizing: border-box;
}

form {
	max-width: 650px;
	margin: 40px auto;
	padding: 30px;
	border: 1px solid #ddd;
	border-radius: 10px;
}

form label {
	display: block;
	margin-bottom: 10px;
	font-weight: bold;
}

form textarea {
	width: 100%;
	padding: 12px;
	margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 15px;
	resize: vertical;
}

form h1 {
	text-align: center;
	margin: 0 0 30px;
}

.party-info {
	display: flex;
	align-items: center;
	gap: 20px;
	margin-bottom: 30px;
}

.party-image {
	width: 140px;
	height: 110px;
	flex-shrink: 0;
	background-color: #eee;
	border-radius: 5px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.party-text {
	margin: 25px 0 0 15px;
}

.party-title {
	margin: 0 0 10px;
	font-size: 18px;
	font-weight: bold;
}

.meet-date {
	margin-bottom: 25px;
	font-size: 14px;
	color: #555;
}

.agreement {
	margin: 20px 0;
	padding: 15px;
	background-color: #f7f7f7;
	border-radius: 5px;
}

.agreement label {
	margin: 0;
	font-size: 14px;
	font-weight: normal;
	line-height: 1.6;
	cursor: pointer;
}

.apply-buttons {
	text-align: center;
	margin: 30px 0;
}

#apply-btn {
	width: 170px;
	height: 45px;
	padding: 14px;
	margin-right: 20px;
	background-color: black;
	color: white;
	border: 1px solid black;
	border-radius: 5px;
	font-size: 16px;
	cursor: pointer;
	vertical-align: middle;
	background-color: black;
}

#cancel-btn {
	width: 170px;
	height: 45px;
	padding: 12px 20px;
	background-color: white;
	color: black;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 15px;
	cursor: pointer;
	vertical-align: middle;
}

.error-message {
	margin: 15px 0 0;
	color: #c62828;
	font-size: 14px;
	white-space: pre-line;
	line-height: 1.6;
}
</style>
</head>
<body>


	<form action="/party/applySubmit" method="post">
		<h1>모임 신청</h1>
		<div class="party-info">
			<div class="party-image">모임 사진</div>

			<div class="party-text">
				<p class="party-title">${party.title}</p>
				<input type="hidden" name="partyId" value="${party.partyId}">

				<p class="meet-date">
					모임 날짜 :
					<fmt:formatDate value="${party.meetDate}"
						pattern="yyyy.MM.dd(E) HH:mm" />
				</p>
			</div>
		</div>
		<C:if test="${not empty party.question}">
			<label for="answer">* ${party.question}</label>
			<textarea id="answer" name="answer" rows="5" maxlength="500">${answer}</textarea>
		</C:if>

		<div class="agreement">
			<label for="agree"> <input type="checkbox" id="agree"
				name="agree" value="Y" required> 모임 규칙 및 노쇼 방지 안내에 동의합니다.
			</label>
		</div>

		<div class="apply-buttons">
			<button type="submit" id="apply-btn">신청하기</button>

			<button type="button" id="cancel-btn"
				onclick="location.href='/party/detail?partyId=${party.partyId}'">취소하기</button>
		</div>
		<p class="error-message">${message}</p>
	</form>

</body>
</html>