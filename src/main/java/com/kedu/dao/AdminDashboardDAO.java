package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.AdminDashboardDTO;

@Repository
public class AdminDashboardDAO {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	public List<AdminDashboardDTO> getGenderCount(String startDate, String endDate){
	
		String sql = "select GENDER, "
				+ "count(*) CNT "
				+ "from MEMBER "
				+ "where REGDATE >= to_date(?, 'YYYY-MM-DD') "
				+ "and REGDATE < to_date(?, 'YYYY-MM-DD') + 1 "
				+ "group by GENDER";
		
		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			
			AdminDashboardDTO dto = new AdminDashboardDTO();
			
			dto.setGender(rs.getString("GENDER"));
			dto.setCount(rs.getInt("CNT"));
			
			return dto;
			
		}, startDate, endDate);
	}
	
	public List<AdminDashboardDTO> getAgeGroupCount(String startDate, String endDate) {
		
		String sql =
				"select trunc(months_between(sysdate, BIRTH_DATE) / 120) * 10 AGE_GROUP, "
				+ "count(*) CNT "
				+ "from MEMBER "
				+ "where REGDATE >= to_date(?, 'YYYY-MM-DD') "
				+ "and REGDATE < to_date(?, 'YYYY-MM-DD') + 1 "
				+ "group by trunc(months_between(sysdate, BIRTH_DATE) / 120) * 10 "
				+ "order by trunc(months_between(sysdate, BIRTH_DATE) / 120) * 10";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			
			AdminDashboardDTO dto = new AdminDashboardDTO();
			
			dto.setAgeGroup(rs.getInt("AGE_GROUP") + "대");
			dto.setCount(rs.getInt("CNT"));
			
			return dto;
			
		}, startDate, endDate);
	}
	
	public List<AdminDashboardDTO> getPartyCategoryStats(String startDate, String endDate) {

		String sql =
				"select gs.CATEGORY, " +
				"count(distinct p.PARTY_ID) CREATE_COUNT, " +
				"count(pm.PARTY_MEMBER_ID) JOIN_COUNT " +
				"from PARTY p " +
				"join GOOD_STORE gs on p.STORE_ID = gs.STORE_ID " +
				"left join PARTY_MEMBER pm on p.PARTY_ID = pm.PARTY_ID " +
				"where p.REGDATE >= to_date(?, 'YYYY-MM-DD') " +
				"and p.REGDATE < to_date(?, 'YYYY-MM-DD') + 1 " +
				"group by gs.CATEGORY " +
				"order by gs.CATEGORY";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			AdminDashboardDTO dto = new AdminDashboardDTO();

			dto.setCategory(rs.getString("CATEGORY"));
			dto.setCreateCount(rs.getInt("CREATE_COUNT"));
			dto.setJoinCount(rs.getInt("JOIN_COUNT"));

			return dto;

		}, startDate, endDate);
	}
	
	public List<AdminDashboardDTO> getChallengeCategoryStats(String startDate, String endDate) {

		String sql =
				"select c.CATEGORY, " +
				"count(distinct c.CHALLENGE_ID) CREATE_COUNT, " +
				"count(cm.CHALLENGE_MEMBER_ID) JOIN_COUNT " +
				"from CHALLENGE c " +
				"left join CHALLENGE_MEMBER cm " +
				"on c.CHALLENGE_ID = cm.CHALLENGE_ID " +
				"where c.CREATED_AT >= to_date(?, 'YYYY-MM-DD') " +
				"and c.CREATED_AT < to_date(?, 'YYYY-MM-DD') + 1 " +
				"group by c.CATEGORY " +
				"order by c.CATEGORY";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			AdminDashboardDTO dto = new AdminDashboardDTO();

			dto.setCategory(rs.getString("CATEGORY"));
			dto.setCreateCount(rs.getInt("CREATE_COUNT"));
			dto.setJoinCount(rs.getInt("JOIN_COUNT"));

			return dto;

		}, startDate, endDate);
	}
}
