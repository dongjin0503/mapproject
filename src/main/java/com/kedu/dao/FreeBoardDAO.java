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

	public List<FreeBoardDTO> boardList(int start, int end, String search) {
	    String sql = "select * from (" + "  select row_number() over(order by post_id desc) rn, f.* from freeboard f where title like ?"
	            + ") where rn between ? and ?";
	    return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), "%" + search + "%", start, end);
	}

	public List<FreeBoardDTO> searchTitle(String search) throws Exception {
		String sql = "select * from freeboard where title like ? order by post_id desc";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), "%" + search + "%");
	}

	public int getNextSeq() {
		String sql = "select seq_freeboard.nextval from dual";
		return jdbc.queryForObject(sql, Integer.class);
	}

	public void writeUp(int postId, FreeBoardDTO dto) {
	       String sql = "insert into freeboard(post_id, member_id, title, content_category, content, view_count, like_count) values(?, ?, ?, ?, ?, 0, 0)";
	       jdbc.update(sql, postId, dto.getMemberId(), dto.getTitle(), dto.getContentCategory(), dto.getContent());
	   }

	public FreeBoardDTO detail(int postId) {

		String sql1 = "update freeboard set view_count=view_count+1 where post_id = ?";
		jdbc.update(sql1, postId);

		String sql = "select * from freeboard where post_id=?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), postId);
	}

	public void updateContent(FreeBoardDTO dto) {
		String sql = "update freeboard set title=?,content_category=?,content=? where post_id=?";
		jdbc.update(sql, dto.getTitle(), dto.getContentCategory(), dto.getContent(), dto.getPostId());
	}

	public void deleteContent(int postId) {
		String sql = "delete from freeboard where post_id=?";
		jdbc.update(sql, postId);
	}

	public int getTotalCount(String search) {
	    String sql = "select count(*) from freeboard where title like ?";
	    return jdbc.queryForObject(sql, Integer.class, "%" + search + "%");
	}

	public void likeCountPlus(int postId) {
		String sql = "update freeboard set like_count=like_count+1 where post_id=?";
		jdbc.update(sql, postId);
	}

	public void likeCountMinus(int postId) {
		String sql = "update freeboard set like_count=like_count-1 where post_id=?";
		jdbc.update(sql, postId);
	}

	public int getLikeCount(int postId) {
		String sql = "select like_count from freeboard where post_id=?";
		return jdbc.queryForObject(sql, Integer.class, postId);
	}

}
