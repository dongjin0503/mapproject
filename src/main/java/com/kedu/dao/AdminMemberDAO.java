package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.kedu.dto.MemberDTO;

@Repository
public class AdminMemberDAO {

	@Autowired
	private JdbcTemplate jdbc;
	
	@Autowired
	private PartyDAO partyDAO;
	
	public List<MemberDTO> listMember(String keyword){
		
		String sql = "select member_id as id , username, name , phone , email , gender ,regdate "
				+ "from member where member_id like ? or username like ? or name like ? "
				+ "order by regdate desc";
		
		String k = "%" + keyword + "%";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(MemberDTO.class), k , k , k);
	}
	
	@Transactional
	public int deleteMember(String id) {
	    if (!"admin".equals(id)) {
	        partyDAO.notifyPartiesCanceledByHost(id);  
	    }
		String sql = "delete from member where member_id = ? and member_id <> 'admin'";
		return jdbc.update(sql ,id);
	}
	
	
}
