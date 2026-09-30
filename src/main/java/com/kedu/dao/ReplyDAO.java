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
	    String sql = "insert into reply(reply_id,post_id,member_id,parent_reply_id,content,like_count)"
	            + "values(reply_seq.nextval,?,?,nullif(?,0),?,0)";
//    nullif(a,b) >> a랑 b 같으면 null, 다르면 a반환 
//    이유 ReplyDTO.parentReplyId가 int라서 null을 못 담고, 일반 댓글은 0으로 넘어오기 때문
//    DB에 null로 넣고 싶어서 SQL에서 0을 null로 바꿔주기
	    jdbc.update(sql, dto.getPostId(), dto.getMemberId(), dto.getParentReplyId(), dto.getContent());
	}
	
	public void updateReply(ReplyDTO dto) {
		String sql = "update reply set content=? where reply_id=?";
		jdbc.update(sql, dto.getContent(),dto.getReplyId());
	}
	
	public void deleteReply(int replyId) {
	    String sql = "delete from reply where reply_id=? or parent_reply_id=?";
	    jdbc.update(sql, replyId, replyId);
	}
	public void deleteByPostId(int postId) {
	    String sql = "delete from reply where post_id=?";
	    jdbc.update(sql, postId);
	}
	
	public List<ReplyDTO> selectByPostId(int postId) {
		String sql = "select * from reply where post_id=? order by nvl(parent_reply_id, reply_id), reply_id";
	    return jdbc.query(sql, new BeanPropertyRowMapper<>(ReplyDTO.class), postId);
	}
//	nvl(a,b) >> a가 null이면 b, null이 아니면 a 반환
	public int countByPostId(int postId) {
	    String sql = "select count(*) from reply where post_id=?";
	    return jdbc.queryForObject(sql, Integer.class, postId);
	}
	
	
}
