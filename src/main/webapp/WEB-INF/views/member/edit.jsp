<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 짠내맵 개인정보 수정 </title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>  
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">


<Style>
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

/* ---------- 상단 로고 바 ---------- */
.logo-bar {
  padding: 4px 24px;
  border-bottom: 1.5px solid var(--line);
}
.logo { display: inline-block; text-decoration: none; }
.logo img { display: block; height: 80px; }

/* ---------- 전체 영역 ---------- */
.wrap { width: 1100px; margin: 24px auto 40px; }
.layout { display: flex; align-items: flex-start; gap: 20px; }

/* ---------- 왼쪽 ---------- */
.left {
  flex: none;
  width: 200px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.box {
  border: 1.5px solid var(--line);
  border-radius: 6px;
  background: #fff;
}

/* 프로필 카드 */
.profile {
  padding: 20px 14px;
  text-align: center;
}
.avatar {
  width: 64px;
  height: 64px;
  margin: 0 auto 10px;
}
.avatar i {
  display: block;
  font-size: 64px;
  line-height: 64px;
  color: var(--line-strong);
}
.nickname {
  font-size: 14px;
  font-weight: 700;
  color: var(--accent);
}

/* 세로 메뉴 */
.menu a {
  display: block;
  padding: 11px 14px;
  border-left: 2px solid transparent;
  font-size: 12.5px;
  color: var(--text-dim);
  text-decoration: none;
}
.menu a:hover { background: var(--fill); }
.menu a.active {
  border-left-color: var(--accent);
  font-weight: 700;
  color: var(--accent);
}

/* ---------- 오른쪽 ---------- */
.right {
  flex: 1;
  min-width: 0;
  min-height: 320px;
  padding: 24px;
  display: flex;
  flex-direction: column;
}

.section-label {
  margin-bottom: 16px;
  font-size: 11px;
  letter-spacing: .4px;
  color: var(--text-dim);
}

/* 내 정보 항목 (4열) */
.fields {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 22px 24px;
}
.span2 { grid-column: span 2; }                       /* ★ 추가 */

.label {
  margin-bottom: 4px;
  font-size: 11px;
  color: var(--text-dim);
}

/* 수정 불가 칸 (회색) */
.value,
input[readonly] {
  display: block;
  width: 100%;
  height: 36px;
  padding: 8px 10px;
  border: 1.5px solid var(--line);
  border-radius: 4px;
  background: var(--fill);
  font-family: inherit;
  font-size: 12.5px;
  line-height: 18px;
  color: var(--text);
  outline: none;
  cursor: default;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}

/* ★ 추가: 수정 가능 칸 (흰색) */
input:not([readonly]) {
  display: block;
  width: 100%;
  height: 36px;
  padding: 8px 10px;
  border: 1.5px solid var(--line-strong);
  border-radius: 4px;
  background: #fff;
  font-family: inherit;
  font-size: 12.5px;
  line-height: 18px;
  color: var(--text);
  outline: none;
}
input:not([readonly]):focus { border-color: var(--accent); }

/* ★ 추가: input + 버튼 한 줄 */
.row { display: flex; gap: 6px; margin-bottom: 6px; }
.row input { flex: 1; min-width: 0; width: auto; }

/* ★ 추가: 버튼 */
.btn {
  height: 36px;
  padding: 0 14px;
  border: 1.5px solid var(--line-strong);
  border-radius: 4px;
  background: #fff;
  font-family: inherit;
  font-size: 12.5px;
  color: var(--text);
  cursor: pointer;
  white-space: nowrap;
}
.btn.primary { background: var(--accent); border-color: var(--accent); color: #fff; }

/* ★ 추가: 안내 메시지 */
.msg { margin-top: 4px; font-size: 11px; color: #2563eb; min-height: 14px; }
.msg.error { color: #b91c1c; }

/* ★ 추가: 저장/취소 버튼 줄 */
.btn-row {
  margin-top: auto;
  padding-top: 24px;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}

/* 회원 탈퇴 (이 화면에서는 안 쓰지만 둬도 됨) */
.bottom {
  margin-top: auto;
  padding-top: 24px;
  text-align: right;
}
.leave {
  font-size: 11px;
  color: #b91c1c;
  text-decoration: underline;
  cursor: pointer;
}
</Style>


</head>	
<body>

	<form id="editForm" action="/member/update" method="post" onsubmit="return editCheck()">   
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class ="wrap">	
	<div class = "layout">
	<div class="left">  
	<div class = "box profile">
	<div class="avatar"><i class="fa-solid fa-circle-user"></i></div>
	<div class="nickname">${member.username}</div>
	</div>
	<div class ="box menu"> 
	<a href ="/member/mypage"  > 내 정보</a>
	<a href ="/member/edit" class= "active"> 개인정보 수정 </a>
	<a href ="#" > 북마크 </a>
	<a href ="#" > 내가 쓴 글 </a>
	<a href ="#" > 참여 기록 </a>
	</div>
	 </div> 
	<div class="box right"> 
	<div class= "section-label"> 내 정보 </div>
	<div class = "fields">
	<div class ="field">
	<div class ="label"> 아이디 </div>
	<input type ="text" value = "${member.id}" readonly>
	</div>
	<div class ="field">
	<div class ="label"> 이름 </div>
	<input id ="name" name ="name" type ="text" value = "${member.name}" >
	</div>
	<div class ="field">
	<div class ="label"> 휴대전화</div>
	<input id="phone" name = "phone" type ="text" value = "${member.phone}" >
	</div>
	<div class ="field">
	<div class ="label"> 이메일 </div>
	<input id="email" name ="email" type ="text" value = "${member.email}" >
	</div>
	
	<div class="field span2">
   	<div class="label"> 주소 </div>
	<div class="row">
	<input type="text" id="zipcode" name="zipcode" value="${member.zipcode}" readonly>
	<button type="button" class="btn" id="search">우편번호 검색</button>
	</div>
	<div class="row">
	<input type="text" id="address1" name="address1" value="${member.address1}" readonly>
	</div>
	<div class="row">
	<input type="text" id="address2" name="address2" value="${member.address2}" placeholder="상세주소">
	</div>
	</div>
	
	<div class ="field">
	<div class ="label"> 생년월일</div>
	<fmt:formatDate value="${member.birth_date}" pattern="yyyy-MM-dd" var="bd"/>
    <input id="birth" name="birth_date" type="text" value="${bd}" placeholder="YYYY-MM-DD">
	</div>
	<div class ="field">
	<div class ="label"> 성별 </div>
	<input type ="text" value = "${member.gender}"  readonly>
	</div>
	
	<div class="field span2">
	<div class="label"> 닉네임 </div>
	<div class="row">
	<input type="text" id="username" name="username" value="${member.username}" check="true">
	<button type="button" class="btn" id="btnnamecheck">중복확인</button>
	</div>
	<div class="msg" id="namecheck"></div>
	</div>

	<div class="field">
	<div class="label"> 새 비밀번호 <span style="color:var(--text-dim)">(변경 시에만 입력)</span></div>
	<input type="password" id="newPw" name="newPw" autocomplete="new-password">
	</div>

	<div class="field">
	<div class="label"> 새 비밀번호 확인 </div>
	<input type="password" id="newPw2" autocomplete="new-password">
	<div class="msg" id="pwmsg"></div>
	</div>
	
	<div class ="field">
	<div class ="label"> 가입일자</div>
	<span class="value"><fmt:formatDate value="${member.regdate}" pattern="yyyy.MM.dd"/></span>
	</div>
	</div>
	<div class ="btn-row">
	<button type="button" class="btn" onclick="location.href='/member/mypage'">취소</button>
	<button type="submit" class="btn primary">저장</button>
	</div>
	</div>		
	</div>
	</div>
	</form>
	
	<script>
	const origName = "${member.username}";
	const regName  = /^[가-힣A-Za-z0-9]{2,10}$/;
	const regPhone = /^01[016789]\d{7,8}$/;
	const regEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	const regBirth = /^\d{4}-\d{2}-\d{2}$/;
	const regPw    = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!-\/:-@\[-`{-~])[A-Za-z\d!-\/:-@\[-`{-~]{8,16}$/;
	
	
	$("#username").on("input", function() {
	    $("#namecheck").text("").removeClass("error");

	    const now = $(this).val().trim();      

	    if (now === origName) {                
	        $(this).attr("check", "true");     
	    } else {                               
	        $(this).attr("check", "false");    
	    }
	});
	
	$("#btnnamecheck").on("click",function(){
		const name = $("#username").val().trim();
		if(!regName.test(name)) {
		 $("#namecheck").text("닉네임은 2~10자 한글/영문/숫자만 가능합니다.").addClass("error");
		 return;
		} 
		if (name === origName) {
	        $("#namecheck").text("현재 사용 중인 닉네임입니다.").removeClass("error");
	        $("#username").attr("check", "true");
	        return;
	    }
		$.ajax({
			url : "/member/ajax/nickname",
			data : {username : name},
			dataType : "json"
		}).done(function(resp){
			if(resp) {
				$("#namecheck").text("이미 사용 중인 닉네임 입니다.").addClass("error");
				$("#username").attr("check","false");
			} else {
				$("#namecheck").text("사용 가능한 닉네임 입니다, ").removeClass("error");
				$("#username").attr("check","true");
				
			}
		});
	});
	
	
	$("#search").on("click", function() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            $("#zipcode").val(data.zonecode);
	            $("#address1").val(data.roadAddress);
	            $("#address2").focus();
	        }
	    }).open();
	});
	
	$("#newPw, #newPw2").on("input" , function (){
		const p1 = $("#newPw").val();
		const p2 = $("#newPw2").val();
		if(p1 === "" && p2 ===""){
		$("#pwmsg").text(""); return;	
		}
		if(!regPw.test(p1)) {
			$("#pwmsg").text("영문 , 숫자 , 특수문자 포함 8~16자").addClass("error");	
		} else if (p1 !== p2) {
			$("#pwmsg").text("비밀번호가 일치하지 않습니다.").addClass("error");	
		}else {
			$("#pwmsg").text("사용 가능한 비밀번호입니다.").removeClass("error");
		}
	
	});
	
	function editCheck() {
	    if ($("#name").val().trim() === "") { alert("이름을 입력해주세요."); return false; }
	    if (!regBirth.test($("#birth").val().trim())) { alert("생년월일은 YYYY-MM-DD 형식으로 입력해주세요."); return false; }
	    if (!regName.test($("#username").val().trim())) { alert("닉네임은 2~10자 한글/영문/숫자만 가능합니다."); return false; }
	    if ($("#username").attr("check") !== "true") { alert("닉네임 중복확인을 해주세요."); return false; }
	    if (!regPhone.test($("#phone").val().trim())) { alert("휴대전화 형식이 올바르지 않습니다."); return false; }
	    if (!regEmail.test($("#email").val().trim())) { alert("이메일 형식이 올바르지 않습니다."); return false; }
	    if ($("#zipcode").val() === "") { alert("주소를 입력해주세요."); return false; }

	    const p1 = $("#newPw").val();
	    const p2 = $("#newPw2").val();
	    if (p1 !== "" || p2 !== "") {
	        if (!regPw.test(p1)) { alert("비밀번호 형식이 올바르지 않습니다."); return false; }
	        if (p1 !== p2) { alert("비밀번호가 일치하지 않습니다."); return false; }
	    }
	    return true;
	}
	
	</script>
</body>
</html>