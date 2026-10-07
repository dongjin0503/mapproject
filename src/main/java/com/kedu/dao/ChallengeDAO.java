package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.ChallengeDTO;

@Repository
public class ChallengeDAO {

	@Autowired
	private JdbcTemplate jdbc;

	// 챌린지 목록 (참여자 수, D-day, 상태까지 같이 계산해서 가져옴)
	public List<ChallengeDTO> listChallenge() {
		String sql = "select c.challenge_id, c.member_id, c.category, c.title, c.description, "
				+ "to_char(c.start_date, 'YYYY-MM-DD') as start_date, "
				+ "to_char(c.end_date, 'YYYY-MM-DD') as end_date, "
				+ "(select count(*) from challenge_member m where m.challenge_id = c.challenge_id) as member_count, "
				+ "trunc(c.end_date) - trunc(sysdate) as d_day, "
				+ "case "
				+ "when trunc(sysdate) < trunc(c.start_date) then '모집중' "
				+ "when trunc(sysdate) > trunc(c.end_date) then '종료' "
				+ "else '진행중' "
				+ "end as status "
				+ "from challenge c "
				+ "order by c.challenge_id desc";

		return jdbc.query(sql, new BeanPropertyRowMapper<>(ChallengeDTO.class));
	}
}