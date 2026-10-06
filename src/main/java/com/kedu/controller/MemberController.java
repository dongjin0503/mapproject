package com.kedu.controller;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kedu.dao.MemberDAO;
import com.kedu.dto.MemberDTO;

@Controller
@RequestMapping("/member")
public class MemberController {

	@Autowired
	private MemberDAO dao; 
	
	public static String getSHA512(String input) {
	      if (input == null)
	         return null;
	      try {
	         byte[] hash = MessageDigest.getInstance("SHA-512").digest(input.getBytes(StandardCharsets.UTF_8));
	         return String.format("%0128x", new BigInteger(1, hash));
	      } catch (NoSuchAlgorithmException e) {
	         throw new RuntimeException(e);
	      }
	   }
	
	@RequestMapping("/sign")
	public String sign() {
		return "member/sign";
	}
	
	@RequestMapping("signup") 
		public String insert(MemberDTO dto) {
			String secret = getSHA512(dto.getPw());
			dto.setPw(secret);
			dao.signup(dto);
			
			return "redirect:/member/signupdone";
		}
	
	@RequestMapping("signupdone")
	public String signupdone() {
		return "member/signupdone";
	}
	@RequestMapping("/login")
	public String login(Model model , MemberDTO dto , HttpSession session) {
		if (dto.getId() == null) {          
			return "member/login";          
		}  
		String secret = getSHA512(dto.getPw());
		dto.setPw(secret);
		boolean result = dao.login(dto);
		if(result) {
			session.setAttribute("loginId", dto.getId()) ;
		return "redirect:/map/main";	
		} else {
			model.addAttribute("msg","아이디 또는 비밀번호가 올바르지 않습니다.");
			return "member/login";
		}
		
	}
	
	@RequestMapping("/logout")
	public String logout (HttpSession session) {
		session.invalidate();
		
		return "redirect:/map/main";
	}
	
	
	@RequestMapping("mypage")
	public String mypage (HttpSession session, Model model) {
		String id = (String) session.getAttribute("loginId") ;
	    if (id == null) {                                 
	        return "redirect:/member/login";               
	    }
		MemberDTO dto = dao.selectMember(id);
		model.addAttribute("member",dto) ;
		return "member/mypage";
	}
	
	@RequestMapping("leave") 
		public String leave(HttpSession session, MemberDTO dto) {
			String id = (String) session.getAttribute("loginId");
			dto.setId(id);
			dao.delete(dto);
			
			return "redirect:/map/main";
		}
	
	@ResponseBody
	@RequestMapping("/ajax/sign")
	public boolean sign(String id) throws Exception{

		return dao.idcheck(id);
		  
	}
	
	@ResponseBody
	@RequestMapping("/ajax/nickname") 
	public boolean nickname (String username) {
		return dao.namecheck(username);
	}
	
	@RequestMapping("/findid")
	public String findIdPage() {
		return "member/findid";
	}
	
	@RequestMapping("/findpw")
	public String findPwPage() {
		return "member/findpw";
	}
	
	@ResponseBody
	@RequestMapping("/ajax/findid")
	public String findId(String name , String phone) {
		
		MemberDTO dto = dao.findId(name, phone);
		
		if (dto == null) {
			return "";
		}
		
		String id = dto.getId();
		int show  =3 ;
		if (id.length() <= 3) {
			show = 1;
		}
		String masked = id.substring(0,show);
		for (int i = show ; i < id.length(); i ++) {
			masked += "*";
		}
		return masked;
	}
	
	@ResponseBody
	@RequestMapping("/ajax/checkpw")
	public boolean checkForReset(String id, String name, String phone, HttpSession session) {
	    boolean ok = dao.matchmember(id, name, phone);
	    if (ok) {
	        session.setAttribute("resetId", id);
	    }
	    return ok;
	}

	@ResponseBody
	@RequestMapping("/ajax/resetpw")
	public boolean resetPw(String pw, HttpSession session) {
	    String id = (String) session.getAttribute("resetId");
	    if (id == null) {
	        return false;
	    }
	    if (pw == null || !pw.matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!-/:-@\\[-`{-~])[A-Za-z\\d!-/:-@\\[-`{-~]{8,16}$")) {
	        return false;
	    }

	    dao.updatepw(id, getSHA512(pw));
	    session.removeAttribute("resetId");
	    return true;
	}
	
	
	@RequestMapping("/edit")
	public String editPage(HttpSession session, Model model) {
		String id = (String) session.getAttribute("loginId");
		if (id == null) {
			return "redirect:/member/login";
		}
		model.addAttribute("member", dao.selectMember(id));
		return "member/edit";
	}

	@RequestMapping("/update")
	public String update(HttpSession session , MemberDTO dto , String newPw) {
		
		String id = (String) session.getAttribute("loginId");
		
		if (id == null) {
			return "redirect:/member/login";
		}
		
		dto.setId(id);
		dao.update(dto);
		
		if (newPw != null && !newPw.isEmpty()) {
			dao.updatepw(id, getSHA512(newPw));
			
		}
		return "redirect:/member/mypage";
	}
	
	
	
}
	
	

