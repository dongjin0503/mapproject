package com.kedu.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.ReplyDTO;

@Repository
public class ReplyDAO {

	@Autowired
	private JdbcTemplate jdbc;
	
	public void addReply(ReplyDTO dto) {
		String sql = "insert into reply(reply_id,post_id,member_id,parent_reply_id,content,like_count"
				+"values(reply_seq.nextval,?,?,?,?,?)";
		jdbc.update(sql, dto.getPostId(),dto.getMemberId(),dto.getReplyId(),dto.getContent(),0);
	}
	
	
}
