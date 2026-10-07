package com.kedu.controller;

import java.io.File;
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

import com.kedu.dao.FreeBoardDAO;
import com.kedu.dao.FreeBoardFileDAO;
import com.kedu.dao.FreeBoardLikeDAO;
import com.kedu.dao.FreeBoardReplyDAO;
import com.kedu.dto.FreeBoardDTO;
import com.kedu.dto.FreeBoardFileDTO;

@Controller
@RequestMapping("/FreeBoard")
public class FreeboardController {

	@Autowired
	private FreeBoardDAO dao;

	@Autowired
	private FreeBoardReplyDAO rdao;

	@Autowired
	private FreeBoardLikeDAO ldao;

	@Autowired
	private FreeBoardFileDAO fdao;

	@RequestMapping("/freeboard")
	public String boardList(@RequestParam(defaultValue = "") String category,@RequestParam(defaultValue = "1") int cpage, @RequestParam(defaultValue = "") String search,
			Model model) throws Exception {				//search 기본값 ""공백으로놔서 검색안햇을때는 모든 리스트 불러오기
		search = search.trim();							//검색조건의 공백 없애기
		int recordCountPerPage = 10;
		int naviCountPerPage = 5;

		int recordTotalCount = dao.getTotalCount(search, category);
		int pageTotalCount = Math.max(1, (int) Math.ceil(recordTotalCount / (double) recordCountPerPage));
		if (cpage < 1)
			cpage = 1;
		if (cpage > pageTotalCount)
			cpage = pageTotalCount;

		int startRow = cpage * recordCountPerPage - (recordCountPerPage - 1);
		int endRow = cpage * recordCountPerPage;

		model.addAttribute("list", dao.boardList(startRow, endRow, search, category));
		model.addAttribute("category", category);
		model.addAttribute("recordTotalCount", recordTotalCount);
		model.addAttribute("recordCountPerPage", recordCountPerPage);
		model.addAttribute("naviCountPerPage", naviCountPerPage);
		model.addAttribute("cpage", cpage);
		model.addAttribute("search", search);

		return "/FreeBoard/freeboard";
	}

//	@RequestMapping("/search")		boardList 메소드에서 검색까지 처리(필요없단소리)
//	public String search(String search, Model model) throws Exception {
//
//		List<FreeBoardDTO> searchList = dao.searchTitle(search);
//		model.addAttribute("searchList", searchList);
//
//		return "/FreeBoard/freeboard";
//	}

	@RequestMapping("/write")
	public String write() throws Exception {

		return "/FreeBoard/write";
	}

	@RequestMapping("/writeup")
	public String writeUp(FreeBoardDTO dto, HttpSession session, MultipartFile[] files) throws Exception {
		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
        return "redirect:/member/login";
    }
		
		dto.setMemberId(loginId);
		
		int thisSeq = dao.getNextSeq();
		dao.writeUp(thisSeq, dto);
		String path = "d:/uploads/";

		for (MultipartFile file : files) {
			if (file.isEmpty()) {
				continue;
			}
			String oriName = file.getOriginalFilename();
			String sysName = UUID.randomUUID() + "_" + oriName;
			file.transferTo(new File(path + sysName));
			fdao.insert(oriName, sysName, thisSeq);
		}
		return "redirect:/FreeBoard/freeboard?cpage=1";
	}

	@RequestMapping("/detail")
	public String detail(HttpSession session,int postId, Model model, @RequestParam(defaultValue = "1") int cpage) throws Exception {

		model.addAttribute("post", dao.detail(postId)); // viewCount+1포함
		model.addAttribute("replyList", rdao.selectByPostId(postId));
		model.addAttribute("commentCount", rdao.countByPostId(postId));
		model.addAttribute("fileList", fdao.fileList(postId));
		model.addAttribute("cpage", cpage);
		
		String loginId = (String) session.getAttribute("loginId");
		model.addAttribute("liked", loginId != null && ldao.likeCheck(postId, loginId));	// 내가 추천했는지

		return "/FreeBoard/detail";
	}

	@RequestMapping("/updateContent")
	public String updateContent(HttpSession session,FreeBoardDTO dto, Model model, @RequestParam(defaultValue = "1") int cpage,
			MultipartFile[] files, @RequestParam(required = false) int[] deleteFileId) throws Exception {
		String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null || !dao.isWriter(dto.getPostId(), loginId)) {
	        return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
	    }
		
		dao.updateContent(dto);

		// 삭제 체크한 파일 (다른 글의 파일은 못 지우게 postId 확인)
		if (deleteFileId != null) {
			for (int fileId : deleteFileId) {
				FreeBoardFileDTO fdto = fdao.selectById(fileId);
				if (fdto.getPostId() == dto.getPostId()) {
					new File("d:/uploads/" + fdto.getSysname()).delete();
					fdao.delete(fileId);
				}
			}
		}
		// 새로 추가한 파일 (writeUp과 같은 방식)
		if (files != null) {
			for (MultipartFile file : files) {
				if (file.isEmpty()) {
					continue;
				}
				String oriName = file.getOriginalFilename();
				String sysName = UUID.randomUUID() + "_" + oriName;
				file.transferTo(new File("d:/uploads/" + sysName));
				fdao.insert(oriName, sysName, dto.getPostId());
			}
		}
		return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
	}

	@RequestMapping(value = "/deleteContent", method = RequestMethod.POST)
	public String deleteContent(HttpSession session, int postId, @RequestParam(defaultValue = "1") int cpage) throws Exception {
		
		
		String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null || !dao.isWriter(postId, loginId)) {
	        return "redirect:/FreeBoard/detail?postId=" + postId + "&cpage=" + cpage;
	    }
		
		
		for (FreeBoardFileDTO f : fdao.fileList(postId)) {
		    new File("d:/uploads/" + f.getSysname()).delete();   // 실제 파일 삭제
		    fdao.delete(f.getFileId());                          // DB 정보 삭제
		}
		rdao.deleteByPostId(postId);								// 댓글 삭제
		ldao.deleteLike(postId);									// 추천 삭제
		dao.deleteContent(postId);									// 게시물 삭제

		return "redirect:/FreeBoard/freeboard?cpage=" + cpage;
	}

	@ResponseBody
	@RequestMapping(value = "/likecount", produces = "text/plain; charset=UTF-8")	//좋아요 눌렀을때 406같은 에러뜨면 produces부분 삭제
	public String likecount(int postId, HttpSession session) throws Exception {
		String memberId = (String) session.getAttribute("loginId");
		if (memberId == null) {
		    return "-1";
		}

		boolean likeCheckResult = ldao.likeCheck(postId, memberId);

		if (likeCheckResult) {
			dao.likeCountMinus(postId);
			ldao.likeCountMinus(postId, memberId);
		} else {
			dao.likeCountPlus(postId);
			ldao.likeCountPlus(postId, memberId);
		}

		int liked = dao.getLikeCount(postId);
		return liked + "," + (likeCheckResult ? 0 : 1);	// "추천수,내추천상태(1=눌림)"
	}
}
