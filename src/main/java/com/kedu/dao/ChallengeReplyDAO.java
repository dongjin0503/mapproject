package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.ChallengeReplyDTO;

@Repository
public class ChallengeReplyDAO {
	
	@Autowired
	private JdbcTemplate jdbc;
	
	public int addReply(String memberId, ChallengeReplyDTO dto) {
		String sql = "insert into Challenge_reply(challenge_reply_id , challenge_id , member_id , content) "
				+ "values(seq_challenge_reply.nextval , ? , ? , ?)";
				
			return jdbc.update(sql , dto.getChallenge_id() , memberId , dto.getContent());
	}
	
	public List<ChallengeReplyDTO> listReply(int challengeId){
		String sql = "select r.challenge_reply_id , r.challenge_id, r.member_id, m.username , r.content ,r.parent_reply_id, to_char(r.created_at, 'YYYY-MM-DD HH24:MI') as created_at "
				+ "from challenge_reply r join member m on r.member_id = m.member_id where r.challenge_id =? "
				+ "order by nvl (r.parent_reply_id, r.challenge_reply_id), r.challenge_reply_id ";
		// [닉네임 가져오기] member 테이블과 join
				//   - r, m 은 테이블 별명 (challenge_reply r / member m)
				//   - on r.member_id = m.member_id : 댓글 작성자 아이디와 같은 회원 행을 붙인다
				//   - m.username 이 닉네임 → DTO 의 username 필드에 들어간다
				//   - member_id 처럼 양쪽에 있는 컬럼은 r. / m. 을 붙여서 구분한다
				//
				// [댓글 정렬] 부모 댓글 바로 아래에 그 대댓글이 오게 줄 세우기
				//
				// nvl(A, B) : A가 NULL이면 B, 값이 있으면 A를 쓴다
				//   - 댓글   : parent_reply_id가 NULL  → 자기 번호(challenge_reply_id)가 묶음 번호
				//   - 대댓글 : parent_reply_id에 값 있음 → 부모 댓글 번호가 묶음 번호
				//
				// order by 기준1, 기준2
				//   - 기준1 nvl(...)          : 같은 댓글 묶음끼리 모은다
				//   - 기준2 challenge_reply_id : 묶음 안에서 번호 순 (댓글 → 대댓글)
				//
				// 예) 댓글A(1), 댓글B(2), A의 대댓글(3), B의 대댓글(4)
				//     묶음 번호 : 1, 2, 1, 2
				//     정렬 결과 : A(1) → A의 대댓글(3) → B(2) → B의 대댓글(4)
				//
				// ※ 댓글과 대댓글 2단계까지만 가능 (대댓글의 대댓글은 안 됨)	
		return jdbc.query(sql, new BeanPropertyRowMapper<>(ChallengeReplyDTO.class) , challengeId);
	}
	
	public int addReReply(String memberId, ChallengeReplyDTO dto) {
		String sql = "insert into Challenge_reply(challenge_reply_id , challenge_id , member_id , content , parent_reply_id) "
				+ "values(seq_challenge_reply.nextval , ? , ? , ? , ?)";
				
			return jdbc.update(sql , dto.getChallenge_id() , memberId , dto.getContent(), dto.getParent_reply_id());
	}
	
	public int updateReply(int replyId ,String memberId, String content) {
		String sql = "update challenge_reply set content = ? "
				+ "where challenge_reply_id = ? and member_id = ?";
		
		return jdbc.update(sql , content , replyId, memberId);
		
	}
	
	public int deleteReply(int replyId , String memberId) {
		String sql1 = "delete from challenge_reply where parent_reply_id = "
				+ "(select challenge_reply_id from challenge_reply where "
				+ " challenge_reply_id = ? and member_id =?)";
		jdbc.update(sql1, replyId, memberId);
		
		String sql2 = "delete from challenge_reply where challenge_reply_id = ? and member_id = ?";
				
		return jdbc.update(sql2 , replyId, memberId);
		
	}
}
