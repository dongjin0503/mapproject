<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정산 결과</title>

<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 700px;
	margin: 40px auto;
}

.result-box {
	border: 1px solid #ddd;
	border-radius: 10px;
	padding: 30px;
}

.summary {
	padding-bottom: 20px;
	border-bottom: 1px solid #ddd;
}

.summary p {
	margin: 10px 0;
}

.member-title {
	margin-top: 25px;
	font-weight: bold;
}

.result-row {
	display: flex;
	justify-content: space-between;
	padding: 15px 0;
	border-bottom: 1px solid #eee;
}

.amount {
	font-weight: bold;
}

.back-btn {
	width: 100%;
	height: 48px;
	margin-top: 30px;
	background-color: black;
	color: white;
	border: none;
	border-radius: 5px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
}
</style>

</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<h2>정산 결과</h2>

		<div class="result-box">

			<div class="summary">

				<p>
					총 금액 : <strong> <fmt:formatNumber
							value="${settlement.totalAmount}" pattern="#,###" /> 원
					</strong>
				</p>

				<p>
					정산 방식 :

					<c:choose>

						<c:when test="${settlement.settlementType eq 'EQUAL'}">
							균등 정산
						</c:when>

						<c:otherwise>
							메뉴별 정산
						</c:otherwise>

					</c:choose>

				</p>

			</div>


			<div class="member-title">멤버별 정산 금액</div>

			<c:if test="${empty details}">
				<p>정산 결과가 없습니다.</p>
			</c:if>
			<c:forEach var="detail" items="${details}">

				<div class="result-row">

					<span>${detail.memberName}</span> <span class="amount"> 
					<fmt:formatNumber value="${detail.amount}" pattern="#,###" /> 원
					</span>

				</div>

			</c:forEach>

		</div>


		<button type="button" class="back-btn"
			onclick="location.href='/party/detail?partyId=${settlement.partyId}'">
			모임으로 돌아가기</button>

	</div>

</body>
</html>