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
p {
white-space : pre-line;
}
</style>
</head>
<body>
<form action="/party/createSubmit" method="post">
<label for="title">모임 제목</label>
<input type="text" id="title" name="title" value="${party.title}" required>

<label for="contents">모임 소개</label>
<textarea id="contents" name="contents" maxlength="2000">${party.contents}</textarea>

<label for="meetDate">모임 날짜 및 시간</label>
<input type="datetime-local" id="meetDate" name="meetDateText" value="${meetDateText}"required>

<label for="joinType">모집 유형</label>
<select id="joinType" name="joinType" required>
<option value="">모집 유형을 선택하세요.</option>
<option value="FCFS" ${party.joinType == 'FCFS' ? 'selected' : ''}>선착순</option>
<option value="APPROVAL" ${party.joinType == 'APPROVAL' ? 'selected' : '' }>모임장 승인</option>
</select>

<label for="minPeople">최소 인원</label>
<input type="number" id="minPeople" name="minPeople" min="2" value="${party.minPeople}" required>

<label for="maxPeople">최대 인원</label>
<input type="number" id="maxPeople" name="maxPeople" min="2" value="${party.maxPeople}" required>

<label for="genderRule">참여 성별</label>
<select id="genderRule" name="genderRule">
<option value="" ${party.genderRule == '' ? 'selected' : ''}>제한 없음</option>
<option value="male" ${party.genderRule == 'male' ? 'selected' : ''}>남자만</option>
<option value="female" ${party.genderRule == 'female' ? 'selected' : '' }>여자만</option>
</select>

<label for="minAge">최소 나이</label>
<input type="number" id="minAge" name="minAge" min="1" value="${party.minAge}">

<label for="maxAge">최대 나이</label>
<input type="number" id="maxAge" name="maxAge" min="1" value="${party.maxAge}">

<label for="question">참여 신청 질문</label>
<input type="text" id="question" name="question" maxlength="300" placeholder="(예) 사이비신가요?" value="${party.question}">

<label for="storeId">모임 장소</label>
<select id="storeId" name="storeId" required>
    <option value="">장소를 선택하세요</option>
    <option value="1">테스트 식당</option>
</select>

<button type="submit">모임 만들기</button>
<p>${message}</p>
</form>
</body>
</html>