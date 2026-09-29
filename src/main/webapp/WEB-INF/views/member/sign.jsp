<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
   <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>짠내맵 회원가입</title>
 <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
 <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<style>
:root {
  --line: #9ca3af;
  --line-strong: #4b5563;
  --fill: #f3f4f6;
  --fill-strong: #e5e7eb;
  --text: #374151;
  --text-dim: #9ca3af;
  --note: #2563eb;
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

/* ---------- 상단 로고 바 ---------- */
.logo-bar {
  padding: 14px 24px;
  border-bottom: 1.5px solid var(--line);
}
.logo {
  display: inline-block;
  padding: 4px 10px;
  border: 1.5px solid var(--line-strong);
  border-radius: 4px;
  font-size: 15px;
  font-weight: 700;
  color: var(--accent);
  text-decoration: none;
}
.logo:has(img) { padding: 0; border: none; }   /* 이미지로 바꾸면 테두리 제거 */
.logo img { display: block; height: 28px; }

/* ---------- 전체 폭 + 좌우 배치 ---------- */
.wrap { width: 640px; margin: 36px auto 44px; }
.layout { display: flex; align-items: flex-start; gap: 24px; }

/* ---------- 단계 표시 ---------- */
.steps {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 28px;
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

/* ---------- 폼 박스 ---------- */
.container {
  flex: 1;
  min-width: 0;
  padding: 24px;
  background: #fff;
  border: 1.5px solid var(--line);
  border-radius: 6px;
}

/* 필드 라벨 (아이디, 비밀번호 ...) */
.container > div {
  margin: 14px 0 5px;
  font-size: 12px;
  color: var(--text);
}
.req { color: #b91c1c; }

/* 섹션 제목 (계정 정보 / 개인 정보) */
.container > .section-label {
  margin: 0 0 8px;
  font-size: 10px;
  letter-spacing: .4px;
  color: var(--text-dim);
}

/* 섹션 구분선 */
.container > .divider {
  height: 1px;
  margin: 18px 0;
  background: var(--fill-strong);
}

/* 입력창 */
input[type="text"],
input[type="password"] {
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
input::placeholder { color: var(--text-dim); }
input[type="text"]:focus,
input[type="password"]:focus { border-color: var(--accent); }

/* 입력창 + 버튼 한 줄 (중복확인, 우편번호 검색) */
.container > .with-btn { display: flex; gap: 8px; margin: 0; }
.with-btn input { flex: 1; min-width: 0; }
.with-btn button { flex: none; width: 100px; padding: 0; }

/* 버튼 공통 */
button {
  height: 36px;
  padding: 0 16px;
  border: 1.5px solid var(--line-strong);
  border-radius: 4px;
  background: #fff;
  color: var(--accent);
  font-size: 12.5px;
  cursor: pointer;
}
button:hover { background: var(--fill); }

/* 안내 문구 (파란 이탤릭) */
#idcheck, #pwcheck, #namecheck {
  margin: 4px 0 0;
  font-size: 10.5px;
  font-style: italic;
  color: var(--note);
}
#idcheck.error, #pwcheck.error, #namecheck.error { color: #b91c1c; }

/* 성별 칩 */
.container > .gender { margin: 0; }
.gender label {
  display: inline-block;
  margin-right: 6px;
  cursor: pointer;
}
.gender input[type="radio"] { display: none; }
.gender label span {
  display: inline-block;
  padding: 4px 12px;
  border: 1.2px solid var(--line);
  border-radius: 14px;
  font-size: 11px;
  background: #fff;
}
.gender input[type="radio"]:checked + span {
  background: var(--accent);
  border-color: var(--accent);
  color: #fff;
}

/* ---------- 하단 버튼 (이전 / 가입하기) : container 안 ---------- */
.container > .btn-area {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin: 24px 0 0;
}
.btn-area button:first-child { width: 140px; }
.btn-area button:last-child {
  width: 220px;
  background: var(--accent);
  border-color: var(--accent);
  color: #fff;
}

.agree { display: block; cursor: pointer; }
.agree input { display: none; }
.agree span::before { content: "○ "; }
.agree input:checked + span { color: var(--accent); font-weight: 700; }
.agree input:checked + span::before { content: "✓ "; }
.btn-area button:last-child:hover { background: #000; }

/* ---------- 우측 패널 ---------- */
.side {
  flex: none;
  width: 200px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.side-box {
  padding: 14px;
  border: 1.5px solid var(--line);
  border-radius: 6px;
  font-size: 11px;
  line-height: 1.6;
  color: var(--text-dim);
}
.side-box.fill { background: var(--fill); }
.side-box .title { margin-bottom: 8px; font-size: 10px; }
.side-box .list { font-size: 11.5px; line-height: 1.8; }
.side-box b { color: var(--text); }
.side-box a {
  display: inline-block;
  margin-top: 8px;
  color: var(--note);
  text-decoration: underline;
}
.logo-bar {
  padding: 4px 24px;          /* 기존 14px 24px → 위아래를 최소로 */
}
.logo img { display: block; height: 80px; }   /* 원하는 크기 */

.wrap { margin: 16px auto 32px; }             /* 기존 36px auto 44px → 위쪽 여백 줄이기 */
.steps { margin-bottom: 18px; }  
	</style>
</head>
<body>
	<div class = "logo-bar">
	<a class="logo" href ="/"> <img src = "/images/logo.png"> </a>
	</div>
	<form action = "/member/signup" method = "post" onsubmit = "return signupCheck()">
	<div class="wrap">
    <div class="steps">
    <div class="step on"><span class="num">1</span><span>약관 동의</span></div>
    <div class="bar"></div>
    <div class="step on"><span class="num">2</span><span>정보 입력</span></div>
    <div class="bar"></div>
    <div class="step"><span class="num">3</span><span>가입 완료</span></div>
    </div>

    <div class="layout">	
	<div class ="container">
	<div class = "section-label"> 계정정보 </div>
	<div> 아이디 <span class="req">*</span></div>
	<div class="with-btn">
	<input id = "id" name="id" type ="text" placeholder ="4~16자 영문/숫자"> 
	<button id = "btnidcheck" type ="button"> 중복확인 </button>
	</div>
	<div id ="idcheck"> </div>
	
	<div> 비밀번호 <span class="req">*</span></div>
	<input id = "pw" name ="pw" type ="password" placeholder = "영문/숫자/특수문자 조합 8~16자">
	<div> 비밀번호 확인 <span class="req">*</span></div>
	<input id  = "pw1" name ="pw1" type = "password" placeholder = "비밀번호 재입력">
	<div id = "pwcheck">  </div>
	<div> 닉네임 <span class="req">*</span></div>
	<div class ="with-btn">
	<input id = "username" name ="username" type = "text" placeholder = "다른 회원에게 보여질 이름"> 
	<button id = "btnnamecheck" type ="button"> 중복확인</button>
	</div>
	<div id = "namecheck">  </div>
	<div class ="divider"> </div>
	
	<div class ="section-label"> 개인 정보</div>
	<div> 이름 <span class="req">*</span></div>
	<input name ="name" type ="text" placeholder ="실명 입력">
	<div> 휴대전화 <span class="req">*</span></div>
	<input name = "phone" type = "text"  placeholder = "숫자만 입력">
	<div> 이메일 <span class="req">*</span></div>
	<input name = "email" type ="text" placeholder ="example@email.com">
	<div> 주소 <span class="req">*</span></div>
	<div class ="with-btn">
	<input id = "zipcode" name = "zipcode" type = "text" placeholder = "우편번호 검색">
	<button type = "button" id ="search"> 검색 </button>
	</div>
	<div> 기본주소 <span class="req">*</span></div>
	<input id = "address1" name ="address1" type ="text" placeholder = "기본주소 ">
	<div> 상세주소 <span class="req">*</span></div>
	<input id = "address2" name ="address2" type = "text" placeholder = "상세주소 ">
	<div> 생년월일 <span class="req">*</span></div>
	<input name ="birth_date" type = "text" placeholder ="YYYY-MM-DD">
	<div> 성별</div>
	<div class="gender">
    <label>
        <input name = "gender" type="radio"  value="M">
        <span>남성</span>
    </label>

    <label>
        <input name = "gender" type="radio"  value="F">
        <span>여성</span>
    </label> 
   
    </div>
	 <div class ="btn-area">
    <button type ="button"> 이전</button> 
    <button> 가입하기 </button>
    </div> 
	</div>
	<div class="side">
    <div class="side-box fill">
    <div class="title">약관 동의 현황</div>
    <div class="list">
  <label class="agree"><input type="checkbox" class="agree-req"><span>이용약관 동의 (필수)</span></label>
  <label class="agree"><input type="checkbox" class="agree-req"><span>개인정보 수집·이용 동의 (필수)</span></label>
  <label class="agree"><input type="checkbox" class="agree-req"><span>만 14세 이상 (필수)</span></label>
  <label class="agree"><input type="checkbox"><span>마케팅 정보 수신 (선택)</span></label>
</div>
    <a href="#">이전 단계로</a>
    </div>
    <div class="side-box">
    모든 <b>*</b> 항목은 필수 입력이며, 아이디·닉네임 중복확인을 완료해야 가입하기 버튼이 활성화됩니다.
    </div>
    </div>
	</div>
    </div>
</form>	
	
	
	<script>
	// ========== 요소 가져오기 ==========
	let id           = document.getElementById("id");
	let idcheck      = document.getElementById("idcheck");
	let btnidcheck   = document.getElementById("btnidcheck");

	let pw           = document.getElementById("pw");
	let pw1          = document.getElementById("pw1");
	let pwcheck      = document.getElementById("pwcheck");

	let username     = document.getElementById("username");
	let namecheck    = document.getElementById("namecheck");
	let btnnamecheck = document.getElementById("btnnamecheck");

	let zipcode      = document.getElementById("zipcode");
	let address1     = document.getElementById("address1");
	let address2     = document.getElementById("address2");

	// ========== 정규식 (placeholder 기준) ==========
	const reg = {
	    id       : /^[A-Za-z0-9]{4,16}$/,                       // 4~16자 영문/숫자
	    pw       : /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!-\/:-@\[-`{-~])[A-Za-z\d!-\/:-@\[-`{-~]{8,16}$/,  // 영문+숫자+특수문자 8~16자
	    username : /^[가-힣A-Za-z0-9]{2,10}$/,                   // 2~10자 한글/영문/숫자 (임의 규칙)
	    name     : /^([가-힣]{2,10}|[A-Za-z][A-Za-z ]{1,29})$/,   // 한글 2~10자 또는 영문
	    phone    : /^01[016789]\d{7,8}$/,                       // 숫자만
	    email    : /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
	    birth    : /^(19|20)\d{2}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/   // YYYY-MM-DD
	};

	// 없는 날짜(2월 30일)와 미래 날짜 걸러내기
	function validBirth(v) {
	    if(!reg.birth.test(v)) return false;
	    const [y, m, d] = v.split("-").map(Number);
	    const dt = new Date(y, m - 1, d);
	    return dt.getFullYear() === y && dt.getMonth() === m - 1 && dt.getDate() === d && dt <= new Date();
	}

	// ========== 우편번호 검색 ==========
	document.getElementById("search").onclick = function () {
	    new kakao.Postcode({
	        oncomplete: function (data) {
	            zipcode.value  = data.zonecode;
	            address1.value = data.userSelectedType === "R" ? data.roadAddress : data.jibunAddress;
	            address2.focus();
	        }
	    }).open();
	}

	// ========== 아이디 중복확인 ==========
	btnidcheck.onclick = function() {
	    if(!reg.id.test(id.value)) {
	        idcheck.innerHTML = "4~16자 영문/숫자로 입력해 주세요.";
	        idcheck.classList.add("error");
	        return;
	    }
	    $.ajax({
	        url : "${pageContext.request.contextPath}/member/ajax/sign",
	        data : { id : id.value },
	        dataType : "json"
	    }).done(function(resp) {
	        if(resp) {
	            idcheck.innerHTML = "이미 사용 중인 아이디 입니다.";
	            idcheck.classList.add("error");
	            id.setAttribute("check", "false");
	        } else {
	            idcheck.innerHTML = "사용 가능한 아이디 입니다.";
	            idcheck.classList.remove("error");
	            id.setAttribute("check", "true");
	        }
	    }).fail(function(xhr) {
	        console.log(xhr.status, xhr.responseText);
	        alert("중복확인 실패 (상태 코드: " + xhr.status + ")");
	    });
	}

	// 확인 후 아이디를 바꾸면 다시 검사하도록 초기화
	id.oninput = function() {
	    id.setAttribute("check", "false");
	    idcheck.innerHTML = "";
	    idcheck.classList.remove("error");
	}

	// ========== 닉네임 중복확인 ==========
	btnnamecheck.onclick = function() {
	    if(!reg.username.test(username.value)) {
	        namecheck.innerHTML = "2~10자 한글/영문/숫자로 입력해 주세요.";
	        namecheck.classList.add("error");
	        return;
	    }
	    $.ajax({
	        url : "${pageContext.request.contextPath}/member/ajax/nickname",
	        data : { username : username.value },
	        dataType : "json"
	    }).done(function(resp) {
	        if(resp) {
	            namecheck.innerHTML = "이미 사용 중인 닉네임 입니다.";
	            namecheck.classList.add("error");
	            username.setAttribute("check", "false");
	        } else {
	            namecheck.innerHTML = "사용 가능한 닉네임 입니다.";
	            namecheck.classList.remove("error");
	            username.setAttribute("check", "true");
	        }
	    }).fail(function(xhr) {
	        console.log(xhr.status, xhr.responseText);
	        alert("중복확인 실패 (상태 코드: " + xhr.status + ")");
	    });
	}

	username.oninput = function() {
	    username.setAttribute("check", "false");
	    namecheck.innerHTML = "";
	    namecheck.classList.remove("error");
	}

	// ========== 비밀번호 실시간 검사 ==========
	function checkPw() {
	    if(pw.value === "" && pw1.value === "") {
	        pwcheck.innerHTML = "";
	        pwcheck.classList.remove("error");
	        return;
	    }
	    if(!reg.pw.test(pw.value)) {
	        pwcheck.innerHTML = "영문/숫자/특수문자 조합 8~16자로 입력해 주세요.";
	        pwcheck.classList.add("error");
	    } else if(pw1.value === "") {
	        pwcheck.innerHTML = "";
	        pwcheck.classList.remove("error");
	    } else if(pw.value === pw1.value) {
	        pwcheck.innerHTML = "비밀번호 일치";
	        pwcheck.classList.remove("error");
	    } else {
	        pwcheck.innerHTML = "비밀번호를 확인하여 주십시오.";
	        pwcheck.classList.add("error");
	    }
	}
	pw.onkeyup  = checkPw;
	pw1.onkeyup = checkPw;

	// ========== 제출 검사 ==========
	function fail(input, msg) {
	    alert(msg);
	    input.focus();
	    return false;
	}

	function signupCheck() {
		 if(document.querySelectorAll(".agree-req:not(:checked)").length > 0) {
		        alert("필수 약관에 모두 동의해 주세요.");
		        return false;
		    }
	
	    if(id.getAttribute("check") !== "true")
	        return fail(id, "아이디 중복검사를 해주세요.");

	    if(!reg.pw.test(pw.value))
	        return fail(pw, "비밀번호는 영문/숫자/특수문자 조합 8~16자로 입력해 주세요.");

	    if(pw.value !== pw1.value)
	        return fail(pw1, "비밀번호가 일치하지 않습니다.");

	    if(username.getAttribute("check") !== "true")
	        return fail(username, "닉네임 중복검사를 해주세요.");

	    let nameInput  = document.querySelector("[name='name']");
	    let phoneInput = document.querySelector("[name='phone']");
	    let emailInput = document.querySelector("[name='email']");
	    let birthInput = document.querySelector("[name='birth_date']");

	    if(!reg.name.test(nameInput.value.trim()))
	        return fail(nameInput, "이름을 정확히 입력해 주세요.");

	    if(!reg.phone.test(phoneInput.value))
	        return fail(phoneInput, "휴대전화는 숫자만 입력해 주세요. (예: 01012345678)");

	    if(!reg.email.test(emailInput.value))
	        return fail(emailInput, "이메일 형식이 올바르지 않습니다.");

	    if(zipcode.value === "" || address1.value === "")
	        return fail(document.getElementById("search"), "우편번호 검색으로 주소를 입력해 주세요.");

	    if(address2.value.trim() === "")
	        return fail(address2, "상세주소를 입력해 주세요.");

	    if(!validBirth(birthInput.value))
	        return fail(birthInput, "생년월일을 YYYY-MM-DD 형식으로 정확히 입력해 주세요.");
				
	    return true;
	}
	</script>
	
</body>
</html>