package com.kedu.controller;

import java.time.LocalDate;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kedu.dao.AdminDashboardDAO;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

	@Autowired
	private AdminDashboardDAO adminDashboardDAO;

	@RequestMapping("/dashboard")
	public String main(Model model, HttpSession session,
			@RequestParam(value = "startDate", required = false) String startDate,
			@RequestParam(value = "endDate", required = false) String endDate) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/member/login";
		}

		if (!loginId.equals("admin")) {
			return "redirect:/";
		}

		if (startDate == null || startDate.equals("")) {
			startDate = LocalDate.now().minusMonths(1).toString();
		}

		if (endDate == null || endDate.equals("")) {
			endDate = LocalDate.now().toString();
		}

		model.addAttribute("genderCount", adminDashboardDAO.getGenderCount(startDate, endDate));

		model.addAttribute("ageGroupCount", adminDashboardDAO.getAgeGroupCount(startDate, endDate));

		model.addAttribute("challengeCategoryStats", adminDashboardDAO.getChallengeCategoryStats(startDate, endDate));

		model.addAttribute("partyCategoryStats", adminDashboardDAO.getPartyCategoryStats(startDate, endDate));

		return "admin/dashboard";
	}

}