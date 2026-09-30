<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
.categoryGroup {
	display: flex;
	gap: 8px;
	margin: 10px 0;
}

/* 원래 radio 동그라미는 숨기되, 키보드 이동은 되도록 opacity로 숨김 */
.categoryGroup input[type="radio"] {
	position: absolute;
	opacity: 0;
	pointer-events: none;
}

.categoryGroup label {
	padding: 8px 18px;
	border: 1px solid #aab3c4;
	border-radius: 20px;
	background: white;
	color: #39465c;
	cursor: pointer;
	user-select: none;
}

.categoryGroup label:hover {
	border-color: #1c2535;
}

/* 선택된 항목 */
.categoryGroup input[type="radio"]:checked+label {
	background: #1c2535;
	color: white;
	border-color: #1c2535;
}

/* 키보드로 이동할 때 표시 */
.categoryGroup input[type="radio"]:focus-visible+label {
	outline: 2px solid #2457d6;
}
</style>
</head>
<body>
	<form action="/FreeBoard/writeup" method="post"
		enctype="multipart/form-data">
		<!-- <input type="hidden" id="categoryType" name="contentCategory" value="자유"> -->
		<div class="container">

			<div class="header">
				<h2>게시글 작성</h2>
			</div>

			<div class="writer">
				<input type="text" name="memberId" value="${loginId }" readonly>
			</div>

			<div class="title">
				<input type="text" name="title" placeholder="제목을 입력하세요 (최대 300바이트)">
			</div>
			<div class="categoryGroup">
				<input type="radio" name="contentCategory" id="cat-free" value="자유" checked><label for="cat-free">자유</label>
				<input type="radio" name="contentCategory" id="cat-question" value="질문"><label for="cat-question">질문</label>
				<input type="radio" name="contentCategory" id="cat-info" value="정보"> <label for="cat-info">정보</label>
			</div>

			<div class="content">
				<textarea name="content" placeholder="내용을 입력하세요 (최대 4000바이트)"></textarea>
			</div>


			<fieldset id="fileBox">
				<legend>파일 업로드</legend>
				<br> <input type="file" name="files">
				<input id="add" type="button" value="추가 파일 업로드">
			</fieldset>

			<script>
				$("#add").click(
						function() {
							$("#fileBox").append(
									'<br><input type="file" name="files">');
						});
			</script>
			<div class="footer">
				<a href="/FreeBoard/freeboard?cpage=1"><input type="button"
					value="취소"></a> <input id="listup" type="submit" value="작성완료">
			</div>

		</div>
	</form>

</body>
</html>