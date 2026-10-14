package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.ChattingRoomDTO;

@Repository
public class ChattingRoomDAO {
	
	@Autowired
	private JdbcTemplate jdbc;
	
	public void insert(ChattingRoomDTO dto) {	// 메세지 저장
		String sql = "insert into chattingroom(message_id, party_id, member_id, content, message_type)"
				+ " values(seq_chattingroom.nextval,?,?,?,?)";
		jdbc.update(sql,dto.getPartyId(),dto.getMemberId(),dto.getContent(),dto.getMessageType());
				
	}
	
	public List<ChattingRoomDTO> selectByPartyId(int partyId){	//지난 대화 불러오기
		String sql = "select c.*, m.username from chattingroom c "
		        + "join member m on c.member_id = m.member_id "
		        + "where c.party_id=? order by c.message_id";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(ChattingRoomDTO.class), partyId);
	}
	
	public String selectTitle(int partyId) {
		String sql = "select title from party where party_id=?";
		return jdbc.queryForObject(sql, String.class, partyId);
	}
	
	public int selectMemberCount(int partyId) {
		String sql = "select count(*) from party_member where party_id=?";
		return jdbc.queryForObject(sql, Integer.class, partyId);
	}
	
	public List<String> selectMemberList(int partyId){
		String sql = "select m.username from party_member pm "
	               + "join member m on pm.member_id = m.member_id "
	               + "where pm.party_id=? order by pm.join_date";
		return jdbc.queryForList(sql, String.class, partyId);
	}
	public String selectNickname(String memberId) {
		String sql = "select username from member where member_id=?";
	    return jdbc.queryForObject(sql, String.class, memberId);
	}
	
	// 내 마지막 입장/퇴장 기록이 ENTER면 이미 입장한 상태
	// select를 두번 감싼 이유 : rownum은 정렬보다 먼저 번호를 매긴다. desc전에 rownum이 정해짐
	public boolean isEntered(int partyId, String memberId) {
		String sql = "select message_type from ("
		           + "select message_type from chattingroom "
		           + "where party_id = ? and member_id = ? and message_type in ('ENTER','LEAVE') "
		           + "order by message_id desc) "
		           + "where rownum = 1";
		List<String> result = jdbc.queryForList(sql, String.class, partyId, memberId);
		return !result.isEmpty() && result.get(0).equals("ENTER");
		// 처음 입장하는 사람은 입퇴장 기록이없어서 queryForObject를 쓰면 예외가 발생한다.
		// 결과가 없을 수도 있기에 queryForList를 쓴다.(빈 리스트 돌려줌)
	}
}
