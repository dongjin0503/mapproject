package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.QnaDTO;
import com.kedu.dto.QnaReplyDTO;

@Repository
public class QnaDAO {
	
	@Autowired
	private JdbcTemplate jdbc;
	
	public List<QnaDTO> listQna(String keyword){
		
		String sql = "select q.qna_id , q.title , q.writer , q.secret , q.write_date , q.view_count , m.username , "
		        + "(select count(*) from qna_reply r where r.parent_qna_id = q.qna_id) as reply_count "
		        + " from qna q  join member m on q.writer = m.member_id "
		        + "where q.title like ? order by q.qna_id desc";
				
		return jdbc.query(sql,new BeanPropertyRowMapper<>(QnaDTO.class), "%" + keyword + "%");
	}
	
	public QnaDTO getQna(int qna_id) {
		
		String sql = "select q.qna_id , q.title , q.writer , q.secret , q.write_date , q.view_count , q.contents , m.username "
				+ " from qna q  join member m on q.writer = m.member_id "
				+ "where q.qna_id = ?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(QnaDTO.class), qna_id);
	}
	
	public int addViewCount(int qna_id) {
		
		String sql = "update qna set view_count = view_count +1 where qna_id = ?";
				
		return jdbc.update(sql,  qna_id);
	}
	

	public int addQna(QnaDTO dto) {
		
		String sql = "insert into qna(qna_id , title , contents , writer , write_date , secret , view_count) "
		        + "values (qna_seq.nextval , ? , ? , ? , systimestamp , ? , 0)";

		return jdbc.update(sql, dto.getTitle(), dto.getContents(), dto.getWriter(), dto.getSecret());
	}
	
	public int updateQna(QnaDTO dto) {
		String sql = "update qna set title = ? , contents = ? , secret = ? where qna_id = ? and writer = ? ";
		
		return jdbc.update(sql , dto.getTitle() ,dto.getContents() , dto.getSecret(), dto.getQna_id() , dto.getWriter());
	}
	
	public int deleteQna (int qna_id , String writer) {
		String sql1 = "delete from  qna_reply where parent_qna_id = ? ";
		
		jdbc.update(sql1 , qna_id);
		
		String sql2 = "delete from qna where qna_id = ? and writer = ?";
		return jdbc.update(sql2 , qna_id, writer);
	}
	
	public List<QnaReplyDTO> listReply(int qna_id){
		String sql = "select r.qna_reply_id , r.parent_qna_id , r.contents , r.writer , r.write_date , m.username from qna_reply r join "
				+ "member m on r.writer = m.member_id where r.parent_qna_id = ? order by r.qna_reply_id" ;
		
		return jdbc.query(sql, new BeanPropertyRowMapper<>(QnaReplyDTO.class) , qna_id);
	}
	
	public int addQnaReply(QnaReplyDTO dto) {
		
		String sql = "insert into qna_reply(qna_reply_id , parent_qna_id , contents , writer , write_date) "
				+ "values (qna_reply_seq.nextval , ? , ? , ? , systimestamp)";
		
		return jdbc.update(sql , dto.getParent_qna_id() , dto.getContents() , dto.getWriter());
	}
	
	public int updateQnaReply(QnaReplyDTO dto) {
		
		String sql = "update qna_reply set contents = ? where qna_reply_id = ?";
		
		return jdbc.update(sql , dto.getContents() , dto.getQna_reply_id());
	}
	
	public int deleteQnaReply(int qna_reply_id) {
		
		String sql = "delete from qna_reply where qna_reply_id = ?";
			
		return jdbc.update(sql , qna_reply_id);
	}
}
