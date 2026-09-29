<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<form action="/FreeBoard/writeup" method="post"
		enctype="multipart/form-data">
		<input type="hidden" id="categoryType" name="contentCategory" value="자유">
		<div class="container">

			<div class="header">
				<h2>게시글 작성</h2>
			</div>

			<div class="writer">
				<input type="text" name ="memberId" value="${loginId }" readonly>
			</div>

			<div class="title">
				<input type="text" name="title" placeholder="제목을 입력하세요 (최대 300바이트)">
			</div>
			<div class="contentCategory">
			<input type="button" id="fbtn" value="자유">
			<input type="button" id="qbtn" value="질문">
			<input type="button" id="ibtn" value="정보">
			</div>
			<script>
			$("#fbtn").on("click", function(){
				$("#categoryType").val("자유");
			});
			$("#qbtn").on("click", function(){
				$("#categoryType").val("질문");
			});
			$("#ibtn").on("click", function(){
				$("#categoryType").val("정보");
			});
			</script>
			<div class="content">
				<textarea name="content" placeholder="내용을 입력하세요 (최대 4000바이트)"></textarea>
			</div>
			
			
			<fieldset id="fileBox">
				<legend>파일 업로드</legend>
				<br> <input type="file" name="files"> <input id="add"
					type="button" value="추가 파일 업로드">
			</fieldset>

			<script>
				$("#add").click(function() {
					$("#fileBox").append('<br><input type="file" name="files">');
				});
			</script>
			<div class="footer">
				<a href="/FreeBoard/freeboard?cpage=1"><input type="button" value="취소"></a>
				<input id="listup" type="submit" value="작성완료">
			</div>

		</div>
	</form>

</body>
</html>