package com.kedu.dto;

import java.sql.Timestamp;

public class PartyApplicationDTO {
	
	private int applicationId;
	private int partyId;
	private String applicantId;
	private String answer;
	private String status;
	private Timestamp applyDate;
	
	public PartyApplicationDTO(){}
	
	public PartyApplicationDTO(int applicationId, int partyId, String applicantId, String answer, String status,
			Timestamp applyDate) {
		super();
		this.applicationId = applicationId;
		this.partyId = partyId;
		this.applicantId = applicantId;
		this.answer = answer;
		this.status = status;
		this.applyDate = applyDate;
	}

	public int getApplicationId() {
		return applicationId;
	}

	public void setApplicationId(int applicationId) {
		this.applicationId = applicationId;
	}

	public int getPartyId() {
		return partyId;
	}

	public void setPartyId(int partyId) {
		this.partyId = partyId;
	}

	public String getApplicantId() {
		return applicantId;
	}

	public void setApplicantId(String applicantId) {
		this.applicantId = applicantId;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Timestamp applyDate) {
		this.applyDate = applyDate;
	}
	
}
