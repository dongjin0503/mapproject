package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.LedgerDTO;

@Repository
public class LedgerDAO {

	@Autowired
	private JdbcTemplate jdbcTemplate;


	// 가계부 등록
	public int insert(LedgerDTO dto) {

		String sql = "INSERT INTO LEDGER "
				+ "(LEDGER_ID, MEMBER_ID, LEDGER_DATE, TYPE, CATEGORY, AMOUNT, MEMO) "
				+ "VALUES (LEDGER_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";

		return jdbcTemplate.update(
				sql,
				dto.getMemberId(),
				dto.getLedgerDate(),
				dto.getType(),
				dto.getCategory(),
				dto.getAmount(),
				dto.getMemo()
		);
	}


	// 내 가계부 목록
	public List<LedgerDTO> findAll(String memberId) {

		String sql = "SELECT * "
				+ "FROM LEDGER "
				+ "WHERE MEMBER_ID = ? "
				+ "ORDER BY LEDGER_DATE DESC, LEDGER_ID DESC";

		return jdbcTemplate.query(
				sql,
				(rs, rowNum) -> {

					LedgerDTO dto = new LedgerDTO();

					dto.setLedgerId(rs.getInt("LEDGER_ID"));
					dto.setMemberId(rs.getString("MEMBER_ID"));
					dto.setLedgerDate(rs.getDate("LEDGER_DATE"));
					dto.setType(rs.getString("TYPE"));
					dto.setCategory(rs.getString("CATEGORY"));
					dto.setAmount(rs.getInt("AMOUNT"));
					dto.setMemo(rs.getString("MEMO"));

					return dto;
				},
				memberId
		);
	}


	// 가계부 한 건 조회
	public LedgerDTO findById(int ledgerId, String memberId) {

		String sql = "SELECT * "
				+ "FROM LEDGER "
				+ "WHERE LEDGER_ID = ? "
				+ "AND MEMBER_ID = ?";

		List<LedgerDTO> list = jdbcTemplate.query(
				sql,
				(rs, rowNum) -> {

					LedgerDTO dto = new LedgerDTO();

					dto.setLedgerId(rs.getInt("LEDGER_ID"));
					dto.setMemberId(rs.getString("MEMBER_ID"));
					dto.setLedgerDate(rs.getDate("LEDGER_DATE"));
					dto.setType(rs.getString("TYPE"));
					dto.setCategory(rs.getString("CATEGORY"));
					dto.setAmount(rs.getInt("AMOUNT"));
					dto.setMemo(rs.getString("MEMO"));

					return dto;
				},
				ledgerId,
				memberId
		);

		return list.isEmpty() ? null : list.get(0);
	}


	// 가계부 수정
	public int update(LedgerDTO dto) {

		String sql = "UPDATE LEDGER "
				+ "SET LEDGER_DATE = ?, "
				+ "TYPE = ?, "
				+ "CATEGORY = ?, "
				+ "AMOUNT = ?, "
				+ "MEMO = ? "
				+ "WHERE LEDGER_ID = ? "
				+ "AND MEMBER_ID = ?";

		return jdbcTemplate.update(
				sql,
				dto.getLedgerDate(),
				dto.getType(),
				dto.getCategory(),
				dto.getAmount(),
				dto.getMemo(),
				dto.getLedgerId(),
				dto.getMemberId()
		);
	}


	// 가계부 삭제
	public int delete(int ledgerId, String memberId) {

		String sql = "DELETE FROM LEDGER "
				+ "WHERE LEDGER_ID = ? "
				+ "AND MEMBER_ID = ?";

		return jdbcTemplate.update(
				sql,
				ledgerId,
				memberId
		);
	}


	// 월별 수입 합계
	public int getMonthlyIncome(String memberId, String month) {

		String sql = "SELECT NVL(SUM(AMOUNT), 0) "
				+ "FROM LEDGER "
				+ "WHERE MEMBER_ID = ? "
				+ "AND TYPE = 'INCOME' "
				+ "AND TO_CHAR(LEDGER_DATE, 'YYYY-MM') = ?";

		return jdbcTemplate.queryForObject(
				sql,
				Integer.class,
				memberId,
				month
		);
	}


	// 월별 지출 합계
	public int getMonthlyExpense(String memberId, String month) {

		String sql = "SELECT NVL(SUM(AMOUNT), 0) "
				+ "FROM LEDGER "
				+ "WHERE MEMBER_ID = ? "
				+ "AND TYPE = 'EXPENSE' "
				+ "AND TO_CHAR(LEDGER_DATE, 'YYYY-MM') = ?";

		return jdbcTemplate.queryForObject(
				sql,
				Integer.class,
				memberId,
				month
		);
	}
}