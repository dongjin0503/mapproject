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

<style>
/* 채팅 전체 */
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
    box-shadow: 0 3px 15px rgba(0,0,0,0.1);
}

/* 채팅 헤더 */
.chatHeader {
    padding: 15px;
    box-sizing: border-box;
    border-bottom: 1px solid #ddd;
}

/* 채팅 내용 */
.chatBody {
    flex: 1;
    overflow-y: auto;
    padding: 15px;
    box-sizing: border-box;
    background: #f3f4f6;
}

/* 입장 / 퇴장 메시지 */
.enterMessage,
.leaveMessage {
    text-align: center;
    color: gray;
    margin: 10px 0;
}

/* 내 메시지 */
.myMessage {
    display: flex;
    flex-direction: row-reverse;   /* 말풍선 오른쪽, 시간은 그 왼쪽 */
    align-items: flex-end;
    gap: 6px;
    margin: 10px 0;
}
.myMessage > div:nth-child(1) {    /* 말풍선 */
    max-width: 70%;
    padding: 8px 12px;
    background: #111827;
    color: white;
    border-radius: 12px 12px 0 12px;
    word-break: break-word;
    text-align: left;
}
.myMessage > div:nth-child(2) {    /* 시간 */
    font-size: 11px;
    color: #999;
}

/* 다른 사람 메시지 */
.otherMessage {
    display: grid;
    grid-template-columns: minmax(0, max-content) max-content;
    column-gap: 6px;
    align-items: end;
    justify-content: start;
    max-width: 75%;
    margin: 10px 0;
}
.otherMessage > div:nth-child(1) { /* 이름 */
    grid-column: 1 / -1;
    font-size: 12px;
    color: #666;
    margin-bottom: 3px;
}
.otherMessage > div:nth-child(2) { /* 말풍선 */
    padding: 8px 12px;
    background: white;
    border: 1px solid #ddd;
    border-radius: 0 12px 12px 12px;
    word-break: break-word;
}
.otherMessage > div:nth-child(3) { /* 시간 */
    font-size: 11px;
    color: #999;
}

/* 햄버거 버튼 */
#hamburgerbtn {
    float: right;
    border: none;
    background: none;
    font-size: 20px;
    line-height: 1;
    cursor: pointer;
}

/* 참여자 사이드바 */
#memberList {
    position: absolute;
    top: 0;
    left: 100%;

    width: 200px;
    height: 100%;

    padding: 20px;
    box-sizing: border-box;

    background-color: white;
    border: 1px solid #ddd;
    border-radius: 0 10px 10px 0;
    box-shadow: 3px 0 10px rgba(0,0,0,0.15);

    z-index: 10;
}

/* 참여자 한 명 */
#memberList div {
    padding: 8px;
    border-bottom: 1px solid #eee;
}

/* 채팅 나가기 버튼 */
#exitbtn {
    width: 100%;
    margin-top: 15px;
}

/* 제목 / 인원 */
.chatHeader > span:first-child { font-weight: bold; font-size: 16px; }
.chatHeader > span:nth-child(2) { color: #888; font-size: 13px; margin-left: 6px; }

/* 검색창 */
.searchMessage { display: flex; gap: 6px; margin-top: 10px; clear: both; }
#searchText { flex: 1; padding: 6px 8px; border: 1px solid #ddd; border-radius: 6px; }
.searchMessage input[type=button] { padding: 6px 10px; border: 1px solid #ddd; border-radius: 6px; background: white; cursor: pointer; }

/* 메시지 입력 */
.chatBottom { display: flex; gap: 8px; padding: 12px; box-sizing: border-box; border-top: 1px solid #ddd; }
#message { flex: 1; height: 50px; resize: none; padding: 8px 10px; box-sizing: border-box; border: 1px solid #ddd; border-radius: 8px; font-family: inherit; }
#sendbtn { width: 70px; border: none; border-radius: 8px; background: #111827; color: white; font-weight: bold; cursor: pointer; }
</style>
</head>
<body>
	<div class="container">
		<div class="header">
			<div class="header-left">
				<div class="logo">짠내맵</div>
				<div class="nav">
					<a href="#">지도</a> <a href="#">파티원모집</a> <a href="#">챌린지</a> <a href="#">가계부</a> <a href="/FreeBoard/freeboard">자유게시판</a>
					<a href="#">Q&A게시판</a>
				</div>
			</div>
		</div>
	</div>


	<!-- 채팅방 -->
	<div class="chat">
		<div class="chatHeader">
			<span>${partyTitle}</span> <span>${partyMember}</span>
			<input type="button" id="hamburgerbtn" value="☰">		<!-- 참여자목록, 채팅나가기버튼 -->
				<div id="memberList" style="display: none;">
    				<c:forEach var="member" items="${memberList}">
       				 <div>${member}</div>
    				</c:forEach>
    				<input type="button" id="exitbtn" value="채팅 나가기">
				</div>
			
			<div class="searchMessage">
   				<input id="searchText" type="text" placeholder="내용 검색">
    			<input id="searchbtn" type="button" value="검색">
    			<input id="allbtn" type="button" value="전체보기">
			</div>
		</div>
		<script>
		
		$("#hamburgerbtn").on("click",function(){
			$("#memberList").toggle();
		})
		
		$("#exitbtn").on("click", async function(){		// 채팅나가기 버튼 클릭	(async) -> await사용
			await stompClient.publish({				// await는 publish작업 끝날때까지 기다리기
		        destination : "/app/chat",
		        body : JSON.stringify({
		            partyId : partyId,
		            memberId : "tester",
		            content : "tester님이 퇴장했습니다.",
		            messageType : "LEAVE"
		        })
		    });
		
			await stompClient.deactivate();				//stomp/websocket 연결 종료
			location.href="#";		//파티페이지로 이동
		});
		
		
		
		$("#searchbtn").on("click", function(){
			let searchText = $("#searchText").val().trim();		// 검색버튼 눌렀을때 검색내용공백 제거하고
			if(searchText == ""){								// 공백제거한 문자가 빈칸이면 return		
				return;
			}
			$("#chat .myMessage, #chat .otherMessage").each(function() {	// 모든 메세지 각각 검사하면서
																			// 검색내용이랑 비교
		        let content = $(this).text();
		        if(content.includes(searchText)) {
		            $(this).show();											// 찾으면 show
		        } else {
		            $(this).hide();											// 못찾으면 hide
		        }
		    });
		});
		
		$("#allbtn").on("click", function(){
			$("#chat .myMessage, #chat .otherMessage").show();				// 검색하느라 숨겼던 채팅 보기
			$("#searchText").val("");										// 검색창 비우기
		})
		</script>

		<!-- 채팅 내용 -->
		<div class="chatBody" id="chat">
			<c:forEach var="chat" items="${chatList}">		<!-- 채팅 기록 불러오기 -->
				<c:choose>
					<c:when test="${chat.memberId == loginId}">	<!-- 내 채팅 -->
						<div class="myMessage">
							<div><c:out value="${chat.content}"/></div>
							<div><fmt:formatDate value="${chat.createdAt}" pattern="a h:mm"/></div>
						</div>			<!-- fmt:formatDate >> Timestamp를 원하는 모양의 문자열로 변경 a(오전/오후) h(12시간제 시) mm(분) -->
					</c:when>

					<c:otherwise>
						<div class="otherMessage">			<!-- 다른 사람 채팅 -->
							<div><c:out value="${chat.memberId}"/></div>
							<div><c:out value="${chat.content}"/></div>
							<div><fmt:formatDate value="${chat.createdAt}" pattern="a h:mm"/></div>
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
	
	$("#message").on("keydown",function(e){		//메시지 두번전송문제 해결
		if(e.key == "Enter" && !e.shiftKey && !e.isComposing){		// 엔터키 누르면 전송버튼 클릭됨
			e.preventDefault();				// 폼 안에 있을 경우 폼이 멋대로 제출되는 것을 방지
			$("#sendbtn").click();
		}
	})
	
	</script>

	<script>
	
		/* const partyId = 1; // 임시 테스트용 (나중에 DB에서 가져옴) */
		$("#chat").scrollTop($("#chat")[0].scrollHeight);
		const partyId = ${partyId};
		
		const stompClient = new StompJs.Client({
			brokerURL : "ws://" + location.host + "/ws"
		});
		
		// WebSocket 연결 성공
		stompClient.onConnect = function() {
			console.log("WebSocket 연결 성공!");
			
			// 채팅방 구독
				stompClient.subscribe("/topic/chat/" + partyId, function(message) { //message는 STOMP 메시지 객체
					let data = JSON.parse(message.body);				//message.body는 실제 데이터내용(body)
					
					if(data.messageType == "ENTER") {		// 메세지타입 입장일때
					    $("#chat").append(
					        "<div class='enterMessage'>" + esc(data.content) + "</div>"
					    );
					} else if(data.messageType == "LEAVE") {		// 메세지타입 퇴장일때
						    $("#chat").append(
						        "<div class='leaveMessage'>" + esc(data.content) + "</div>"
						    );
					} else if(data.memberId == "tester") {
					    $("#chat").append(					// 내 메세지는 <when>뒤로 넣기
					        "<div class='myMessage'>" + "<div>" + esc(data.content) + "</div>" +
					            "<div>" + formatTime(data.createdAt) + "</div>" + "</div>"
					    );
					} else {
					    $("#chat").append(					// 다른사람 메세지는 <otherwise>뒤로 넣기 
					        "<div class='otherMessage'>" +
					            "<div>" + esc(data.memberId) + "</div>" + "<div>" + esc(data.content) + "</div>" +
					            "<div>" + formatTime(data.createdAt) + "</div>" + "</div>"
					    );
					}
					$("#chat").scrollTop($("#chat")[0].scrollHeight);	// 전체 채팅의 높이를 가져와서 스크롤위치 변경
					
			});	
				function esc(s) { return $("<div>").text(s).html(); }
				function formatTime(t) {		// 실시간 메시지 시간표시
				    const d = new Date(t);
				    if (isNaN(d)) return t;		// 변환 실패시 거르기
				    return d.toLocaleTimeString("ko-KR", { hour: "numeric", minute: "2-digit" });
				}
			
			
			// 입장 메세지
				stompClient.publish({
			        destination : "/app/chat",
			        body : JSON.stringify({
			            partyId : partyId,
			            memberId : "tester",
			            content : "tester님이 입장했습니다.",
			            messageType : "ENTER"
			        })
			    });
		};
		
	//	퇴장시 Websocket 연결 끊기기 전에 퇴장메세지
		/* stompClient.onDisconnect = function() {
		    console.log("채팅방 나감!");
		    stompClient.publish({
		        destination : "/app/chat",
		        body : JSON.stringify({
		            partyId : partyId,
		            memberId : "tester",
		            content : "tester님이 퇴장했습니다.",
		            messageType : "LEAVE"
		        })
		    });

		}; */
		
		// WebSocket 오류
		stompClient.onWebSocketError = function(error) {
			console.log("WebSocket 연결 실패:", error);
		};
		
		// 연결 시작
		stompClient.activate();
		// 전송 버튼 클릭
		$("#sendbtn").on("click", function() {
			
			let message = $("#message").val();
			if(message.trim() ==""){				// 텍스트칸에 공백을 지웠을때 아무것도없으면 전송안됨(not null)
				return;
			}
			
/* 			console.log("전송 데이터:", {		테스트용
			    partyId : partyId,
			    memberId : "tester",
			    content : message,
			    messageType : "TEXT"
			}); */

			stompClient.publish({			//채팅 전송시 dto로 저장되면서 @MessageMapping매핑
				destination : "/app/chat",
				body : JSON.stringify({
					partyId : partyId,
					memberId : "tester",		/* ${loginId} */
					content : message,
					messageType : "TEXT"
				})
			});
			$("#message").val("");
		});
	</script>


</body>
</html>