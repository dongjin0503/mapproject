package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.BestDTO;

@Repository
public class BestBoardDAO {

	@Autowired
	private JdbcTemplate jdbc;
	
	public List<BestDTO> listBest() {
		String sql = "select * from (select "
				+ "row_number() over(order by f.like_count desc, f.view_count desc, f.post_id desc) as rn, "
				+ "f.post_id as postId, f.title as title, f.content_category as category, "
				+ "f.like_count as likeCount, f.view_count as viewCount, m.username as username, "
				+ "(select count(*) from freeboard_reply r where r.post_id = f.post_id) as replyCount "
				+ "from freeboard f left join member m on f.member_id = m.member_id "
				+ "where nvl(f.content_category, ' ') <> '공지' and f.like_count > 0) "
				+ "where rn <= 10 order by rn";
		return jdbc.query(sql, new BeanPropertyRowMapper<BestDTO>(BestDTO.class));
	}
	
}
