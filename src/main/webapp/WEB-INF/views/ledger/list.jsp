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
	max-width: 1200px;
	margin: 30px auto;
}

.fc-toolbar-title {
	font-size: 28px !important;
	line-height: 1.3;
}

/* =========================================================
   달력 날짜 칸
   (가운데 정렬 + 수입/지출 금액 + 선택한 날짜 표시)
   ========================================================= */

/* 날짜 칸 높이 (모든 줄 같은 높이) */
.fc .fc-daygrid-day-frame {
	min-height: 72px;
}

/* 이 프로젝트는 달력 일정(event) 기능을 안 쓰므로,
   FullCalendar가 일정용으로 비워 두는 빈자리를 없앤다.
   (그대로 두면 금액이 두 줄인 날이 있는 줄만 길어짐) */
.fc .fc-daygrid-day-events {
	min-height: 0 !important;
	margin: 0 !important;
}

/* 날짜 숫자 가운데 정렬 (FullCalendar 기본값은 오른쪽 정렬) */
.fc .fc-daygrid-day-top {
	justify-content: center;
	flex-direction: row;
}

.fc .fc-daygrid-day-number {
	white-space: nowrap;
	color: #1F2937;
	text-decoration: none;
	font-size: 13px;
	padding: 4px 6px 2px;
	border-radius: 4px;
}

/* 오늘: 기본 노란 배경 대신 회색 배지 */
.fc .fc-daygrid-day.fc-day-today {
	background: transparent;
}

.fc .fc-day-today .fc-daygrid-day-number {
	margin-top: 3px;
	padding: 1px 6px;
	background-color: #6B7280;
	color: white;
	font-weight: bold;
}

/* 날짜 칸을 누를 수 있다는 표시 */
.fc .fc-daygrid-day {
	cursor: pointer;
}

.fc .fc-daygrid-day:hover {
	background-color: #F9FAFB;
}

/* 선택한 날짜: 연한 배경 + 진한 테두리 */
.fc .fc-daygrid-day.selected-day {
	background-color: #F9FAFB;
	box-shadow: inset 0 0 0 2px #111827;
}

.fc .fc-daygrid-day.selected-day .fc-daygrid-day-number {
	font-weight: bold;
	color: #111827;
}

.fc .fc-daygrid-day.fc-day-today.selected-day .fc-daygrid-day-number {
	color: white;
}

/* 날짜 칸 안의 수입/지출 금액 */
.ledger-amounts {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 1px;
	font-size: 10.5px;
	line-height: 1.3;
	font-weight: bold;
	font-variant-numeric: tabular-nums;
}

.amount-income {
	color: #1D4ED8;
}

.amount-expense {
	color: #C2410C;
}

/* 달력 아래 범례 */
.calendar-legend {
	display: flex;
	flex-wrap: wrap;
	gap: 4px 14px;
	justify-content: center;
	font-size: 12px;
	color: #6B7280;
	margin: -5px 0 15px;
}

.calendar-legend span {
	white-space: nowrap;
}

.calendar-legend b {
	font-weight: bold;
}

.ledger-wrap {
	display: flex;
	gap: 20px;
	align-items: stretch;   /* 왼쪽·오른쪽 높이를 같게 */
}

.ledger-form {
	width: 460px;
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

#category,
input[name='amount'],
textarea[name='memo'] {
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
	display: flex;
	flex-direction: column;
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
	flex: 1;                /* 남는 높이를 채워서 왼쪽 박스 아래 끝과 맞춤 */
	margin-top: 15px;
	min-height: 244px;
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
	gap: 10px;                  /* 글자와 버튼 사이 간격 */
	padding: 10px 0;
	border-bottom: 1px solid #ddd;
}

/* 긴 메모가 상자 안에서 줄바꿈되도록 */
.day-item > span {
	flex: 1;
	min-width: 0;
	overflow-wrap: anywhere;
}

.day-btns {
	display: flex;
	gap: 5px;
	align-items: center;
	flex-shrink: 0;             /* 버튼 영역이 찌그러지지 않게 */
}

.edit-btn,
.delete-btn {
	padding: 5px 10px;
	border: none;
	border-radius: 4px;
	font-size: 13px;
	cursor: pointer;
	text-decoration: none;
	white-space: nowrap;
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

			<form class="ledger-form"
				action="/ledger/insert"
				method="post">

				<div id="calendar"></div>

				<div class="calendar-legend">
					<span><b class="amount-income">+ 파란 금액</b> 수입</span>
					<span><b class="amount-expense">− 주황 금액</b> 지출</span>
					<span>1천 = 1,000원 · 1만 = 10,000원</span>
				</div>

				<input type="hidden"
					name="ledgerDateText"
					id="ledgerDate">

				<div class="type-area">

					<label class="type-label">
						<input type="radio"
							name="type"
							value="INCOME"
							required>
						수입
					</label>

					<label class="type-label">
						<input type="radio"
							name="type"
							value="EXPENSE">
						지출
					</label>

				</div>

				<select name="category"
					id="category"
					required>

					<option value="">항목 선택</option>

				</select>

			<%-- 1원 ~ 1억 원, 정수만 (마이너스·0 입력 불가) --%>
				<input type="number"
					name="amount"
					placeholder="금액"
					min="1"
					max="100000000"
					step="1"
					required>

				<textarea name="memo"
					maxlength="100"
					placeholder="메모 (100자 이내)"></textarea>

				<button type="submit"
					class="save-btn">
					저장
				</button>

			</form>


			<div class="right-area">

				<div class="summary">

					<div class="start-area">

						<div class="summary-box">

							<div>기초금액</div>

							<strong>
								<fmt:formatNumber
									value="${budget}"
									pattern="#,###" />원
							</strong>

						</div>

						<form class="budget-form"
							action="/ledger/budget"
							method="post">

							<div class="start-type">

								<label>
									<input type="radio"
										name="startType"
										value="carry"
										required>
									전월 이월
								</label>

								<label>
									<input type="radio"
										name="startType"
										value="budget"
										checked>
									예산 설정
								</label>

							</div>

												<input type="number"
								name="budgetAmount"
								class="budgetAmount"
								min="0"
								max="100000000"
								step="1"
								placeholder="금액">
							<button type="submit"
								class="budget-btn">
								설정
							</button>

						</form>

					</div>


					<div class="summary-box">

						<div>총수입</div>

						<strong>
							<fmt:formatNumber
								value="${totalIncome}"
								pattern="#,###" />원
						</strong>

					</div>


					<div class="summary-box">

						<div>총지출</div>

						<strong>
							<fmt:formatNumber
								value="${totalExpense}"
								pattern="#,###" />원
						</strong>

					</div>


					<div class="summary-box">

						<div>잔액</div>

						<strong>
							<fmt:formatNumber
								value="${remainAmount}"
								pattern="#,###" />원
						</strong>

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

					<h3 id="selected-date">
						날짜를 선택해주세요.
					</h3>

					<div id="day-list">
						달력에서 날짜를 선택하면 상세 내역이 표시됩니다.
					</div>

				</div>

			</div>

		</div>

	</div>


<script>

/* 서버가 저장을 거절한 경우 이유를 알림창으로 */
<c:if test="${not empty ledgerMessage}">
alert("${ledgerMessage}");
</c:if>

/* =========================================================
   가계부 데이터
   ========================================================= */

let ledgerList = [

	<c:forEach var="ledger"
		items="${ledgers}"
		varStatus="status">

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


/* =========================================================
   날짜별 수입 / 지출 합계 만들기
   예) dailyTotals["2026-10-14"] = { income: 30000, expense: 15500 }
   ========================================================= */

let dailyTotals = {};

for (let ledger of ledgerList) {

	let date = ledger.date.substring(0, 10);

	if (dailyTotals[date] == null) {
		dailyTotals[date] = { income : 0, expense : 0 };
	}

	if (ledger.type === "INCOME") {
		dailyTotals[date].income += ledger.amount;
	} else {
		dailyTotals[date].expense += ledger.amount;
	}
}


/* 달력 칸이 좁아서 금액을 한글 단위로 짧게 표시
   예) 500 → "500",  7000 → "7천",  1500 → "1.5천",
       15500 → "1.6만",  2500000 → "250만" */
function shortAmount(amount) {

	// 1만 원 이상: 만 단위 (소수점 첫째 자리까지)
	if (amount >= 10000) {
		let man = Math.round(amount / 1000) / 10;
		return man.toLocaleString() + "만";
	}

	// 1천 원 이상: 천 단위 (소수점 첫째 자리까지)
	if (amount >= 1000) {
		let cheon = Math.round(amount / 100) / 10;

		// 9,960원처럼 반올림하면 10천이 되는 경우는 1만으로
		if (cheon >= 10) {
			return "1만";
		}

		return cheon + "천";
	}

	// 1천 원 미만: 그대로
	return String(amount);
}


/* 날짜 → "2026-10-14" 모양의 글자 */
function toDateKey(date) {

	let month = String(date.getMonth() + 1).padStart(2, "0");
	let day = String(date.getDate()).padStart(2, "0");

	return date.getFullYear() + "-" + month + "-" + day;
}


/* 지금 선택한 날짜 (달을 넘겼다 돌아와도 표시를 유지하려고 기억) */
let selectedDate = null;


/* =========================================================
   FullCalendar
   ========================================================= */

document.addEventListener(
	"DOMContentLoaded",
	function() {

		let calendarEl =
			document.getElementById("calendar");


		let calendar =
			new FullCalendar.Calendar(
				calendarEl,
				{

					initialView : "dayGridMonth",

					locale : "ko",

					headerToolbar : {

						left : "title",

						center : "",

						right : "today prev,next"

					},

					datesSet :
						function(info) {

							let months = [
								"January",
								"February",
								"March",
								"April",
								"May",
								"June",
								"July",
								"August",
								"September",
								"October",
								"November",
								"December"
							];

							let date =
								info.view.currentStart;

							let year =
								date.getFullYear();

							let monthName =
								months[
									date.getMonth()
								];

							$(".fc-toolbar-title")
								.html(
									year
									+ "<br>"
									+ monthName
								);

						},


					/* 날짜를 "14일" 대신 "14"로 표시 */
					dayCellContent :
						function(arg) {
							return String(arg.date.getDate());
						},


					/* 날짜 칸이 화면에 그려질 때마다 실행:
					   그날의 수입/지출 금액을 칸 안에 넣는다 */
					dayCellDidMount :
						function(arg) {

							// 이전 달 / 다음 달 날짜 칸은 건너뜀
							if (arg.isOther) {
								return;
							}

							let key = toDateKey(arg.date);

							// 선택해 둔 날짜면 다시 표시
							if (key === selectedDate) {
								arg.el.classList.add("selected-day");
							}

							let totals = dailyTotals[key];

							if (totals == null) {
								return;
							}

							let html = "";

							if (totals.income > 0) {
								html += "<span class='amount-income' title='수입 "
									+ totals.income.toLocaleString() + "원'>+"
									+ shortAmount(totals.income) + "</span>";
							}

							if (totals.expense > 0) {
								html += "<span class='amount-expense' title='지출 "
									+ totals.expense.toLocaleString() + "원'>−"
									+ shortAmount(totals.expense) + "</span>";
							}

							arg.el
								.querySelector(".fc-daygrid-day-top")
								.insertAdjacentHTML(
									"afterend",
									"<div class='ledger-amounts'>" + html + "</div>"
								);
						},


					dateClick :
						function(info) {

							// 선택한 날짜 칸 표시: 전에 선택한 칸은 지우고 새 칸에 표시
							selectedDate = info.dateStr;

							$(".fc-daygrid-day.selected-day")
								.removeClass("selected-day");

							$(info.dayEl)
								.addClass("selected-day");

							$("#ledgerDate")
								.val(
									info.dateStr
								);

							$("#selected-date")
								.text(
									info.dateStr
									+ " 상세 내역"
								);

							let html = "";


							for (
								let ledger
								of ledgerList
							) {

								if (
									ledger.date
									===
									info.dateStr
								) {

									let typeText =
										ledger.type
										=== "INCOME"
										? "수입"
										: "지출";


									html +=

										"<div class='day-item'>" +

											"<span>" +

												"<b>"
												+ ledger.category
												+ "</b>" +

												" / "
												+ typeText +

												" / "
												+ ledger.amount.toLocaleString()
												+ "원" +

												" / "
												+ ledger.memo +

											"</span>" +

											"<div class='day-btns'>" +

												"<a href='/ledger/edit?ledgerId="
												+ ledger.ledgerId
												+ "' class='edit-btn'>수정</a>" +

												"<form action='/ledger/delete' method='post'>" +

													"<input type='hidden' "
													+ "name='ledgerId' "
													+ "value='"
													+ ledger.ledgerId
													+ "'>" +

													"<button type='submit' "
													+ "class='delete-btn'>"
													+ "삭제"
													+ "</button>" +

												"</form>" +

											"</div>" +

										"</div>";

								}

							}


							if (html === "") {

								html =
									"등록된 내역이 없습니다.";

							}


							$("#day-list")
								.html(html);

						}

				}
			);


		calendar.render();

	}
);


/* =========================================================
   수입 / 지출 선택 시 카테고리 변경
   ========================================================= */

$("input[name='type']").on(
	"change",
	function() {

		let type =
			$(this).val();

		let category =
			$("#category");

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

		}

		else if (type === "EXPENSE") {

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

	}
);


/* =========================================================
   날짜 선택 안 하고 저장 방지
   ========================================================= */

$(".ledger-form").on(
	"submit",
	function(e) {

		if (
			$("#ledgerDate").val()
			=== ""
		) {

			alert(
				"날짜를 선택해주세요."
			);

			e.preventDefault();

		}

	}
);


/* =========================================================
   카테고리별 지출 차트
   ========================================================= */

let categoryData = {};

let currentMonth = "${currentMonth}";


for (let ledger of ledgerList) {

	if (
		ledger.type === "EXPENSE"
		&&
		ledger.date.startsWith(
			currentMonth
		)
	) {

		if (
			categoryData[
				ledger.category
			]
			== null
		) {

			categoryData[
				ledger.category
			]
				= 0;

		}

		categoryData[
			ledger.category
		]
			+= ledger.amount;

	}

}


new Chart(

	document.getElementById(
		"categoryChart"
	),

	{

		type : "doughnut",

		data : {

			labels :
				Object.keys(
					categoryData
				),

			datasets : [

				{

					data :
						Object.values(
							categoryData
						)

				}

			]

		},

		options : {

			responsive : true,

			maintainAspectRatio : false

		}

	}

);


/* =========================================================
   월별 지출 추이
   ========================================================= */

let monthlyData = {};


for (let ledger of ledgerList) {

	if (
		ledger.type
		=== "EXPENSE"
	) {

		let month =
			ledger.date.substring(
				0,
				7
			);

		if (
			monthlyData[
				month
			]
			== null
		) {

			monthlyData[
				month
			]
				= 0;

		}

		monthlyData[
			month
		]
			+= ledger.amount;

	}

}


let months =
	Object.keys(
		monthlyData
	).sort();


let monthlyAmounts = [];


for (let month of months) {

	monthlyAmounts.push(
		monthlyData[
			month
		]
	);

}


new Chart(

	document.getElementById(
		"monthlyChart"
	),

	{

		type : "line",

		data : {

			labels :
				months,

			datasets : [

				{

					label :
						"월별 지출",

					data :
						monthlyAmounts,

					tension :
						0.3

				}

			]

		},

		options : {

			responsive : true,

			maintainAspectRatio : false

		}

	}

);

</script>


<jsp:include page="/WEB-INF/views/common/footer.jsp" />


</body>
</html>
