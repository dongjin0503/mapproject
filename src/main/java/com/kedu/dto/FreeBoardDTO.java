package com.kedu.dto;

import java.sql.Timestamp;

public class FreeBoardDTO {
	private int postId;
	private String memberId;
	private String title;
	private String contentCategory;
	private String content;
	private int viewCount;
	private int likeCount;
	private Timestamp createdAt;
	private int replyCount;
	
	// 1. username 필드 추가
	private String username;

	
	public FreeBoardDTO() {};
	
	public FreeBoardDTO(int postId, String memberId, String title, String contentCategory, String content,
			int viewCount, int likeCount, Timestamp createdAt) {
		this.postId = postId;
		this.memberId = memberId;
		this.title = title;
		this.contentCategory = contentCategory;
		this.content = content;
		this.viewCount = viewCount;
		this.likeCount = likeCount;
		this.createdAt = createdAt;
	}

	// 2. username을 포함하는 전체 생성자 (필요 시 사용)
	public FreeBoardDTO(int postId, String memberId, String title, String contentCategory, String content,
			int viewCount, int likeCount, Timestamp createdAt, int replyCount, String username) {
		this.postId = postId;
		this.memberId = memberId;
		this.title = title;
		this.contentCategory = contentCategory;
		this.content = content;
		this.viewCount = viewCount;
		this.likeCount = likeCount;
		this.createdAt = createdAt;
		this.replyCount = replyCount;
		this.username = username;
	}

	// 3. username Getter / Setter 추가
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public int getReplyCount() { return replyCount; }
	public void setReplyCount(int replyCount) { this.replyCount = replyCount; }
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
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContentCategory() {
		return contentCategory;
	}
	public void setContentCategory(String contentCategory) {
		this.contentCategory = contentCategory;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
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