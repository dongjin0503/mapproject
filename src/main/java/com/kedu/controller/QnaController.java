package com.kedu.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.QnaDAO;
import com.kedu.dto.QnaDTO;
import com.kedu.dto.QnaReplyDTO;

@Controller
@RequestMapping("/qna")
public class QnaController {
	
	@Autowired
	private QnaDAO dao;
	
	
	@RequestMapping("list")
	public String list(String keyword , Model model) {
		
		if (keyword == null ) {
			keyword = "";
		}		
		
		model.addAttribute("keyword", keyword);
		model.addAttribute("list", dao.listQna(keyword));
		
		return "qna/list";

	}
	
	@RequestMapping("write")
	public String write(HttpSession session) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";
		} else {
			return "qna/write";
		}
	}
	
	@RequestMapping("writeOk")
	public String writeOk(HttpSession session , QnaDTO dto) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";
		} else {
			if (dto.getSecret() == null) {
				dto.setSecret("N");
			}
			dto.setWriter(id);
			dao.addQna(dto);
		}
		return "redirect:/qna/list";
	}
	
	@RequestMapping("detail")
	public String detail(int qna_id , HttpSession session , Model model) {
		
		String id = (String) session.getAttribute("loginId");
		QnaDTO q = dao.getQna(qna_id);
		
		if ("Y".equals(q.getSecret())) {
		    if (!"admin".equals(id) && !q.getWriter().equals(id)) {
		        return "redirect:/qna/list";
		    }
		}
		dao.addViewCount(qna_id);
		model.addAttribute("qna", q);
		model.addAttribute("replyList", dao.listReply(qna_id));
		return "qna/detail";
		
	}
	
	@RequestMapping("update")
	public String update(int qna_id , HttpSession session , Model model) {
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";
		}
		
		QnaDTO q = dao.getQna(qna_id);

		if (!q.getWriter().equals(id)) {
		    return "redirect:/qna/list";
		}
		model.addAttribute("qna", q);
		return "qna/update";
		
	}
	
	@RequestMapping("updateOk")
	public String updateOk(HttpSession session , QnaDTO dto) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";
		}
		if (dto.getSecret() == null) {
		    dto.setSecret("N");
		}
		dto.setWriter(id);
		dao.updateQna(dto);
		
		return "redirect:/qna/detail?qna_id=" + dto.getQna_id();
		
	}
	
	@RequestMapping("delete")
	public String delete(int qna_id, HttpSession session) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			
			return "redirect:/member/login";
		}
		
		QnaDTO q = dao.getQna(qna_id);
		if (q.getWriter().equals(id) || "admin".equals(id)) {
			dao.deleteQna(qna_id, q.getWriter());
		}
		
		return "redirect:/qna/list";
		
	}
	
	@RequestMapping ("replyOk")
	public String replyOk(HttpSession session , QnaReplyDTO dto) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (!"admin".equals(id)) {
			
			return "redirect:/qna/list";
		}
		
		dto.setWriter(id);
		dao.addQnaReply(dto);
		
		return "redirect:/qna/detail?qna_id=" + dto.getParent_qna_id();
	}
	
	@RequestMapping ("replyUpdateOk")
	public String replyUpdateOk(HttpSession session , QnaReplyDTO dto) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (!"admin".equals(id)) {
			return "redirect:/qna/list";
		}
		
		dao.updateQnaReply(dto);
		
		return "redirect:/qna/detail?qna_id=" + dto.getParent_qna_id();

	}
	
	@RequestMapping ("replyDelete")
	public String replyDelete(int qna_reply_id, int qna_id , HttpSession session ) {
		String id = (String) session.getAttribute("loginId");
		
		if (!"admin".equals(id)) {
			return "redirect:/qna/list";
		}
		
		dao.deleteQnaReply(qna_reply_id);
		
		return "redirect:/qna/detail?qna_id=" + qna_id;

		
	}
}
