package com.kedu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.ChallengeDAO;
import com.kedu.dto.ChallengeDTO;

@Controller
@RequestMapping("challenge")
public class ChallengeController {

	@Autowired
	private ChallengeDAO dao;

	// 챌린지 목록 화면
	@RequestMapping("list")
	public String list(Model model) {
		List<ChallengeDTO> list = dao.listChallenge();
		model.addAttribute("list", list);
		return "challenge/list";
	}
	
	@RequestMapping("create")
	public String create(HttpSession session) {
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";
		} else {
			return "challenge/create";
		}
	}
	
	@RequestMapping("createOk")
	public String createOk(HttpSession session , ChallengeDTO dto) {
		String id = (String) session.getAttribute("loginId");
		
		if(id == null) {
			return "redirect:/member/login";
		} else {
			if(dto.getEnd_date().compareTo(dto.getStart_date()) < 0) {
				return "redirect:/challenge/create";
			}
			dao.addChallenge(id, dto);
			return "redirect:/challenge/list";
		}
	}
	
	
	
	
}
