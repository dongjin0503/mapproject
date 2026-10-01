package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.Good_StoreDTO;
import com.kedu.dto.Store_ServiceDTO;

@Repository
public class Good_StoreDAO {

	@Autowired
	private JdbcTemplate jdbc;

	public List<Good_StoreDTO> listByBounds(double swLat, double swLng, double neLat, double neLng) {
		// 
		String sql = "select * from (select * from good_store where latitude between ? and ? and longitude between ? and ?) where rownum <= 1000";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(Good_StoreDTO.class), swLat, swLng, neLat, neLng);
	}

	public List<Store_ServiceDTO> listService(int storeId) {
		String sql = "select * from store_service where store_id = ? order by service_id";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(Store_ServiceDTO.class), storeId);
	}
}
