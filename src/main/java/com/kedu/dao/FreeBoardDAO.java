package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.FreeBoardDTO;

@Repository
public class FreeBoardDAO {

	
	@Autowired
	private JdbcTemplate jdbc;
	
	public List<FreeBoardDTO> boardList(){
		String sql = "select * from freeboard";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class));
	}
	
	public void writeUp(FreeBoardDTO dto) {
		String sql = "insert into freeboard(post_id, member_id, title, content_category, content, view_count, like_count)"
				+ "values(seq_freeboard.nextval,?, ?, ?, ?, 0,0)";
		jdbc.update(sql, dto.getMemberId(),dto.getTitle(),dto.getTitle(),dto.getContentCategory());
	}
	
	public FreeBoardDTO detail(int postId) {
		String sql = "select * from freeboard where postId=?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), postId);
	}
	
	public void updateContent(FreeBoardDTO dto) {
		String sql = "update freeboard set title=?,content_category=?,content=?";
		jdbc.update(sql, dto.getTitle(),dto.getContentCategory(),dto.getContent());
	}
	
	public void deleteContent(int postId) {
		String sql = "delete from freeboard where postId=?";
		jdbc.update(sql, postId);
	}
	
	
}
