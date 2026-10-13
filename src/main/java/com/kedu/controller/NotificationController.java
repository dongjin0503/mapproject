package com.kedu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kedu.dao.NotificationDAO;
import com.kedu.dto.NotificationDTO;

@Controller
@RequestMapping("/notification")
public class NotificationController {

	@Autowired
	private NotificationDAO notificationDAO;

	@RequestMapping("/list")
	public String list(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:/member/login";
		}

		List<NotificationDTO> notifications = notificationDAO.findByReceiverId(loginId);

		model.addAttribute("notifications", notifications);

		return "notification/list";
	}

	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public String delete(@RequestParam("notificationId") int notificationId, HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:/member/login";
		}

		notificationDAO.delete(notificationId, loginId);

		return "redirect:/notification/list";
	}

	@ResponseBody
	@RequestMapping("/count")
	public int count(HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return 0;
		}

		return notificationDAO.countByReceiverId(loginId);
	}
}
