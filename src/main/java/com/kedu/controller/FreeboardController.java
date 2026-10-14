package com.kedu.controller;

import java.io.File;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kedu.dao.FreeBoardDAO;
import com.kedu.dao.FreeBoardFileDAO;
import com.kedu.dao.FreeBoardLikeDAO;
import com.kedu.dao.FreeBoardReplyDAO;
import com.kedu.dao.MemberDAO;
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
	
	@Autowired
	private MemberDAO mdao;

	@RequestMapping("/freeboard")
	public String boardList(@RequestParam(defaultValue = "") String category,@RequestParam(defaultValue = "1") int cpage, @RequestParam(defaultValue = "") String search,
			Model model) throws Exception {				//search 기본값 ""공백으로놔서 검색안햇을때는 모든 리스트 불러오기
		search = search.trim();							//검색조건의 공백 없애기
		int recordCountPerPage = 10;
		int naviCountPerPage = 5;

		int recordTotalCount = dao.getTotalCount(search, category);		//검색조건과 카테고리가 설정되어있으면 개수 뽑기 
		int pageTotalCount = Math.max(1, (int) Math.ceil(recordTotalCount / (double) recordCountPerPage));	//전체 글 수로 총 페이지 수를 계산
		//Math.ceil = 반올림 / max(1 ...) = 최소값 1(글이 11개아래로 0개포함) 
		if (cpage < 1)
			cpage = 1;
		if (cpage > pageTotalCount)
			cpage = pageTotalCount;

		int startRow = cpage * recordCountPerPage - (recordCountPerPage - 1);	//한 페이지의 시작레코드
		int endRow = cpage * recordCountPerPage;								//한 페이지의 끝레코드

		model.addAttribute("list", dao.boardList(startRow, endRow, search, category));
		model.addAttribute("category", category);	//선택한 카테고리 고정
		model.addAttribute("recordTotalCount", recordTotalCount);
		model.addAttribute("recordCountPerPage", recordCountPerPage);
		model.addAttribute("naviCountPerPage", naviCountPerPage);
		model.addAttribute("cpage", cpage);
		model.addAttribute("search", search);	//검색 후 검색한 value 화면에 고정

		return "/FreeBoard/freeboard";
	}

	
	
	@RequestMapping("/write")		//글 작성 페이지로 이동
	public String write(HttpSession session, Model model) throws Exception {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId != null) {
			model.addAttribute("loginUsername", mdao.selectMember(loginId).getUsername());
		}
		return "/FreeBoard/write";
	}

	@RequestMapping("/writeup")		//작성완료 버튼 클릭시
	public String writeUp(FreeBoardDTO dto, HttpSession session, MultipartFile[] files) throws Exception {
		String loginId = (String) session.getAttribute("loginId");

		if (loginId == null) {
        return "redirect:/member/login";
    }
		
		dto.setMemberId(loginId);
		
		// 비관리자가 개발자도구로 "공지"를 보내도 서버에서 "자유"로 바꿔 막음
		if ("공지".equals(dto.getContentCategory()) && !"admin".equals(loginId)) {
			dto.setContentCategory("자유");
		}
		
		int thisSeq = dao.getNextSeq();		//다음 글번호 미리 뽑는다
		dao.writeUp(thisSeq, dto);			//뽑은 글번호로 글을 저장(seq.nextval사용안함)
		
		
		String path = "d:/uploads/";		//첨부파일 저장

		for (MultipartFile file : files) {
			if (file.isEmpty()) {
				continue;		//파일이 비어있으면 files배열에서 빈 항목 저장 안하고 건너뜀
			}
			String oriName = file.getOriginalFilename();		//파일명 (사용자에게 보여줄 이름)
			String sysName = UUID.randomUUID() + "_" + oriName;	//실제로 저장할 이름. 앞에 랜덤문자열 붙혀서 겹치지 않게함(덮어씌워지지않게)
			file.transferTo(new File(path + sysName));			//업로드된 파일을 폴더에 저장
			fdao.insert(oriName, sysName, thisSeq);				// DB에 저장용.(detail.jsp)에서 뽑아쓰기 위함
		}
		return "redirect:/FreeBoard/freeboard?cpage=1";
	}

	@RequestMapping("/detail")
	public String detail(HttpSession session,int postId, Model model, @RequestParam(defaultValue = "1") int cpage) throws Exception {

		model.addAttribute("post", dao.detail(postId)); // viewCount+1포함
		model.addAttribute("replyList", rdao.selectByPostId(postId));	//게시글 번호로 댓글조회
		model.addAttribute("commentCount", rdao.countByPostId(postId));	//조회한 댓글 수
		model.addAttribute("fileList", fdao.fileList(postId));	//게시글 번호로 파일 조회
		model.addAttribute("cpage", cpage);
		
		String loginId = (String) session.getAttribute("loginId");
		if (loginId != null) {
			model.addAttribute("loginUsername", mdao.selectMember(loginId).getUsername());
		}
		model.addAttribute("liked", loginId != null && ldao.likeCheck(postId, loginId));
							// 게시글 번호&로그인 아이디 로 추천이 눌러져 있는지 체크
		return "/FreeBoard/detail";
	}

	@RequestMapping("/updateContent")
	public String updateContent(HttpSession session,FreeBoardDTO dto, Model model, @RequestParam(defaultValue = "1") int cpage,
			MultipartFile[] files, @RequestParam(required = false) int[] deleteFileId) throws Exception {
		String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null || !dao.isWriter(dto.getPostId(), loginId)) {
	        return "redirect:/FreeBoard/detail?postId=" + dto.getPostId() + "&cpage=" + cpage;
	    }
		
	    // 수정으로도 공지로 바꾸는 걸 막음 (쓰기만 막으면 반쪽이라 똑같이 한 번 더)
	    if ("공지".equals(dto.getContentCategory()) && !"admin".equals(loginId)) {
	        dto.setContentCategory("자유");
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
	    if (loginId == null || !dao.isWriter(postId, loginId)) {	//로그인하지 않았거나 로그인한 사람과 작성자가 다르면 detail화면으로 돌려보냄
	        return "redirect:/FreeBoard/detail?postId=" + postId + "&cpage=" + cpage;
	    }
		
		
		for (FreeBoardFileDTO f : fdao.fileList(postId)) {	//postid로 게시글에 첨부된 파일정보 하나씩 가져옴
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

		boolean likeCheckResult = ldao.likeCheck(postId, memberId);	//ajax로 추천버튼 눌렀을때 이미 누른상태인지 체크

		if (likeCheckResult) {	//추천을 이미 눌렀다면
			dao.likeCountMinus(postId);	//추천 내리기
			ldao.likeCountMinus(postId, memberId);	//추천 기록 삭제
		} else {
			dao.likeCountPlus(postId);	//추천 누르기
			ldao.likeCountPlus(postId, memberId);	//추천 기록 추가
		}

		int liked = dao.getLikeCount(postId);	//최신 추천수
		return liked + "," + (likeCheckResult ? 0 : 1);	// "추천수,내추천상태(1=눌림)"
	}
}
