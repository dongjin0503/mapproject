package com.kedu.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.FreeBoardDAO;
import com.kedu.dto.FreeBoardDTO;

@Controller
@RequestMapping("/FreeBoard")
public class FreeboardController {
	
	@Autowired
	private FreeBoardDAO dao;
	
	@RequestMapping("/freeboard")
	public String boardList(Model model) throws Exception{
		List<FreeBoardDTO> lists =  dao.boardList();
		model.addAttribute("list",lists);
		
		return "/FreeBoard/freeboard";
	}
	
	@RequestMapping("/write")
	public String write() throws Exception{
		
		return "/FreeBoard/write";
	}
	
	@RequestMapping("/writeup")
	public String writeUp(FreeBoardDTO dto) throws Exception{
		dao.writeUp(dto);
		
		return "redirect:/FreeBoard/freeboard";
	}
	
	@RequestMapping("/detail")
	public String detail(int postId, Model model) throws Exception{
		FreeBoardDTO dto = dao.detail(postId);
		model.addAttribute("post",dto);
		
		return "/FreeBoard/detail";
	}
	
	@RequestMapping("/updateContent")
	public String updateContent(FreeBoardDTO dto,Model model) throws Exception {
		dao.updateContent(dto);
		
		return "redirect:/FreeBoard/detail?postId="+dto.getPostId();
	}
	
	@RequestMapping("/deleteContent")
	public String deleteContent(int postId, int cpage) {
		
		dao.deleteContent(postId);
		
		return "redirect:/FreeBoard/freeboard?cpage="+cpage;
	}
	
	

}
