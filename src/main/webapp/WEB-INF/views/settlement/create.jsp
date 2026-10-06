<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>모임비 정산</title>
<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 700px;
	margin: 40px auto;
}

h2 {
	margin-bottom: 10px;
}

.party-title {
	color: #666;
	margin-bottom: 30px;
}

.settlement-box {
	width: 400px; border : 1px solid #ddd;
	border-radius: 10px;
	padding: 30px;
	border: 1px solid #ddd;
}

.section {
	margin-bottom: 25px;
}

.section-title {
	font-weight: bold;
	margin-bottom: 12px;
}

.type-label {
	margin-right: 20px;
	cursor: pointer;
}

#totalAmount {
	width: 200px;
}

#equal-area, #menu-area {
	margin-top: 25px;
	padding-top: 20px;
	border-top: 1px solid #eee;
}

#menu-area {
	display: none;
}

input[type="text"], input[type="number"] {
	height: 40px;
	padding: 0 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.menu-row {
	padding: 20px 0;
	border-bottom: 1px solid #eee;
}

.menu-name {
	margin-bottom: 5px;
}

.member-list {
	margin-top: 15px;
}

.member-list label {
	margin-right: 15px;
}

#add-menu-btn, .delete-menu-btn {
	height: 35px;
	padding: 0 15px;
	border: 1px solid #ccc;
	background-color: white;
	border-radius: 5px;
	cursor: pointer;
}

.submit-btn {
	width: 100%;
	height: 48px;
	margin-top: 30px;
	border: none;
	border-radius: 5px;
	background-color: black;
	color: white;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
}

.message {
	color: #d00;
	margin-bottom: 20px;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="container">

		<h2>모임비 정산</h2>
		<p class="party-title">${party.title}</p>
		<c:if test="${not empty message}">
			<p class="message">${message}</p>
		</c:if>
		<div class="settlement-box">
			<form action="/settlement/createSubmit" method="post">

				<input type="hidden" name="partyId" value="${party.partyId}">

				<div class="section">
					<div class="section-title">정산 방식</div>
					<label class="type-label"> <input type="radio"
						name="settlementType" value="EQUAL" checked>균등 정산
					</label> <label class="type-label"> <input type="radio"
						name="settlementType" value="MENU">메뉴별 정산
					</label>
				</div>

				<div id="equal-area">
					<div class="section-title">총 사용 금액</div>
					<input type="number" id="totalAmount" name="totalAmount" min="1"
						placeholder="총 사용 금액을 입력하세요." required> <span>원</span>
				</div>

				<div id="menu-area">
					<div id="menu-list">
						<div class="menu-row">
							<div>
								<input type="text" class="menu-name" placeholder="메뉴명">
								<input type="number" class="menu-amount" placeholder="메뉴 금액"
									min="1">

								<button type="button" class="delete-menu-btn">삭제</button>
							</div>

							<div class="member-list">
								<p>정산 대상 멤버</p>
								<c:forEach var="member" items="${members}">
									<label> <input type="checkbox" class="member-checkbox"
										value="${member.memberId}">${member.memberName}
									</label>
								</c:forEach>

							</div>
						</div>
					</div>
					<br>
					<button type="button" id="add-menu-btn">메뉴 추가</button>
				</div>

				<div id="menu-result-inputs"></div>
				<button type="submit" class="submit-btn">정산하기</button>
			</form>
		</div>
	</div>
	<script>
		$("input[name='settlementType']").on(
				"change",
				function() {
					let type = $(this).val();

					if (type === "EQUAL") {
						$("#equal-area").show();
						$("#menu-area").hide();

						$("#totalAmount").prop("required", true).prop(
								"disabled", false);

						$("#menu-result-inputs").empty();

					} else {
						$("#equal-area").hide();
						$("#menu-area").show();

						$("#totalAmount").prop("required", false).prop(
								"disabled", true);
					}
				});

		$("#add-menu-btn").on("click", function() {
			let newMenu = $(".menu-row").first().clone();

			newMenu.find(".menu-name").val("");
			newMenu.find(".menu-amount").val("");

			newMenu.find(".member-checkbox").prop("checked", false);

			$("#menu-list").append(newMenu);
		});

		$(document).on("click", ".delete-menu-btn", function() {

			if ($(".menu-row").length === 1) {
				alert("메뉴는 최소 1개 이상 있어야 합니다.");
				return;
			}

			$(this).closest(".menu-row").remove();
		});

		$("form").on(
				"submit",
				function(e) {

					let settlementType = $(
							"input[name='settlementType']:checked").val();

					if (settlementType !== "MENU") {
						return;
					}

					let memberAmounts = {};
					let totalAmount = 0;
					let valid = true;

					$(".menu-row").each(
							function() {
								let menuAmount = Number($(this).find(
										".menu-amount").val());

								let checkedMembers = $(this).find(
										".member-checkbox:checked");

								if (!menuAmount || menuAmount <= 0) {
									alert("메뉴 금액을 입력해주세요.");
									valid = false;

									return false;
								}

								if (checkedMembers.length === 0) {
									alert("정산 대상 멤버를 선택해주세요.");
									valid = false;

									return false;
								}
								totalAmount += menuAmount;

								let amount = Math.floor(menuAmount
										/ checkedMembers.length);

								let remainder = menuAmount
										% checkedMembers.length;

								checkedMembers.each(function(index) {

									let memberId = $(this).val();

									if (memberAmounts[memberId] == null) {
										memberAmounts[memberId] = 0;
									}

									memberAmounts[memberId] += amount;

									// 메뉴별 나머지는 첫 번째 선택 멤버 부담
									if (index === 0) {
										memberAmounts[memberId] += remainder;
									}

								});

							});

					if (!valid) {

						e.preventDefault();

						return;
					}

					$("#menu-result-inputs").empty();

					// 메뉴 전체 금액
					$("#menu-result-inputs").append($("<input>", {
						type : "hidden",
						name : "totalAmount",
						value : totalAmount
					}));

					// 사람별 최종 금액
					$.each(memberAmounts, function(memberId, amount) {

						$("#menu-result-inputs").append($("<input>", {
							type : "hidden",
							name : "memberIds",
							value : memberId
						}));

						$("#menu-result-inputs").append($("<input>", {
							type : "hidden",
							name : "memberAmounts",
							value : amount
						}));

					});

				});
	</script>
</body>
</html>