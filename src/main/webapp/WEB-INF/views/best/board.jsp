<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 베스트 게시글 </title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	
<style>
* { box-sizing: border-box; }

.container { width: 1200px; max-width: calc(100% - 40px); margin: auto; font-family: "Noto Sans KR", "Malgun Gothic", Arial, sans-serif; color: #1c2535; background: #fff; padding: 25px 0 50px; }
a { text-decoration: none; color: inherit; }
.page-title { margin: 0 0 6px; font-size: 22px; font-weight: 700; color: #1c2535; }
.page-sub { margin: 0 0 28px; font-size: 13px; color: #8995a9; }

/* ===== TOP 3 시상대 (1~3위 모두 스포트라이트) ===== */
.sec-label { margin: 0 0 14px; font-size: 13px; font-weight: bold; color: #5a6678; }
.podium { display: flex; justify-content: center; align-items: flex-end; gap: 34px; margin: 0 auto 44px; padding-top: 34px; max-width: 780px; border-bottom: 2px solid #1c2535; }
.pod { width: 220px; text-align: center; }
.pod1 { order: 2; transform: scale(1.1); transform-origin: bottom center; }   /* 1등: 가운데, 살짝 크게 */
.pod2 { order: 1; }   /* 2등: 왼쪽 */
.pod3 { order: 3; }   /* 3등: 오른쪽 */

.crown { width: 34px; height: 34px; margin: 0 auto 8px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 17px; border: 1.5px solid #9ca3af; }
.pod1 .crown { background: #d4af37; border-color: #a8841f; }
.pod2 .crown { background: #c0c0c0; }
.pod3 .crown { background: #cd7f32; border-color: #a8641f; }

.pod-card { display: block; padding: 14px 12px; margin-bottom: 8px; background: #fff; border-radius: 10px; transition: transform .15s, box-shadow .15s; }
.pod-card::before { display: block; margin-bottom: 6px; font-size: 10px; font-weight: 800; letter-spacing: 3px; }
.pod1 .pod-card { border: 2px solid #d4af37; box-shadow: 0 0 0 5px rgba(212, 175, 55, .16), 0 12px 30px rgba(28, 37, 53, .14); }
.pod2 .pod-card { border: 2px solid #aeb4bd; box-shadow: 0 0 0 5px rgba(174, 180, 189, .22), 0 10px 24px rgba(28, 37, 53, .10); }
.pod3 .pod-card { border: 2px solid #cd7f32; box-shadow: 0 0 0 5px rgba(205, 127, 50, .16), 0 10px 24px rgba(28, 37, 53, .10); }
.pod-card:hover { transform: translateY(-4px); }
.pod1 .pod-card:hover { box-shadow: 0 0 0 5px rgba(212, 175, 55, .28), 0 18px 36px rgba(28, 37, 53, .20); }
.pod2 .pod-card:hover { box-shadow: 0 0 0 5px rgba(174, 180, 189, .34), 0 16px 30px rgba(28, 37, 53, .16); }
.pod3 .pod-card:hover { box-shadow: 0 0 0 5px rgba(205, 127, 50, .28), 0 16px 30px rgba(28, 37, 53, .16); }
.pod1 .pod-card::before { content: 'BEST 1'; color: #a8841f; }
.pod2 .pod-card::before { content: 'BEST 2'; color: #7b8089; }
.pod3 .pod-card::before { content: 'BEST 3'; color: #a8641f; }
.pod-title { font-size: 14px; font-weight: bold; line-height: 1.4; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
.pod-writer { margin-top: 8px; font-size: 12px; color: #8995a9; }
.pod-like { margin-top: 6px; font-size: 13px; font-weight: bold; color: #e91717; }

/* 막대: 금 · 은 · 동 + 광택 */
.stand { position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center; font-size: 26px; font-weight: 800; border-radius: 6px 6px 0 0; box-shadow: 0 8px 14px rgba(28, 37, 53, .10); }
.stand::after { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 42%; background: linear-gradient(180deg, rgba(255, 255, 255, .65), rgba(255, 255, 255, 0)); }
.pod1 .stand { height: 120px; font-size: 32px; background: linear-gradient(180deg, #f7e9ae, #e2c660); color: #6b5200; }
.pod2 .stand { height: 84px; background: linear-gradient(180deg, #eceff3, #c9ced6); color: #5d636d; }
.pod3 .stand { height: 56px; background: linear-gradient(180deg, #f0d4b5, #d9a36c); color: #7a4a14; }

/* ===== 4~10위 목록 (카드 한 줄씩 + 빨간 포인트 바) ===== */
.box { max-width: 760px; margin: 0 auto; }
.rank-row { display: flex; align-items: center; gap: 14px; padding: 0 18px; height: 56px; margin-bottom: 10px; background: #fff; border: 1px solid #d5dce7; border-left: 5px solid #c0392b; border-radius: 12px; box-shadow: 0 2px 8px rgba(28, 37, 53, .05); transition: transform .15s, box-shadow .15s; }
.rank-row:hover { transform: translateY(-2px); box-shadow: 0 8px 18px rgba(28, 37, 53, .10); }
.rank-no { width: 26px; font-size: 16px; font-weight: 700; color: #c0392b; text-align: center; flex-shrink: 0; }
.rank-cat { width: 44px; font-size: 12px; color: #2457d6; text-align: center; }
.rank-title { flex: 1; font-size: 14px; color: #1c2535; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.rank-reply { font-size: 12px; font-weight: bold; color: #2457d6; margin-left: 6px; }
.rank-writer { width: 90px; font-size: 12px; color: #8995a9; text-align: right; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.rank-like { width: 62px; padding: 4px 0; background: #fff0f0; border-radius: 999px; font-size: 13px; font-weight: bold; color: #e91717; text-align: center; }

.empty { padding: 60px 0; text-align: center; color: #8995a9; font-size: 14px; }
.back { display: block; width: 120px; margin: 30px auto 0; padding: 9px 0; text-align: center; border: 2px solid #1c2535; border-radius: 8px; box-shadow: 2px 2px 0 #1c2535; font-size: 13px; color: #1c2535; }
.back:hover { background: #f3f5f9; }

/* ===== (선택) 라벨 알약 배지 : 쓰기 싫으면 이 블록 전체를 지우세요 ===== */
.pod-card::before { display: inline-block; padding: 3px 12px; margin-bottom: 8px; border-radius: 999px; color: #fff !important; letter-spacing: 2px; }
.pod1 .pod-card::before { background: #d4af37; }
.pod2 .pod-card::before { background: #9aa1ac; }
.pod3 .pod-card::before { background: #cd7f32; }

</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<div class = "container">
	<h2 class ="page-title"> 베스트 게시글 </h2>
	<p class = "page-sub"> 자유게시판에서 추천을 가장 많이 받은 글 TOP 10 </p>
	
	<c:choose>
		<c:when test="${empty list }">
		<div class ="empty"> 아직 추천을 받은 글이 없어요. </div>
		</c:when>
		
		<c:otherwise>
		
		<div class ="sec-label"> TOP 3</div>
		<div class ="podium">
		<c:forEach var = "m" items ="${top3 }">
		<div class ="pod pod${m.rn}">
		<div class = "crown">👑 </div>
		<a class = "pod-card" href = "/FreeBoard/detail?postId=${m.postId }&cpage=1">
		<div class = "pod-title"> ${m.title }</div>
		<div class ="pod-writer"> ${m.username }</div>
		<div class = "pod-like">♥ 추천 ${m.likeCount } </div>
		</a>
				<div class ="stand">${m.rn}</div>
		</div>
		</c:forEach>
		</div>
		
		<c:if test="${rest.size()>0}">
		<div class="sec-label" style="max-width:760px; margin:0 auto 12px;">4 ~ 10위</div>
		<div class = "box">
		<c:forEach var ="m" items ="${rest }">
		<a class="rank-row" href="/FreeBoard/detail?postId=${m.postId}&cpage=1">
		<span class ="rank-no">${m.rn }</span>
		<span class ="rank-cat">${m.category }</span>
		<span class="rank-title">${m.title}<c:if test="${m.replyCount > 0}"><span class="rank-reply">[${m.replyCount}]</span></c:if></span>
		<span class = "rank-writer">${m.username }</span>
		<span class="rank-like">♥ ${m.likeCount}</span>
		</a>
		</c:forEach>
		</div>
		
		</c:if>

		</c:otherwise>
	</c:choose>
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>