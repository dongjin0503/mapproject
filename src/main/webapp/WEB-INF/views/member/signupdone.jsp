<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>짠내맵 회원가입 완료</title>
<style>
:root {
  --line: #9ca3af;
  --line-strong: #4b5563;
  --fill: #f3f4f6;
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

/* ---------- 상단 로고 바 ---------- */
.logo-bar {
  padding: 4px 24px;
  border-bottom: 1.5px solid var(--line);
}
.logo { display: inline-block; text-decoration: none; }
.logo img { display: block; height: 80px; }

/* ---------- 전체 폭 ---------- */
.wrap { width: 640px; margin: 16px auto 32px; }

/* ---------- 단계 표시 ---------- */
.steps {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 18px;
}
.step {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 11.5px;
  color: var(--text-dim);
}
.step .num {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border: 1.5px solid var(--line);
  border-radius: 50%;
  font-size: 11px;
}
.step.on { font-weight: 700; color: var(--accent); }
.step.on .num { background: var(--accent); border-color: var(--accent); color: #fff; }
.steps .bar { width: 32px; height: 1.5px; background: var(--line); }

/* ---------- 완료 박스 ---------- */
.container {
  padding: 48px 24px;
  text-align: center;
  background: #fff;
  border: 1.5px solid var(--line);
  border-radius: 6px;
}

.check {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  margin: 0 auto 16px;
  border: 1.5px solid var(--accent);
  border-radius: 50%;
  background: var(--accent);
  font-size: 28px;
  color: #fff;
}

.title {
  margin-bottom: 8px;
  font-size: 18px;
  font-weight: 700;
  color: var(--accent);
}

.desc {
  margin-bottom: 28px;
  font-size: 12.5px;
  line-height: 1.7;
  color: var(--text-dim);
}

/* ---------- 버튼 ---------- */
.btn-area {
  display: flex;
  justify-content: center;
  gap: 10px;
}

button {
  height: 38px;
  border: 1.5px solid var(--line-strong);
  border-radius: 4px;
  background: #fff;
  font-family: inherit;
  font-size: 12.5px;
  color: var(--accent);
  cursor: pointer;
}
button:hover { background: var(--fill); }

.btn-area button { width: 160px; }

.btn-area .primary {
  border-color: var(--accent);
  background: var(--accent);
  color: #fff;
}
.btn-area .primary:hover { background: #000; }
</style>
</head>
<body>

	<div class="logo-bar">
		<a class="logo" href="/"><img src="/images/logo.png" alt="짠내맵"></a>
	</div>

	<div class="wrap">

		<div class="steps">
			<div class="step on"><span class="num">1</span><span>약관 동의</span></div>
			<div class="bar"></div>
			<div class="step on"><span class="num">2</span><span>정보 입력</span></div>
			<div class="bar"></div>
			<div class="step on"><span class="num">3</span><span>가입 완료</span></div>
		</div>

		<div class="container">
			<div class="check">✓</div>
			<div class="title">회원가입이 완료되었습니다</div>
			<div class="desc">
				짠내맵의 회원이 되신 것을 환영합니다.<br>
				로그인하고 다양한 서비스를 이용해 보세요.
			</div>

			<div class="btn-area">
				<button type="button" onclick="location.href='/'">홈으로</button>
				<button type="button" class="primary" onclick="location.href='/member/login'">로그인하기</button>
			</div>
		</div>

	</div>

</body>
</html>