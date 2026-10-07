package com.kedu.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kedu.dao.LedgerDAO;
import com.kedu.dto.LedgerDTO;

@Controller
@RequestMapping("/ledger")
public class LedgerController {

   @Autowired
   private LedgerDAO ledgerDAO;


   // 가계부 목록
   @RequestMapping("/list")
   public String list(HttpSession session, Model model) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      model.addAttribute(
            "ledgers",
            ledgerDAO.findAll(loginId)
      );

      return "ledger/list";
   }


   // 등록 화면
   @RequestMapping("/write")
   public String write(HttpSession session) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      return "ledger/write";
   }


   // 등록
   @RequestMapping(value = "/insert", method = RequestMethod.POST)
   public String insert(
         LedgerDTO dto,
         HttpSession session) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      dto.setMemberId(loginId);

      ledgerDAO.insert(dto);

      return "redirect:/ledger/list";
   }


   // 수정 화면
   @RequestMapping("/edit")
   public String edit(
         @RequestParam("ledgerId") int ledgerId,
         HttpSession session,
         Model model) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      LedgerDTO ledger =
            ledgerDAO.findById(ledgerId, loginId);

      if (ledger == null) {
         return "redirect:/ledger/list";
      }

      model.addAttribute("ledger", ledger);

      return "ledger/edit";
   }


   // 수정
   @RequestMapping(value = "/update", method = RequestMethod.POST)
   public String update(
         LedgerDTO dto,
         HttpSession session) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      dto.setMemberId(loginId);

      ledgerDAO.update(dto);

      return "redirect:/ledger/list";
   }


   // 삭제
   @RequestMapping(value = "/delete", method = RequestMethod.POST)
   public String delete(
         @RequestParam("ledgerId") int ledgerId,
         HttpSession session) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      ledgerDAO.delete(ledgerId, loginId);

      return "redirect:/ledger/list";
   }
}