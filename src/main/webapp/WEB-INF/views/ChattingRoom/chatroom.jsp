<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>party-chat</title>

<!-- STOMP -->
<script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.1.1/bundles/stomp.umd.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/WebAsset/FontAwesome@pro/css/all.min.css">
<style>
/* =========================
   채팅 전체
========================= */
.chat {
	width: 50%;
	height: 700px;
	margin: 50px auto;
	position: relative;
	display: flex;
	flex-direction: column;
	border: 1px solid #ddd;
	border-radius: 10px;
	background-color: white;
	box-shadow: 0 3px 15px rgba(0, 0, 0, 0.1);
}

/* =========================
   채팅 헤더
========================= */
.chatHeader {
	padding: 15px;
	box-sizing: border-box;
	border-bottom: 1px solid #ddd;
}

/* 제목 */
.chatHeader>span:first-child {
	font-weight: bold;
	font-size: 16px;
}

/* 인원 */
.chatHeader>span:nth-child(2) {
	color: #888;
	font-size: 13px;
	margin-left: 6px;
}

/* =========================
   햄버거 버튼
=========================*/
#hamburgerbtn {
	float: right;
	border: none;
	background: none;
	font-size: 20px;
	line-height: 1;
	cursor: pointer;
}

/* =========================
   참여자 사이드바
========================= */
#memberList {
    position: absolute;
    top: 0;
    left: 100%;
    width: 250px;
    height: 100%;
    padding: 20px;
    box-sizing: border-box;
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 0 10px 10px 0;
    box-shadow: 3px 0 10px rgba(0, 0, 0, 0.15);
    z-index: 10;

    display: block;
    visibility: hidden;
    opacity: 0;
    transform: translateX(-15px);

    transition:
        opacity 0.3s ease,
        transform 0.3s ease,
        visibility 0.3s ease;

    pointer-events: none;
}


/* 사이드바 열림 */
#memberList.active {
    visibility: visible;
    opacity: 1;
    transform: translateX(0);
    pointer-events: auto;
}

/* 참여자 한 명 */
#memberList div {
	padding: 8px;
	border-bottom: 1px solid #eee;
}

/* 채팅 나가기 버튼 */
#exitbtn {
    display: block;
    width: 100%;
    margin-top: 20px;
    padding: 10px 12px;
    background-color: #fff;
    color: #666;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    box-sizing: border-box;
}

/* 마우스 오버 */
#exitbtn:hover {
    background-color: #fef2f2;
    color: #dc2626;
    border-color: #fecaca;
}

/* 클릭 효과 */
#exitbtn:active {
    background-color: #fee2e2;
}
/* =========================
   검색창 (기본적으로 숨김)
========================= */

.searchMessage {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 0;
    max-height: 0;
    opacity: 0;
    overflow: hidden;
    visibility: hidden;
    transform: translateY(-8px);

    transition:
        max-height 0.35s ease,
        margin-top 0.35s ease,
        opacity 0.25s ease,
        transform 0.35s ease,
        visibility 0.35s ease;
}

/* 검색창 열림 */
.searchMessage.active {
    max-height: 50px;
    margin-top: 10px;
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
    overflow: visible;
}

/* 검색창 + 돋보기 아이콘 영역 */
.searchBox {
    position: relative;
    flex: 1;
    min-width: 0;
}

/* 검색 입력창 */
#searchText {
    display: block;
    width: 100%;
    height: 34px;
    padding: 6px 36px 6px 10px;
    box-sizing: border-box;
    border: 1px solid #ddd;
    border-radius: 6px;
    outline: none;
    font-size: 13px;
}

/* 검색창 포커스 */
#searchText:focus {
    border-color: #999;
}

/* 돋보기 버튼 */
#searchbtn {
    position: absolute;
    top: 50%;
    right: 8px;
    transform: translateY(-50%);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 4px;
    border: none;
    background: transparent;
    color: #777;
    font-size: 15px;
    cursor: pointer;
}

/* 돋보기 마우스 오버 */
#searchbtn:hover {
    color: #111827;
}

/* 전체보기 버튼 */
#allbtn {
    flex-shrink: 0;
    height: 34px;
    padding: 6px 10px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background: white;
    color: #333;
    font-size: 13px;
    cursor: pointer;
}

#allbtn:hover {
    background: #f3f4f6;
}

/* =========================
   채팅 내용
========================= */
.chatBody {
	flex: 1;
	overflow-y: auto;
	padding: 15px;
	box-sizing: border-box;
	background: #f3f4f6;
}

/* =========================
   입장 / 퇴장 메시지
========================= */
.enterMessage, .leaveMessage {
	text-align: center;
	color: gray;
	margin: 10px 0;
}

/* =========================
   내 메시지
========================= */
.myMessage {
	display: flex;
	flex-direction: row-reverse;
	align-items: flex-end;
	gap: 6px;
	margin: 10px 0;
}

/* 내 메시지 말풍선 */
.myMessage>div:nth-child(1) {
	max-width: 70%;
	padding: 8px 12px;
	background: #111827;
	color: white;
	border-radius: 12px 12px 0 12px;
	word-break: break-word;
	text-align: left;
}

/* 내 메시지 시간 */
.myMessage>div:nth-child(2) {
	font-size: 11px;
	color: #999;
}

/* =========================
   다른 사람 메시지
========================= */
.otherMessage {
	display: grid;
	grid-template-columns: minmax(0, max-content) max-content;
	column-gap: 6px;
	align-items: end;
	justify-content: start;
	max-width: 75%;
	margin: 10px 0;
}

/* 다른 사람 이름 */
.otherMessage>div:nth-child(1) {
	grid-column: 1/-1;
	font-size: 12px;
	color: #666;
	margin-bottom: 3px;
}

/* 다른 사람 말풍선 */
.otherMessage>div:nth-child(2) {
	padding: 8px 12px;
	background: white;
	border: 1px solid #ddd;
	border-radius: 0 12px 12px 12px;
	word-break: break-word;
}

/* 다른 사람 시간 */
.otherMessage>div:nth-child(3) {
	font-size: 11px;
	color: #999;
}

/* =========================
   메시지 입력 영역
========================= */
.chatBottom {
	display: flex;
	gap: 8px;
	padding: 12px;
	box-sizing: border-box;
	border-top: 1px solid #ddd;
}

/* 메시지 입력창 */
#message {
	flex: 1;
	height: 50px;
	resize: none;
	padding: 8px 10px;
	box-sizing: border-box;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-family: inherit;
}

/* 전송 버튼 */
#sendbtn {
	width: 70px;
	border: none;
	border-radius: 8px;
	background: #111827;
	color: white;
	font-weight: bold;
	cursor: pointer;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>


	<!-- 채팅방 -->
	<div class="chat">
		<div class="chatHeader">
			<span><c:out value="${partyTitle}" /></span>
			<span>${partyMember}<c:out value="${member}" /></span>
			<input type="button" id="hamburgerbtn" value="☰">
			<!-- 참여자목록, 채팅나가기버튼 -->
			<div id="memberList">
				<c:forEach var="member" items="${memberList}">
					<!-- 햄버거버튼 눌렀을 시 채팅참여자 닉네임 -->
					<div><i class="fa-solid fa-user"></i>  ${member}</div>
				</c:forEach>
				<input type="button" id="exitbtn" value="채팅 나가기">
			</div>

			<div class="searchMessage">
    			<div class="searchBox">
        			<input id="searchText" type="text" placeholder="내용 검색">
        			<button type="button" id="searchbtn" aria-label="검색">
            			<i class="fa-solid fa-magnifying-glass"></i>
        			</button>
    			</div>
    			<input id="allbtn" type="button" value="전체보기">
			</div>
		</div>
		
		<script>
		$("#hamburgerbtn").on("click", function() {	// 햄버거버튼 눌렀을때 active로 보이게한다
			$("#memberList").toggleClass("active");
		    $(".searchMessage").toggleClass("active");
		});
		
		// 채팅 나가기 버튼
		$("#exitbtn").on("click", async function(){		// async >> 함수 안에서 await 쓰기 위함
			// await는 publish작업 끝날때까지 기다리기
			await stompClient.publish({		// STOMP 메시지를 서버에 보냄
		        destination : "/app/chat",	// Config의 /app 창구로 Controller에 들어감
		        body : JSON.stringify({		// 보낼 내용을 JSON 문자열로 바꿈
		            partyId : partyId,
		            memberId : "${loginId}",
		            content : loginNickname+"님이 퇴장했습니다.",
		            messageType : "LEAVE"
		        })
		    });
		// 연결 종료
			await stompClient.deactivate();				//stomp/websocket 연결 종료
			location.href="/party/detail?partyId=" + partyId;	//파티페이지로 이동
		});
		
		
		
		// 검색창의 Enter키로 검색 기능
		$("#searchText").on("keydown", function (e) {		// enter키로 검색가능
		    if (e.key === "Enter") {
		        e.preventDefault();		// Enter의 기본 동작(폼 제출 등)을 막음
		        $("#searchbtn").click();
		    }
		});
		
		
		// 검색버튼 클릭시 함수 실행
		$("#searchbtn").on("click", function(){
			let searchText = $("#searchText").val().trim();		// 검색버튼 눌렀을때 검색내용 공백 제거
			
			if(searchText == ""){
				$("#allbtn").click();// 공백제거한 검색 내용이 빈칸이면 전체보기 버튼 클릭
				return;
			}
			$("#chat .enterMessage, #chat .leaveMessage").hide();	// 입퇴장 메세지는 검색 중 숨김
			// 모든 메세지 각각 검사하면서 검색내용이랑 비교
			$("#chat .myMessage, #chat .otherMessage").each(function() {												
		        let content = $(this).text();		// 돌고있는 메시지를 변수에 저장
		        if(content.includes(searchText)) {
		            $(this).show();					// 찾으면 show
		        } else {
		            $(this).hide();					// 못찾으면 hide
		        }
		    });
		});
		
		// 전체보기 버튼 클릭시 함수 실행
		$("#allbtn").on("click", function(){
			// 입퇴장 포함 전체 다시 보기
			$("#chat .myMessage, #chat .otherMessage, #chat .enterMessage, #chat .leaveMessage").show();
			$("#searchText").val("");		// 검색창 비우기
			$("#chat").scrollTop($("#chat")[0].scrollHeight);
			// $("#chat")[0]은 jQuery 객체에서 순수 HTML 요소를 꺼냄.
			// scrollHeight는 내용 전체 높이, 이 값을 scrollTop에 넣으면 맨 아래로 이동.
		})
		</script>
		<!-- ------------------------------------------------------------------ -->



		<!-- 채팅 내용 -->
		<div class="chatBody" id="chat">
		<!-- 채팅내역 반복문 돌면서 타입별로 보여줌 -->
			<c:forEach var="chat" items="${chatList}"> 
				<c:choose>
					<c:when test="${chat.messageType == 'ENTER'}">
						<div class="enterMessage">
							<c:out value="${chat.content}" />
						</div>
					</c:when>
					<c:when test="${chat.messageType == 'LEAVE'}">
						<div class="leaveMessage">
							<c:out value="${chat.content}" />
						</div>
					</c:when>
					
					<!-- 내 채팅 -->
					<c:when test="${chat.memberId == loginId}">
						<div class="myMessage">
							<div>
								<c:out value="${chat.content}" />
							</div>
							<div>
								<fmt:formatDate value="${chat.createdAt}" pattern="a h:mm" />
							</div>
						</div>
					</c:when>
					<!-- 다른 사람 채팅 -->
					<c:otherwise>
						<div class="otherMessage">
							<div>
								<c:out value="${chat.username}" />
							</div>
							<div>
								<c:out value="${chat.content}" />
							</div>
							<div>
								<fmt:formatDate value="${chat.createdAt}" pattern="a h:mm" />
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
		
		
		<!-- 메시지 입력 -->
		<div class="chatBottom">
			<textarea id="message" placeholder="메시지 입력"></textarea>
			<input type="button" id="sendbtn" value="전송">
		</div>
	</div>
	<script>
	
	// 메세지 입력창에서 키를 눌렀을 때 실행
	$("#message").on("keydown",function(e){		// 메시지 두번전송문제 해결
		if(e.key == "Enter" && !e.shiftKey && !e.isComposing){
			// Enter를 눌렀으면서 shift를 누르지 않았고 한글 조합중이 아닐 경우
			// isComposing이 true인 첫 번째를 걸러서 한 번만 보냄
			
			e.preventDefault();				// textarea에 줄바꿈이 들어가는 걸 막음								
			$("#sendbtn").click();
		}
	})
	</script>





	<script>
	
		// 페이지를 처음 열 때, DB에서 불러온 기존 대화를 보여준 상태에서 스크롤을 맨 아래 위치시킴
		$("#chat").scrollTop($("#chat")[0].scrollHeight);
		
		const partyId = ${partyId};					// int - 따옴표 없음
		const loginId = "${loginId}";				// String - 따옴표 필요
		const loginNickname = "${loginNickname}";	// String
		
		const needEnter = ${needEnter};				// true/false (따옴표 필요 없음)
		// 입장 메시지를 보내야 하는지" 여부.
		// 처음 들어왔거나 나갔다가 다시 들어온 경우만 true이고, 새로고침이면 false라서 입장 메시지가 중복으로 안 나감
		
		
		// 연결: /ws  
		// 아직 접속하지 않음
		const stompClient = new StompJs.Client({	// 연결 담당 객체 생성
			brokerURL : "ws://" + location.host + "/ws"
			//           ws://localhost:8080/ws
		});
		// 연결 시작
		stompClient.activate(); // 연결 성공시 onConnect함수 실행
		
		
		// WebSocket 연결 성공시 실행
		stompClient.onConnect = function() {	// 함수 안에 구독과 입장 메시지 전송이 있는 이유
			console.log("WebSocket 연결 성공!");	// -> 연결이 돼야 구독과 전송도 가능하기 때문
			
			// 채팅방 구독
				stompClient.subscribe("/topic/chat/" + partyId, function(message) { //message는 STOMP 메시지 객체
					
					let data = JSON.parse(message.body);	//message.body는 실제 데이터내용(body)
					// 문자열을 객체로 바꾸면 data.content, data.memberId처럼 쓸 수 있음
					
					
					// esc대신 c:out을 쓰면 안되는 이유
					// 실행되는 곳과 시점이 달라서
					//[서버]  JSP가 실행됨  →  HTML 완성  →  브라우저로 전송  →  끝 (JSP는 여기서 종료)
					//[브라우저]  HTML 표시  →  이후 WebSocket으로 새 메시지가 올 때마다 JS가 실행됨
					
					// <c:out>, ${...}는 서버가 페이지를 만드는 그 한 순간에만 처리
					
					// WebSocket 메시지는 페이지가 뜬 뒤에 브라우저에 도착해서
					// 이 시점에는 서버의 JSP가 이미 끝났으니 c:out이 실행될 수가 없다
					
					if(data.messageType == "ENTER") {		// 메세지타입 입장일때
					    $("#chat").append(
					        "<div class='enterMessage'>" + esc(data.content) + "</div>"
					    );
					} else if(data.messageType == "LEAVE") {		// 메세지타입 퇴장일때
						    $("#chat").append(
						        "<div class='leaveMessage'>" + esc(data.content) + "</div>"
						    );
					} else if(data.memberId == "${loginId}") {
					    $("#chat").append(					// 내 메세지는 <when>뒤로 넣기
					        "<div class='myMessage'>" + "<div>" + esc(data.content) + "</div>" +
					            "<div>" + formatTime(data.createdAt) + "</div>" + "</div>"
					    );
					} else {
					    $("#chat").append(					// 다른사람 메세지는 <otherwise>뒤로 넣기 
					        "<div class='otherMessage'>" +
					            "<div>" + esc(data.username) + "</div>" + "<div>" + esc(data.content) + "</div>" +
					            "<div>" + formatTime(data.createdAt) + "</div>" + "</div>"
					    );
					}
					
					$(window).on("load", function(){	// load는 페이지 로딩이 끝날 때 한 번만 일어나는 이벤트		
						$("#chat").scrollTop($("#chat")[0].scrollHeight);	// 전체 채팅의 높이를 가져와서 스크롤위치 변경
					});
					
			});	
			
				function esc(s) { return $("<div>").text(s).html(); }
				// 메시지 안의 <, > 같은 문자를 안전한 글자로 바꿈.
				// <div>를 임시로 만들어서 .text(s)로 글자로 넣고 .html()로 꺼내면 <script>가 &lt;script&gt;로 변환
				// <c:out>을 쓰는 것과 같은 역할
				
				
				
				function formatTime(t) {		// 실시간 메시지 시간표시
				    const d = new Date(t);		// 시간 값 변수에 저장
				    if (isNaN(d)) return t;		// 변환에 실패했는지 검사해서, 실패하면 원래 값을 그대로 돌려줌
				    return d.toLocaleTimeString("ko-KR", { hour: "numeric", minute: "2-digit" });
				    // toLocaleTimeString은 그 객체의 시간 부분만 사용자 지역 형식의 문자열로 만들어주는 메서드
				}
			
			
				// 입장 메세지 (처음 입장하거나 나가기 후 재입장일 때만)
				if (needEnter) {
					stompClient.publish({
						destination : "/app/chat",
						body : JSON.stringify({
							partyId : partyId,
							memberId : loginId,
							content : loginNickname + "님이 입장했습니다.",
							messageType : "ENTER"
						})
					});
				}
		};
		
		// WebSocket 오류
		stompClient.onWebSocketError = function(error) {
			console.log("WebSocket 연결 실패:", error);
		};
		
		// 전송 버튼 클릭
		$("#sendbtn").on("click", function() {
			
			let message = $("#message").val();
			if(message.trim() ==""){				// 텍스트칸에 공백을 지웠을때 아무것도없으면 전송안됨(not null)
				return;
			}
			
			
			
			// 일반 메시지를 /app/chat으로 보내고, 입력창을 비운다
			// 보낸 뒤 내 화면에 바로 말풍선을 붙이지 않고, 서버가 방송해서 돌아온 메시지가 subscribe 함수에서 그려진다.
			
			stompClient.publish({			//채팅 전송시 dto로 저장되면서 @MessageMapping매핑
				destination : "/app/chat",
				body : JSON.stringify({
					partyId : partyId,
					memberId : loginId,
					content : message,
					messageType : "TEXT"
				})
			});
			$("#message").val("");
		});
	</script>


</body>
</html>