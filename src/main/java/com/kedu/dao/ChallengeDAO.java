package com.kedu.dao;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.kedu.dto.ChallengeDTO;

@Repository
public class ChallengeDAO {

	@Autowired
	private JdbcTemplate jdbc;
	
	@Autowired
	private NotificationDAO notificationDAO;
	
	// 챌린지 목록 (참여자 수, D-day, 상태까지 같이 계산해서 가져옴)
	public List<ChallengeDTO> listChallenge() {
		String sql = "select c.challenge_id, c.member_id, c.title, c.description, "
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
				+ "order by "
				+ "case when trunc(sysdate) > trunc(c.end_date) then 2 "
				+ "when trunc(sysdate) < trunc(c.start_date) then 1 "
				+ "else 0 end, "
				+ "case when trunc(sysdate) > trunc(c.end_date) then trunc(sysdate) - trunc(c.end_date) "
				+ "when trunc(sysdate) < trunc(c.start_date) then trunc(c.start_date) - trunc(sysdate) "
				+ "else trunc(c.end_date) - trunc(sysdate) end, "
				+ "c.challenge_id desc";

		return jdbc.query(sql, new BeanPropertyRowMapper<>(ChallengeDTO.class));
	}
	
	public int addChallenge(String memberId, ChallengeDTO dto) {
		
		int id = jdbc.queryForObject("select challenge_seq.nextval from dual ", Integer.class);
		String sql = "insert into challenge(challenge_id, member_id, title, description, start_date, end_date) "
				+ "values(?, ?, ?, ?, to_date(?, 'YYYY-MM-DD'), to_date(?, 'YYYY-MM-DD'))";
		
		jdbc.update(sql,id , memberId, dto.getTitle(), dto.getDescription(), dto.getStart_date(), dto.getEnd_date());
		
		addMember(id, memberId, null, null , null);
		
		return id ;
	}
	
	// 챌린지 1건 조회 (상세 화면용)
	public ChallengeDTO getChallenge(int challengeId) {
		String sql = "select c.challenge_id, c.member_id, c.title, c.description, "
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
				+ "where c.challenge_id = ?";

		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(ChallengeDTO.class), challengeId);
	}
	
	public List<ChallengeDTO> MyChallengeRecord(String loginId){
		String sql = "SELECT c.challenge_id, c.title, cm.joined_at FROM challenge c "
				+ "JOIN challenge_member cm ON c.challenge_id = cm.challenge_id "
				+ "WHERE cm.member_id = ? ORDER BY cm.joined_at DESC";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(ChallengeDTO.class), loginId);
	}
	
	public boolean isJoined(int challengeId, String memberId) {
		String sql = "select count(*) from challenge_member where challenge_id = ? and member_id = ?";
		
		int count = jdbc.queryForObject(sql,Integer.class , challengeId, memberId);
		
		return count > 0;
		
	}
	
	public int addMember(int challengeId , String memberId, String goal, String pledge , String cycle) {
		String sql = "insert into challenge_member (challenge_member_id , challenge_id , member_id , joined_at , goal, pledge , cert_cycle)"
				+ " values (challenge_member_seq.nextval , ? , ? , systimestamp , ? ,? ,?)";
		
		return jdbc.update(sql, challengeId, memberId , goal , pledge , cycle);
	}
	
	// 폴링용: 목록 카드에서 주기적으로 갱신할 값만 가볍게 조회
	public List<ChallengeDTO> listProgress() {
		String sql = "select c.challenge_id, "
				+ "(select count(*) from challenge_member m where m.challenge_id = c.challenge_id) as member_count, "
				+ "trunc(c.end_date) - trunc(sysdate) as d_day, "
				+ "case "
				+ "when trunc(sysdate) < trunc(c.start_date) then '모집중' "
				+ "when trunc(sysdate) > trunc(c.end_date) then '종료' "
				+ "else '진행중' "
				+ "end as status, "
				+ "nvl(round(least(greatest((trunc(sysdate) - trunc(c.start_date)) "
				+ "/ nullif(trunc(c.end_date) - trunc(c.start_date), 0) * 100, 0), 100)), 100) as progress "
				+ "from challenge c";

		return jdbc.query(sql, new BeanPropertyRowMapper<>(ChallengeDTO.class));
	}
	
	public Map<String, Object> getMyJoin(int challengeId, String memberId) {
	    String sql = "select goal, pledge, cert_cycle from challenge_member where challenge_id = ? and  member_id = ?"; 
	    return jdbc.queryForMap(sql, challengeId, memberId);
	}
	
	@Transactional
	public void joinChallenge(int challengeId, String memberId,
	      String goal, String pledge, String cycle) {

	   ChallengeDTO challenge = getChallenge(challengeId);

	   addMember(challengeId, memberId, goal, pledge, cycle);

	   notificationDAO.insert(
	         challenge.getMember_id(),
	         "CHALLENGE_JOIN",
	         "CHALLENGE",
	         challengeId,
	         challenge.getTitle() + " 챌린지에 새로운 멤버가 참여했습니다."
	   );
	} 
}