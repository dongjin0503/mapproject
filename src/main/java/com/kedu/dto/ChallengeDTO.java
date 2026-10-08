package com.kedu.dto;

import java.sql.Timestamp;

public class ChallengeDTO {

	// ===== DB 컬럼 (CHALLENGE 테이블) =====
	private int challenge_id;
	private String member_id;
	private String title;
	private String description;
	private String start_date;   // 쿼리에서 to_char 로 글자로 바꿔 받음
	private String end_date;
	private String created_at;

	// ===== 쿼리에서 계산해서 받는 값 (DB 컬럼 아님) =====
	private int member_count;    // 참여자 수
	private int d_day;           // 종료까지 남은 날
	private String status;       // 모집중 / 진행중 / 종료
	
	// ==== challege, challenge_member 테이블 조인 ====
	private Timestamp joined_at;

	public Timestamp getJoined_at() {
		return joined_at;
	}
	public void setJoined_at(Timestamp joined_at) {
		this.joined_at = joined_at;
	}


	// 기본 생성자 (BeanPropertyRowMapper 가 꼭 필요로 함)
	public ChallengeDTO() {
	}

	
	public ChallengeDTO(int challenge_id, String member_id, String title, String description, String start_date,
			String end_date, String created_at, int member_count, int d_day, String status) {
		super();
		this.challenge_id = challenge_id;
		this.member_id = member_id;
		this.title = title;
		this.description = description;
		this.start_date = start_date;
		this.end_date = end_date;
		this.created_at = created_at;
		this.member_count = member_count;
		this.d_day = d_day;
		this.status = status;
	}


	public int getChallenge_id() {
		return challenge_id;
	}

	public void setChallenge_id(int challenge_id) {
		this.challenge_id = challenge_id;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getStart_date() {
		return start_date;
	}

	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}

	public String getEnd_date() {
		return end_date;
	}

	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public int getMember_count() {
		return member_count;
	}

	public void setMember_count(int member_count) {
		this.member_count = member_count;
	}

	public int getD_day() {
		return d_day;
	}

	public void setD_day(int d_day) {
		this.d_day = d_day;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}