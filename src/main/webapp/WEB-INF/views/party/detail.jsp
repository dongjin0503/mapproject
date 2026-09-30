<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 상세</title>
<style>
.party-summary p {
	margin: 8px;
	float: left;
}
</style>
</head>
<body>
	<div class="party-image">모임 이미지</div>

	<section class="party-summary">
		<h1>${party.title}</h1>
		<p>
			모임 날짜:
			<fmt:formatDate value="${party.meetDate}"
				pattern="yyyy.MM.dd(E) HH:mm" />
		</p>
		<p>모임장: ${party.hostId}</p>
		<p>모임 장소: ${party.storeName}</p>
		<p>위치: ${party.address}</p>
		<p>참여 방식: ${party.joinType == 'FCFS' ? '선착순' : '승인제'}</p>
		<p>참여 인원: ${memberCount}명 / ${party.maxPeople}명</p>
	</section>

	<section class="party-intro">
		<h2>모임 소개</h2>
		<p>${party.contents}</p>
	</section>

	<section class="party-members">
		<h2>참여 확정 멤버</h2>
		<C:forEach var="memberId" items="${memberIds}">
			<span class="member">${memberId}</span>
		</C:forEach>

		<C:if test="${empty memberIds}">
			<p>아직 참여 확정 멤버가 없습니다.</p>
		</C:if>
	</section>

	<section class="party-conditions">
		<h2>참여 조건</h2>

		<C:if test="${not empty party.genderRule}">
			<p>참여 성별: ${party.genderRule}</p>
		</C:if>
		<C:if test="${party.minAge != null}">
			<p>최소 나이: ${party.minAge}세</p>
		</C:if>
		<C:if test="${party.maxAge != null}">
			<p>최대 나이: ${party.maxAge}세</p>
		</C:if>
		<C:if test="${not empty party.question}">
			<p>참여 신청 질문: ${party.question}</p>
		</C:if>
	</section>

	<button type="button"
		onclick="location.href='/party/apply?partyId=${party.partyId}'">
		신청하기</button>

	<button type="button" onclick="location.href='/party/list'">
		목록으로 돌아가기</button>

</body>
</html>