package com.kedu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.ChattingRoomDAO;
import com.kedu.dao.PartyDAO;
import com.kedu.dto.ChattingRoomDTO;

@Controller
@RequestMapping("/Chattingroom")
public class ChattingRoomController {
	
	@Autowired
	private PartyDAO partyDAO;
	
	@Autowired
	private ChattingRoomDAO dao;
	
	@Autowired
	private SimpMessagingTemplate template;
	//서버가 원하는 때에 원하는 채널로 방송하는 도구
	//Config에서 @EnableWebSocketMessageBroker를 켰기 때문에 스프링이 이 객체를 만들어줌
	
	
	//@SendTo("/topic/chat") 주소를 코드에 고정해서 쓰는 방식
	//파티마다 다른 채널로 보내야 하면 template을 사용 (/topic/chat/1, /topic/chat/2)
	
	
	
	@RequestMapping("/chat")
    public String chatPage(int partyId, Model model, HttpSession session) throws Exception {
		
		
		String loginId = (String) session.getAttribute("loginId");

	    if (loginId == null) {
	        return "redirect:/member/login";
	    }
	    if (!partyDAO.isMember(partyId, loginId)) {	// 이 파티의 멤버가 아닐 시에 파티 상세페이지로 돌려보냄
	        return "redirect:/party/detail?partyId=" + partyId;
	    }
	    
		List<ChattingRoomDTO> chatList = dao.selectByPartyId(partyId);		// 채팅방 채팅기록
		List<String> memberList = dao.selectMemberList(partyId);		// 파티참여 인원 닉네임
		
		String title = dao.selectTitle(partyId);				// 파티테이블의 파티제목
		int partyMem = dao.selectMemberCount(partyId);			// 파티참여인원수
		
		model.addAttribute("needEnter", !dao.isEntered(partyId, loginId));		// 마지막 기록이 enter인지 확인
		// 이미 입장해 있으면 isEntered가 true,
		// !로 뒤집어서 needEnter는 false가 됨. >> 새로고침해도 입장 메시지가 또 나가지 않음.
		
		model.addAttribute("loginNickname", dao.selectNickname(loginId));		// memberid로 닉네임 저장
		model.addAttribute("memberList", memberList);			// 햄버거 메뉴의 멤버리스트
		model.addAttribute("partyTitle",title);					// 채팅방 헤더 제목
		model.addAttribute("chatList",chatList);				// 채팅 사용자 표시 memberid>nickname변경
		model.addAttribute("partyMember",partyMem);				// 헤더의 인원수
		model.addAttribute("partyId",partyId);

		
        return "/ChattingRoom/chatroom";
    }
	
	
	
	// 클래스의 @RequestMapping 어노테이션은 WebSocket메세지에는 적용되지 않는다. >> /app/chat
	@MessageMapping("/chat")		// STOMP로 메시지가 올 때 (WebSocket) 저장하고 방송함
	public ChattingRoomDTO chatting(ChattingRoomDTO dto) throws Exception{	// JS가 JSON.stringify로 보낸 JSON을 스프링이 자동으로 DTO 객체로 바꿔서 넣어줌
		
		dto.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));	//createdAt 오류날수있어서 추가함
		dao.insert(dto); //메세지를 DB에 저장
		dto.setUsername(dao.selectNickname(dto.getMemberId()));					//닉네임 가져와서 setter로 dto에 저장
		
		template.convertAndSend(	// convertAndSend(보낼목적지, 보낼 데이터);
		        "/topic/chat/" + dto.getPartyId(),dto
		    );
		
		
		return dto;		//필요없음. 반환타입void로 바꾸고 없애도 됨
	}
}
