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
	
	public List<AdminDashboardDTO> getMonthlyPartyCount() {

		String sql =
				"select TO_CHAR(REGDATE, 'YYYY-MM') MONTH, "
				+ "count(*) CNT "
				+ "from PARTY "
				+ "group by TO_CHAR(REGDATE, 'YYYY-MM') "
				+ "order by MONTH";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			AdminDashboardDTO dto = new AdminDashboardDTO();

			dto.setMonth(rs.getString("MONTH"));
			dto.setCount(rs.getInt("CNT"));

			return dto;
		});
	}
	
	public List<AdminDashboardDTO> getMonthlyPartyMemberCount() {

		String sql =
				"select TO_CHAR(JOIN_DATE, 'YYYY-MM') MONTH, "
				+ "count(*) CNT "
				+ "from PARTY_MEMBER "
				+ "group by TO_CHAR(JOIN_DATE, 'YYYY-MM') "
				+ "order by MONTH";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			AdminDashboardDTO dto =
					new AdminDashboardDTO();

			dto.setMonth(
					rs.getString("MONTH"));

			dto.setCount(
					rs.getInt("CNT"));

			return dto;
		});
	}
	
	public List<AdminDashboardDTO> getGenderCount(){
	
		String sql = "select GENDER, "
				+ "count(*) CNT "
				+ "from MEMBER "
				+ "group by GENDER";
		
		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			
			AdminDashboardDTO dto = new AdminDashboardDTO();
			
			dto.setGender(rs.getString("GENDER"));
			dto.setCount(rs.getInt("CNT"));
			
			return dto;
			
		});
	}
	
	public List<AdminDashboardDTO> getAgeGroupCount(){
		
		String sql = "select trunc(months_between(sysdate, BIRTH_DATE)/120)*10 AGE_GROUP, "
				+ "count(*) CNT "
				+ "from MEMBER "
				+ "group by trunc(months_between(sysdate, BIRTH_DATE)/120)*10 "
				+ "order by AGE_GROUP";
		
		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			
			AdminDashboardDTO dto = new AdminDashboardDTO();
			
			dto.setAgeGroup(rs.getString("AGE_GROUP")+"대");
			dto.setCount(rs.getInt("CNT"));
			
			return dto;
		});
	}
}
