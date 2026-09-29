package com.kedu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kedu.dao.FreeBoardDAO;
import com.kedu.dao.FreeBoardLikeDAO;
import com.kedu.dao.ReplyDAO;
import com.kedu.dto.FreeBoardDTO;

@Controller
@RequestMapping("/FreeBoard")
public class FreeboardController {

	@Autowired
	private FreeBoardDAO dao;

	@Autowired
	private ReplyDAO rdao;
	
	@Autowired
	private FreeBoardLikeDAO ldao;

	@RequestMapping("/freeboard")
	public String boardList(@RequestParam(defaultValue = "1") int cpage, Model model) throws Exception {
		int recordCountPerPage = 10;
		int naviCountPerPage = 5;

		int recordTotalCount = dao.getTotalCount();
		int pageTotalCount = Math.max(1, (int) Math.ceil(recordTotalCount / (double) recordCountPerPage));
		if (cpage < 1)
			cpage = 1;
		if (cpage > pageTotalCount)
			cpage = pageTotalCount;

		int startRow = cpage * recordCountPerPage - (recordCountPerPage - 1);
		int endRow = cpage * recordCountPerPage;

		model.addAttribute("list", dao.boardList(startRow, endRow));
		model.addAttribute("recordTotalCount", recordTotalCount);
		model.addAttribute("recordCountPerPage", recordCountPerPage);
		model.addAttribute("naviCountPerPage", naviCountPerPage);
		model.addAttribute("cpage", cpage);

		return "/FreeBoard/freeboard";
	}

	@RequestMapping("/write")
	public String write() throws Exception {

		return "/FreeBoard/write";
	}

	@RequestMapping("/writeup")
	public String writeUp(FreeBoardDTO dto) throws Exception {
		dao.writeUp(dto);

		return "redirect:/FreeBoard/freeboard";
	}

	@RequestMapping("/detail")
	public String detail(int postId, Model model, int cpage) throws Exception {
		model.addAttribute("post", dao.detail(postId));
		model.addAttribute("replyList", rdao.selectByPostId(postId));
		model.addAttribute("commentCount", rdao.countByPostId(postId));
		model.addAttribute("cpage", cpage);

		return "/FreeBoard/detail";
	}

	@RequestMapping("/updateContent")
	public String updateContent(FreeBoardDTO dto, Model model) throws Exception {
		dao.updateContent(dto);

		return "redirect:/FreeBoard/detail?postId=" + dto.getPostId();
	}

	@RequestMapping("/deleteContent")
	public String deleteContent(int postId, int cpage) throws Exception {

		rdao.deleteByPostId(postId);

		dao.deleteContent(postId);

		return "redirect:/FreeBoard/freeboard?cpage=" + cpage;
	}

	@ResponseBody
	@RequestMapping(value="/likecount", produces="text/plain; charset=UTF-8")
	public String likecount(int postId,String memberId) throws Exception {
		boolean likeCheckResult = ldao.likeCheck(postId,memberId);

		if (likeCheckResult) {
			  dao.likeCountMinus(postId);
			  ldao.likeCountMinus(postId,memberId);
			  return "";
		} else {
			dao.likeCountPlus(postId);
			ldao.likeCountPlus(postId,memberId);	
			return "";
		}
	}

}
