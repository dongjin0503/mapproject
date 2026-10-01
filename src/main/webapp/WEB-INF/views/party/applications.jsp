<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신청 관리</title>
<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 800px;
	margin: 40px auto;
	padding: 30px;
}

.container h1 {
	margin: 0 0 30px;
	font-size: 26px;
	text-align: center;
}

.result-message {
	text-align: center;
	font-size: 14px;
	line-height: 1.6;
	white-space: pre-line;
	margin-bottom: 20px;
}

.application-card {
	padding: 20px;
	margin-bottom: 20px;
	border: 1px solid #ddd;
	border-radius: 8px;
}

.application-card p {
	margin: 0 0 12px;
	line-height: 1.6;
	white-space: pre-line;
	overflow-wrap: anywhere;
}

.application-btns {
	display: flex;
	align-items : center;
	justify-content : center;
	gap: 15px;
	margin-top: 15px;

}

.application-btns form {
	margin: 0;
}

.approve-btn {
	padding: 10px 20px;
	border-radius: 5px;
	font-size: 14px;
	cursor: pointer;
	background-color: black;
	color: white;
	border: 1px solid black;
}

.reject-btn {
	padding: 10px 20px;
	border-radius: 5px;
	font-size: 14px;
	cursor: pointer;
	background-color: white;
	color: black;
	border: 1px solid #ccc;
}

#back-btn {
	display: block;
	margin: 30px auto 0;
	padding: 12px 20px;
	background-color: white;
	color: black;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 15px;
	cursor: pointer;
}
.empty-message {
    padding: 50px 20px;
    background-color: #f7f7f7;
    border: 1px solid #eee;
    border-radius: 10px;
    text-align: center;
}

.empty-message p {
    margin: 0;
    color: #777;
    font-size: 15px;
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="container">
		<h1>${party.title} 신청관리</h1>
		<p class="result-message">${message}</p>

		<C:forEach var="application" items="${applications}">
			<div class="application-card">
				<p>신청자 : ${application.applicantId}</p>
				<p>답변 : ${application.answer}</p>
				<div class="application-btns">
					<form action="/party/approve" method="post">
						<input type="hidden" name="partyId" value="${party.partyId}">
						<input type="hidden" name="applicationId"
							value="${application.applicationId}">
						<button type="submit" class="approve-btn">승인</button>
					</form>

					<form action="/party/reject" method="post">
						<input type="hidden" name="partyId" value="${party.partyId}">
						<input type="hidden" name="applicationId"
							value="${application.applicationId}">
						<button type="submit" class="reject-btn">거절</button>
					</form>
				</div>
			</div>

		</C:forEach>
		<C:if test="${empty applications}">
		<div class="empty-message">
			<p>승인 대기 중인 신청이 없습니다.</p>
			</div>
		</C:if>

		<button type="button" id="back-btn"
			onclick="location.href='/party/detail?partyId=${party.partyId}'">
			모임으로 돌아가기</button>
	</div>
</body>
</html>