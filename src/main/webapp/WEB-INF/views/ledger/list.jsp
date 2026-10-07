<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link
	href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.css"
	rel="stylesheet">

<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<title>가계부</title>

<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 1100px;
	margin: 30px auto;
}

.ledger-wrap {
	display: flex;
	gap: 20px;
	align-items: flex-start;
}

.ledger-form {
	width: 360px;
	padding: 15px;
	border: 1px solid #ccc;
	border-radius: 8px;
	flex-shrink: 0;
}

#calendar {
	margin-bottom: 15px;
}

.type-area {
	display: flex;
	gap: 20px;
	margin: 15px 0;
}

.type-label {
	display: flex;
	align-items: center;
	gap: 6px;
	font-size: 15px;
	cursor: pointer;
}

.type-label input {
	margin: 0;
	width: auto;
}

#category, input[name='amount'], textarea[name='memo'] {
	width: 100%;
	padding: 10px;
	margin-bottom: 12px;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 14px;
}

textarea[name='memo'] {
	height: 80px;
	resize: none;
}

.save-btn {
	width: 100%;
	height: 44px;
	border: none;
	border-radius: 5px;
	background-color: black;
	color: white;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
}

.right-area {
	flex: 1;
	min-width: 0;
}

.summary {
	display: flex;
	gap: 15px;
	margin-bottom: 15px;
	align-items: flex-start;
}

.summary-box {
	flex: 1;
	min-width: 0;
	height: 80px;
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 8px;
	text-align: center;
}

.start-area {
	flex: 1;
	min-width: 0;
}

.start-area .summary-box {
	width: 100%;
}

.budget-form {
	display: flex;
	flex-wrap: wrap;
	gap: 5px;
	margin-top: 5px;
	width: 100%;
}

.start-type {
	width: 100%;
	display: flex;
	gap: 8px;
	font-size: 12px;
}

.start-type label {
	white-space: nowrap;
}

.budget-form input[type="number"] {
	flex: 1;
	width: 0;
	min-width: 0;
	height: 30px;
	padding: 5px;
}

.budget-form button {
	height: 30px;
	padding: 0 10px;
	white-space: nowrap;
}

.budget-btn {
	width: 50px;
	height: 44px;
	border: none;
	border-radius: 5px;
	background-color: black;
	color: white;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
}

.chart-area {
	display: flex;
	gap: 15px;
	margin-top: 15px;
}

.chart-box {
	flex: 1;
	height: 280px;
	border: 1px solid #ccc;
	border-radius: 8px;
	padding: 15px;
	position: relative;
}

.chart-box canvas {
	max-width: 100%;
	max-height: 200px;
}

.day-detail {
	margin-top: 15px;
	min-height: 220px;
	padding: 20px;
	border: 1px solid #ccc;
	border-radius: 8px;
}

.day-detail h3 {
	margin-top: 0;
	margin-bottom: 15px;
}

.day-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 0;
	border-bottom: 1px solid #ddd;
}

.day-btns {
	display: flex;
	gap: 5px;
	align-items: center;
}

.edit-btn,
.delete-btn {
	padding: 5px 10px;
	border: none;
	border-radius: 4px;
	font-size: 13px;
	cursor: pointer;
	text-decoration: none;
}

.edit-btn {
	background-color: #eee;
	color: black;
}

.delete-btn {
	background-color: black;
	color: white;
}
</style>

</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<h2>가계부</h2>

		<div class="ledger-wrap">

			<form class="ledger-form" action="/ledger/insert" method="post">

				<div id="calendar"></div>

				<input type="hidden" name="ledgerDateText" id="ledgerDate">

				<div class="type-area">

					<label class="type-label"> <input type="radio" name="type"
						value="INCOME" required> 수입
					</label> <label class="type-label"> <input type="radio" name="type"
						value="EXPENSE"> 지출
					</label>

				</div>

				<select name="category" id="category" required>
					<option value="">항목 선택</option>
				</select> <input type="number" name="amount" placeholder="금액" required>

				<textarea name="memo" placeholder="메모"></textarea>

				<button type="submit" class="save-btn">저장</button>

			</form>

			<div class="right-area">

				<div class="summary">
					<div class="start-area">

						<div class="summary-box">
							<div>기초금액</div>
							<strong><fmt:formatNumber value="${budget}" pattern="#,###" />원</strong>
						</div>
						<form class="budget-form" action="/ledger/budget" method="post">

							<div class="start-type">

								<label> <input type="radio" name="startType"
									value="carry" required> 전월 이월
								</label> <label> <input type="radio" name="startType"
									value="budget" checked> 예산 설정
								</label>

							</div>

							<input type="number" name="budgetAmount" class="budgetAmount"
								placeholder="금액">

							<button type="submit" class="budget-btn">설정</button>

						</form>

					</div>

					<div class="summary-box">
						<div>총수입</div>
						<strong><fmt:formatNumber value="${totalIncome}" pattern="#,###" />원</strong>
					</div>

					<div class="summary-box">
						<div>총지출</div>
						<strong><fmt:formatNumber value="${totalExpense}" pattern="#,###"/>원</strong>
					</div>

					<div class="summary-box">
						<div>잔액</div>
						<strong><fmt:formatNumber value="${remainAmount}" pattern="#,###"/>원</strong>
					</div>

				</div>

				<div class="chart-area">

					<div class="chart-box">
					<div>카테고리별 지출</div>
					<canvas id="categoryChart"></canvas>
					</div>

					<div class="chart-box">
					<div>월별 지출 추이</div>
					<canvas id="monthlyChart"></canvas>
					</div>

				</div>

				<div class="day-detail">

					<h3 id="selected-date">날짜를 선택해주세요.</h3>

					<div id="day-list">달력에서 날짜를 선택하면 상세 내역이 표시됩니다.</div>

				</div>

			</div>

		</div>

	</div>

	<script>

		let ledgerList = [

			<c:forEach var="ledger" items="${ledgers}" varStatus="status">

				{
					ledgerId : ${ledger.ledgerId},
					date : "${ledger.ledgerDate}",
					type : "${ledger.type}",
					category : "${ledger.category}",
					amount : ${ledger.amount},
					memo : "${ledger.memo}"
				}

				<c:if test="${!status.last}">
					,
				</c:if>

			</c:forEach>

		];

		document.addEventListener("DOMContentLoaded", function() {

			let calendarEl =
				document.getElementById("calendar");

			let calendar =
				new FullCalendar.Calendar(calendarEl, {

					initialView : "dayGridMonth",

					dateClick : function(info) {

						$("#ledgerDate").val(info.dateStr);

						$("#selected-date")
							.text(info.dateStr + " 상세 내역");

						let html = "";

						for (let ledger of ledgerList) {

							if (ledger.date === info.dateStr) {

								let typeText =
									ledger.type === "INCOME"
									? "수입"
									: "지출";

								html +=
									"<div class='day-item'>" +
									"<span>" +
									"<b>" + ledger.category + "</b>" +
									" / " + typeText +
									" / " + ledger.amount.toLocaleString() + "원" +
									" / " + ledger.memo +
									"</span>"+
									
									"<div class='day-btns'>" +
									"<a href='/ledger/edit?ledgerId="
											+ ledger.ledgerId + 
											"' class='edit-btn'>수정</a>" +
											
											
			"<form action='/ledger/delete' method='post'>" +
				"<input type='hidden' name='ledgerId' value='"
				+ ledger.ledgerId +
				"'>" +
				"<button type='submit' class='delete-btn'>삭제</button>" +
			"</form>" +

		"</div>" +
									"</div>";
							}
						}

						if (html === "") {
							html = "등록된 내역이 없습니다.";
						}

						$("#day-list").html(html);
					}

				});

			calendar.render();
		});

		$("input[name='type']").on("change", function() {

			let type = $(this).val();

			let category = $("#category");

			category.empty();

			category.append(
				"<option value=''>항목 선택</option>"
			);

			if (type === "INCOME") {

				category.append(
					"<option value='급여'>급여</option>"
				);

				category.append(
					"<option value='용돈'>용돈</option>"
				);

				category.append(
					"<option value='기타수입'>기타수입</option>"
				);

			} else if (type === "EXPENSE") {

				category.append(
					"<option value='식비'>식비</option>"
				);

				category.append(
					"<option value='교통'>교통</option>"
				);

				category.append(
					"<option value='쇼핑'>쇼핑</option>"
				);

				category.append(
					"<option value='생활'>생활</option>"
				);

				category.append(
					"<option value='의료'>의료</option>"
				);

				category.append(
					"<option value='여가'>여가</option>"
				);

				category.append(
					"<option value='저축'>저축</option>"
				);

				category.append(
					"<option value='기타'>기타</option>"
				);
			}

		});

		$(".ledger-form").on("submit", function(e) {

			if ($("#ledgerDate").val() === "") {

				alert("날짜를 선택해주세요.");

				e.preventDefault();
			}

		});
		let categoryData = {};

		let currentMonth = "2026-10";

		for (let ledger of ledgerList) {

			if (
				ledger.type === "EXPENSE"
				&& ledger.date.startsWith(currentMonth)
			) {

				if (categoryData[ledger.category] == null) {
					categoryData[ledger.category] = 0;
				}

				categoryData[ledger.category] += ledger.amount;
			}
		}

		new Chart(
			document.getElementById("categoryChart"),
			{
				type : "doughnut",

				data : {
					labels : Object.keys(categoryData),

					datasets : [{
						data : Object.values(categoryData)
					}]
				},
				

				options : {
					responsive : true,
					maintainAspectRatio : false
				}
			}
		);
		
		let monthlyData = {};

		for (let ledger of ledgerList) {

			if (ledger.type === "EXPENSE") {

				let month = ledger.date.substring(0, 7);

				if (monthlyData[month] == null) {
					monthlyData[month] = 0;
				}

				monthlyData[month] += ledger.amount;
			}
		}

		let months = Object.keys(monthlyData).sort();

		let monthlyAmounts = [];

		for (let month of months) {
			monthlyAmounts.push(monthlyData[month]);
		}

		new Chart(
			document.getElementById("monthlyChart"),
			{
				type : "line",

				data : {
					labels : months,

					datasets : [{
						label : "월별 지출",
						data : monthlyAmounts,
						tension : 0.3
					}]
				},

				options : {
					responsive : true,
					maintainAspectRatio : false
				}
			}
		);
	</script>

</body>
</html>