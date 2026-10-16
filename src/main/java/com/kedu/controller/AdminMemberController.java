package com.kedu.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.AdminMemberDAO;
import com.kedu.dao.MemberDAO;
import com.kedu.dto.MemberDTO;

@Controller
@RequestMapping("/admin")
public class AdminMemberController {

	@Autowired
	private AdminMemberDAO dao;
	
	@Autowired
	private MemberDAO mdao;
	
	@RequestMapping("/members")
	public String members(String keyword , String msg , Model model , HttpSession session) {
		
		String id = (String) session.getAttribute("loginId");
		if (id == null) {
			return "redirect:/member/login";
		}
		
		if(!id.equals("admin")) {
			return "redirect:/";
		}
		
		if (keyword == null) {
			keyword ="";
		}
		
		model.addAttribute("list",dao.listMember(keyword));
		model.addAttribute("keyword", keyword);
		model.addAttribute("msg",msg);
		
		return "admin/members";
	}
	
	@RequestMapping("/memberDelete")
	public String memberDelete(String id , HttpSession session) {
		
		String loginId = (String) session.getAttribute("loginId");
		
		if (loginId == null) {
			return "redirect:/member/login";
		}
		
		if (!loginId.equals("admin")) {
			return "redirect:/";
		}
		
		if (id.equals("admin")) {
			return "redirect:/admin/members?msg=admin";
		}
		
		MemberDTO dto = new MemberDTO();
		dto.setId(id);
		mdao.delete(dto);   // 회원 + 그 회원의 데이터 모두 삭제
		
		return "redirect:/admin/members?msg=ok";
	}
	
	
	
}
