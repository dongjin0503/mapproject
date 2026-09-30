<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신청 관리</title>
</head>
<body>
	<h1>${party.title}신청 관리</h1>
	<p>${message}</p>
	<C:forEach var="application" items="${applications}">
		<div>
			<p>신청자 : ${application.applicantId}</p>
			<p>답변 : ${application.answer}</p>
			
			<form action="/party/approve" method="post">
			<input type="hidden" name="partyId" value="${party.partyId}">
			<input type="hidden" name="applicationId" value="${application.applicationId}">
			<button type="submit">승인</button>
			</form>
			
			<form action="/party/reject" method="post">
			<input type="hidden" name="partyId" value="${party.partyId}">
			<input type="hidden" name="applicationId" value="${application.applicationId}">
			<button type="submit">거절</button>
			</form>
		</div>
	</C:forEach>

	<C:if test="${empty applications}">
		<p>승인 대기 중인 신청이 없습니다.</p>
	</C:if>

	<button type="button"
		onclick="location.href='/party/detail?partyId=${party.partyId}'">
		모임으로 돌아가기</button>
</body>
</html>