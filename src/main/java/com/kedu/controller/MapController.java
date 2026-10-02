package com.kedu.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kedu.dao.Good_StoreDAO;
import com.kedu.dto.Good_StoreDTO;
import com.kedu.dto.Store_ServiceDTO;

@Controller
@RequestMapping("map")
public class MapController {


	@Autowired
	private Good_StoreDAO dao;

	
	@RequestMapping("main")
	public String main () {
		return "map/main";
	}
	
	@ResponseBody
	@RequestMapping("ajax/store")
	public List<Good_StoreDTO> store(double swLat, double swLng, double neLat, double neLng , String category) {
		return  dao.listByBounds(swLat, swLng, neLat, neLng , category);
		 
	}
	
	@ResponseBody
	@RequestMapping("ajax/service")
	public List<Store_ServiceDTO> service (int storeId){
		return dao.listService(storeId);
	}
}
