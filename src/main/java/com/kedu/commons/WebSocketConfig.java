package com.kedu.commons;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration					// 이 클래스는 스프링 설정 파일 역할
@EnableWebSocketMessageBroker	// WebSocket 위에 STOMP 메시징 기능을 켜는 스위치
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {	// 채팅용 길 만드는 단계 (첫번째)
	
	  @Override
	    public void configureMessageBroker(MessageBrokerRegistry registry) {

		  // 서버 → 클라이언트 메시지 전송
	        registry.enableSimpleBroker("/topic");
	        //		방송국 채널이다 /topic/...을 구독(subscribe)한 사람들에게 서버가 메시지를 뿌린다
	        

	      // 클라이언트 → 서버 Controller 이동
	        registry.setApplicationDestinationPrefixes("/app");
	        //     사용자가 /app/...으로 보낸 메시지는 Controller의 @MessageMapping으로 들어간다
	    }
	  
	  @Override
	    public void registerStompEndpoints(StompEndpointRegistry registry) {	//브라우저가 처음 연결하는 문
		  	
	        registry.addEndpoint("/ws");	//JSP가 이 주소로 접속함. 연결은 한번만 하고 이후 메세지들은 이 연결로 오간다. 
	        // 일반 웹페이지는 http://localhost:8080/freeboard 같은 URL로 요청하면 서버가 응답하고 끝난다.
	        // 채팅은 서버가 먼저 메시지를 밀어줘야 하니까,
	        // 브라우저와 서버가 연결을 한 번 맺고 계속 열어 두는 방식이 필요하다. 그게 WebSocket
	    }
	
	  // A가 /app/chat/5 로 전송 → Controller가 받음 → /topic/chat/5 로 방송 → 그 채널 구독 중인 A, B, C 모두 수신

}
