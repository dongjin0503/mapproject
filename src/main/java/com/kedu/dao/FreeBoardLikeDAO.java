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

	public void likeCountMinus(int postId, String memberId) {
		String sql = "delete from freeboard_like where post_id=? and member_id=?";
		jdbc.update(sql, postId,memberId);
	}

	public void likeCountPlus(int postId, String memberId) {
		String sql = "insert into freeeboard_like(like_id,post_id,member_id)"
				+ "values(seq_freeboard_like.nextval,?,?)";
		jdbc.update(sql, postId, memberId);	
	}

}
