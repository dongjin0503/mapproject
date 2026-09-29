package com.kedu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.ReplyDAO;
import com.kedu.dto.ReplyDTO;

@Controller
@RequestMapping("/reply")
public class ReplyController {
	
	@Autowired
	private ReplyDAO dao;
	
	@RequestMapping("/addReply")
	public String addReply(ReplyDTO dto) throws Exception{
		
		dao.addReply(dto);
		
		return "redirect:/FreeBoard/detail?postId="+dto.getPostId();
	}
	
	@RequestMapping("/updateReply")
	public String updateReply(ReplyDTO dto) throws Exception{
		
		dao.updateReply(dto);
		return "redirect:/FreeBoard/detail?postId="+dto.getPostId();
	}
	
	@RequestMapping("/deleteReply")
	public String deleteReply(int replyId, int postId) throws Exception{
		
		dao.deleteReply(replyId);
		
		return "redirect:/FreeBoard/detail?postId="+postId;
	}

}
