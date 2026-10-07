<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
}

.left-area {
	width: 360px;
	border: 1px solid #ccc;
	border-radius: 8px;
	padding: 15px;
}

.right-area {
	flex: 1;
}

.summary {
	display: flex;
	gap: 15px;
	margin-bottom: 15px;
}

.summary-box {
	flex: 1;
	padding: 20px;
	border: 1px solid #ccc;
	border-radius: 8px;
	text-align: center;
}

.chart-area {
	display: flex;
	gap: 15px;
}

.chart-box {
	flex: 1;
	height: 250px;
	border: 1px solid #ccc;
	border-radius: 8px;
	padding: 15px;
}

#calendar {
	margin-bottom: 15px;
}

input, textarea {
	width: 100%;
	padding: 10px;
	margin-bottom: 10px;
}

.type-area {
	margin-bottom: 10px;
}

.save-btn {
	width: 100%;
	padding: 12px;
	background: black;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}
</style>
</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<h1>가계부</h1>

		<div class="ledger-wrap">

			<div class="left-area">

				<div id="calendar"></div>

				<form action="/ledger/insert" method="post">

					<input type="hidden" name="ledgerDate" id="ledgerDate"> 
					<input type="text" name="category" placeholder="항목" required> 
					<input type="number" name="amount" placeholder="금액" required>

					<textarea name="memo" placeholder="메모"></textarea>

					<div class="type-area">

						<label> <input type="radio" name="type" value="INCOME"
							required> 수입
						</label> <label> <input type="radio" name="type" value="EXPENSE">
							지출
						</label>

					</div>

					<button type="submit" class="save-btn">저장</button>

				</form>

			</div>


			<div class="right-area">

				<div class="summary">

					<div class="summary-box">총수입</div>

					<div class="summary-box">총지출</div>

					<div class="summary-box">잔여예산</div>

				</div>

				<div class="chart-area">

					<div class="chart-box">카테고리별 지출</div>

					<div class="chart-box">월별 지출 추이</div>

				</div>

			</div>

		</div>

	</div>
<script>
	document.addEventListener("DOMContentLoaded", function() {

		let calendarEl = document.getElementById("calendar");

		let calendar = new FullCalendar.Calendar(calendarEl, {

			initialView: "dayGridMonth",

			dateClick: function(info) {

				$("#ledgerDate").val(info.dateStr);

				alert(info.dateStr + " 선택");
			}

		});

		calendar.render();
	});
</script>
</body>
</html>