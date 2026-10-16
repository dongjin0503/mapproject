<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챌린지 개설</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
	
	<style>
* { box-sizing: border-box; }

.container {
	--line: #9ca3af;
	--line-strong: #4b5563;
	--fill: #f3f4f6;
	--fill-strong: #e5e7eb;
	--text: #374151;
	--dim: #9ca3af;
	--accent: #111827;
	width: 440px;
	margin: 36px auto;
	font-family: Arial, "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
	color: var(--text);
}

.container .box {
	border: 1.5px solid var(--line);
	border-radius: 6px;
	background: #fff;
	padding: 20px;
}

.container h2 {
	margin: 0 0 14px;
	font-size: 17px;
	color: var(--accent);
}

.field { margin-bottom: 14px; }

.lbl {
	font-size: 12px;
	font-weight: 700;
	margin-bottom: 6px;
}

.lbl em {
	color: #dc2626;
	font-style: normal;
}

.field input[type=text],
.field input[type=date],
.field select,
.field textarea {
	width: 100%;
	border: 1.5px solid var(--line);
	border-radius: 4px;
	padding: 8px 10px;
	font-size: 12px;
	font-family: inherit;
	color: var(--text);
	background: #fff;
}

/* 카테고리 드롭다운 */
.field select {
	height: 36px;
	cursor: pointer;
}

.field textarea {
	height: 110px;
	resize: none;
}

.field input:focus,
.field select:focus,
.field textarea:focus {
	outline: none;
	border-color: var(--line-strong);
}

/* 시작일/종료일 나란히 */
.row2 { display: flex; gap: 10px; }
.row2 .field { flex: 1; }

.btns { display: flex; gap: 10px; margin-top: 18px; }

.btn-cancel, .btn-primary {
	padding: 9px 16px;
	border-radius: 4px;
	font-size: 12.5px;
	font-family: inherit;
	text-align: center;
	cursor: pointer;
}

.btn-cancel {
	width: 120px;
	border: 1.5px solid var(--line-strong);
	background: #fff;
	color: var(--accent);
}

.btn-primary {
	flex: 1;
	border: 1.5px solid var(--accent);
	background: var(--accent);
	color: #fff;
}
</style>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
		<div class="container">
		<div class="box">
			<h2>챌린지 개설</h2>
			<form action="/challenge/createOk" method="post">
				<div class="field">
					<div class="lbl">제목 <em>*</em></div>
					<input type="text" name="title" required>
				</div>

				<div class="row2">
					<div class="field">
						<div class="lbl">시작일 <em>*</em></div>
						<input type="date" name="start_date" required>
					</div>
					<div class="field">
						<div class="lbl">종료일 <em>*</em></div>
						<input type="date" name="end_date" required>
					</div>
				</div>
				
				<div class="field">
    			<div class="lbl">카테고리 <em>*</em></div>
    			<select name="category" required>
        		<option value="">선택하세요</option>
        		<option value="식비">식비</option>
		        <option value="교통">교통</option>
        		<option value="쇼핑">쇼핑</option>
        		<option value="저축">저축</option>
        		<option value="기타">기타</option>
    			</select>
				</div>
				
				<div class="field">
					<div class="lbl">설명</div>
					<textarea name="description"></textarea>
				</div>

				<div class="btns">
					<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
					<button type="submit" class="btn-primary">개설</button>
				</div>
			</form>
		</div>
	</div>

	<Script>
	
	// 오늘 날짜 (yyyy-MM-dd)
	var now = new Date();
	var month = now.getMonth() + 1;
	var day = now.getDate();
	if (month < 10) { month = "0" + month; }
	if (day < 10) { day = "0" + day; }
	var today = now.getFullYear() + "-" + month + "-" + day;
	
	// 달력에서 오늘 이전 날짜는 선택할 수 없게
	$("input[name='start_date']").attr("min", today);
	$("input[name='end_date']").attr("min", today);
	
	$("form").on("submit", function(){
	    var start = $("input[name='start_date']").val();
	    var end   = $("input[name='end_date']").val();

	    if(start < today){                              // 직접 입력해도 막기
	        alert("시작일은 오늘 이후로 선택해주세요.");
	        return false;
	    }

	    if(end < start){                                // 1번 빈칸 (종료일이 시작일보다 빠른 조건)
	        alert("종료일은 시작일보다 빠를 수 없어요.");
	        return false;                            // 제출 막기
	    }
	});
	</Script>
		<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>