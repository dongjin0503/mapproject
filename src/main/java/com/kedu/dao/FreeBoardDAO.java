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
	
	public List<FreeBoardDTO> boardList(int start, int end) {
	    String sql = "select * from ("
	               + "  select row_number() over(order by post_id desc) rn, f.* from freeboard f"
	               + ") where rn between ? and ?";
	    return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), start, end);
	}
	
	public void writeUp(FreeBoardDTO dto) {
		String sql = "insert into freeboard(post_id, member_id, title, content_category, content, view_count, like_count)"
				+ "values(seq_freeboard.nextval,?, ?, ?, ?, 0,0)";
		jdbc.update(sql, dto.getMemberId(),dto.getTitle(),dto.getContentCategory(),dto.getContent());
	}
	
	public FreeBoardDTO detail(int postId) {
		String sql = "select * from freeboard where post_id=?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), postId);
	}
	
	public void updateContent(FreeBoardDTO dto) {
		String sql = "update freeboard set title=?,content_category=?,content=? where post_id=?";
		jdbc.update(sql, dto.getTitle(),dto.getContentCategory(),dto.getContent(),dto.getPostId());
	}
	
	public void deleteContent(int postId) {
		String sql = "delete from freeboard where post_id=?";
		jdbc.update(sql, postId);
	}
	
	public int getTotalCount() {
	    String sql = "select count(*) from freeboard";
	    return jdbc.queryForObject(sql, Integer.class);
	}
	
	
}
