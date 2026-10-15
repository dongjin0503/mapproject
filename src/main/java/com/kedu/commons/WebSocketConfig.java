package com.kedu.commons;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
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
	    }
	
	  // A가 /app/chat/5 로 전송 → Controller가 받음 → /topic/chat/5 로 방송 → 그 채널 구독 중인 A, B, C 모두 수신

}
