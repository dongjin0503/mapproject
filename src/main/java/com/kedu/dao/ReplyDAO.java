package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.ReplyDTO;

@Repository
public class ReplyDAO {

	@Autowired
	private JdbcTemplate jdbc;
	
	public void addReply(ReplyDTO dto) {
		String sql = "insert into reply(reply_id,post_id,member_id,content,like_count)"
				+"values(reply_seq.nextval,?,?,?,0)";
		jdbc.update(sql, dto.getPostId(),dto.getMemberId(),dto.getContent());
	}
	
	public void updateReply(ReplyDTO dto) {
		String sql = "update reply set content=? where reply_id=?";
		jdbc.update(sql, dto.getContent(),dto.getReplyId());
	}
	
	public void deleteReply(int replyId) {
		String sql = "delete from reply where reply_id=?";
		jdbc.update(sql, replyId);
	}
	public void deleteByPostId(int postId) {
	    String sql = "delete from reply where post_id=?";
	    jdbc.update(sql, postId);
	}
	
	public List<ReplyDTO> selectByPostId(int postId) {
	    String sql = "select * from reply where post_id=? order by reply_id";
	    return jdbc.query(sql, new BeanPropertyRowMapper<>(ReplyDTO.class), postId);
	}

	public int countByPostId(int postId) {
	    String sql = "select count(*) from reply where post_id=?";
	    return jdbc.queryForObject(sql, Integer.class, postId);
	}
}
