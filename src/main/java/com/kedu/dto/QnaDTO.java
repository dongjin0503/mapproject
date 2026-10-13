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
	
	
}
