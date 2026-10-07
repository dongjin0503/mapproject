package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.FreeBoardReplyDTO;

@Repository
public class FreeBoardReplyDAO {
	
	@Autowired
	private JdbcTemplate jdbc;
	
	public void addReply(FreeBoardReplyDTO dto) {
	    String sql = "insert into freeboard_reply(freeboard_reply_id,post_id,member_id,parent_reply_id,content,like_count)"
	            + "values(seq_freeboard_reply.nextval,?,?,nullif(?,0),?,0)";
//    nullif(a,b) >> a랑 b 같으면 null, 다르면 a반환 
//    이유 ReplyDTO.parentReplyId가 int라서 null을 못 담고, 일반 댓글은 0으로 넘어오기 때문
//    DB에 null로 넣고 싶어서 SQL에서 0을 null로 바꿔주기
	    jdbc.update(sql, dto.getPostId(), dto.getMemberId(), dto.getParentReplyId() == null ? 0 : dto.getParentReplyId(), dto.getContent());
	}
	
	public void updateReply(FreeBoardReplyDTO dto) {
		String sql = "update freeboard_reply set content=? where freeboard_reply_id=?";
		jdbc.update(sql, dto.getContent(),dto.getReplyId());
	}
	
	public void deleteReply(int replyId) {
	    String sql = "delete from freeboard_reply where freeboard_reply_id=? or parent_reply_id=?";
	    jdbc.update(sql, replyId, replyId);
	}
	public void deleteByPostId(int postId) {
	    String sql = "delete from freeboard_reply where post_id=?";
	    jdbc.update(sql, postId);
	}
	
	public List<FreeBoardReplyDTO> selectByPostId(int postId) {
		String sql = "select r.*, r.freeboard_reply_id as reply_id from freeboard_reply r "
		           + "where r.post_id=? order by nvl(r.parent_reply_id, r.freeboard_reply_id), r.freeboard_reply_id";
	    return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardReplyDTO.class), postId);
	}
//	nvl(a,b) >> a가 null이면 b, null이 아니면 a 반환
	public int countByPostId(int postId) {
	    String sql = "select count(*) from freeboard_reply where post_id=?";
	    return jdbc.queryForObject(sql, Integer.class, postId);
	}
	public boolean isWriter(int replyId, String memberId) {
	    String sql = "select count(*) from freeboard_reply where freeboard_reply_id=? and member_id=?";
	    return jdbc.queryForObject(sql, Integer.class, replyId, memberId) > 0;
	}
}