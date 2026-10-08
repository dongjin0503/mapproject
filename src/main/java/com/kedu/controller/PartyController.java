package com.kedu.controller;

import java.io.File;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.kedu.dao.MemberDAO;
import com.kedu.dao.PartyDAO;
import com.kedu.dao.SettlementDAO;
import com.kedu.dto.MemberDTO;
import com.kedu.dto.PartyApplicationDTO;
import com.kedu.dto.PartyDTO;
import com.kedu.dto.SettlementDTO;

@Controller
@RequestMapping("/party")
public class PartyController {

   @Autowired
   private PartyDAO partyDAO;

   @Autowired
   private MemberDAO memberDAO;
   
   @Autowired
   private SettlementDAO settlementDAO;

   @Autowired
   private Gson gson;

   @RequestMapping("/list")
   public String list(Model model, HttpSession session) {
      List<PartyDTO> parties = partyDAO.findAll(0);
      
       for (PartyDTO party : parties) {
            party.setImageSysName(
                  partyDAO.findFirstImage(party.getPartyId())
            );
         }
      
      
      model.addAttribute("parties", parties);
      
      String loginId = (String) session.getAttribute("loginId");
      
      if(loginId != null) {
         model.addAttribute("bookmarkedPartyIds", partyDAO.findBookmarkedPartyIds(loginId));
      }
      return "party/list";
   }

   @ResponseBody
   @RequestMapping(value = "/more", produces = "application/json; charset=UTF-8")
   public String more(@RequestParam int offset) {
      List<PartyDTO> parties = partyDAO.findAll(offset);
       for (PartyDTO party : parties) {
            party.setImageSysName(
                  partyDAO.findFirstImage(party.getPartyId())
            );
         }
      
      
      return gson.toJson(parties);
   }

   @RequestMapping("/detail")
   public String derail(int partyId, HttpSession session, Model model) {
      PartyDTO party = partyDAO.findById(partyId);
     
      if (party == null) {
         return "redirect:/party/list";
      }
      
      model.addAttribute(
              "partyImages",
              partyDAO.findPartyImages(partyId)
        );
      
      SettlementDTO settlement = settlementDAO.findByPartyId(partyId);;
      
      model.addAttribute("settlement", settlement);
      
      int memberCount = partyDAO.countMembers(partyId);
      model.addAttribute("memberCount", memberCount);

      model.addAttribute("members", partyDAO.findSettlementMembers(partyId));

      MemberDTO host = memberDAO.selectMember(party.getHostId());
      model.addAttribute("hostName", host.getUsername());

      String loginId = (String) session.getAttribute("loginId");

      if (loginId != null) {

         boolean isMember = partyDAO.isMember(partyId, loginId);
         boolean hasPending = partyDAO.hasPendingApplication(partyId, loginId);
         model.addAttribute("bookmarked", partyDAO.isBookmarked(partyId, loginId));
         model.addAttribute("isMember", isMember);
         model.addAttribute("hasPending", hasPending);
      }
      model.addAttribute("party", party);

      return "party/detail";
   }

   @RequestMapping("/create")
   public String create() {
      return "party/create";
   }

   @RequestMapping("/apply")
   public String apply(int partyId, HttpSession session, Model model) {

   	PartyDTO party = partyDAO.findById(partyId);

   	String loginId =
   			(String) session.getAttribute("loginId");

   	if (loginId == null) {
   		return "redirect:/member/login";
   	}

   	if (party == null) {
   		return "redirect:/party/list";
   	}

   	String imageSysName =
   			partyDAO.findFirstImage(partyId);

   	model.addAttribute("party", party);
   	model.addAttribute("imageSysName", imageSysName);

   	return "party/apply";
   }

   @RequestMapping(value = "/createSubmit", method = RequestMethod.POST)
   public String createSubmit(PartyDTO dto, @RequestParam("meetDateText") String meetDateText,@RequestParam(value = "partyImage", required = false) MultipartFile[] partyImages, HttpSession session,
         Model model) throws Exception {

      String loginId = (String) session.getAttribute("loginId");
      if (loginId == null) {
         return "redirect:/member/login";
      }

      dto.setHostId(loginId);

      LocalDateTime meetDate = LocalDateTime.parse(meetDateText);
      dto.setMeetDate(Timestamp.valueOf(meetDate));

      String message = "";

      if (dto.getTitle() == null || dto.getTitle().trim().isEmpty()) {
         message += "모임 제목을 입력해 주세요.\n";
      } else {
         dto.setTitle(dto.getTitle().trim());
      }

      if (dto.getMinPeople() < 2 || dto.getMaxPeople() < dto.getMinPeople()) {
         message += "모임의 최소 인원은 2명이며, 최대 인원은 최소 인원 이상이어야 합니다.\n";
      }

      if (dto.getMinAge() != null && dto.getMaxAge() != null && dto.getMinAge() > dto.getMaxAge()) {
         message += "최대 나이는 최소 나이 이상이어야 합니다.\n";
      }

      if (!meetDate.isAfter(LocalDateTime.now())) {
         message += "모임 날짜는 현재 시간 이후로 선택해 주세요.\n";
      }

      if (!message.isEmpty()) {
         model.addAttribute("message", message);
         model.addAttribute("party", dto);
         model.addAttribute("meetDateText", meetDateText);
         return "party/create";
      }

      int partyId = partyDAO.createParty(dto);
      
      if (partyImages != null) {

            for (MultipartFile partyImage : partyImages) {

               if (partyImage.isEmpty()) {
                  continue;
               }

               String oriName = partyImage.getOriginalFilename();

               String sysName =
                     UUID.randomUUID().toString()
                     + "_" + oriName;

               File folder = new File("D:/study/uploads/");

               if (!folder.exists()) {
                  folder.mkdirs();
               }

               partyImage.transferTo(
                     new File(folder, sysName)
               );

               partyDAO.insertPartyImage(
                     partyId,
                     oriName,
                     sysName
               );
            }
         }

      
      return "redirect:/party/detail?partyId=" + partyId;
   }

   @RequestMapping(value = "/applySubmit", method = RequestMethod.POST)
   public String applySubmit(@RequestParam("partyId") int partyId,
         @RequestParam(value = "answer", defaultValue = "") String answer,
         @RequestParam(value = "agree", defaultValue = "") String agree, HttpSession session, Model model) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      try {
         if (!"Y".equals(agree)) {
            throw new IllegalArgumentException("모임 규칙 및 노쇼 방지 안내에 동의해주세요.");
         }

         PartyDTO dto = partyDAO.findById(partyId);

         if (dto == null) {
            return "redirect:/party/list";
         }

         MemberDTO member = memberDAO.selectMember(loginId);

         if ("male".equals(dto.getGenderRule()) && !"남성".equals(member.getGender())) {
            throw new IllegalArgumentException("남성만 참여할 수 있는 모임입니다.");
         }

         if ("female".equals(dto.getGenderRule()) && !"여성".equals(member.getGender())) {
            throw new IllegalArgumentException("여성만 참여할 수 있는 모임입니다.");
         }

         int age = Period.between(member.getBirth_date().toLocalDate(), LocalDate.now()).getYears();

         if (dto.getMinAge() != null && age < dto.getMinAge()) {
            throw new IllegalArgumentException("최소" + dto.getMinAge() + "세부터 참여할 수 있습니다.");
         }

         if (dto.getMaxAge() != null && age > dto.getMaxAge()) {
            throw new IllegalArgumentException("최대" + dto.getMaxAge() + "세까지 참여할 수 있습니다.");
         }

         partyDAO.apply(partyId, loginId, answer);
         return "redirect:/party/detail?partyId=" + partyId;

      } catch (IllegalArgumentException e) {
         PartyDTO dto = partyDAO.findById(partyId);

         if (dto == null) {
            return "redirect:/party/list";
         }
         model.addAttribute("party", dto);
         model.addAttribute("message", e.getMessage());
         model.addAttribute("answer", answer);

         return "party/apply";
      }
   }

   @RequestMapping("/applications")
   public String applications(int partyId, HttpSession session, Model model) {
      PartyDTO dto = partyDAO.findById(partyId);

      if (dto == null) {
         return "redirect:/party/list";
      }

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      if (!loginId.equals(dto.getHostId())) {
         return "redirect:/party/list";
      }

      List<PartyApplicationDTO> applications = partyDAO.findPendingApplications(partyId);

      model.addAttribute("party", dto);
      model.addAttribute("applications", applications);

      return "party/applications";
   }

   @RequestMapping(value = "/approve", method = RequestMethod.POST)
   public String approve(@RequestParam("partyId") int partyId, @RequestParam("applicationId") int applicationId,
         HttpSession session, RedirectAttributes redirectAttributes) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      try {
         partyDAO.approve(partyId, applicationId, loginId);
         redirectAttributes.addFlashAttribute("message", "승인했습니다.");
      } catch (IllegalArgumentException e) {
         redirectAttributes.addFlashAttribute("message", e.getMessage());
      }

      return "redirect:/party/applications?partyId=" + partyId;
   }

   @RequestMapping(value = "/reject", method = RequestMethod.POST)
   public String reject(@RequestParam("partyId") int partyId, @RequestParam("applicationId") int applicationId,
         HttpSession session, RedirectAttributes redirectAttributes) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      try {
         partyDAO.reject(partyId, applicationId, loginId);
         redirectAttributes.addFlashAttribute("message", "거절했습니다.");
      } catch (IllegalArgumentException e) {
         redirectAttributes.addFlashAttribute("message", e.getMessage());
      }
      return "redirect:/party/applications?partyId=" + partyId;
   }

   @RequestMapping(value = "/kick", method = RequestMethod.POST)
   public String kick(@RequestParam("partyId") int partyId, @RequestParam("memberId") String memberId,
         HttpSession session, RedirectAttributes redirectAttributes) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }

      try {
         partyDAO.kickMember(partyId, memberId, loginId);

         redirectAttributes.addFlashAttribute("message", "멤버를 내보냈습니다.");
      } catch (IllegalArgumentException e) {
         redirectAttributes.addFlashAttribute("message", e.getMessage());
      }
      return "redirect:/party/detail?partyId=" + partyId;
   }

   @RequestMapping(value = "/cancelApplication", method = RequestMethod.POST)
   public String cancelApplication(@RequestParam("partyId") int partyId, HttpSession session,
         RedirectAttributes redirectAttributes) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }
      try {
         partyDAO.cancelApplication(partyId, loginId);
         redirectAttributes.addFlashAttribute("message", "신청을 취소했습니다.");
      } catch (IllegalArgumentException e) {
         redirectAttributes.addFlashAttribute("message", e.getMessage());
      }
      return "redirect:/party/detail?partyId=" + partyId;
   }

   @RequestMapping(value = "/leave", method = RequestMethod.POST)
   public String leave(@RequestParam("partyId") int partyId, HttpSession session,
         RedirectAttributes redirectAttributes) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "redirect:/member/login";
      }
      try {
         partyDAO.leaveParty(partyId, loginId);
         redirectAttributes.addFlashAttribute("message", "모임에서 나왔습니다.");
      } catch (IllegalArgumentException e) {
         redirectAttributes.addFlashAttribute("message", e.getMessage());
      }
      return "redirect:/party/detail?partyId=" + partyId;
   }

   @ResponseBody
   @RequestMapping(value = "/bookmark", method = RequestMethod.POST)
   public String bookmark(@RequestParam("partyId") int partyId, HttpSession session) {

      String loginId = (String) session.getAttribute("loginId");

      if (loginId == null) {
         return "LOGIN";
      }

      if (partyDAO.isBookmarked(partyId, loginId)) {

         partyDAO.deleteBookmark(partyId, loginId);

         return "DELETE";

      } else {

         partyDAO.insertBookmark(partyId, loginId);

         return "INSERT";
      }
   }
   
   @RequestMapping("/edit")
   public String edit(
   		@RequestParam("partyId") int partyId,
   		HttpSession session,
   		Model model) {

   	String loginId =
   			(String) session.getAttribute("loginId");

   	if (loginId == null) {
   		return "redirect:/member/login";
   	}

   	PartyDTO party =
   			partyDAO.findById(partyId);

   	if (party == null) {
   		return "redirect:/party/list";
   	}

   	if (!loginId.equals(party.getHostId())) {
   		return "redirect:/party/detail?partyId=" + partyId;
   	}

   	String meetDateText =
   			party.getMeetDate()
   				.toLocalDateTime()
   				.toString()
   				.substring(0, 16);

   	model.addAttribute("party", party);
   	model.addAttribute("meetDateText", meetDateText);

   	return "party/edit";
   }
   
   @RequestMapping(value = "/update", method = RequestMethod.POST)
   public String update(
   		PartyDTO dto,
   		@RequestParam("meetDateText") String meetDateText,
   		HttpSession session,
   		Model model) {

   	String loginId =
   			(String) session.getAttribute("loginId");

   	if (loginId == null) {
   		return "redirect:/member/login";
   	}

   	PartyDTO original =
   			partyDAO.findById(dto.getPartyId());

   	if (original == null) {
   		return "redirect:/party/list";
   	}

   	if (!loginId.equals(original.getHostId())) {
   		return "redirect:/party/list";
   	}

   	dto.setHostId(loginId);

   	LocalDateTime meetDate =
   			LocalDateTime.parse(meetDateText);

   	dto.setMeetDate(
   			Timestamp.valueOf(meetDate)
   	);

   	if (dto.getTitle() == null
   			|| dto.getTitle().trim().isEmpty()) {

   		model.addAttribute(
   				"message",
   				"모임 제목을 입력해 주세요."
   		);

   		model.addAttribute("party", dto);
   		model.addAttribute("meetDateText", meetDateText);

   		return "party/edit";
   	}

   	if (!meetDate.isAfter(LocalDateTime.now())) {

   		model.addAttribute(
   				"message",
   				"모임 날짜는 현재 시간 이후로 선택해 주세요."
   		);

   		model.addAttribute("party", dto);
   		model.addAttribute("meetDateText", meetDateText);

   		return "party/edit";
   	}

   	partyDAO.update(dto);

   	return "redirect:/party/detail?partyId="
   			+ dto.getPartyId();
   }
}
