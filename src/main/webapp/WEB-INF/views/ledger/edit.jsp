<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<title>가계부 수정</title>

<style>
* {
	box-sizing: border-box;
}

.container {
	width: 420px;
	margin: 50px auto;
}

.edit-box {
	padding: 25px;
	border: 1px solid #ccc;
	border-radius: 8px;
}

.edit-box h2 {
	margin-top: 0;
}

.edit-box input,
.edit-box select,
.edit-box textarea {
	width: 100%;
	padding: 10px;
	margin-bottom: 12px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.type-area {
	display: flex;
	gap: 20px;
	margin-bottom: 15px;
}

.type-area label {
	display: flex;
	align-items: center;
	gap: 5px;
}

.type-area input {
	width: auto;
	margin: 0;
}

textarea {
	height: 100px;
	resize: none;
}

.btn-area {
	display: flex;
	gap: 10px;
}

.update-btn {
	flex: 1;
	height: 42px;
	border: none;
	border-radius: 5px;
	background-color: black;
	color: white;
	cursor: pointer;
}

.cancel-btn {
	flex: 1;
	height: 42px;
	border: 1px solid #ccc;
	border-radius: 5px;
	background-color: white;
	cursor: pointer;
}
</style>

</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<div class="edit-box">

			<h2>가계부 수정</h2>

			<form action="/ledger/update" method="post">

				<input type="hidden"
					name="ledgerId"
					value="${ledger.ledgerId}">

				<input type="date"
					name="ledgerDateText"
					value="${ledger.ledgerDate}"
					required>

				<div class="type-area">

					<label>
						<input type="radio"
							name="type"
							value="INCOME"
							${ledger.type == 'INCOME' ? 'checked' : ''}>
						수입
					</label>

					<label>
						<input type="radio"
							name="type"
							value="EXPENSE"
							${ledger.type == 'EXPENSE' ? 'checked' : ''}>
						지출
					</label>

				</div>

				<select name="category"
					id="category"
					required>
				</select>

				<input type="number"
					name="amount"
					value="${ledger.amount}"
					required>

				<textarea name="memo">${ledger.memo}</textarea>

				<div class="btn-area">

					<button type="submit"
						class="update-btn">
						수정
					</button>

					<button type="button"
						class="cancel-btn"
						onclick="history.back();">
						취소
					</button>

				</div>

			</form>

		</div>

	</div>

	<script>

		function setCategory() {

			let type =
				$("input[name='type']:checked").val();

			let category =
				$("#category");

			let currentCategory =
				"${ledger.category}";

			category.empty();


			if (type === "INCOME") {

				category.append("<option value='급여'>급여</option>");
				category.append("<option value='용돈'>용돈</option>");
				category.append("<option value='기타수입'>기타수입</option>");

			} else {

				category.append("<option value='식비'>식비</option>");
				category.append("<option value='교통'>교통</option>");
				category.append("<option value='쇼핑'>쇼핑</option>");
				category.append("<option value='생활'>생활</option>");
				category.append("<option value='의료'>의료</option>");
				category.append("<option value='여가'>여가</option>");
				category.append("<option value='저축'>저축</option>");
				category.append("<option value='기타'>기타</option>");

			}

			category.val(currentCategory);
		}


		setCategory();


		$("input[name='type']").on(
			"change",
			function() {

				let category =
					$("#category");

				category.empty();

				if ($(this).val() === "INCOME") {

					category.append("<option value='급여'>급여</option>");
					category.append("<option value='용돈'>용돈</option>");
					category.append("<option value='기타수입'>기타수입</option>");

				} else {

					category.append("<option value='식비'>식비</option>");
					category.append("<option value='교통'>교통</option>");
					category.append("<option value='쇼핑'>쇼핑</option>");
					category.append("<option value='생활'>생활</option>");
					category.append("<option value='의료'>의료</option>");
					category.append("<option value='여가'>여가</option>");
					category.append("<option value='저축'>저축</option>");
					category.append("<option value='기타'>기타</option>");

				}

			}
		);

	</script>

</body>
</html>