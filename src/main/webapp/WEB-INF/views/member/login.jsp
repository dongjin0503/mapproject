<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>짠내맵 로그인 </title>
</head>

<style>
:root {
  --line: #9ca3af;
  --line-strong: #4b5563;
  --fill: #f3f4f6;
  --fill-strong: #e5e7eb;
  --text: #374151;
  --text-dim: #9ca3af;
  --accent: #111827;
}

* { box-sizing: border-box; }

body {
  margin: 0;
  font-family: Arial, "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
  color: var(--text);
  background: #fff;
}

input, button { font-family: inherit; }

/* ---------- 상단 로고 바 (회원가입과 동일) ---------- */
.logo-bar {
  padding: 4px 24px;
  border-bottom: 1.5px solid var(--line);
}
.logo { display: inline-block; text-decoration: none; }
.logo img { display: block; height: 80px; }

/* ---------- 로그인 박스 ---------- */
.login-wrap {
  display: flex;
  justify-content: center;
  padding: 60px;
}

.container {
  width: 340px;
  padding: 14px;
  background: #fff;
  border: 1.5px solid var(--line);
  border-radius: 6px;
}

.container .title {
  margin-bottom: 16px;
  text-align: center;
  font-weight: 700;
  color: var(--accent);
}

.fields {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.fields input {
  width: 100%;
  height: 36px;
  padding: 8px 10px;
  border: 1.5px solid var(--line);
  border-radius: 4px;
  font-size: 12px;
  color: var(--text);
  background: #fff;
  outline: none;
}
.fields input::placeholder { color: var(--text-dim); }
.fields input:focus { border-color: var(--accent); }

/* 로그인 버튼 (검정) */
.login-btn {
  width: 100%;
  height: 36px;
  border: 1.5px solid var(--accent);
  border-radius: 4px;
  background: var(--accent);
  color: #fff;
  font-size: 12.5px;
  cursor: pointer;
}
.login-btn:hover { background: #000; }

/* 회원가입 버튼 (흰 배경 테두리형) */
.sub-btn {
  width: 100%;
  height: 36px;
  border: 1.5px solid var(--line-strong);
  border-radius: 4px;
  background: #fff;
  color: var(--accent);
  font-size: 12.5px;
  cursor: pointer;
}
.sub-btn:hover { background: var(--fill); }

.sub-links {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 6px;
  font-size: 11.5px;
  color: var(--text-dim);
}
.sub-links a { color: inherit; text-decoration: none; }
.sub-links a:hover { color: var(--accent); text-decoration: underline; }
.msg {
  font-size: 11.5px;
  text-align: center;
  color: #b91c1c;
}
</style>


<body>
	
	<div class="logo-bar">
	<a class="logo" href="/"><img src="/images/logo.png" alt="짠내맵"></a>
	</div>
	
	<form action ="/member/login" method="post">
	<div class="login-wrap">
	<div class = "container">
	<div class ="title" > 로그인 </div>
	<div class = "fields">
	<input name = "id" type ="text" placeholder="아이디"> 
	<input name = "pw" type ="password" placeholder=" 비밀번호">
	<div class="msg">${msg}</div> 
	<button class = "login-btn"> 로그인 </button>
	<button type ="button"  class="sub-btn" onclick="location.href='/member/sign'"> 회원가입 </button> 
	<div class ="sub-links">
	<a href="#" onclick="window.open('/member/findid', 'findPopup', 'width=420,height=520'); return false;">아이디 찾기</a>
	<a href="#" onclick="window.open('/member/findpw', 'findPopup', 'width=420,height=520'); return false;">비밀번호 찾기</a>

	</div>
	</div>
	</div>
	</div>
	</form>			
</body>
</html>