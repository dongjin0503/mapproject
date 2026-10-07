<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 - 글쓰기</title>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	padding: 0 0 40px;
	font-family: "Noto Sans KR", "Malgun Gothic", Arial, sans-serif;
	color: #1c2535;
	background-color: #fff;
}

/* 글쓰기 카드 */
.container {
	width: 900px;
	max-width: calc(100% - 40px);
	margin: 0 auto;
	padding: 28px 35px;
	background: white;
	border: 1px solid #d5dce7;
	border-radius: 10px;
	box-shadow: 0 2px 10px rgba(28, 37, 53, 0.05);
}

.header {
	padding-bottom: 16px;
	border-bottom: 2px solid #1c2535;
}

.header h2 {
	margin: 0;
	font-size: 22px;
}

/* 작성자 */
.writer {
	margin-top: 16px;
}

.writer input {
	width: 200px;
	height: 36px;
	padding: 0 12px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background: #f3f5f9;
	color: #8995a9;
	font-size: 13px;
}

/* 제목 */
.title {
	margin-top: 12px;
}

.title input {
	width: 100%;
	height: 46px;
	padding: 0 14px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	font-size: 18px;
	font-weight: bold;
}

.title input:focus {
	outline: none;
	border-color: #1c2535;
}

/* 카테고리: 숨긴 radio의 기준 위치가 없어서 추가 */
.categoryGroup {
	position: relative;
	display: flex;
	gap: 8px;
	margin: 10px 0;
}
/* 파일 업로드 */
#fileBox {
	margin-top: 20px;
	padding: 14px 16px;
	border: 1px solid #d5dce7;
	border-radius: 8px;
	font-size: 13px;
	color: #39465c;
}

#fileBox legend {
	padding: 0 8px;
	font-weight: bold;
}

#add {
	margin-left: 8px;
	padding: 6px 12px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background: white;
	font-size: 12px;
	cursor: pointer;
}

#add:hover {
	border-color: #1c2535;
}

/* 하단 버튼 */
.footer {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
	margin-top: 24px;
}

.footer a {
	text-decoration: none;
}

.footer input {
	height: 40px;
	padding: 0 24px;
	border-radius: 6px;
	font-size: 14px;
	cursor: pointer;
}

.footer input[type=button] {
	border: 1px solid #d5dce7;
	background: white;
	color: #39465c;
}

#listup {
	border: none;
	background: #1c2535;
	color: white;
	font-weight: bold;
}

#listup:hover {
	background: #2d3a52;
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
<%@ include file="/WEB-INF/views/common/header.jsp" %>
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
				<textarea name="content" id="content" placeholder="내용을 입력하세요 (최대 4000바이트)"></textarea>
			</div>
			
			<!-- 본문 textarea를 summernote-lite 에디터로 바꾸기 -->
			<script>
			$(function () {
			    $('#content').summernote({
			        height: 400,
			        lang: 'ko-KR',
			        placeholder: '내용을 입력하세요'
			    });
			});
			</script>
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