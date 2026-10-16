package com.kedu.controller;

import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kedu.dao.FreeBoardReplyDAO;
import com.kedu.dto.FreeBoardReplyDTO;

@Controller
@RequestMapping("/reply")
public class FreeBoardReplyController {

	@Autowired
	private FreeBoardReplyDAO dao;

	@RequestMapping("/addReply")
	public String addReply(HttpSession session,FreeBoardReplyDTO dto,@RequestParam(defaultValue = "1") int cpage) throws Exception {
		String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null) {
	        return "redirect:/member/login";
	    }
	    dto.setMemberId(loginId);
	    if (dto.getContent() != null
	            && dto.getContent().getBytes(StandardCharsets.UTF_8).length > 1000) {
	        // 1000바이트 초과 시 DB 저장을 진행하지 않도록 처리
	    	return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
	    }
	    
	    dao.addReply(dto);
		
		 return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
	}

	@RequestMapping("/updateReply")
	public String updateReply(HttpSession session,FreeBoardReplyDTO dto, @RequestParam(defaultValue = "1") int cpage) throws Exception {
		 String loginId = (String) session.getAttribute("loginId");
		    if (loginId != null && dao.isWriter(dto.getReplyId(), loginId)) {
		    	if (dto.getContent() != null
		    	        && dto.getContent().getBytes(StandardCharsets.UTF_8).length > 1000) {
		    	    // 1000바이트 초과 시 DB 저장을 진행하지 않도록 처리
		    		return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
		    	}
		        dao.updateReply(dto);
		    }
		    return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
		
	}

	@RequestMapping(value = "/deleteReply", method = RequestMethod.POST)
	public String deleteReply(HttpSession session, int replyId, int postId, @RequestParam(defaultValue = "1") int cpage) throws Exception {
		String loginId = (String) session.getAttribute("loginId");
	    if (loginId != null && dao.isWriter(replyId, loginId)) {	//로그인 검증/댓글작성자와 유저 비교검증
	        dao.deleteReply(replyId);	//조건 트루면 댓글삭제
	    }
		return "redirect:/FreeBoard/detail?postId=" + postId + "&cpage=" + cpage;
	}
}
