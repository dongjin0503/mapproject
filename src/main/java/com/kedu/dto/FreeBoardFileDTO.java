package com.kedu.dto;

import java.sql.Timestamp;

public class FreeBoardFileDTO {

	private int fileId;
	private int postId;
	private String oriname;
	private String sysname;
	
	public FreeBoardFileDTO() {}
	public FreeBoardFileDTO(int fileId, int postId, String oriname, String sysname) {
		super();
		this.fileId = fileId;
		this.postId = postId;
		this.oriname = oriname;
		this.sysname = sysname;
	}
	public int getFileId() {
		return fileId;
	}
	public void setFileId(int fileId) {
		this.fileId = fileId;
	}
	public int getPostId() {
		return postId;
	}
	public void setPostId(int postId) {
		this.postId = postId;
	}
	public String getOriname() {
		return oriname;
	}
	public void setOriname(String oriname) {
		this.oriname = oriname;
	}
	public String getSysname() {
		return sysname;
	}
	public void setSysname(String sysname) {
		this.sysname = sysname;
	}

	
}
