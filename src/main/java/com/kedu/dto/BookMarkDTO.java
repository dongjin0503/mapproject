package com.kedu.dto;

import java.sql.Timestamp;

public class BookMarkDTO {

	private int bookmarkId;
	private String memberId;
	private String contentType;
	private int contentId;
	private Timestamp createdAt;
	private String title;
	private String category;
	
	public BookMarkDTO() {}
	public BookMarkDTO(int bookmarkId, String memberId, String contentType, int contentId, Timestamp createdAt) {
		super();
		this.bookmarkId = bookmarkId;
		this.memberId = memberId;
		this.contentType = contentType;
		this.contentId = contentId;
		this.createdAt = createdAt;
	}
	public String getCategory() { return category; }
	public void setCategory(String category) { this.category = category; }
	public String getTitle() {
	    return title;
	}
	public void setTitle(String title) {
	    this.title = title;
	}
	public int getBookmarkId() {
		return bookmarkId;
	}
	public void setBookmarkId(int bookmarkId) {
		this.bookmarkId = bookmarkId;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public int getContentId() {
		return contentId;
	}
	public void setContentId(int contentId) {
		this.contentId = contentId;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	
	
	
	
}
