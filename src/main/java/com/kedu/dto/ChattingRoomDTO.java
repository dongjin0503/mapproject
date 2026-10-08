package com.kedu.dto;

import java.sql.Timestamp;

public class ChattingRoomDTO {
	
	private int messageId;
	private int partyId;
	private String memberId;
	private String content;
	private String messageType;
	private Timestamp createdAt;
	
	
	// 채팅창에 띄울 nickname 필드추가
	private String username;
	
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public ChattingRoomDTO() {}
	public ChattingRoomDTO(int messageId, int partyId, String memberId, String content, String messageType,
			Timestamp createdAt) {
		super();
		this.messageId = messageId;
		this.partyId = partyId;
		this.memberId = memberId;
		this.content = content;
		this.messageType = messageType;
		this.createdAt = createdAt;
	}
	public int getMessageId() {
		return messageId;
	}
	public void setMessageId(int messageId) {
		this.messageId = messageId;
	}
	public int getPartyId() {
		return partyId;
	}
	public void setPartyId(int partyId) {
		this.partyId = partyId;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getMessageType() {
		return messageType;
	}
	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	


}
