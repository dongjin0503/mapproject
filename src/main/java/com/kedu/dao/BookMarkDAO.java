package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.BookMarkDTO;

@Repository
public class BookMarkDAO {
	
	@Autowired
	private JdbcTemplate jdbc;
	
	public int insertBookmark(String memberId, String contentType, int contentId) {
	    String sql = "insert into bookmark (bookmark_id, member_id, content_type, content_id) "
	               + "values (seq_bookmark.nextval, ?, ?, ?)";
	    return jdbc.update(sql, memberId, contentType, contentId);
	}
	public boolean existsBookmark(String memberId, String contentType, int contentId) {
	    String sql = "select count(*) from bookmark where member_id = ? and content_type = ? and content_id = ?";
	    int count = jdbc.queryForObject(sql, Integer.class, memberId, contentType, contentId);
	    return count > 0;
	}

	public int deleteBookmark(String memberId, String contentType, int contentId) {
	    String sql = "delete from bookmark where member_id = ? and content_type = ? and content_id = ?";
	    return jdbc.update(sql, memberId, contentType, contentId);
	}
	
	
	public List<BookMarkDTO> bookmarkList(String loginId) {
		String sql = "select b.bookmark_id, b.content_type, b.content_id, p.title, null as category, b.created_at "
		           + "from bookmark b join party p on b.content_type = 'PARTY' and b.content_id = p.party_id "
		           + "where b.member_id = ? "
		           + "union all "
		           + "select b.bookmark_id, b.content_type, b.content_id, c.title, null as category, b.created_at "
		           + "from bookmark b join challenge c on b.content_type = 'CHALLENGE' and b.content_id = c.challenge_id "
		           + "where b.member_id = ? "
		           + "union all "
		           + "select b.bookmark_id, b.content_type, b.content_id, s.store_name as title, s.category, b.created_at "
		           + "from bookmark b join good_store s on b.content_type = 'STORE' and b.content_id = s.store_id "
		           + "where b.member_id = ? "
		           + "order by created_at desc";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(BookMarkDTO.class),loginId, loginId, loginId);
	}
	

}
