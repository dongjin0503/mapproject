package com.kedu.dto;

public class FreeBoardLikeDTO {

	private int likeId;
	private int postId;
	private String memberId;
	
	
	
	public FreeBoardLikeDTO() {}
	public FreeBoardLikeDTO(int likeId, int postId, String memberId) {
		super();
		this.likeId = likeId;
		this.postId = postId;
		this.memberId = memberId;
	}
	public int getLikeId() {
		return likeId;
	}
	public void setLikeId(int likeId) {
		this.likeId = likeId;
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
	
	
	
}
