package com.kedu.dto;

import java.sql.Timestamp;

public class QnaReplyDTO {

	private int qna_reply_id;
	private int parent_qna_id;
	private String contents;
	private String writer;
	private java.sql.Timestamp write_date;
	private String username;
	
	public QnaReplyDTO() {
		
	}

	public QnaReplyDTO(int qna_reply_id, int parent_qna_id, String contents, String writer, Timestamp write_date,
			String username) {
		super();
		this.qna_reply_id = qna_reply_id;
		this.parent_qna_id = parent_qna_id;
		this.contents = contents;
		this.writer = writer;
		this.write_date = write_date;
		this.username = username;
	}

	public int getQna_reply_id() {
		return qna_reply_id;
	}

	public void setQna_reply_id(int qna_reply_id) {
		this.qna_reply_id = qna_reply_id;
	}

	public int getParent_qna_id() {
		return parent_qna_id;
	}

	public void setParent_qna_id(int parent_qna_id) {
		this.parent_qna_id = parent_qna_id;
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

	public java.sql.Timestamp getWrite_date() {
		return write_date;
	}

	public void setWrite_date(java.sql.Timestamp write_date) {
		this.write_date = write_date;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
	
}
