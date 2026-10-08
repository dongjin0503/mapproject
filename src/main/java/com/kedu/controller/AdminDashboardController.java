package com.kedu.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.AdminDashboardDAO;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

	@Autowired
	private AdminDashboardDAO adminDashboardDAO;

	@RequestMapping("/dashboard")
	public String main(Model model, HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");
		if(loginId == null) {
			return "redirect:/member/login";
		}
		
		if(!loginId.equals("admin")) {
			return "redirect:/";
		}
		
		model.addAttribute("monthlyPartyCount",
				adminDashboardDAO.getMonthlyPartyCount());

		model.addAttribute("monthlyPartyMemberCount",
				adminDashboardDAO.getMonthlyPartyMemberCount());

		model.addAttribute("genderCount",
				adminDashboardDAO.getGenderCount());

		model.addAttribute("ageGroupCount",
				adminDashboardDAO.getAgeGroupCount());

		return "admin/dashboard";
	}
	
	
}