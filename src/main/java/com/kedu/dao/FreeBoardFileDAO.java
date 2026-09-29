package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import com.kedu.dto.FreeBoardFileDTO;

public class FreeBoardFileDAO {

	@Autowired
	private JdbcTemplate jdbc;

	public void insert(String oriName,String sysName,int thisSeq) {

		String sql = "insert into files values(files_seq.nextval, ?, ?, sysdate, ?)";
		jdbc.update(sql, oriName, sysName, thisSeq);
	}
	
	public List<FreeBoardFileDTO> fileList(int postId){
		String sql = "select * from files where parent_seq=?";
		return jdbc.query(sql,new BeanPropertyRowMapper<>(FreeBoardFileDTO.class),postId);
	}
}
