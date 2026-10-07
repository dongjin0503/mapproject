package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.kedu.dto.PartyDTO;
import com.kedu.dto.SettlementDTO;

@Repository
public class SettlementDAO {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private PartyDAO partyDAO;

	public int getNextSettlementId() {
		String sql = "select SETTLEMENT_SEQ.nextval from dual";

		return jdbcTemplate.queryForObject(sql, Integer.class);
	}

	public int insert(SettlementDTO dto) {

		String sql = "insert into SETTLEMENT " + "(SETTLEMENT_ID, PARTY_ID, SETTLEMENT_TYPE, TOTAL_AMOUNT) "
				+ "values (?,?,?,?)";

		return jdbcTemplate.update(sql, dto.getSettlementId(), dto.getPartyId(), dto.getSettlementType(),
				dto.getTotalAmount());

	}

	public int insertDetail(int settlementId, String memberId, long amount) {

		String sql = "insert into SETTLEMENT_DETAIL " + "(DETAIL_ID, SETTLEMENT_ID, MEMBER_ID, AMOUNT) "
				+ "values (SETTLEMENT_DETAIL_SEQ.nextval, ?, ?, ?)";

		return jdbcTemplate.update(sql, settlementId, memberId, amount);
	}

	@Transactional
	public int createEqual(int partyId, String hostId, long totalAmount) {

		PartyDTO dto = partyDAO.findById(partyId);

		if (dto == null) {
			throw new IllegalArgumentException("존재하지 않는 모임입니다.");
		}

		if (!dto.getHostId().equals(hostId)) {
			throw new IllegalArgumentException("모임장만 정산할 수 있습니다.");
		}

		if (totalAmount <= 0) {
			throw new IllegalArgumentException("정산 금액은 0원보다 커야 합니다.");
		}

		List<String> memberIds = partyDAO.findMemberIds(partyId);

		if (memberIds.isEmpty()) {
			throw new IllegalArgumentException("정산할 참여 멤버가 없습니다.");
		}

		long amount = totalAmount / memberIds.size();
		long remainder = totalAmount % memberIds.size();

		int settlementId = getNextSettlementId();

		SettlementDTO settlement = new SettlementDTO();
		settlement.setSettlementId(settlementId);
		settlement.setPartyId(partyId);
		settlement.setSettlementType("EQUAL");
		settlement.setTotalAmount(totalAmount);

		insert(settlement);

		for (String memberId : memberIds) {
			long memberAmount = amount;

			if (memberId.equals(hostId)) {
				memberAmount += remainder;
			}

			insertDetail(settlementId, memberId, memberAmount);
		}

		return settlementId;
	}

	@Transactional
	public int createMenu(int partyId, String hostId, long totalAmount, List<String> memberIds,
			List<Long> memberAmounts) {
		PartyDTO dto = partyDAO.findById(partyId);

		if (dto == null) {
			throw new IllegalArgumentException("존재하지 않는 모임입니다.");
		}

		if (!dto.getHostId().equals(hostId)) {
			throw new IllegalArgumentException("모임장만 정산할 수 있습니다.");
		}

		if (totalAmount <= 0) {
			throw new IllegalArgumentException("정산 금액은 0원보다 커야 합니다.");
		}

		if (memberIds == null || memberAmounts == null || memberIds.isEmpty()) {
			throw new IllegalArgumentException("정산할 멤버가 없습니다.");
		}

		if (memberIds.size() != memberAmounts.size()) {
			throw new IllegalArgumentException("정산 정보가 올바르지 않습니다.");
		}

		int settlementId = getNextSettlementId();

		SettlementDTO settlementDTO = new SettlementDTO();

		settlementDTO.setSettlementId(settlementId);
		settlementDTO.setPartyId(partyId);
		settlementDTO.setSettlementType("MENU");
		settlementDTO.setTotalAmount(totalAmount);

		insert(settlementDTO);

		for (int i = 0; i < memberIds.size(); i++) {
			insertDetail(settlementId, memberIds.get(i), memberAmounts.get(i));
		}
		
		return settlementId;
	}

	public SettlementDTO findSettlement(int settlementId) {

		String sql = "select * from SETTLEMENT where SETTLEMENT_ID = ?";

		return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {

			SettlementDTO dto = new SettlementDTO();

			dto.setSettlementId(rs.getInt("SETTLEMENT_ID"));
			dto.setPartyId(rs.getInt("PARTY_ID"));
			dto.setSettlementType(rs.getString("SETTLEMENT_TYPE"));
			dto.setTotalAmount(rs.getLong("TOTAL_AMOUNT"));

			return dto;

		}, settlementId);
	}
	
	public List<SettlementDTO> findSettlementDetails(int settlementId) {

		String sql = "select sd.MEMBER_ID, m.USERNAME, sd.AMOUNT "
				+ "from SETTLEMENT_DETAIL sd "
				+ "join MEMBER m on sd.MEMBER_ID = m.MEMBER_ID "
				+ "where sd.SETTLEMENT_ID = ? "
				+ "order by sd.DETAIL_ID";

		return jdbcTemplate.query(sql, (rs, rowNum) -> {

			SettlementDTO dto = new SettlementDTO();

			dto.setMemberId(rs.getString("MEMBER_ID"));
			dto.setMemberName(rs.getString("USERNAME"));
			dto.setAmount(rs.getLong("AMOUNT"));

			return dto;

		}, settlementId);
	}
}
