package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.MemberDTO;

@Repository
public class MemberDAO {

	@Autowired
	private JdbcTemplate jdbc;

	public int signup(MemberDTO dto) {
		String sql = "INSERT INTO MEMBER "
				+ "(MEMBER_ID, USERNAME, PASSWORD, NAME, PHONE, EMAIL, ZIPCODE, ADDRESS1, ADDRESS2, BIRTH_DATE, GENDER) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		return jdbc.update(sql, dto.getId(), dto.getUsername(), dto.getPw(), dto.getName(), dto.getPhone(),
				dto.getEmail(), dto.getZipcode(), dto.getAddress1(), dto.getAddress2(), dto.getBirth_date(),
				dto.getGender());
	}

	public boolean login(MemberDTO dto) {
		System.out.println("·Î±×ÀÎ µµÂø");
		String sql = "select count(*) from member where member_id = ? and password =?";
		
		int result = jdbc.queryForObject(sql, Integer.class, dto.getId(), dto.getPw());

		return result > 0;
	}

	public void update(MemberDTO dto, String loginId) {
		String sql = "update member set name , phone, email, zipcode , address1 , address2 , birth_date ";
		jdbc.update(sql, dto.getName(), dto.getPhone(), dto.getEmail(), dto.getZipcode(), dto.getAddress1(),
				dto.getAddress2(), dto.getBirth_date());
	}

	public MemberDTO selectMember(String id) {
		String sql = "select *from member where member_id = ?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(MemberDTO.class), id);

	}
	
	public void delete(MemberDTO dto) {
		String sql = "delete from member where member_id =? " ;
		jdbc.update(sql , dto.getId());
		
	}
	
	public boolean idcheck(String id) {
		String sql = "select count(*) from member where member_id = ?" ;
		int result = jdbc.queryForObject(sql, Integer.class , id);
		
		return result > 0;
	}
	
	public boolean namecheck(String username) {
		String sql = "select count(*) from member where username = ? ";
		int result = jdbc.queryForObject(sql, Integer.class , username);
		
		return result > 0;
		
	}
	public MemberDTO findId(String name, String phone) {
		String sql = "select member_id as id from member where name =? and phone = ?";
		List<MemberDTO> list = jdbc.query(sql, new BeanPropertyRowMapper<>(MemberDTO.class),name , phone);
		
		if(list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}		
	}
	public boolean matchmember(String id , String name, String phone) {
		String sql = "select count(*) from member where member_id = ?  and name = ? and phone = ?" ;
		int result = jdbc.queryForObject(sql, Integer.class ,id , name , phone);
		
		return result > 0 ; 
		
	}
	
	public int updatepw(String id , String pw) {
		String sql = "update member set password = ? where member_id = ?";
		return jdbc.update(sql  ,pw , id);
	}
	
	
	
}
