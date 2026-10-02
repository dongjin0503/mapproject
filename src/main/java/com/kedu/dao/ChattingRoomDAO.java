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
	
	public void insert(ChattingRoomDTO dto) {
		String sql = "insert into chattingroom(message_id, party_id, member_id, content, message_type)"
				+ " values(seq_chattingroom.nextval,?,?,?,?)";
		jdbc.update(sql,dto.getPartyId(),dto.getMemberId(),dto.getContent(),dto.getMessageType());
				
	}
	
	public List<ChattingRoomDTO> selectByPartyId(int partyId){
		String sql = "select * from chattingroom where party_id=? order by message_id";
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
		String sql = "select member_id from party_member where party_id=? order by party_member";
		return jdbc.queryForList(sql, String.class, partyId);
	}
}
