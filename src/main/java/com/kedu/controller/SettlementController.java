package com.kedu.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kedu.dao.PartyDAO;
import com.kedu.dao.SettlementDAO;
import com.kedu.dto.PartyDTO;
import com.kedu.dto.SettlementDTO;

@Controller
@RequestMapping("/settlement")
public class SettlementController {

	@Autowired
	private PartyDAO partyDAO;

	@Autowired
	private SettlementDAO settlementDAO;

	@RequestMapping("/create")
	public String create(@RequestParam("partyId") int partyId, HttpSession session, Model model) {

		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:/member/login";
		}

		PartyDTO dto = partyDAO.findById(partyId);

		if (dto == null) {
			return "redirect:/party/list";
		}

		if (!loginId.equals(dto.getHostId())) {
			return "redirect:/party/detail?partyId=" + partyId;
		}

		model.addAttribute("party", dto);
		model.addAttribute("members", partyDAO.findSettlementMembers(partyId));

		return "settlement/create";
	}

	@RequestMapping(value = "/createSubmit", method = RequestMethod.POST)
	public String createSubmit(@RequestParam("partyId") int partyId,
			@RequestParam("settlementType") String settlementType, @RequestParam("totalAmount") long totalAmount,
			@RequestParam(value = "memberIds", required = false) List<String> memberIds,
			@RequestParam(value = "memberAmounts", required = false) List<Long> memberAmounts, HttpSession session,
			Model model) {

		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
			return "redirect:/member/login";
		}

		try {

			int settlementId;

			if ("EQUAL".equals(settlementType)) {

				settlementId = settlementDAO.createEqual(partyId, loginId, totalAmount);

			} else if ("MENU".equals(settlementType)) {

				settlementId = settlementDAO.createMenu(partyId, loginId, totalAmount, memberIds, memberAmounts);

			} else {

				throw new IllegalArgumentException("정산 방식이 올바르지 않습니다.");
			}

			return "redirect:/settlement/result?settlementId=" + settlementId;

		} catch (IllegalArgumentException e) {
			PartyDTO dto = partyDAO.findById(partyId);

			if (dto == null) {
				return "redirect:/party/list";
			}

			model.addAttribute("party", dto);
			model.addAttribute("members", partyDAO.findSettlementMembers(partyId));
			model.addAttribute("message", e.getMessage());

			return "settlement/create";
		}
	}

	@RequestMapping("/result")
	public String result(@RequestParam("settlementId") int settlementId, Model model) {

		SettlementDTO settlementDTO = settlementDAO.findSettlement(settlementId);

		List<SettlementDTO> details = settlementDAO.findSettlementDetails(settlementId);

		model.addAttribute("settlement", settlementDTO);
		model.addAttribute("details", details);

		return "settlement/result";
	}
}
