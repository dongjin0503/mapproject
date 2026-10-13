package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.QnaDTO;

@Repository
public class QnaDAO {
	
	@Autowired
	private JdbcTemplate jdbc;
	
	public List<QnaDTO> listQna(String keyword){
		
		String sql = "select q.qna_id , q.title , q.writer , q.secret , q.write_date , q.view_count , m.username "
				+ " from qna q  join member m on q.writer = m.member_id "
				+ "where q.title like ? order by q.qna_id desc";
				
		return jdbc.query(sql,new BeanPropertyRowMapper<>(QnaDTO.class), "%" + keyword + "%");
	}
	
	public QnaDTO getQna(int qna_id) {
		
		String sql = "select q.qna_id , q.title , q.writer , q.secret , q.write_date , q.view_count , q.content, m.username "
				+ " from qna q  join member m on q.writer = m.member_id "
				+ "where q.qna_id = ?";
		return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(QnaDTO.class), qna_id);
	}
	
	public int addViewCount(int qna_id) {
		
		String sql = "update qna set view_count = +1 where qna_id = ?";
				
		return jdbc.queryForObject(sql, Integer.class , qna_id);
	}
	
//	public int addQna(QnaDTO dto) {
//		
//		String sql = "insert into qna(qna_id , title , contents , writer_date , secret , view_count)"
//				+ " values (Qna_seq.nextval, ? , ? ,systimestamp , ? , 0 );	  
//				
//		return jdbc.update(sql , dto);
//	}
}
