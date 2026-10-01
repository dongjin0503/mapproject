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

/* 2단계는 처음에 숨김 */
#step2 {
	display: none;
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

input[type="text"], input[type="password"] {
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
	<img src="/images/logo.png" alt ="짠내맵"> 
	</div>
	<div class ="wrap">
	<div class = "container">
	<div id ="step1"> 
	<div class ="title">  비밀번호 찾기 </div>
	<div class ="desc"> 비밀번호 찾기를 위한 정보를 입력해주세요 </div>
	<fieldset>
	<legend> ID </legend>
	<input id ="id" type = "text" placeholder ="아이디를 입력해주세요">
	</fieldset>
	<fieldset>
	<legend> 이름 </legend>
	<input id ="name" type = "text" placeholder = "이름을 입력해주세요">
	</fieldset>
	<fieldset>
	<legend> 연락처</legend>
	<input id = "phone" type ="text" placeholder ="연락처를 입력해주세요 ">
	</fieldset>
	<div class ="msg" id ="msg1"></div>
	<button id="btncheck" type = "button"> 비밀번호 찾기 </button>
	</div>
	
	<div id="step2">
	<div class="title">새 비밀번호 설정</div>
	<div class="desc">새로 사용할 비밀번호를 입력해주세요</div>

	<fieldset>
	<legend>새 비밀번호</legend>
	<input id="pw" type="password" placeholder="영문/숫자/특수문자 조합 8~16자">
	</fieldset>

	<fieldset>
	<legend>새 비밀번호 확인</legend>
	<input id="pw1" type="password" placeholder="비밀번호 재입력">
	</fieldset>

	<div class="msg" id="msg2"></div>
	<button type="button" id="btnReset">비밀번호 변경</button>
	
	</div>
	<button type="button" class="close-btn" onclick="window.close()">닫기</button>
	</div>
	</div>	
	<script>
	
	let pwReg = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!-\/:-@\[-`{-~])[A-Za-z\d!-\/:-@\[-`{-~]{8,16}$/;
	
	$("#btncheck").on("click",function(){
		let id = $("#id").val().trim();
		let name = $("#name").val().trim();
		let phone = $("#phone").val().trim();
		
		if(id == "" || name == ""|| phone == "") {
			$("#msg1").addClass("error").text("모든 항목을 입력해주세요.");
			return;
		}
		$.ajax({
			url : "/member/ajax/checkpw",
			type : "get",
			data : {id : id , name : name , phone : phone},
			dataType : "json"
		}).done(function(resp){
			if(resp) {
				$("#step1").hide();
				$("#step2").show();
			} else {
				$("#msg1").addClass("error").text ("일치하는 회원 정보가 없습니다");
			}
		});
		});
	
		$("#btnReset").on("click",function(){
			let pw = $("#pw").val();
			let pw1 =$("#pw1").val();
			
			if(!pwReg.test(pw)){
			$("#msg2").addClass("error").text("영문/숫자/특수문자를 포함하여 8~16자로 입력해주세요");
			return;
			}
			
			if (pw != pw1) {
				$("#msg2").addClass("error").text("비밀번호가 일치하지 않습니다.");
				return;
			}
			$.ajax({
				url : "/member/ajax/resetpw",
				type : "post",
				data : {pw : pw},
				dataType : "json"
			}).done(function(resp){
				if(resp) {
					alert("비밀번호가 변경되었습니다. 새 비밀번호로 로그인 해주세요.");
					window.close();
				} else {
					$("#msg2").addClass("error").text("변경에 실패했습니다. 처음부터 다시 시도해주세요");
				}
			});
			});
		
	</script>
</body>
</html>