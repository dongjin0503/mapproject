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



/* 글쓰기 카드 */
.container {
	width: 900px;
	max-width: calc(100% - 40px);
	margin: 0 auto;
	margin-top: 20px;
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

.fileUploadRow {
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;
    min-width: 0;
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

/* 추가 파일 한 줄 */
.additionalFileRow {
    display: flex;
    align-items: center;
    gap: 10px;
    min-width: 0;
}

/* 추가 파일 input의 파일 선택 버튼 */
.additionalFile {
    flex: 1;
    min-width: 0;
    width: 100%;
    font-size: 13px;
    color: #39465c;
}

/* 브라우저 기본 파일 선택 버튼 스타일 */
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

/* 추가 파일 삭제 버튼 */
.removeFile {
    flex-shrink: 0;
    padding: 8px 10px;
    border: 1px solid #fecaca;
    border-radius: 8px;
    background: white;
    color: #dc2626;
    cursor: pointer;
}

.removeFile:hover {
    background: #fef2f2;
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
	<form id="writeForm" action="/FreeBoard/writeup" method="post" enctype="multipart/form-data">
		<div class="container">
			<div class="header">
				<h2>게시글 작성</h2>
			</div>
			<div class="writer">
				<input type="text" name="memberId" value="${loginUsername}" readonly>
			</div>
			<div class="title">
				<input type="text" name="title" placeholder="제목을 입력하세요 (최대 300바이트)">
			</div>
			<div class="categoryGroup">
				<input type="radio" name="contentCategory" id="cat-free" value="자유" checked><label for="cat-free">자유</label>
				<input type="radio" name="contentCategory" id="cat-question" value="질문"><label for="cat-question">질문</label>
				<input type="radio" name="contentCategory" id="cat-info" value="정보"> <label for="cat-info">정보</label>
				
			<%-- 관리자에게만 "공지" 라디오를 보여 줌 (실제 차단은 1번) --%>
			<c:if test = "${sessionScope.loginId == 'admin'}">
			<input type ="radio" name ="contentCategory" id ="cat-notice" value ="공지"><label for ="cat-notice"> 공지</label>
			</c:if>
				<!-- type radio는 name이 같은것들이 여러가지면 체크한것만 들어감(나머지는 해제) -->
			</div>
			
			<div class="content">
				<textarea name="content" id="content" placeholder="내용을 입력하세요 (최대 약 2MB)"></textarea>
			</div>
			<div id="contentByteCount" style="text-align: right; margin-top: 8px; font-size: 13px; color: #8995a9;">0 / 2000000 bytes</div>
			<!-- 본문 textarea를 summernote-lite 에디터로 바꾸기 -->
			
<script>
$(function () {
    const maxBytes = 2000000;
    const $editor = $('#content');
    const $count = $('#contentByteCount');

    $editor.summernote({
        height: 400,
        lang: 'ko-KR',
        placeholder: '내용을 입력하세요',
        callbacks: {
            onInit: function () {
                // Summernote 이미지 창의 파일 input(name="files")이 첨부파일로 같이 전송되는 것을 막음
                $('.note-image-input').removeAttr('name');
            },
            onChange: function (contents) {
                updateByteCount(contents);
            }
        }
    });

    // 본문 HTML의 UTF-8 바이트 수 계산
    function getContentBytes() {
        const content = $editor.summernote('code');
        return new TextEncoder().encode(content).length;
    }

    // 바이트 수 표시
    function updateByteCount(content) {
        const byteCount = new TextEncoder().encode(content).length;

        $count.text(byteCount + ' / ' + maxBytes + ' bytes');
        $count.css('color', byteCount > maxBytes ? 'red' : '#8995a9');
    }

    // 작성완료 전 검사
    $('#writeForm').on('submit', function (e) {
        // 제목 비어있음 검사
        if ($('input[name="title"]').val().trim() === '') {
            e.preventDefault();
            alert('제목을 입력해 주세요.');
            $('input[name="title"]').focus();
            return false;
        }

        // 제목 300바이트 검사
        const titleBytes = new TextEncoder().encode($('input[name="title"]').val()).length;

        if (titleBytes > 300) {
            e.preventDefault();
            alert('제목은 300바이트까지만 입력할 수 있습니다.\n현재: ' + titleBytes + '바이트');
            return false;
        }

        const byteCount = getContentBytes();

        if (byteCount > maxBytes) {
            e.preventDefault();
            alert('본문은 이미지를 포함하여 2000000바이트(약 2MB)까지만 작성할 수 있습니다.');
            return false;
        }
    });

    // 최초 바이트 수 표시
    updateByteCount($editor.summernote('code'));

    // 서버에서 되돌려보낸 경우 안내
    const params = new URLSearchParams(location.search);
    if (params.get('error') === 'titleEmpty') {
        alert('제목을 입력해 주세요.');
    } else if (params.get('error') === 'titleTooLong') {
        alert('제목은 300바이트까지만 입력할 수 있습니다.');
    } else if (params.get('error') === 'contentTooLong') {
        alert('본문이 2000000바이트(약 2MB)를 초과했습니다. 내용을 줄여 주세요.');
    }
});
</script>

			<fieldset id="fileBox">
    			<legend>파일 업로드</legend>
				<div class="fileUploadRow">
        			<input id="selectFile" type="file" name="files" class="fileInput">
					<label for="selectFile" class="fileBtn">파일 선택</label>
        			<span id="firstFileName" class="fileName">선택된 파일 없음</span>
        			<input id="add" type="button" value="+">
    			</div>
				<div id="additionalFiles"></div>
			</fieldset>

			<script>
			$("#selectFile").on("change", function() {	//"change": 입력값이 바뀌었을 때 발생하는 이벤트("파일을 골랐을 때")
			    const file = this.files[0];				

			    $("#firstFileName").text(		//파일 존재여부로 텍스트변경
			        file ? file.name : "선택된 파일 없음"
			    );
			});
			
			$("#add").on("click", function() {	//추가파일 업로드 버튼 클릭시
			    $("#additionalFiles").append(
			        $('<input>', {
			            type: 'file',
			            name: 'files',
			            class: 'additionalFile'
			        })
			    );
			});
			</script>
			<div class="footer">
				<a href="/FreeBoard/freeboard?cpage=1"><input type="button" value="취소"></a>
				<input id="listup" type="submit" value="작성완료">
			</div>
		</div>
	</form>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>