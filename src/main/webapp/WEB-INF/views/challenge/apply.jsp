<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 챌린지 참여 신청 </title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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

.title {
	font-size: 15px;
	font-weight: 700;
	color: var(--accent);
	margin-bottom: 6px;
}

.sub {
	font-size: 11px;
	color: var(--dim);
}

.container hr {
	border: 0;
	height: 1px;
	background: var(--fill-strong);
	margin: 14px 0;
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

.field textarea {
	height: 70px;
	resize: none;
}

.field input:focus,
.field textarea:focus {
	outline: none;
	border-color: var(--line-strong);
}

/* 인증 주기 칩 (라디오를 숨기고 글자 칩으로 표시) */
.chip {
	display: inline-block;
	margin-right: 6px;
	cursor: pointer;
}

.chip input { display: none; }

.chip span {
	display: inline-block;
	border: 1.2px solid var(--line);
	border-radius: 14px;
	padding: 4px 12px;
	font-size: 11px;
	background: #fff;
}

.chip input:checked + span {
	background: var(--accent);
	border-color: var(--accent);
	color: #fff;
}

.agree {
	display: flex;
	align-items: center;
	gap: 8px;
	font-size: 11.5px;
	color: var(--dim);
	margin: 10px 0 18px;
	cursor: pointer;
}

.btns { display: flex; gap: 10px; }

.btn-cancel, .btn-primary {
	padding: 9px 16px;
	border-radius: 4px;
	font-size: 12.5px;
	font-family: inherit;
	text-align: center;
	text-decoration: none;
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
	
</head>
<body>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
			<div class="container">
		<div class="box">
			<div class="title">${ch.title}</div>
			<div class="sub">${ch.start_date} ~ ${ch.end_date} · 참여자 ${ch.member_count}명</div>
			<hr>

			<form action="/challenge/applyOk" method="post">
				<input type="hidden" name="challenge_id" value="${ch.challenge_id}">

				<div class="field">
					<div class="lbl">나의 목표 금액 / 목표치 <em>*</em></div>
					<input name="goal" type="text" placeholder="예 : 이번 달 배달비 3만원 이하" required>
				</div>

				<div class="field">
					<div class="lbl">참여 다짐 한마디 <em>*</em></div>
					<textarea name="pledge" placeholder="함께 절약할 목표나 각오를 적어주세요" required></textarea>
				</div>

				<div class="field">
					<div class="lbl">인증 주기</div>
					<label class="chip"><input type="radio" name="cycle" value="매일"><span>매일</span></label>
					<label class="chip"><input type="radio" name="cycle" value="주 2~3회"><span>주 2~3회</span></label>
				</div>

				<label class="agree">
					<input type="checkbox" required> 챌린지 규칙(인증 미제출 시 처리 방식 등)에 동의합니다
				</label>

				<div class="btns">
					<a class="btn-cancel" href="/challenge/detail?challenge_id=${ch.challenge_id}">취소</a>
					<button type="submit" class="btn-primary">참여 신청</button>
				</div>
			</form>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>