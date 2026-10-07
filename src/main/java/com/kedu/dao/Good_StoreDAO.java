package com.kedu.dao;

import java.util.ArrayList;
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

	public List<Good_StoreDTO> listByBounds(double swLat, double swLng, double neLat, double neLng , String[] category , int price) {
		
		List<Object> args = new ArrayList<>();
		
		String sql = "select good_store.*, (select min(price) from store_service where store_service.store_id = good_store.store_id) as min_price"
				+ " from good_store where latitude between ? and ? and longitude between ? and ?";

		args.add(swLat);
		args.add(neLat);
		args.add(swLng);
		args.add(neLng);
		
		if(category != null && category.length > 0 ) {
			sql = sql + " and category in (";
			
			for (int i=0; i < category.length; i++) {
				if(i >0) {
					sql = sql + ",";
				}
				sql = sql + "?";
				args.add(category[i]);
		}
			sql = sql + ")";
		}
		
		if (price > 0) {
			sql = sql + " and exists (select 1 from store_service s where s.store_id = good_store.store_id and s.price <= ?)";
			args.add(price);
		}

		sql = "select * from (" + sql + ") where rownum <= 1000";
		
		
		return jdbc.query(sql, new BeanPropertyRowMapper<>(Good_StoreDTO.class), args.toArray());
		}
	



	public List<Store_ServiceDTO> listService(int storeId) {
		String sql = "select * from store_service where store_id = ? order by service_id";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(Store_ServiceDTO.class), storeId);
	}
	
	public boolean isBookmarked(String memberId , int storeId ) {
	String sql = "select count(*) from bookmark where member_id = ? and content_type = 'STORE' and content_id = ?";
	int cnt = jdbc.queryForObject(sql, Integer.class, memberId, storeId);
	return cnt > 0 ;
	}
	
	public int addBookmark(String memberId , int storeId) {
		String sql = "insert into bookmark(bookmark_id, member_id, content_type, content_id) values(seq_bookmark.nextval ,? ,'STORE' ,?) ";
		return  jdbc.update(sql , memberId, storeId);			
	}
	
	public int removeBookmark(String memberId, int storeId) {
		String sql = "delete from bookmark where member_id = ? and content_type = 'STORE' and content_id = ?";
		return jdbc.update(sql, memberId, storeId);
	}
	
	public Good_StoreDTO selectOne(int storeId) {
		String sql = "select * from good_store where store_id=?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(Good_StoreDTO.class),storeId);
	}
}
