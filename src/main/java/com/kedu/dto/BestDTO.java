package com.kedu.dto;

public class BestDTO {

	private int rn;            // 순위
	private int postId;        // 글번호
	private String title;      // 제목
	private String category;   // 카테고리
	private int likeCount;     // 추천 수
	private int viewCount;     // 조회 수
	private String username;   // 작성자 닉네임
	private int replyCount;    // 댓글 수
	
	public BestDTO() {
		
	}
	public BestDTO(int rn, int postId, String title, String category, int likeCount, int viewCount, String username,
			int replyCount) {
		super();
		this.rn = rn;
		this.postId = postId;
		this.title = title;
		this.category = category;
		this.likeCount = likeCount;
		this.viewCount = viewCount;
		this.username = username;
		this.replyCount = replyCount;
	}
	public int getRn() {
		return rn;
	}
	public void setRn(int rn) {
		this.rn = rn;
	}
	public int getPostId() {
		return postId;
	}
	public void setPostId(int postId) {
		this.postId = postId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public int getReplyCount() {
		return replyCount;
	}
	public void setReplyCount(int replyCount) {
		this.replyCount = replyCount;
	}
	
	
}
