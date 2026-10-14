package com.kedu.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.BestBoardDAO;
import com.kedu.dto.BestDTO;

@Controller
@RequestMapping("/best")
public class BestController {

	@Autowired
	private BestBoardDAO dao;
	
	@RequestMapping("/board")
	public String board(Model model) {
	
		List<BestDTO> list = dao.listBest();
		
		List<BestDTO> top3 = new ArrayList<BestDTO>();
		List<BestDTO> rest = new ArrayList<BestDTO>();
		
		for (int i =0; i < list.size(); i++) {
			if (i < 3) {
				top3.add(list.get(i));
			} else {
				rest.add(list.get(i));
			}
		}
		
		model.addAttribute("list",list);
		model.addAttribute("top3",top3);
		model.addAttribute("rest",rest);
		
		return "best/board";
	}
}
