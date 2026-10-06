package com.kedu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kedu.dao.ReplyDAO;
import com.kedu.dto.ReplyDTO;

@Controller
@RequestMapping("/reply")
public class ReplyController {

	@Autowired
	private ReplyDAO dao;

	@RequestMapping("/addReply")
	public String addReply(ReplyDTO dto,@RequestParam(defaultValue = "1") int cpage) throws Exception {
		dao.addReply(dto);
		
		 return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
	}

	@RequestMapping("/updateReply")
	public String updateReply(ReplyDTO dto, @RequestParam(defaultValue = "1") int cpage) throws Exception {
		dao.updateReply(dto);
		
		return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
	}

	@RequestMapping(value = "/deleteReply", method = RequestMethod.POST)
	public String deleteReply(int replyId, int postId, @RequestParam(defaultValue = "1") int cpage) throws Exception {
		dao.deleteReply(replyId);
		return "redirect:/FreeBoard/detail?postId=" + postId + "&cpage=" + cpage;
	}

}
