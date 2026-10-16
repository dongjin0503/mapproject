package com.kedu.controller;

import java.sql.Date;
import java.time.YearMonth;
import java.util.Arrays;
import java.util.List;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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


   // [보완5] 입력값 검사 기준
   private static final int MAX_AMOUNT = 100_000_000;   // 한 번에 기록할 수 있는 최대 금액 (1억)
   private static final int MAX_MEMO_LENGTH = 100;      // 메모 최대 글자 수 (화면 maxlength와 같게)
   private static final List<String> INCOME_CATEGORIES =
         Arrays.asList("급여", "용돈", "기타수입");
   private static final List<String> EXPENSE_CATEGORIES =
         Arrays.asList("식비", "교통", "쇼핑", "생활", "의료", "여가", "저축", "기타");

   //등록·수정 공통 검사. 문제가 있으면 안내 문장, 없으면 null
   private String validate(LedgerDTO dto, String ledgerDateText) {

      try {
         dto.setLedgerDate(Date.valueOf(ledgerDateText));   // "2026-10-16" 형식이 아니면 예외
      } catch (IllegalArgumentException | NullPointerException e) {
         return "날짜를 달력에서 선택해 주세요.";
      }

      if ("INCOME".equals(dto.getType())) {
         if (!INCOME_CATEGORIES.contains(dto.getCategory())) {
            return "수입 항목을 선택해 주세요.";
         }
      } else if ("EXPENSE".equals(dto.getType())) {
         if (!EXPENSE_CATEGORIES.contains(dto.getCategory())) {
            return "지출 항목을 선택해 주세요.";
         }
      } else {
         return "수입 또는 지출을 선택해 주세요.";
      }

      if (dto.getAmount() <= 0) {
         return "금액은 1원 이상으로 입력해 주세요. (지출은 '지출'을 선택하고 양수로 입력)";
      }

      if (dto.getAmount() > MAX_AMOUNT) {
         return "금액은 1억 원 이하로 입력해 주세요.";
      }

      if (dto.getMemo() != null && dto.getMemo().length() > MAX_MEMO_LENGTH) {
         return "메모는 " + MAX_MEMO_LENGTH + "자 이하로 입력해 주세요.";
      }

      return null;
   }
   
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
      
      String month = YearMonth.now().toString();
      
      int totalIncome = ledgerDAO.getMonthlyIncome(loginId, month);
      
      int totalExpense = ledgerDAO.getMonthlyExpense(loginId, month);
      
      int budget = ledgerDAO.getMonthlyBudget(loginId, month);
      
      int remainAmount =
    			budget + totalIncome - totalExpense;
      
      model.addAttribute("totalIncome", totalIncome);
      model.addAttribute("totalExpense", totalExpense);
      model.addAttribute("budget", budget);
      model.addAttribute("remainAmount", remainAmount);
      model.addAttribute("currentMonth", month);

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
	         @RequestParam("ledgerDateText") String ledgerDateText,
	         HttpSession session,
	         RedirectAttributes redirectAttributes) {

	      String loginId = (String) session.getAttribute("loginId");

	      if (loginId == null) {
	         return "redirect:/member/login";
	      }

	      dto.setMemberId(loginId);

	      // [보완5] 마이너스·0원·잘못된 항목은 저장하지 않고 안내
	      String error = validate(dto, ledgerDateText);
	      if (error != null) {
	         redirectAttributes.addFlashAttribute("ledgerMessage", error);
	         return "redirect:/ledger/list";
	      }

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
	 		@RequestParam("ledgerDateText") String ledgerDateText,
	         HttpSession session,
	         RedirectAttributes redirectAttributes) {

	      String loginId = (String) session.getAttribute("loginId");

	      if (loginId == null) {
	         return "redirect:/member/login";
	      }

	      dto.setMemberId(loginId);

	      // [보완5] 수정할 때도 같은 기준으로 검사
	      String error = validate(dto, ledgerDateText);
	      if (error != null) {
	         redirectAttributes.addFlashAttribute("ledgerMessage", error);
	         return "redirect:/ledger/edit?ledgerId=" + dto.getLedgerId();
	      }

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
   
   // 예산 저장
   @RequestMapping(value = "/budget", method = RequestMethod.POST)
   public String budget(
		   @RequestParam("startType") String startType,
   		@RequestParam(value = "budgetAmount", required = false, defaultValue = "0") int budgetAmount,
   		HttpSession session,
   		RedirectAttributes redirectAttributes) {
   	String loginId = (String) session.getAttribute("loginId");

   	if (loginId == null) {
   		return "redirect:/member/login";
   	}
   	
   	YearMonth currentMonth = YearMonth.now();

   	String month = currentMonth.toString();

   	
 	// 직접 설정하는 예산은 0원 이상만 (이월 금액은 지난달 결과라 마이너스일 수 있음)
   	if ("budget".equals(startType) && (budgetAmount < 0 || budgetAmount > MAX_AMOUNT)) {
   		redirectAttributes.addFlashAttribute("ledgerMessage", "예산은 0원 이상 1억 원 이하로 입력해 주세요.");
   		return "redirect:/ledger/list";
   	}
   	
   	if(startType.equals("carry")) {
   		
   		String previousMonth = currentMonth.minusMonths(1).toString();
   		
   		budgetAmount = ledgerDAO.getPreviousBalance(loginId, previousMonth);
   	}
   	
   	ledgerDAO.saveMonthlyBudget(
   			loginId,
   			month,
   			budgetAmount
   	);

   	return "redirect:/ledger/list";
   }
   
}