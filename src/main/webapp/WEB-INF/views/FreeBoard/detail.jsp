<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 - 글 열람</title>

<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	background-color: #f5f5f5;
	font-family: Arial, sans-serif;
	color: #333;
}

.container {
	width: 900px;
	margin: 65px auto 20px;
	padding: 25px 35px 18px;
	background-color: white;
	border: 1px solid #e5e5e5;
	border-radius: 5px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.header {
	padding-bottom: 20px;
	border-bottom: 2px solid #333;
}

.header h2 {
	margin: 0;
	font-size: 24px;
	font-weight: bold;
}

/* 게시글 정보 */
.detail {
	display: flex;
	align-items: center;
	gap: 25px;
	padding: 15px 5px;
	border-bottom: 1px solid #ddd;
	font-size: 13px;
	color: #666;
}

.detail span {
	white-space: nowrap;
	font-weight: bold;
}

/* 글 내용 */
.content {
	padding: 25px 10px;
	border-bottom: 1px solid #ddd;
	font-size: 15px;
}

.content textarea {
	width: 100%;
	height: 300px;
	overflow-y: auto;
	padding: 15px;
	border: 1px solid #ddd;
	border-radius: 5px;
	background-color: #fafafa;
	font-size: 14px;
	color: #333;
	line-height: 1.7;
	resize: none;
	outline: none;
}

/* 하단 버튼 */
.footer {
	display: flex;
	justify-content: center;
	margin-top: 20px;
}

.footer a {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 100px;
	height: 40px;
	border-radius: 5px;
	background-color: #333;
	color: white;
	font-size: 14px;
	text-decoration: none;
}

.footer a:hover {
	background-color: #222;
}

#titletext {
	border: none;
	font-size: 30px;
	font-weight: bold;
}

.commentHeader {
	margin-top: 25px;
	padding-bottom: 10px;
	font-size: 18px;
	font-weight: bold;
	border-bottom: 2px solid #333;
}

/* 댓글 작성 영역 */
.commentPlace {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-top: 15px;
	padding: 15px 10px;
	background-color: #fafafa;
	border: 1px solid #ddd;
	border-radius: 5px;
}

/* 댓글 입력창 */
.commentPlace textarea {
	flex: 1;
	width: 100%;
	height: 80px;
	padding: 12px 15px;
	border: 1px solid #ccc;
	border-radius: 5px;
	background-color: white;
	font-size: 14px;
	color: #333;
	line-height: 1.5;
	resize: none;
	outline: none;
}

/* 댓글 입력창 클릭했을 때 */
.commentPlace textarea:focus {
	border-color: #333;
}

/* 작성자 */
.commentPlace input[name="writer"] {
	width: 150px;
	height: 40px;
	padding: 0 10px;
	border: 1px solid #ddd;
	border-radius: 5px;
	background-color: #eee;
	color: #666;
	font-size: 13px;
}

/* 댓글 등록 버튼 */
.commentPlace input[type="submit"] {
	width: 90px;
	height: 40px;
	border: none;
	border-radius: 5px;
	background-color: #333;
	color: white;
	font-size: 13px;
	cursor: pointer;
}
/* 댓글 목록 */
.replyList {
	margin-top: 20px;
}

/* 댓글 하나 */
.reply {
	padding: 15px 10px;
	border-bottom: 1px solid #ddd;
}

/* 댓글 작성자 + 작성일 */
.replyInfo {
	display: flex;
	align-items: center;
	gap: 15px;
	margin-bottom: 8px;
	font-size: 13px;
}

.replyInfo input {
	border: 0.2px solid black;
	background-color: white;
	cursor: pointer;
	margin-left: auto;
}

.replyInfo input+input {
	margin-left: 5px;
}

/* 작성자 */
.replyWriter {
	font-weight: bold;
	color: #333;
}

/* 작성일 */
.replyDate {
	color: #999;
}

/* 댓글 내용 */
.replyContents {
	width: 100%;
	height: 100px;
	padding: 10px;
	font-size: 14px;
	line-height: 1.6;
	color: #555;
	border: 1px solid #ddd;
	border-radius: 5px;
	background-color: #fafafa;
	resize: none;
	outline: none;
}

.replyContents:focus {
	border-color: #333;
	background-color: white;
}
</style>

</head>

<body>
	<form action="/FreeBoard/UpdateContent">
		<input type="hidden" name="postId" value="${post.postId }">
		  
		<input type="hidden" name="cpage" value="${cpage}">
		<div class="container">
			<div class="header">
				<input id="titleText" name="title" type="text"
					value="${post.title}" readonly>
			</div>
			<div class="detail">
				<span>번호: ${post.postId}</span>
				<span>작성일: ${post.contentCategory }</span>
				<span>작성자: ${post.memberId }</span>
				<span>조회수: ${post.viewCount }</span>
				<span>조회수: ${post.likeCount }</span>
				<span>조회수: ${post.createAt }</span>
			</div>
			<input type="hidden" id="categoryType" name="contentCategory" value="자유">
			<div class="updateCategory">
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
				<textarea id="textarea" name="content" readonly>${post.content }</textarea>
			</div>
			<div class="fileContent">
				<c:forEach var="i" items="${fileList}">
					<a href="/files/download?sysname=${i.sysname }&oriname=${i.oriname}">${i.oriname }</a><br>
				</c:forEach>
			</div>
			<hr>
			<c:choose>
				<c:when test="${post.memberId != loginId}">
					<div class="footer">
						<a href="/FreeBoard/freeboard?cpage=${cpage }">목록으로</a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="footer">
						<a href="/FreeBoard/freeboard?cpage=${cpage }">목록으로</a>
						<input id="updatebtn" type="button" value="수정">
						<input id="updateokbtn" type="submit" value="수정완료"
							style="display: none;"> <input id="updatecancelbtn"
							type="button" value="수정취소" style="display: none;">
						<input id="deletebtn" type="button" value="삭제">
					</div>
					<script>
						let titletext = document.getElementById("titletext").value;
						let textarea = document.getElementById("textarea").value;
						document.getElementById("updatebtn").onclick = function() {
							document.getElementById("titletext").readOnly = false;
							document.getElementById("textarea").readOnly = false;
							document.getElementById("deletebtn").style.display = "none";
							document.getElementById("updatebtn").style.display = "none";
							document.getElementById("updateokbtn").style.display = "inline-block";
							document.getElementById("updatecancelbtn").style.display = "inline-block";
						}

						document.getElementById("updatecancelbtn").onclick = function() {
							document.getElementById("titletext").readOnly = true;
							document.getElementById("textarea").readOnly = true;
							document.getElementById("deletebtn").style.display = "inline-block";
							document.getElementById("updatebtn").style.display = "inline-block";
							document.getElementById("updateokbtn").style.display = "none";
							document.getElementById("updatecancelbtn").style.display = "none";
							document.getElementById("titletext").value = titletext;
							document.getElementById("textarea").value = textarea;
						}
						document.getElementById("deletebtn").onclick = function() {
							if (confirm("정말 삭제하시겠습니까?")) {
								location.href = "/FreeBoard/deleteContent?postId=${post.postId}&cpage=${cpage}";
							}
						}
					</script>
				</c:otherwise>
			</c:choose>
	</form>
	<form action="/reply/addReply">
		<input type="hidden" name="cpage" value="${cpage }">
		<input type="hidden" name="postId" value="${post.postId}">
		<hr>

		*******<div class="commentHeader">댓글 ${commentCount }</div>
		<br>
		<div class="commentPlace">
			<textarea name="content" placeholder="댓글을 입력하세요 (최대 1000바이트)"></textarea>
			<input type="text" name="memberId" readonly value="작성자: ${loginId}">
			<input type="submit" value="댓글 등록">
		</div>
	</form>

	<c:forEach var="reply" items="${replyList}">
		<form action="/reply/updateReply">
			<!-- 폼이 foreach안에있어야 댓글마다 수정form이 각각 생긴다 -->
			<input type="hidden" name="seq" value="${reply.seq}"> <input
				type="hidden" name="cpage" value="${cpage }"> <input
				type="hidden" name="postId" value="${post.postId}">
			<div class="replyList">
				<div class="reply">

					<div class="replyInfo">
						<span class="replyWriter">${reply.writer}</span> <span
							class="replyDate">${reply.write_date}</span>
						<c:if test="${reply.writer == loginId}">
							<input id="commentUpbtn${reply.seq}" type="button" value="수정">
							<input id="commentUpokbtn${reply.seq}" type="submit" value="수정완료"
								style="display: none;">
							<input id="commentUpcancelbtn${reply.seq}" type="button"
								value="수정취소" style="display: none;">
							<a
								href="/reply/delete?seq=${reply.seq}&parent_seq=${readContent.seq}&cpage=${cpage}">
								<input id="commentDelbtn${reply.seq}" type="button" value="삭제">
							</a>
						</c:if>
					</div>
					<textarea id="comment${reply.seq}" name="content"
						class="replyContents" readonly>${reply.contents}</textarea>
					<script>
						let comment${reply.seq} = document.getElementById("comment${reply.seq}").value;
						document.getElementById("commentUpbtn${reply.seq}").onclick = function() {
							document.getElementById("commentUpbtn${reply.seq}").style.display = "none";
							document.getElementById("commentDelbtn${reply.seq}").style.display = "none";
							document.getElementById("commentUpokbtn${reply.seq}").style.display = "inline-block";
							document.getElementById("commentUpcancelbtn${reply.seq}").style.display = "inline-block";
							document.getElementById("comment${reply.seq}").readOnly = false;
							
						}
						document.getElementById("commentUpcancelbtn${reply.seq}").onclick = function(){
							document.getElementById("commentUpbtn${reply.seq}").style.display = "inline-block";
							document.getElementById("commentDelbtn${reply.seq}").style.display = "inline-block";
							document.getElementById("commentUpokbtn${reply.seq}").style.display = "none";
							document.getElementById("commentUpcancelbtn${reply.seq}").style.display = "none";
							document.getElementById("comment${reply.seq}").readOnly = true;
							document.getElementById("comment${reply.seq}").value = comment${reply.seq};
						}
					</script>
				</div>
			</div>
		</form>
	</c:forEach>


</body>
</html>