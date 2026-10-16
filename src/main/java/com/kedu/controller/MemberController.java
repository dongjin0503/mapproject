package com.kedu.controller;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kedu.commons.MailUtil;
import com.kedu.dao.BookMarkDAO;
import com.kedu.dao.ChallengeDAO;
import com.kedu.dao.FreeBoardDAO;
import com.kedu.dao.MemberDAO;
import com.kedu.dao.PartyDAO;
import com.kedu.dto.BookMarkDTO;
import com.kedu.dto.FreeBoardDTO;
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
	
	
	// 1단계: 아이디 + 가입한 이메일 확인 → 그 이메일로 인증번호 발송
	@ResponseBody
	@RequestMapping("/ajax/sendcode")
	public String sendCode(String id, String email, HttpSession session) {

		// 1) 아이디와 가입한 이메일이 맞는지
		if (id == null || email == null || !dao.matchemail(id.trim(), email.trim())) {
			return "nomatch";
		}

		// 2) 30초 안에 다시 요청하면 막기 (메일 폭탄 방지)
		Long last = (Long) session.getAttribute("authTime");
		if (last != null && System.currentTimeMillis() - last < 30000) {
			return "wait";
		}

		// 3) 6자리 인증번호 (100000 ~ 999999)
		int num = (int) (Math.random() * 900000) + 100000;
		String code = String.valueOf(num);

		// 4) 가입할 때 저장한 이메일(DB 값)로 발송 - 화면에서 받은 값은 쓰지 않음
		id = id.trim();
		email = dao.selectEmail(id);
		try {
			MailUtil.send(email, "[짠내맵] 비밀번호 찾기 인증번호", "인증번호는 [" + code + "] 입니다. 3분 안에 입력해주세요.");
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}

		// 5) 세션에 보관
		session.setAttribute("authId", id);
		session.setAttribute("authCode", code);
		session.setAttribute("authTime", System.currentTimeMillis());
		session.setAttribute("authFail", 0);

		// 6) 화면에 보여줄 가린 이메일 (abc***@gmail.com)
		int at = email.indexOf("@");
		int show = 3;
		if (at <= 3) {
			show = 1;
		}
		return email.substring(0, show) + "***" + email.substring(at);
	}

	// 2단계: 인증번호 확인 → 결과를 글자로 돌려줌
	// "ok" 성공 / "wrong:남은횟수" 틀림 / "locked" 5회 실패 / "expired" 만료·없음
	@ResponseBody
	@RequestMapping("/ajax/verifycode")
	public String verifyCode(String code, HttpSession session) {
		String authId = (String) session.getAttribute("authId");
		String authCode = (String) session.getAttribute("authCode");
		Long authTime = (Long) session.getAttribute("authTime");
		Integer fail = (Integer) session.getAttribute("authFail");

		// 인증번호를 받은 적이 없거나 이미 폐기됨
		if (authId == null || authCode == null || authTime == null || fail == null) {
			return "expired";
		}

		// 3분(180000ms) 지남
		if (System.currentTimeMillis() - authTime > 180000) {
			session.removeAttribute("authCode");
			return "expired";
		}

		// 번호가 틀림
		if (!authCode.equals(code)) {
			fail = fail + 1;
			session.setAttribute("authFail", fail);

			if (fail >= 5) {
				session.removeAttribute("authCode");   // 5회 실패 → 번호 폐기
				return "locked";
			}
			return "wrong:" + (5 - fail);
		}

		// 인증 성공: 이제서야 비밀번호 변경 허용
		session.setAttribute("resetId", authId);
		session.removeAttribute("authCode");
		return "ok";
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
	
	// ------------------------------------------------------마이페이지 내 게시글, 북마크, 참여기록 모아보기
	
	
	@Autowired
	private FreeBoardDAO fdao;
	
	@Autowired
	private BookMarkDAO bdao;
	
	@Autowired
	private PartyDAO pdao;
	
	@Autowired
	private ChallengeDAO cdao;
	
	@ResponseBody
	@RequestMapping("/bookmarkToggle")
	public String toggle(HttpSession session, String contentType, int contentId) {
	    String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null) return "login";   // 로그인 안 했으면
	    if (bdao.existsBookmark(loginId, contentType, contentId)) {
	        bdao.deleteBookmark(loginId, contentType, contentId);
	        return "removed";
	    } else {
	        bdao.insertBookmark(loginId, contentType, contentId);
	        return "added";
	    }
	}
	
	@RequestMapping("/myContent")
	public String myContent(HttpSession session, Model model) throws Exception{
		String loginId = (String)session.getAttribute("loginId");
		List<FreeBoardDTO> myContentList= fdao.myContentList(loginId);
		model.addAttribute("member", dao.selectMember(loginId));
		model.addAttribute("myContentList",myContentList);
		return "/member/myContent";
		
	}
	@ResponseBody
	@RequestMapping("/bookmarkIds")
	public List<Integer> bookmarkIds(HttpSession session, String contentType) {
		List<Integer> ids = new ArrayList<>();
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) return ids;
		for (BookMarkDTO b : bdao.bookmarkList(loginId)) {
			if (contentType.equals(b.getContentType())) ids.add(b.getContentId());
		}
		return ids;
	}
	
	@RequestMapping("/bookmark")
	public String bookmark(HttpSession session,Model model) throws Exception{
		String loginId = (String)session.getAttribute("loginId");
		List<BookMarkDTO> bookmarkList = bdao.bookmarkList(loginId);
		
		List<BookMarkDTO> storeList = new ArrayList<>();
		List<BookMarkDTO> partyList = new ArrayList<>();
		List<BookMarkDTO> challengeList = new ArrayList<>();

		for (BookMarkDTO b : bookmarkList) {
		    if ("STORE".equals(b.getContentType())) storeList.add(b);
		    else if ("PARTY".equals(b.getContentType())) partyList.add(b);
		    else if ("CHALLENGE".equals(b.getContentType())) challengeList.add(b);
		}
		model.addAttribute("member", dao.selectMember(loginId));
		model.addAttribute("storeList", storeList);
		model.addAttribute("partyList", partyList);
		model.addAttribute("challengeList", challengeList);
		return "/member/bookmark";
	}
	
	@RequestMapping("/participationHistory")
	public String participationHistory(HttpSession session, Model model) throws Exception {
	    String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null) return "redirect:/member/login";
	    
	    model.addAttribute("challengeList",cdao.MyChallengeRecord(loginId));
	    model.addAttribute("member", dao.selectMember(loginId));
	    model.addAttribute("partyList", pdao.findJoinedParties(loginId));
	    return "/member/participationHistory";
	}
	
	
}
	
	

