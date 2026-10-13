package com.kedu.dto;

import java.sql.Timestamp;

public class QnaDTO {

	private int qna_id;
	private String title;
	private String contents;
	private String writer;     
	private String secret;     
	private java.sql.Timestamp write_date;
	private int view_count;
	private String username;
	private int reply_count;
	
	public QnaDTO() {
		
	}
	public QnaDTO(int qna_id, String title, String contents, String writer, String secret, Timestamp write_date,
			int view_count, String username) {
		super();
		this.qna_id = qna_id;
		this.title = title;
		this.contents = contents;
		this.writer = writer;
		this.secret = secret;
		this.write_date = write_date;
		this.view_count = view_count;
		this.username = username;
	}
	public int getQna_id() {
		return qna_id;
	}
	public void setQna_id(int qna_id) {
		this.qna_id = qna_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getSecret() {
		return secret;
	}
	public void setSecret(String secret) {
		this.secret = secret;
	}
	public java.sql.Timestamp getWrite_date() {
		return write_date;
	}
	public void setWrite_date(java.sql.Timestamp write_date) {
		this.write_date = write_date;
	}
	public int getView_count() {
		return view_count;
	}
	public void setView_count(int view_count) {
		this.view_count = view_count;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public int getReply_count() {
		return reply_count;
	}
	public void setReply_count(int reply_count) {
		this.reply_count = reply_count;
	}
	

}
