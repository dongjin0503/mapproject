package com.kedu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.ChallengeDAO;
import com.kedu.dao.ChallengeReplyDAO;
import com.kedu.dto.ChallengeDTO;
import com.kedu.dto.ChallengeReplyDTO;

@Controller
@RequestMapping("challenge")
public class ChallengeController {

	@Autowired
	private ChallengeDAO dao;
	
	@Autowired
	private ChallengeReplyDAO rdao;
	
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
	
	@RequestMapping("detail")
	public String detail(int challenge_id , Model model ,HttpSession session) {
		String id = (String) session.getAttribute("loginId");
		
		boolean joined = false;
		
		if(id != null) {
			joined = dao.isJoined(challenge_id, id);
		}
		
		model.addAttribute("joined", joined);
		model.addAttribute("ch", dao.getChallenge(challenge_id));
		model.addAttribute("replyList", rdao.listReply(challenge_id));
		return "challenge/detail";
	}
	
	@RequestMapping("replyOk")
	public String replyOk(HttpSession session , ChallengeReplyDTO dto) {
		String id = (String) session.getAttribute("loginId");
		
		if(id == null) {
			return "redirect:/member/login";
		} else {
			if (dto.getParent_reply_id() == null) {
				rdao.addReply(id, dto);
			} else {
				rdao.addReReply(id, dto);
			}
		}
		return "redirect:/challenge/detail?challenge_id=" + dto.getChallenge_id();
	}
	
	@RequestMapping("replyUpdate")
	public String replyUpdate(HttpSession session , ChallengeReplyDTO dto) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";
		} else {
			rdao.updateReply(dto.getChallenge_reply_id(), id, dto.getContent());
		}
		return "redirect:/challenge/detail?challenge_id=" + dto.getChallenge_id();
	}
	
	@RequestMapping("replyDelete")
	public String replyDelete(HttpSession session, ChallengeReplyDTO dto) {
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";	
		} else {
			rdao.deleteReply(dto.getChallenge_reply_id(), id);
		}
		return "redirect:/challenge/detail?challenge_id=" + dto.getChallenge_id();
	}
	
	@RequestMapping("apply")
	public String apply(int challenge_id , Model model , HttpSession session) {
		String id = (String) session.getAttribute("loginId");
		if (id == null) {
			return "redirect:/member/login";	
		}
		model.addAttribute("ch" , dao.getChallenge(challenge_id));
		
		return "challenge/apply";
	}
	
	@RequestMapping("applyOk")
	public String applyOk(int challenge_id , HttpSession session) {
		String id = (String) session.getAttribute("loginId");
		
		if(id == null) {
			return "redirect:/member/login";
		}
		
		if(dao.isJoined(challenge_id, id)) {
			return "redirect:/challenge/detail?challenge_id=" + challenge_id;
		}
		dao.addMember(challenge_id, id);
		return "redirect:/challenge/detail?challenge_id=" + challenge_id; 
	}
}
