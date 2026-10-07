package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.FreeBoardFileDTO;


@Repository
public class FreeBoardFileDAO {

	@Autowired
	private JdbcTemplate jdbc;

	public void insert(String oriName,String sysName,int postId) {

		String sql = "insert into freeboard_file values(seq_freeboard_file.nextval, ?, ?, ?)";
		jdbc.update(sql,postId, oriName, sysName);
	}
	
	public List<FreeBoardFileDTO> fileList(int postId){ 
	    String sql = "select f.* from freeboard_file f where f.post_id=?"; 
	    return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardFileDTO.class), postId); 
	}
	
	public FreeBoardFileDTO selectById(int fileId) {
	    String sql = "select f.* from freeboard_file f where f.file_id=?";
	    return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(FreeBoardFileDTO.class), fileId);
	}

	public void delete(int fileId) {
	    String sql = "delete from freeboard_file where file_id=?";
	    jdbc.update(sql, fileId);
	}
}