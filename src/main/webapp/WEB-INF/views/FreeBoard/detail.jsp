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
.likeBox {
	margin-left: auto;
	flex-shrink: 0;
	display: flex;
	align-items: center;
	gap: 8px;
}

#likeCount {
	padding: 4px 14px;
	line-height: 1;
	border: 1px solid #d5dce7;
	border-radius: 20px;
	background: white;
	font-size: 13px;
	cursor: pointer;
}

#likeCount:hover {
	border-color: #1c2535;
}

#likeCount i {
	color: #2457d6;
	font-size: 16px;
}

#p1 {
	margin: 0;
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

/* 남의 글 본문 (에디터 없이 읽기만) */
.viewContent {
	min-height: 200px;
	padding: 15px;
	font-size: 15px;
	line-height: 1.7;
	color: #1c2535;
	word-break: break-all;
	overflow-wrap: anywhere;
}

.viewContent img {
	max-width: 100%;
	height: auto;
}

/* 첨부파일 */
#fileBox {
	margin-top: 20px;
	padding: 14px 16px;
	border: 1px solid #d5dce7;
	border-radius: 8px;
	color: #39465c;
	font-size: 13px;
}

#fileBox legend {
	padding: 0 8px;
	font-weight: bold;
}

#fileBox a {
	color: #2457d6;
	text-decoration: none;
}

#fileBox a:hover {
	text-decoration: underline;
}

/* 기존 첨부파일 한 줄 */
.fileItem {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 4px 0;
}

.fileUploadRow {
	display: flex;
	align-items: center;
	gap: 10px;
	width: 100%;
	min-width: 0;
	margin-top: 10px;
}

/* 실제 파일 input 숨기기 */
.fileInput {
	display: none;
}

/* 파일 선택 버튼 */
.fileBtn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 6px;
	flex-shrink: 0;
	padding: 10px 13px;
	border: 1px solid #d5dce7;
	border-radius: 8px;
	background: white;
	color: #39465c;
	cursor: pointer;
	transition: 0.2s;
}

.fileBtn:hover {
	background: #1c2535;
	color: white;
	border-color: #1c2535;
}

/* 파일명 */
.fileName {
	flex: 1;
	min-width: 0;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	color: #8995a9;
}

/* 추가 파일 버튼 */
#add {
	flex-shrink: 0;
	margin-left: auto;
	padding: 10px 12px;
	border: 1px solid #d5dce7;
	border-radius: 8px;
	background: #b0b0b0;
	color: white;
	font-size: 12px;
	cursor: pointer;
	transition: 0.2s;
}

#add:hover {
	background: #1c2535;
	color: white;
}

/* 추가 파일 영역 */
#additionalFiles {
	display: flex;
	flex-direction: column;
	gap: 8px;
	margin-top: 10px;
}

.additionalFile {
	width: 100%;
	min-width: 0;
	font-size: 13px;
	color: #39465c;
}

.additionalFile::file-selector-button {
	padding: 9px 12px;
	margin-right: 10px;
	border: 1px solid #d5dce7;
	border-radius: 8px;
	background: white;
	color: #39465c;
	cursor: pointer;
	transition: 0.2s;
}

.additionalFile::file-selector-button:hover {
	background: #1c2535;
	color: white;
	border-color: #1c2535;
}

/* 하단 버튼 (목록으로/수정/수정완료/수정취소/삭제) */
.footer {
	display: flex;
	justify-content: flex-start;
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

/* 목록으로 버튼은 항상 오른쪽 끝 */
.footer a {
	order: 99;
	margin-left: auto;
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
	flex-wrap: wrap;
	align-items: center;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 15px;
	padding: 14px;
	background-color: #fafbfe;
	border: 1px solid #d5dce7;
	border-radius: 8px;
}

.commentPlace textarea {
	flex: 1 1 100%;
	width: 100%;
	height: 80px;
	padding: 12px 14px;
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

/* 작성자: 입력창이 아니라 글자처럼 왼쪽 아래에 표시 */
.commentPlace input[name="memberId"] {
	margin-right: auto;
	width: 160px;
	height: 32px;
	padding: 0 4px;
	border: none;
	background: transparent;
	color: #1c2535;
	font-size: 14px;
	font-weight: bold;
	outline: none;
}

/* 댓글/답글 등록 버튼 */
.commentPlace input[type="submit"] {
	width: 90px;
	height: 36px;
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
	height: 36px;
	border: 1px solid #d5dce7;
	border-radius: 6px;
	background: white;
	color: #39465c;
	cursor: pointer;
}

/* 댓글 목록 */
.replyList {
	margin-top: 10px;
}

/* 일반 댓글: 얇은 테두리 카드 (그림자 없음) */
.reply {
	padding: 0;
	background: white;
	border: 1px solid #d8dfea;
	border-radius: 10px;
	overflow: hidden;
}

/* 헤더 띠: 아주 연한 배경 + 얇은 구분선 */
.replyInfo {
	display: flex;
	align-items: center;
	gap: 8px;
	margin: 0;
	padding: 10px 20px;
	background: #f0f3f8;
	border-bottom: 1px solid #e0e6ef;
	font-size: 13px;
}

/* 댓글 내용 */
.replyContents {
	display: block;
	width: 100%;
	min-height: 0;
	padding: 18px 22px;
	font-size: 14px;
	line-height: 1.6;
	color: #39465c;
	border: none;
	background: transparent;
	overflow: hidden;
	resize: none;
	outline: none;
}

/* 수정 중일 때만 살짝 강조 */
.replyContents:not([readonly]) {
	background: #fffef8;
}

/* 수정/삭제/답글 버튼: 조용한 알약 버튼 */
.replyInfo input,
.reply > input[type="button"] {
	padding: 3px 10px;
	border: 1px solid #e3e8f0;
	border-radius: 20px;
	background: white;
	color: #6b7790;
	font-size: 12px;
	cursor: pointer;
}

.replyInfo input:hover,
.reply > input[type="button"]:hover {
	border-color: #1c2535;
	color: #1c2535;
}

.replyInfo input[id^="replyDel"]:hover {
	border-color: #c0392b;
	color: #c0392b;
}

/* 답글 버튼: 카드 안쪽 아래 여백 */
.reply > input[type="button"] {
	margin: 0 0 16px 20px;
}

/* 대댓글: 같은 카드인데 헤더 띠만 살짝 푸른빛 + ↳ */
.replyList.childReply {
	margin-top: 6px;
}

.replyList.childReply .reply {
	background: white;
	border-color: #d3dcee;
}

.replyList.childReply .replyInfo {
	background: #eaf0fb;
	border-bottom-color: #d8e2f4;
}

.replyList.childReply .replyWriter::before {
	content: "↳ ";
	color: #aab3c4;
}
/* 대댓글 */
.writerBadge {
	padding: 1px 8px;
	border-radius: 10px;
	background-color: #e8eefc;
	color: #2457d6;
	font-size: 11px;
	font-weight: bold;
}

.replyDate {
	margin-right: auto;
	color: #8995a9;
	font-size: 12px;
}
/* 수정 중일 때만 입력창처럼 */
.replyContents:not([readonly]) {
	background: #fffef8;
	box-shadow: inset 0 0 0 2px #1c2535;
}
</style>

</head>

<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<div class="container">
		<form action="/FreeBoard/updateContent" method="post" enctype="multipart/form-data">
			<input type="hidden" name="postId" value="${post.postId}">
			<input type="hidden" name="cpage" value="${cpage}">
			<div class="header">
				<input id="titleText" name="title" type="text" value="<c:out value='${post.title}'/>" readonly>
			</div>
			<div class="detail">
				<span>번호: ${post.postId}</span>
				<!-- <c:out value= "글자가 html로 해석되는걸 막음"/> -->
				<!-- 숫자는 오류가 생길 수 없으니 안씀 -->
				<span>카테고리: <c:out value="${post.contentCategory}" /></span>
				<span>작성자: <c:out value="${post.username}" /></span>
				<span>조회수: ${post.viewCount}</span>
				<span>작성일: <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/></span>
				<!-- 추천 기능 ajax -->
				<div class="likeBox">
					<button type="button" id="likeCount"><i id="likeIcon" class="${liked ? 'fa-solid' : 'fa-regular'} fa-thumbs-up"></i></button>
					<p id="p1">${post.likeCount}</p>
				</div>
			</div>

			<script>
				$("#likeCount").on("click", function() {
					$.ajax({
						url : "/FreeBoard/likecount",
						type : "post",
						data : {
							postId : "${post.postId}"
						}
					}).done(function(resp) {		//서버가 응답을 return하면 실행
						if (resp == "-1") {
					        alert("로그인 후 이용해주세요.");
					        return;
					    }
						var r = resp.split(",");	//return으로 추천수와 내 추천상태를 받았으므로 두개를 잘라서 배열로 만듦
						$("#p1").text(r[0]);		//#p1에 추천수 들어감
						$("#likeIcon").attr("class", (r[1] == "1" ? "fa-solid" : "fa-regular") + " fa-thumbs-up");
						// r[1]=1이면 추천된 상태이므로 채워진 아이콘, r[1] != 1이면 추천을 내린 상태이므로 빈 아이콘으로 속성변경
					}).fail(function(xhr) {	//오류발생시 확인하기위해(필요없긴함)
						alert("추천 처리 중 오류가 났어요. (" + xhr.status + ")");
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
			
			<!-- 본문 내용 -->
			<div class="content">
				<div id="viewContent" class="viewContent">${post.content}</div>
			<!-- 로그인 아이디랑 작성자 아이디 같으면 수정할때 dto에 저장되게 name 추가 -->
				<c:if test="${post.memberId == loginId}">
					<textarea id="textArea" name="content" style="display: none;"><c:out value="${post.content}" /></textarea>
				</c:if>
			</div>
			<c:if test="${not empty fileList or post.memberId == loginId}">
			<!-- 파일 리스트 비어있으면 display:none -->
				<fieldset id="fileBox" style="${empty fileList ? 'display: none;' : ''}">
					<legend>첨부파일</legend>
			<!-- 존재하면 반복문 -->
					<c:forEach var="i" items="${fileList}">
						<div class="fileItem"><i class="fa-solid fa-paperclip"></i>
							<a href="/FreeBoardFile/download?sysname=${i.sysname }&oriname=${i.oriname}"><c:out value="${i.oriname}"/></a>
							<label class="fileDelChk" style="display: none;"><input type="checkbox" name="deleteFileId" value="${i.fileId}"> 삭제</label>
						</div>
					</c:forEach>

					<div id="updateFile" style="display: none;">
						<div class="fileUploadRow">
							<input id="selectFile" type="file" name="files" class="fileInput">
							<label for="selectFile" class="fileBtn">파일 선택</label>
							<span id="firstFileName" class="fileName">선택된 파일 없음</span>
							<input id="add" type="button" value="+">
						</div>
						<div id="additionalFiles"></div>
					</div>
				</fieldset>
			</c:if>
			
			<script>
			const hasFiles = ${not empty fileList};	//jsp가 서버에서 먼저 계산함
			//const hasFiles = true;     첨부파일이 있는 글
			//const hasFiles = false;    첨부파일이 없는 글

			$("#selectFile").on("change", function() {	//change는 입력값 바뀌었을때 기능(여기서는 파일선택 시)
				const file = this.files[0];
				$("#firstFileName").text(file ? file.name : "선택된 파일 없음");
			});

			$("#add").on("click", function() {
				$("#additionalFiles").append(
					$('<input>', { type: 'file', name: 'files', class: 'additionalFile' })
				);
			});

			function resetFileInputs() {	//파일 선택 칸을 처음 상태로 되돌리는 함수
				// updatecancel 함수에서 사용
				$("#selectFile").val("");
				$("#firstFileName").text("선택된 파일 없음");
				$("#additionalFiles").empty();
			}
			</script>
			<!-- 작성자가 사용자랑 다르면 목록 버튼만 -->
			<c:choose>
				<c:when test="${post.memberId != loginId}">	
					<div class="footer">
						<a href="/FreeBoard/freeboard?cpage=${cpage}">목록으로</a>
					</div>
				</c:when>
				<c:otherwise>
				<!-- 작성자가 사용자랑 같으면 목록&수정 버튼 -->	
					<div class="footer">
						<a href="/FreeBoard/freeboard?cpage=${cpage}">목록으로</a>
						<input id="updatebtn" type="button" value="수정">
						<input id="updateOkbtn" type="submit" value="수정완료" style="display: none;">
						<input id="updateCancelbtn" type="button" value="수정취소" style="display: none;">
						<input id="deletebtn" type="button" value="삭제">
					</div>
					<script>
					// 원래 값 저장. 수정 중 취소했을때 되돌리기 위해 백업용(const 4가지)
						const originTitle = document.getElementById("titleText").value;
						const originContent = document.getElementById("textArea").value;
						// 현재 선택된 카테고리 (세 가지 외의 값이면 null)
						const checkedCategory = document.querySelector('input[name="contentCategory"]:checked');
						const originCategory = checkedCategory ? checkedCategory.value: null;

						//수정버튼
						document.getElementById("updatebtn").onclick = function() {
							document.getElementById("titleText").readOnly = false;
							document.getElementById("viewContent").style.display = "none";
							$('#textArea').summernote({ height: 400, lang: 'ko-KR' });
							document.getElementById("updateCategory").style.display = "flex";
							document.getElementById("deletebtn").style.display = "none";
							document.getElementById("updatebtn").style.display = "none";
							document.getElementById("updateOkbtn").style.display = "inline-block";
							document.getElementById("updateCancelbtn").style.display = "inline-block";
							document.getElementById("fileBox").style.display = "block";
							document.getElementById("updateFile").style.display = "block";
							//클래스가 fileDelChk인 요소가 여러 개일 수 있어서 하나씩 돌면서 보이게 하는 반복문
							document.querySelectorAll(".fileDelChk").forEach(function(e) { e.style.display = "inline"; });
						};

						document.getElementById("updateCancelbtn").onclick = function() {
							document.getElementById("titleText").readOnly = true;
							document.getElementById("updateCategory").style.display = "none";
							document.getElementById("deletebtn").style.display = "inline-block";
							document.getElementById("updatebtn").style.display = "inline-block";
							document.getElementById("updateOkbtn").style.display = "none";
							document.getElementById("updateCancelbtn").style.display = "none";
							document.getElementById("titleText").value = originTitle;
							$('#textArea').summernote('destroy');
							$('#textArea').val(originContent).hide();
							document.getElementById("viewContent").style.display = "block";
							document.getElementById("updateFile").style.display = "none";
							resetFileInputs();	//새로 고른 파일 칸 비우기
							if (!hasFiles) document.getElementById("fileBox").style.display = "none";
							//기존 첨부파일이 없던 글이면 파일 영역 전체를 다시 숨김
							document.querySelectorAll(".fileDelChk").forEach(function(e) {
							    e.style.display = "none";	//삭제 체크박스를 숨기면서 체크도 해제
							    e.querySelector("input").checked = false;
							});
							
							// 바꿨던 카테고리도 원래대로
							if (originCategory !== null) {
								document.querySelector('input[name="contentCategory"][value="'
												+ originCategory + '"]').checked = true;
							}
						};
						
						//게시글 삭제 버튼
						document.getElementById("deletebtn").onclick = function() {
							if (confirm("정말 삭제하시겠습니까?")) {	//확인 누르면true
							    const f = document.getElementById("deleteForm");
							    f.action = "/FreeBoard/deleteContent";	//삭제 주소로 지정하고 submit으로 직접 전송
							    f.submit();
							}
						};
					</script>
				</c:otherwise>
			</c:choose>
	</form>
	
	<!-- 댓글 추가 -->
	<form action="/reply/addReply" method="post">
		<input type="hidden" name="cpage" value="${cpage}">
		<input type="hidden" name="postId" value="${post.postId}">
		<hr>

		<div class="commentHeader">댓글 ${commentCount}</div>
		<br>
		<div class="commentPlace">
			<textarea name="content" placeholder="댓글을 입력하세요 (최대 1000바이트)"></textarea>
			<input type="text" name="memberId" readonly value="<c:out value='${loginUsername}'/>">
			<input type="submit" value="댓글 등록">
		</div>
	</form>
	<c:forEach var="reply" items="${replyList}">
		<form action="/reply/updateReply" method="post">
			<!-- 폼이 foreach안에있어야 댓글마다 수정form이 각각 생긴다 -->
			<input type="hidden" name="replyId" value="${reply.replyId}">
			<input type="hidden" name="cpage" value="${cpage}">
			<input type="hidden" name="postId" value="${post.postId}">
			
			
			<!-- 삼항연산자 (대댓글 들여쓰기)/부모댓글이 있으면 대댓글 -->
			<div class="replyList ${(not empty reply.parentReplyId and reply.parentReplyId != 0) ? 'childReply' : ''}">
				<div class="reply" style="${(not empty reply.parentReplyId and reply.parentReplyId != 0) ? 'margin-left: 40px;' : ''}">

					<div class="replyInfo">
						<span class="replyWriter"><c:out value="${reply.username}" /></span>
						<!-- 댓글 작성자와 게시글 작성자가 같으면 뱃지 추가 -->
						<c:if test="${reply.memberId == post.memberId}"><span class="writerBadge">글쓴이</span></c:if>
						<span class="replyDate"><fmt:formatDate value="${reply.createdAt}" pattern="yyyy.MM.dd HH:mm"/></span>						
						<!-- 한페이지에 댓글 여러개일때 id 겹침 방지 --> 
						<c:if test="${reply.memberId == loginId}">
							<input id="replyUpbtn${reply.replyId}" type="button" value="수정">
							<input id="replyUpOkbtn${reply.replyId}" type="submit" value="수정완료" style="display: none;">
							<input id="replyUpCancelbtn${reply.replyId}" type="button" value="수정취소" style="display: none;">
							<input id="replyDelbtn${reply.replyId}" type="button" value="삭제">
						</c:if>
					</div>
					<textarea id="comment${reply.replyId}" name="content" class="replyContents" readonly><c:out value="${reply.content}" /></textarea>
					<!-- 부모댓글 없을때(대댓글의 대댓글추가를 방지하기 위함) -->
					<c:if test="${(empty reply.parentReplyId or reply.parentReplyId == 0) && not empty loginId}">
    					<input type="button" value="답글" style="margin-top: 8px;" onclick="openRecomment(this, ${reply.replyId})">
					</c:if>
					<!-- openRecomment()는 대댓글 입력칸 열어주는 함수 -->
					
					<!-- 내가 쓴 댓글(c:if)마다 <script>가 하나씩 만들어짐 -->
					<!-- 버튼이 없는 댓글에서 스크립트가 돌면 getElementById가 null을 돌려줘서 에러가 나기 때문 -->
					<c:if test="${reply.memberId == loginId}">
						<script>
							(function() {	// 만들어지자마자 바로 한번 실행하는 함수
											// function()을 ()로 감싸는 이유
											// 댓글 3개면 같은 <script>가 3번 나오는데, 감싸지 않으면 같은 페이지에서 const id를 3번 선언하게 되어 에러
											// 함수로 감싸면 변수가 함수 안에서만 살아서 댓글마다 독립적으로 동작
								const id = "${reply.replyId}";
								const box = document.getElementById("comment" + id);
								const origin = box.value;	// 수정 취소시 백업용
								const up = document.getElementById("replyUpbtn" + id);
								const ok = document.getElementById("replyUpOkbtn" + id);
								const cancel = document.getElementById("replyUpCancelbtn" + id);
								const del = document.getElementById("replyDelbtn" + id);

								// 수정 버튼
								up.onclick = function() {
									up.style.display = "none";
									del.style.display = "none";
									ok.style.display = "inline-block";
									cancel.style.display = "inline-block";
									box.readOnly = false;
									fitReply(box);	//textarea 높이를 글 길이에 맞추는 함수
								};
								// 수정 취소 버튼
								cancel.onclick = function() {
									up.style.display = "inline-block";
									del.style.display = "inline-block";
									ok.style.display = "none";
									cancel.style.display = "none";
									box.readOnly = true;
									box.value = origin;	//백업한 origin을 value값에 넣음
									fitReply(box);
								};
								del.onclick = function() {
									if (confirm("댓글을 삭제하시겠습니까?")) {
									    const f = document.getElementById("deleteForm");
									    f.action = "/reply/deleteReply";
									    f.elements["replyId"].value = id;	//지금 댓글 번호 채워넣음 
									    //폼 안에서 name이 replyId인 입력칸을 찾는 방법
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
		<!-- 삭제 전용 공용 폼 -->
		<form id="deleteForm" method="post" style="display: none;">
			<input type="hidden" name="postId" value="${post.postId}">
			<input type="hidden" name="cpage" value="${cpage}">
			<input type="hidden" name="replyId" value="">
			<!-- value값 비어있다가 댓글 삭제 버튼 누르면 JS가 번호를 채워넣음 (850줄참조) -->
			<!-- 게시글 삭제시에는 쓰지않음 -->
		</form>
		<!-- 답글 입력 공용 폼 -->
		<form id="recommentForm" action="/reply/addReply" method="post" style="display: none;">
    		<input type="hidden" name="postId" value="${post.postId}">
    		<input type="hidden" name="cpage" value="${cpage}">
   			<input type="hidden" name="parentReplyId" value="">
   			<!-- value값 존재시에 대댓글로 저장 -->
   			<input type="hidden" name="memberId" value="<c:out value='${loginId}'/>">
    		<div class="commentPlace" style="margin-left: 40px;">
        		<textarea name="content" placeholder="답글을 입력하세요"></textarea>
       			<input type="submit" value="답글 등록">
       			<input type="button" id="recommentCancel" value="취소">
    		</div>
		</form>
		
		<script>
		
    		function openRecomment(btn, parentId) {	// 답글 버튼 클릭 시
        		const f = document.getElementById("recommentForm");
        		f.elements["parentReplyId"].value = parentId;
        		f.elements["content"].value = "";	// 다른 댓글에서 쓰다 만 내용이 남아 있지 않게 하기 위함
        		btn.closest("form").after(f);	// 가장 가까운 form 찾음
        		// 답글 버튼은 그 댓글의 수정 폼 안에 있으니, 결과는 그 댓글의 폼 전체
        		// after(f): 댓글 폼 바로 다음 위치로 f를 옮김. 새로 복사하는 게 아니라 원래 있던 폼을 이동
        		f.style.display = "block";
    		}
    		function fitReply(t) {	// textarea 높이 자동 조절
        		t.style.height = "auto";
        		t.style.height = t.scrollHeight + "px";
        		//t.scrollHeight는 textarea 안의 내용 전체 높이. 이 값을 height로 넣으면 스크롤 없이 내용이 딱 맞게 보임.
        		
        		//그 앞에 height = "auto"로 한 번 되돌리는 이유가 중요.
        		//높이를 먼저 초기화하지 않으면 scrollHeight가 현재 높이보다 작게 나오지 않아서 글을 지워도 칸이 줄어들지 않습니다. 줄였다가 다시 늘리는 2단계 방식
        		
        		//앞의 수정 스크립트에서 up.onclick과 cancel.onclick 안에 fitReply(box)가 들어 있던 이유.
        		//취소해서 원래 내용으로 돌아가면 높이도 맞춰 줘야 한다.
    		}
    		//댓글 칸 전체에 적용
    		document.querySelectorAll(".replyContents").forEach(function(t) {
        		fitReply(t);	// 페이지를 열자마자 높이를 내용에 맞춤
        		t.addEventListener("input", function() { fitReply(t); });
        		// 글자를 입력할 때마다 높이를 다시 맞춘다. input은 글자가 바뀔 때마다 발생하는 이벤트
    		});
    		//답글 취소 버튼
    		document.getElementById("recommentCancel").onclick = function() {
        		document.getElementById("recommentForm").style.display = "none";	// 답글 폼 숨김
    		};
		</script>
		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	</div>
</body>
</html>