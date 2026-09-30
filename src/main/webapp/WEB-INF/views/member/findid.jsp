<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
:root {
	--line: #9ca3af;
	--line-strong: #4b5563;
	--fill: #f3f4f6;
	--text: #374151;
	--text-dim: #9ca3af;
	--note: #2563eb;
	--accent: #111827;
}

* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
	color: var(--text);
	background: #fff;
}

/* 상단 로고 */
.logo-bar {
	padding: 10px 20px;
	border-bottom: 1.5px solid var(--line);
}

.logo-bar img {
	display: block;
	height: 80px;
}

/* 본문 */
.wrap {
	padding: 16px;
}

.container {
	max-width: 360px;
	margin: 0 auto;
	padding: 16px 14px;
	border: 1.5px solid var(--line);
	border-radius: 6px;
}

.title {
	margin-bottom: 6px;
	font-size: 16px;
	font-weight: 700;
	text-align: center;
	color: var(--accent);
}

.desc {
	margin-bottom: 16px;
	font-size: 11.5px;
	text-align: center;
	color: var(--text-dim);
}

/* fieldset / legend */
fieldset {
	margin: 0 0 12px;
	padding: 6px 10px 10px;
	border: 1.5px solid var(--line);
	border-radius: 4px;
}

legend {
	padding: 0 6px;
	font-size: 11.5px;
	color: var(--text);
}

input[type="text"] {
	width: 100%;
	height: 32px;
	padding: 6px 4px;
	border: none;
	font-size: 12.5px;
	color: var(--text);
	outline: none;
}

input::placeholder {
	color: var(--text-dim);
}

fieldset:focus-within {
	border-color: var(--accent);
}

/* 결과 메시지 */
.msg {
	min-height: 20px;
	margin: 4px 0 10px;
	font-size: 12px;
	text-align: center;
	color: var(--note);
}

.msg.error {
	color: #b91c1c;
}

/* 버튼 */
button {
	width: 100%;
	height: 38px;
	border: 1.5px solid var(--accent);
	border-radius: 4px;
	background: var(--accent);
	font-size: 13px;
	color: #fff;
	cursor: pointer;
}

button:hover {
	background: #000;
}

.close-btn {
	margin-top: 8px;
	border-color: var(--line-strong);
	background: #fff;
	color: var(--accent);
}

.close-btn:hover {
	background: var(--fill);
}
</style>
</head>
<body>

	<div class="logo-bar">
	<img src="/images/logo.png" alt="짠내맵">
	</div>
	<div class = "wrap">	
	<div class ="container">
	<div class ="title"> 아이디 찾기 </div>
	<div class ="desc"> 서비스에 등록된 이름과 휴대폰 번호로 계정을 찾습니다 </div> 
	<fieldset>
	<legend> 이름 </legend>
	<input id ="name" type ="text" placeholder = "이름을 입력 해주세요.">
	</fieldset>
	<fieldset>
	<legend> 휴대폰 번호 </legend>
	<input id = "phone" type = "text" placeholder = "휴대폰 번호를 입력해주세요 ">
	</fieldset>
	<div class = "msg" id="msg"></div>
	<button  id ="btnFind"> 아이디 찾기 </button>
	<button type="button" class="close-btn" onclick="window.close()">닫기</button>
	
	</div>
	</div>
	<script>
		$("#btnFind").on("click", function() {
			let name = $("#name").val().trim();
			let phone = $("#phone").val().trim();

			if (name == "" || phone == "") {
				$("#msg").addClass("error").text("이름과 휴대전화를 입력해주세요.");
				return;
			}

			$.ajax({
				url : "/member/ajax/findid",
				type : "get",
				data : { name : name, phone : phone },
				dataType : "text"
			}).done(function(resp) {
				if (resp == "") {
					$("#msg").addClass("error").text("일치하는 회원 정보가 없습니다.");
				} else {
					$("#msg").removeClass("error").text("회원님의 아이디는 " + resp + " 입니다.");
				}
			});
		});
	</script>
</body>
</html>