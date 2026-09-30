<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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

.label {
  margin-bottom: 4px;
  font-size: 11px;
  color: var(--text-dim);
}

/* 값 표시 칸 (input과 일반 글자 모두 같은 모양) */
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

/* 회원 탈퇴 */
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

	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class ="wrap">	
	<div class = "layout">
	<div class="left">  
	<div class = "box profile">
	<div class="avatar"><i class="fa-solid fa-circle-user"></i></div>
	<div class="nickname">${member.username}</div>
	</div>
	<div class ="box menu"> 
	<a href ="/member/mypage"  class= "active"> 내 정보</a>
	<a href ="/member/edit" > 개인정보 수정 </a>
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
	<input type ="text" value = "${member.name}" readonly>
	</div>
	<div class ="field">
	<div class ="label"> 휴대전화</div>
	<input type ="text" value = "${member.phone}" readonly>
	</div>
	<div class ="field">
	<div class ="label"> 이메일 </div>
	<input type ="text" value = "${member.email}" readonly>
	</div>
	
	<div class ="field"> 
	<div class = "label">주소</div>
	<input type ="text" value = "${member.address1} ${member.address2 }" title = "${member.address1} ${member.address2 }" readonly>
	</div>
	<div class ="field">
	<div class ="label"> 생년월일</div>
	<input type ="text" value = "${member.birth_date}" readonly>
	</div>
	<div class ="field">
	<div class ="label"> 성별 </div>
	<input type ="text" value = "${member.gender}"  readonly>
	</div>
	<div class ="field">
	<div class ="label"> 가입일자</div>
	<span class="value"><fmt:formatDate value="${member.regdate}" pattern="yyyy.MM.dd"/></span>
	</div>
	</div>
	<div class ="bottom">
	<a class="leave"
	onclick="if(confirm('정말 탈퇴하시겠습니까?')) location.href='/member/leave'">회원 탈퇴</a>
	</div>
	</div>		
	</div>
	</div>
	
	
</body>
</html>