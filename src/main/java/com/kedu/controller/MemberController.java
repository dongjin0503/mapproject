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
			
			return "home";
		}
	
	@RequestMapping("/login")
	public String login(MemberDTO dto , HttpSession session) {
		String secret = getSHA512(dto.getPw());
		dto.setPw(secret);
		boolean result = dao.login(dto);
		if(result) {
			session.setAttribute("loginId", dto.getId()) ;
			
		}
		return "redirect:/";
	}
	
	@RequestMapping("/logout")
	public String logout (HttpSession session) {
		session.invalidate();
		
		return "home" ;
	}
	
	
	@RequestMapping("mypage")
	public String mypage (HttpSession session, Model model) {
		String id = (String) session.getAttribute("loginId") ;
		MemberDTO dto = dao.selectMember(id);
		model.addAttribute("member",dto) ;
		return "member/mypage";
	}
	
	@RequestMapping("leave") 
		public String leave(HttpSession session, MemberDTO dto) {
			String id = (String) session.getAttribute("loginId");
			dto.setId(id);
			dao.delete(dto);
			
			return "redirect:/member/logout";
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
}
	
	

