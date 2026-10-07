<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가계부 등록</title>

<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 600px;
	margin: 40px auto;
}

form {
	padding: 30px;
	border: 1px solid #ddd;
	border-radius: 10px;
}

h1 {
	text-align: center;
	margin-top: 0;
	margin-bottom: 30px;
}

label {
	display: block;
	margin-bottom: 8px;
	font-weight: bold;
}

input, select, textarea {
	width: 100%;
	padding: 12px;
	margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

textarea {
	height: 100px;
	resize: vertical;
}

.button-area {
	display: flex;
	gap: 10px;
}

button {
	flex: 1;
	padding: 12px;
	border-radius: 5px;
	cursor: pointer;
}

.save-btn {
	background: black;
	color: white;
	border: 1px solid black;
}

.list-btn {
	background: white;
	border: 1px solid #ccc;
}
</style>
</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<form action="/ledger/insert" method="post">

			<h1>가계부 등록</h1>

			<label for="ledgerDate">날짜</label>

			<input type="date"
				id="ledgerDate"
				name="ledgerDate"
				required>


			<label for="type">구분</label>

			<select id="type"
				name="type"
				required>

				<option value="">선택하세요.</option>
				<option value="INCOME">수입</option>
				<option value="EXPENSE">지출</option>

			</select>


			<label for="category">카테고리</label>

			<select id="category"
				name="category"
				required>

				<option value="">선택하세요.</option>
				<option value="식비">식비</option>
				<option value="교통">교통</option>
				<option value="쇼핑">쇼핑</option>
				<option value="생활">생활</option>
				<option value="급여">급여</option>
				<option value="기타">기타</option>

			</select>


			<label for="amount">금액</label>

			<input type="number"
				id="amount"
				name="amount"
				min="1"
				required>


			<label for="memo">메모</label>

			<textarea id="memo"
				name="memo"
				maxlength="200"></textarea>


			<div class="button-area">

				<button type="submit"
					class="save-btn">
					등록
				</button>

				<button type="button"
					class="list-btn"
					onclick="location.href='/ledger/list'">
					취소
				</button>

			</div>

		</form>

	</div>

</body>
</html>