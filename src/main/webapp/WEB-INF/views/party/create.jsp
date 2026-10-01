<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 만들기</title>
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

form h1 {
	margin: 0 0 30px;
	font-size: 26px;
	text-align: center;
}

form label {
	display: block;
	margin-bottom: 8px;
	font-weight: bold;
}

form input, form select, form textarea {
	width: 100%;
	padding: 12px;
	margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 15px;
}

form textarea {
	min-height: 160px;
	resize: vertical;
}

#create-btn {
	width: 100%;
	padding: 14px;
	background-color: black;
	color: white;
	border: 1px solid black;
	border-radius: 5px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
}

p {
	white-space: pre-line;
}

.error-message {
	white-space: pre-line;
	color: #c62828;
	font-size: 14px;
	line-height: 1.6;
	margin: 15px 0 0;
}
</style>
</head>
<body>
	<form action="/party/createSubmit" method="post">
		<h1>모임 만들기</h1>
		<label for="title">모임 제목</label> <input type="text" id="title"
			name="title" value="${party.title}" maxlength="100" required>
		<label for="contents">모임 소개</label>
		<textarea id="contents" name="contents" maxlength="2000">${party.contents}</textarea>

		<label for="meetDate">모임 날짜 및 시간</label> <input type="datetime-local"
			id="meetDate" name="meetDateText" value="${meetDateText}" required>

		<label for="joinType">모집 유형</label> <select id="joinType"
			name="joinType" required>
			<option value="">모집 유형을 선택하세요.</option>
			<option value="FCFS" ${party.joinType == 'FCFS' ? 'selected' : ''}>선착순</option>
			<option value="APPROVAL"
				${party.joinType == 'APPROVAL' ? 'selected' : '' }>모임장 승인</option>
		</select> <label for="minPeople">최소 인원</label> <input type="number"
			id="minPeople" name="minPeople" min="2" value="${party.minPeople}"
			required> <label for="maxPeople">최대 인원</label> <input
			type="number" id="maxPeople" name="maxPeople" min="2"
			value="${party.maxPeople}" required> <label for="genderRule">참여
			성별</label> <select id="genderRule" name="genderRule">
			<option value="" ${party.genderRule == '' ? 'selected' : ''}>제한
				없음</option>
			<option value="male" ${party.genderRule == 'male' ? 'selected' : ''}>남자만</option>
			<option value="female"
				${party.genderRule == 'female' ? 'selected' : '' }>여자만</option>
		</select> <label for="minAge">최소 나이</label> <input type="number" id="minAge"
			name="minAge" min="1" value="${party.minAge}"> <label
			for="maxAge">최대 나이</label> <input type="number" id="maxAge"
			name="maxAge" min="1" value="${party.maxAge}"> <label
			for="question">참여 신청 질문</label> <input type="text" id="question"
			name="question" maxlength="300" placeholder="(예) 사이비신가요?"
			value="${party.question}"> <label for="storeId">모임 장소</label>
		<select id="storeId" name="storeId" required>
			<option value="">장소를 선택하세요</option>
			<option value="1">테스트 식당</option>
		</select>

		<button type="submit" id="create-btn">모임 만들기</button>
		<p class="error-message">${message}</p>
	</form>
</body>
</html>