package com.kedu.dto;

import java.sql.Timestamp;

public class ReplyDTO {

	
	private int replyId;
	private int postId;
	private String memberId;
	private int parentReplyId;
	private String content;
	private int likeCount;
	private Timestamp createdAt;
	
	private int replyCount;
	
	public ReplyDTO() {};
	public ReplyDTO(int replyId, int postId, String memberId, int parentReplyId, String content, int likeCount,
			Timestamp createdAt) {
		super();
		this.replyId = replyId;
		this.postId = postId;
		this.memberId = memberId;
		this.parentReplyId = parentReplyId;
		this.content = content;
		this.likeCount = likeCount;
		this.createdAt = createdAt;
	}
	
	public int getReplyCount() {
		return replyCount;
	}
	public void setReplyCount(int replyCount) {
		this.replyCount = replyCount;
	}
	public int getReplyId() {
		return replyId;
	}
	public void setReplyId(int replyId) {
		this.replyId = replyId;
	}
	public int getPostId() {
		return postId;
	}
	public void setPostId(int postId) {
		this.postId = postId;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public int getParentReplyId() {
		return parentReplyId;
	}
	public void setParentReplyId(int parentReplyId) {
		this.parentReplyId = parentReplyId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	
	
	
	
}
