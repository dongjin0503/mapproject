package com.kedu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class FreeBoardLikeDAO {

	@Autowired
	private JdbcTemplate jdbc;

	public boolean likeCheck(int postId, String memberId) {
		String sql = "select count(*) from freeboard_like where post_id=? and member_id=?";
		int result = jdbc.queryForObject(sql, Integer.class, postId, memberId);
		if (result > 0) {
			return true;
		} else {
			return false;
		}
	}

	public int likeCountMinus(int postId, String memberId) {
		String sql = "delete from freeboard_like where post_id=? and member_id=?";
		return jdbc.update(sql, postId,memberId);
	}

	public int likeCountPlus(int postId, String memberId) {
		String sql = "insert into freeboard_like(like_id,post_id,member_id)"
				+ "values(seq_freeboard_like.nextval,?,?)";
		return jdbc.update(sql, postId, memberId);
	}
	
	public void deleteLike(int postId) {
		String sql = "delete from freeboard_like where post_id=?";
		jdbc.update(sql,postId);
	}
}