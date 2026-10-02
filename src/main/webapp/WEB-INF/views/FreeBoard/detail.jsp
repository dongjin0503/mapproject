<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 - 글 열람</title>
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
	padding-bottom: 40px;
	background-color: #f7f8fa;
	font-family: "Noto Sans KR", "Malgun Gothic", Arial, sans-serif;
	color: #1c2535;
}

input, textarea, button {
	font-family: inherit;
}

.container {
	width: 900px;
	max-width: calc(100% - 40px);
	margin: 40px auto 20px;
	padding: 28px 35px 24px;
	background-color: white;
	border: 1px solid #d5dce7;
	border-radius: 10px;
	box-shadow: 0 2px 10px rgba(28, 37, 53, 0.05);
}

.header {
	padding-bottom: 16px;
	border-bottom: 2px solid #1c2535;
}

/* 제목: 평소엔 글자만, 수정 모드(readonly 해제)에선 입력창처럼 */
#titleText {
	width: 100%;
	padding: 4px 0;
	border: none;
	outline: none;
	background: transparent;
	font-size: 28px;
	font-weight: bold;
	color: #1c2535;
}

#titleText:not([readonly]) {
	padding: 6px 12px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background: white;
}

/* 게시글 정보 */
.detail {
	display: flex;
	align-items: center;
	gap: 25px;
	padding: 14px 5px;
	border-bottom: 1px solid #e8ecf3;
	font-size: 13px;
	color: #8995a9;
}

.detail span {
	white-space: nowrap;
	font-weight: bold;
}

/* 추천 버튼 + 숫자 */
#likeCount {
	margin-top: 14px;
	padding: 7px 18px;
	border: 1px solid #d5dce7;
	border-radius: 20px;
	background: white;
	font-size: 13px;
	cursor: pointer;
}

#likeCount:hover {
	border-color: #1c2535;
}

#p1 {
	display: inline-block;
	margin: 0 0 0 8px;
	font-weight: bold;
	color: #2457d6;
}

/* 카테고리 선택 (radio) */
.categoryGroup {
	position: relative;
	display: flex;
	gap: 8px;
	margin: 12px 0 0;
}

.categoryGroup input[type="radio"] {
	position: absolute;
	opacity: 0;
	pointer-events: none;
}

.categoryGroup label {
	padding: 8px 18px;
	border: 1px solid #d5dce7;
	border-radius: 20px;
	background: white;
	color: #39465c;
	font-size: 13px;
	cursor: pointer;
	user-select: none;
}

.categoryGroup label:hover {
	border-color: #1c2535;
}

.categoryGroup input[type="radio"]:checked+label {
	background: #1c2535;
	color: white;
	border-color: #1c2535;
}

.categoryGroup input[type="radio"]:focus-visible+label {
	outline: 2px solid #2457d6;
}

/* 글 내용 */
.content {
	padding: 20px 0;
	border-bottom: 1px solid #e8ecf3;
	font-size: 15px;
}

.content > textarea {
	width: 100%;
	height: 300px;
	overflow-y: auto;
	padding: 15px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background-color: #fafbfe;
	font-size: 14px;
	color: #1c2535;
	line-height: 1.7;
	resize: none;
	outline: none;
}

/* 첨부파일 */
.fileContent {
	padding: 10px 4px;
	font-size: 13px;
}

.fileContent a {
	color: #2457d6;
	text-decoration: none;
}

.fileContent a:hover {
	text-decoration: underline;
}

/* 하단 버튼 (목록으로/수정/수정완료/수정취소/삭제) */
.footer {
	display: flex;
	justify-content: center;
	gap: 8px;
	margin-top: 20px;
}

.footer a,
.footer input {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 100px;
	height: 40px;
	border: none;
	border-radius: 6px;
	background-color: #1c2535;
	color: white;
	font-size: 14px;
	text-decoration: none;
	cursor: pointer;
}

.footer a:hover,
.footer input:hover {
	background-color: #2d3a52;
}

#deletebtn {
	background-color: #c0392b;
}

#deletebtn:hover {
	background-color: #a93226;
}

#updateCancelbtn {
	background-color: #8995a9;
}

/* 댓글 */
hr {
	border: none;
	margin: 0;
}

.commentHeader {
	margin-top: 25px;
	padding-bottom: 10px;
	font-size: 18px;
	font-weight: bold;
	border-bottom: 2px solid #1c2535;
}

/* 댓글 작성 영역 */
.commentPlace {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-top: 15px;
	padding: 15px 10px;
	background-color: #fafbfe;
	border: 1px solid #d5dce7;
	border-radius: 6px;
}

.commentPlace textarea {
	flex: 1;
	width: 100%;
	height: 80px;
	padding: 12px 15px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background-color: white;
	font-size: 14px;
	color: #1c2535;
	line-height: 1.5;
	resize: none;
	outline: none;
}

.commentPlace textarea:focus {
	border-color: #1c2535;
}

/* 작성자 */
.commentPlace input[name="memberId"] {
	width: 150px;
	height: 40px;
	padding: 0 10px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background-color: #f3f5f9;
	color: #8995a9;
	font-size: 13px;
}

/* 댓글/답글 등록 버튼 */
.commentPlace input[type="submit"] {
	width: 90px;
	height: 40px;
	border: none;
	border-radius: 6px;
	background-color: #1c2535;
	color: white;
	font-size: 13px;
	cursor: pointer;
}

.commentPlace input[type="submit"]:hover {
	background-color: #2d3a52;
}

#recommentCancel {
	width: 70px;
	height: 40px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background: white;
	color: #39465c;
	cursor: pointer;
}

/* 댓글 목록 */
.replyList {
	margin-top: 20px;
}

.reply {
	padding: 15px 10px;
	border-bottom: 1px solid #e8ecf3;
}

/* 댓글 작성자 + 작성일 + 버튼 */
.replyInfo {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 8px;
	font-size: 13px;
}

.replyWriter {
	font-weight: bold;
	color: #1c2535;
}

.replyDate {
	margin-right: auto;
	color: #8995a9;
}

.replyInfo input,
.reply > input[type="button"] {
	padding: 4px 12px;
	border: 1px solid #d5dce7;
	border-radius: 5px;
	background-color: white;
	color: #39465c;
	font-size: 12px;
	cursor: pointer;
}

.replyInfo input:hover,
.reply > input[type="button"]:hover {
	border-color: #1c2535;
}

/* 댓글 내용 */
.replyContents {
	width: 100%;
	height: 70px;
	padding: 10px;
	font-size: 14px;
	line-height: 1.6;
	color: #39465c;
	border: 1px solid #e8ecf3;
	border-radius: 6px;
	background-color: #fafbfe;
	resize: none;
	outline: none;
}

.replyContents:focus {
	border-color: #1c2535;
	background-color: white;
}
</style>

</head>

<body>
	<div class="container">
		<form action="/FreeBoard/updateContent" method="post" enctype="multipart/form-data">
			<input type="hidden" name="postId" value="${post.postId}">
			<input type="hidden" name="cpage" value="${cpage}">
			<div class="header">
				<input id="titleText" name="title" type="text" value="<c:out value='${post.title}'/>" readonly>
			</div>
			<div class="detail">
				<span>번호: ${post.postId}</span>
				<span>카테고리: <c:out value="${post.contentCategory}" /></span>
				<span>작성자: <c:out value="${post.memberId}" /></span>
				<span>조회수: ${post.viewCount}</span>
				<span>작성일: <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/></span>
			</div>

				<input type="button" id="likeCount" value="추천">
				<p id="p1">${post.likeCount}</p>

			<script>
				$("#likeCount").on("click", function() {
					$.ajax({
						url : "/FreeBoard/likecount",
						type : "post",
						data : {
							postId : "${post.postId}"
						}
					}).done(function(resp) {
						$("#p1").html(resp);
					});
				});
			</script>

			<!-- 수정 모드에서만 보이는 카테고리 선택 (현재 카테고리가 자동 선택됨) -->
			<div class="categoryGroup" id="updateCategory" style="display: none;">
				<input type="radio" name="contentCategory" id="cat-free" value="자유"
					${post.contentCategory == '자유' ? 'checked' : ''}>
				<label for="cat-free">자유</label>

				<input type="radio" name="contentCategory" id="cat-question"
					value="질문" ${post.contentCategory == '질문' ? 'checked' : ''}>
				<label for="cat-question">질문</label>

				<input type="radio" name="contentCategory" id="cat-info" value="정보"
					${post.contentCategory == '정보' ? 'checked' : ''}>
				<label for="cat-info">정보</label>
			</div>

			<div class="content">
				<textarea id="textArea" name="content" readonly><c:out
						value="${post.content}" /></textarea>
			</div>
			<div class="fileContent">
    		<c:forEach var="i" items="${fileList}">
      			<label class="fileDelChk" style="display: none;"><input type="checkbox" name="deleteFileId" value="${i.fileId}"> 삭제</label>
        		<a href="/FreeBoardFile/download?sysname=${i.sysname }&oriname=${i.oriname}"><c:out value="${i.oriname}"/></a>
        		<br>
    		</c:forEach>
    			<div id="updateFile" style="display: none;">
       			 	<input type="file" name="files">
				 	<input type="button" value="추가 파일 업로드" onclick="addFileInput()">
    			</div>
			</div>
			<script>
			$('#textArea').summernote({ height: 400, lang: 'ko-KR' });
			$('#textArea').summernote('disable');
				const originFileHtml = document.getElementById("updateFile").innerHTML;
				function addFileInput() {
    				$("#updateFile").append('<br><input type="file" name="files">');
				}
				
			</script>
			<c:choose>
				<c:when test="${post.memberId != loginId}">
					<div class="footer">
						<a href="/FreeBoard/freeboard?cpage=${cpage}">목록으로</a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="footer">
						<a href="/FreeBoard/freeboard?cpage=${cpage}">목록으로</a>
						<input id="updatebtn" type="button" value="수정">
						<input id="updateOkbtn" type="submit" value="수정완료" style="display: none;">
						<input id="updateCancelbtn" type="button" value="수정취소" style="display: none;">
						<input id="deletebtn" type="button" value="삭제">
					</div>
					<script>
						const originTitle = document.getElementById("titleText").value;
						const originContent = document.getElementById("textArea").value;
						// 현재 선택된 카테고리 (세 가지 외의 값이면 null)
						const checkedCategory = document.querySelector('input[name="contentCategory"]:checked');
						const originCategory = checkedCategory ? checkedCategory.value: null;

						document.getElementById("updatebtn").onclick = function() {
							document.getElementById("titleText").readOnly = false;
							$('#textArea').summernote('enable');
							document.getElementById("updateCategory").style.display = "flex";
							document.getElementById("deletebtn").style.display = "none";
							document.getElementById("updatebtn").style.display = "none";
							document.getElementById("updateOkbtn").style.display = "inline-block";
							document.getElementById("updateCancelbtn").style.display = "inline-block";
							document.getElementById("updateFile").style.display = "block";
							document.querySelectorAll(".fileDelChk").forEach(function(e) { e.style.display = "inline"; });
						};

						document.getElementById("updateCancelbtn").onclick = function() {
							document.getElementById("titleText").readOnly = true;
							$('#textArea').summernote('disable');
							document.getElementById("updateCategory").style.display = "none";
							document.getElementById("deletebtn").style.display = "inline-block";
							document.getElementById("updatebtn").style.display = "inline-block";
							document.getElementById("updateOkbtn").style.display = "none";
							document.getElementById("updateCancelbtn").style.display = "none";
							document.getElementById("titleText").value = originTitle;
							$('#textArea').summernote('code', originContent);
							document.getElementById("updateFile").style.display = "none";
							document.getElementById("updateFile").innerHTML = originFileHtml;
							document.querySelectorAll(".fileDelChk").forEach(function(e) {
							    e.style.display = "none";
							    e.querySelector("input").checked = false;
							});
							
							// 바꿨던 카테고리도 원래대로
							if (originCategory !== null) {
								document
										.querySelector('input[name="contentCategory"][value="'
												+ originCategory + '"]').checked = true;
							}
						};

						document.getElementById("deletebtn").onclick = function() {
							if (confirm("정말 삭제하시겠습니까?")) {
							    const f = document.getElementById("deleteForm");
							    f.action = "/FreeBoard/deleteContent";
							    f.submit();
							}
						};
					</script>
				</c:otherwise>
			</c:choose>
	</form>
	
	
	<form action="/reply/addReply" method="post">
		<input type="hidden" name="cpage" value="${cpage}">
		<input type="hidden" name="postId" value="${post.postId}">
		<hr>

		<div class="commentHeader">댓글 ${commentCount}</div>
		<br>
		<div class="commentPlace">
			<textarea name="content" placeholder="댓글을 입력하세요 (최대 1000바이트)"></textarea>
			<input type="text" name="memberId" readonly
					value="<c:out value='${loginId}'/>">
			<input type="submit" value="댓글 등록">
		</div>
	</form>
	<c:forEach var="reply" items="${replyList}">
		<form action="/reply/updateReply" method="post">
			<!-- 폼이 foreach안에있어야 댓글마다 수정form이 각각 생긴다 -->
			<input type="hidden" name="replyId" value="${reply.replyId}">
			<input type="hidden" name="cpage" value="${cpage}">
			<input type="hidden" name="postId" value="${post.postId}">
			<div class="replyList">
				<div class="reply" style="${reply.parentReplyId != 0 ? 'margin-left: 40px;' : ''}">

					<div class="replyInfo">
						<span class="replyWriter"><c:out value="${reply.memberId}" /></span>
						<span class="replyDate"><fmt:formatDate value="${reply.createdAt}" pattern="yyyy.MM.dd HH:mm"/></span>
						<c:if test="${reply.memberId == loginId}">
							<input id="replyUpbtn${reply.replyId}" type="button" value="수정">
							<input id="replyUpOkbtn${reply.replyId}" type="submit"
									value="수정완료" style="display: none;">
							<input id="replyUpCancelbtn${reply.replyId}" type="button"
									value="수정취소" style="display: none;">
							<input id="replyDelbtn${reply.replyId}" type="button" value="삭제">
						</c:if>
					</div>
					<textarea id="comment${reply.replyId}" name="content" class="replyContents" readonly><c:out value="${reply.content}" /></textarea>
					
						<!-- 대댓글달기 -->
					<%-- <input id="reReplybtn" type="button" value="대댓글 달기">
					<div class="commentPlace">
						<input type="hidden" name="postId" value="${post.postId }">
						<input type="hidden" name="parentReplyId" value="${reply.replyId }">
						<textarea name="content" placeholder="대댓글을 입력하세요 (최대 1000바이트)"></textarea>
						<span>작성자: ${loginId }</span>
						<input type="text" name="memberId" readonly value="<c:out value='${loginId}'/>">
						<input type="submit" value="대댓글 등록">
					</div>
					<script>
						document.getElementById("reReplybtn").onclick = function(){
							
						}	
					</script> --%>
					<c:if test="${reply.parentReplyId == 0 && not empty loginId}">
    					<input type="button" value="답글" style="margin-top: 8px;" onclick="openRecomment(this, ${reply.replyId})">
					</c:if>
					
					<c:if test="${reply.memberId == loginId}">
						<script>
							(function() {
								const id = "${reply.replyId}";
								const box = document.getElementById("comment" + id);
								const origin = box.value;
								const up = document.getElementById("replyUpbtn" + id);
								const ok = document.getElementById("replyUpOkbtn" + id);
								const cancel = document.getElementById("replyUpCancelbtn" + id);
								const del = document.getElementById("replyDelbtn" + id);

								up.onclick = function() {
									up.style.display = "none";
									del.style.display = "none";
									ok.style.display = "inline-block";
									cancel.style.display = "inline-block";
									box.readOnly = false;
								};
								cancel.onclick = function() {
									up.style.display = "inline-block";
									del.style.display = "inline-block";
									ok.style.display = "none";
									cancel.style.display = "none";
									box.readOnly = true;
									box.value = origin;
								};
								del.onclick = function() {
									if (confirm("댓글을 삭제하시겠습니까?")) {
									    const f = document.getElementById("deleteForm");
									    f.action = "/reply/deleteReply";
									    f.elements["replyId"].value = id;
									    f.submit();
									}
								};
							})();
						</script>
					</c:if>
				</div>
			</div>
		</form>
	</c:forEach>
		<form id="deleteForm" method="post" style="display: none;">
			<input type="hidden" name="postId" value="${post.postId}">
			<input type="hidden" name="cpage" value="${cpage}">
			<input type="hidden" name="replyId" value="">
		</form>
		<form id="recommentForm" action="/reply/addReply" method="post" style="display: none;">
    		<input type="hidden" name="postId" value="${post.postId}">
    		<input type="hidden" name="cpage" value="${cpage}">
   			<input type="hidden" name="parentReplyId" value="">
   			<input type="hidden" name="memberId" value="<c:out value='${loginId}'/>">
    		<div class="commentPlace" style="margin-left: 40px;">
        		<textarea name="content" placeholder="답글을 입력하세요"></textarea>
       			<input type="submit" value="답글 등록">
       			<input type="button" id="recommentCancel" value="취소">
    		</div>
		</form>
		<script>
    		function openRecomment(btn, parentId) {
        		const f = document.getElementById("recommentForm");
        		f.elements["parentReplyId"].value = parentId;
        		f.elements["content"].value = "";
        		btn.closest("form").after(f);
        		f.style.display = "block";
    		}
    		document.getElementById("recommentCancel").onclick = function() {
        		document.getElementById("recommentForm").style.display = "none";
    		};
</script>
</div>
</body>
</html>
