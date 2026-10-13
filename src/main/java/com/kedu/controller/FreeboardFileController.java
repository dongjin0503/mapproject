package com.kedu.controller;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/FreeBoardFile")
public class FreeboardFileController {


	@RequestMapping("/download")		// detail.jsp에서 첨부파일 링크 눌렀을때 서버 폴더의 파일 다운로드
	public void download(String sysname, String oriname, HttpServletResponse resp) throws Exception {
		//반환타입 void여도 파일이 다운되는 이유는 resp에 파일을 실어 보내기 때문
		
		
		
		//업로드 때 저장한 폴더(d:/uploads/)와 sysname을 합쳐서 실제 파일 가리킴
		File target = new File("d:/uploads/" + sysname);	//서버가 파일을 찾는다
		
		oriname = new String(oriname.getBytes("UTF-8"), "ISO-8859-1");	//한글 파일명용 관용구

		//지금 resp에 태워 보내는 데이터는 HTML이 아니라 파일 스트림이다
		resp.setContentType("application/octet-stream");
		
		//화면에 띄우지 말고 첨부파일로 저장 (다운로드 창띄움)
		resp.setHeader("Content-Disposition", "attachment; filename=\"" + oriname + "\"");
		
		FileInputStream fis = new FileInputStream(target);	//서버 폴더의 파일을 읽는 통로
		FileCopyUtils.copy(fis, resp.getOutputStream());	//읽는 통로의 내용을 보내는 통로로 통째로 복사
	}

}
