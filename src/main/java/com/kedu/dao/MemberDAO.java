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
		String sql = "select count(*) from member where member_id = ? and password =?";
		
		int result = jdbc.queryForObject(sql, Integer.class, dto.getId(), dto.getPw());

		return result > 0;
	}

	public void update(MemberDTO dto) {
		String sql = "update member set name = ?  , phone = ? , email = ?, "
				+ "zipcode = ? , address1 = ? , address2 = ? , birth_date  = ? ,username = ? where member_id = ?";
		jdbc.update(sql, dto.getName(), dto.getPhone(), dto.getEmail(), dto.getZipcode(), dto.getAddress1(),
				dto.getAddress2(), dto.getBirth_date(), dto.getUsername() , dto.getId());
	}

	public MemberDTO selectMember(String id) {
		String sql = "select member_id as id, username, password as pw, name, phone, email, zipcode, address1, address2, birth_date, gender, regdate from member where member_id = ?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(MemberDTO.class), id);

	}
	
	// 회원 탈퇴 : 이 회원의 데이터를 모두 지우고, 마지막에 회원 본인을 지운다
	public void delete(MemberDTO dto) {
		String id = dto.getId();

		// ---- 1. 내가 만든 파티(모임)와 거기 딸린 것들 ----
		String myParty = "(select party_id from party where host_id = ?)";
		jdbc.update("delete from settlement_detail where settlement_id in "
				+ "(select settlement_id from settlement where party_id in " + myParty + ")", id);
		jdbc.update("delete from settlement where party_id in " + myParty, id);
		jdbc.update("delete from chattingroom where party_id in " + myParty, id);
		jdbc.update("delete from party_application where party_id in " + myParty, id);
		jdbc.update("delete from party_member where party_id in " + myParty, id);
		jdbc.update("delete from party_image where party_id in " + myParty, id);
		jdbc.update("delete from bookmark where content_type = 'PARTY' and content_id in " + myParty, id);
		jdbc.update("delete from party where host_id = ?", id);

		// ---- 2. 남의 파티에서 내가 남긴 것 ----
		jdbc.update("delete from party_member where member_id = ?", id);
		jdbc.update("delete from party_application where applicant_id = ?", id);
		jdbc.update("delete from chattingroom where member_id = ?", id);
		jdbc.update("delete from settlement_detail where member_id = ?", id);

		// ---- 3. 내가 만든 챌린지와 거기 딸린 것들 ----
		String myChallenge = "(select challenge_id from challenge where member_id = ?)";
		jdbc.update("delete from challenge_reply where challenge_id in " + myChallenge, id);
		jdbc.update("delete from challenge_member where challenge_id in " + myChallenge, id);
		jdbc.update("delete from bookmark where content_type = 'CHALLENGE' and content_id in " + myChallenge, id);
		jdbc.update("delete from challenge where member_id = ?", id);

		// ---- 4. 남의 챌린지에서 내가 남긴 것 (내 댓글에 달린 대댓글 먼저) ----
		jdbc.update("delete from challenge_member where member_id = ?", id);
		jdbc.update("delete from challenge_reply where parent_reply_id in "
				+ "(select challenge_reply_id from challenge_reply where member_id = ?)", id);
		jdbc.update("delete from challenge_reply where member_id = ?", id);

		// ---- 5. 내가 쓴 자유게시판 글과 거기 딸린 것들 ----
		String myPost = "(select post_id from freeboard where member_id = ?)";
		jdbc.update("delete from freeboard_file where post_id in " + myPost, id);
		jdbc.update("delete from freeboard_like where post_id in " + myPost, id);
		jdbc.update("delete from freeboard_reply where post_id in " + myPost, id);
		jdbc.update("delete from freeboard where member_id = ?", id);

		// ---- 6. 남의 글에서 내가 남긴 것 ----
		jdbc.update("update freeboard set like_count = like_count - 1 where post_id in "
				+ "(select post_id from freeboard_like where member_id = ?)", id);
		jdbc.update("delete from freeboard_like where member_id = ?", id);
		jdbc.update("delete from freeboard_reply where parent_reply_id in "
				+ "(select freeboard_reply_id from freeboard_reply where member_id = ?)", id);
		jdbc.update("delete from freeboard_reply where member_id = ?", id);

		// ---- 7. Q&A ----
		jdbc.update("delete from qna_reply where parent_qna_id in (select qna_id from qna where writer = ?)", id);
		jdbc.update("delete from qna where writer = ?", id);
		jdbc.update("delete from qna_reply where writer = ?", id);

		// ---- 8. 가계부 · 예산 · 북마크 · 알림 ----
		jdbc.update("delete from ledger where member_id = ?", id);
		jdbc.update("delete from monthly_budget where member_id = ?", id);
		jdbc.update("delete from bookmark where member_id = ?", id);
		jdbc.update("delete from notification where receiver_id = ?", id);

		// ---- 9. 마지막에 회원 본인 ----
		jdbc.update("delete from member where member_id = ?", id);
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
	
	// 아이디 + 가입한 이메일이 일치하는지 (이메일은 대소문자 구분 없이 비교)
	public boolean matchemail(String id, String email) {
		String sql = "select count(*) from member where member_id = ? and lower(email) = lower(?)";
		int result = jdbc.queryForObject(sql, Integer.class, id, email);

		return result > 0;
	}

	public int updatepw(String id , String pw) {
		String sql = "update member set password = ? where member_id = ?";
		return jdbc.update(sql  ,pw , id);
	}
	
	
	public String selectEmail(String id) {
		String sql = "select email from member where member_id = ?";
		return jdbc.queryForObject(sql, String.class, id);
	}
}
