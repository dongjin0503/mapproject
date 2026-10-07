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
	private SimpMessagingTemplate template;		// 파티별 전송으로 하기위해 @SendTo를 변경(파티 하나면 SendTO)
	
	@RequestMapping("/chat")
    public String chatPage(int partyId, Model model, HttpSession session) throws Exception {
		
		
		String loginId = (String) session.getAttribute("loginId");

	    if (loginId == null) {
	        return "redirect:/member/login";
	    }
	    if (!partyDAO.isMember(partyId, loginId)) {
	        return "redirect:/party/detail?partyId=" + partyId;
	    }
		List<ChattingRoomDTO> chatList = dao.selectByPartyId(partyId);		// partyId로 채팅방 채팅기록 가져오기
		List<String> memberList = dao.selectMemberList(partyId);		//파티참여 인원 아이디 가져오기
		
		String title = dao.selectTitle(partyId);				// partyId로 파티테이블에서 파티제목가져오기
		int partyMem = dao.selectMemberCount(partyId);
		
		model.addAttribute("memberList", memberList);
		model.addAttribute("partyTitle",title);
		model.addAttribute("chatList",chatList);
		model.addAttribute("partyMember",partyMem);
		model.addAttribute("partyId",partyId);

		
        return "/ChattingRoom/chatroom";
    }
	
	@MessageMapping("/chat")
	public ChattingRoomDTO chatting(ChattingRoomDTO dto) throws Exception{
		dto.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis())); //createdAt 오류날수있어서 추가함
		dao.insert(dto);
		
		template.convertAndSend(				// convertAndSend(보낼목적지, 보낼 데이터);
		        "/topic/chat/" + dto.getPartyId(),dto
		    );
		
		
		return dto;
	}
}
