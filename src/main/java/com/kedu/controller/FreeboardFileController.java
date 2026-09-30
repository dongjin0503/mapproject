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


	@RequestMapping("/download")
	public void download(String sysname, String oriname, HttpServletResponse resp) throws Exception {

		File target = new File("d:/uploads/" + sysname);

		oriname = new String(oriname.getBytes(), "ISO-8859-1");

		// 지금 resp에 태워 보내는 데이터는 HTML이 아니라 파일 스트림이다
		resp.setContentType("application/octet-stream");
		resp.setHeader("Content-Disposition", "attachment; filename=\"" + oriname + "\"");

		FileInputStream fis = new FileInputStream(target);
		FileCopyUtils.copy(fis, resp.getOutputStream());
	}

}
