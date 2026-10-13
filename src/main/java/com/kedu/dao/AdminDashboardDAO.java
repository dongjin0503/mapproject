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

	public List<AdminDashboardDTO> getGenderCount(String startDate, String endDate) {

		String sql = "select GENDER, " + "count(*) CNT " + "from MEMBER " + "where REGDATE >= to_date(?, 'YYYY-MM-DD') "
				+ "and REGDATE < to_date(?, 'YYYY-MM-DD') + 1 " + "group by GENDER";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			AdminDashboardDTO dto = new AdminDashboardDTO();

			dto.setGender(rs.getString("GENDER"));
			dto.setCount(rs.getInt("CNT"));

			return dto;

		}, startDate, endDate);
	}

	public List<AdminDashboardDTO> getAgeGroupCount(String startDate, String endDate) {

		String sql = "select trunc(months_between(sysdate, BIRTH_DATE) / 120) * 10 AGE_GROUP, " + "count(*) CNT "
				+ "from MEMBER " + "where REGDATE >= to_date(?, 'YYYY-MM-DD') "
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

		String sql = "select gs.CATEGORY, " + "sum(case " + "when p.MEET_DATE < CURRENT_TIMESTAMP "
				+ "then 1 else 0 end) CREATE_COUNT, " + "sum(case " + "when p.MEET_DATE < CURRENT_TIMESTAMP "
				+ "and nvl(pm.MEMBER_COUNT, 0) >= p.MIN_PEOPLE " + "then 1 else 0 end) PROGRESS_COUNT "
				+ "from PARTY p " + "join GOOD_STORE gs on p.STORE_ID = gs.STORE_ID " + "left join ( "
				+ "select PARTY_ID, count(*) MEMBER_COUNT " + "from PARTY_MEMBER " + "group by PARTY_ID "
				+ ") pm on p.PARTY_ID = pm.PARTY_ID " + "where p.REGDATE >= to_date(?, 'YYYY-MM-DD') "
				+ "and p.REGDATE < to_date(?, 'YYYY-MM-DD') + 1 " + "group by gs.CATEGORY " + "order by gs.CATEGORY";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			AdminDashboardDTO dto = new AdminDashboardDTO();

			dto.setCategory(rs.getString("CATEGORY"));
			dto.setCreateCount(rs.getInt("CREATE_COUNT"));
			dto.setProgressCount(rs.getInt("PROGRESS_COUNT"));

			double successRate = 0;

			if (dto.getCreateCount() > 0) {
				successRate = (double) dto.getProgressCount() / dto.getCreateCount() * 100;
			}

			dto.setSuccessRate(successRate);

			return dto;

		}, startDate, endDate);
	}

	public List<AdminDashboardDTO> getChallengeCategoryStats(String startDate, String endDate) {

		String sql = "select c.CATEGORY, " + "sum(case " +
				"when c.START_DATE <= sysdate " +
				"then 1 else 0 end) CREATE_COUNT, " + "sum(case " + "when c.START_DATE <= sysdate "
				+ "and nvl(cm.MEMBER_COUNT, 0) >= 1 " + "then 1 else 0 end) PROGRESS_COUNT " + "from CHALLENGE c "
				+ "left join ( " + "select CHALLENGE_ID, count(*) MEMBER_COUNT " + "from CHALLENGE_MEMBER "
				+ "group by CHALLENGE_ID " + ") cm on c.CHALLENGE_ID = cm.CHALLENGE_ID "
				+ "where c.CREATED_AT >= to_date(?, 'YYYY-MM-DD') " + "and c.CREATED_AT < to_date(?, 'YYYY-MM-DD') + 1 "
				+ "group by c.CATEGORY " + "order by c.CATEGORY";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			AdminDashboardDTO dto = new AdminDashboardDTO();

			dto.setCategory(rs.getString("CATEGORY"));
			dto.setCreateCount(rs.getInt("CREATE_COUNT"));
			dto.setProgressCount(rs.getInt("PROGRESS_COUNT"));

			double successRate = 0;

			if (dto.getCreateCount() > 0) {
				successRate = (double) dto.getProgressCount() / dto.getCreateCount() * 100;
			}

			dto.setSuccessRate(successRate);

			return dto;

		}, startDate, endDate);
	}
}
