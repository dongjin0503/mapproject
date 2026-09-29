package com.kedu.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

	
	@RequestMapping("/")
	public String testLogin(String id, HttpSession session) {
	    session.setAttribute("loginId", id);
	    return "redirect:/FreeBoard/freeboard";
	}
	
}
