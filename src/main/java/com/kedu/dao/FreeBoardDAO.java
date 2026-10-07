package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.FreeBoardDTO;

@Repository
public class FreeBoardDAO {

   @Autowired
   private JdbcTemplate jdbc;

   public List<FreeBoardDTO> boardList(int start, int end, String search, String category) {
		String sql = "select * from ("
				+ "select f.*, "
				+ "(select count(*) from freeboard_reply r where r.post_id = f.post_id) reply_count, "
				+ "row_number() over(order by f.post_id desc) rn "
				+ "from freeboard f "
				+ "where title like ? and content_category like ?) "
				+ "where rn between ? and ?";
		return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), "%" + search + "%", categoryFilter(category), start, end);
	}

//   public List<FreeBoardDTO> searchTitle(String search) throws Exception {
//      String sql = "select * from freeboard where title like ? order by post_id desc";
//      return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), "%" + search + "%");
//   }

   public int getNextSeq() {
      String sql = "select seq_freeboard.nextval from dual";
      return jdbc.queryForObject(sql, Integer.class);
   }

   public void writeUp(int postId, FreeBoardDTO dto) {
          String sql = "insert into freeboard(post_id, member_id, title, content_category, content, view_count, like_count) values(?, ?, ?, ?, ?, 0, 0)";
          jdbc.update(sql, postId, dto.getMemberId(), dto.getTitle(), dto.getContentCategory(), dto.getContent());
      }

   public FreeBoardDTO detail(int postId) {

      String sql1 = "update freeboard set view_count=view_count+1 where post_id = ?";
      jdbc.update(sql1, postId);

      String sql = "select * from freeboard where post_id=?";
      return jdbc.queryForObject(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), postId);
   }

   public void updateContent(FreeBoardDTO dto) {
      String sql = "update freeboard set title=?,content_category=?,content=? where post_id=?";
      jdbc.update(sql, dto.getTitle(), dto.getContentCategory(), dto.getContent(), dto.getPostId());
   }

   public void deleteContent(int postId) {
      String sql = "delete from freeboard where post_id=?";
      jdbc.update(sql, postId);
   }

   public int getTotalCount(String search, String category) {
		String sql = "select count(*) from freeboard where title like ? and content_category like ?";
		return jdbc.queryForObject(sql, Integer.class, "%" + search + "%", categoryFilter(category));
	}
   	// 전체(빈 값)면 "%"로 모든 글, 값이 있으면 그 카테고리만
   private String categoryFilter(String category) {
	   return (category == null || category.isEmpty()) ? "%" : category;
   	}

   public void likeCountPlus(int postId) {
      String sql = "update freeboard set like_count=like_count+1 where post_id=?";
      jdbc.update(sql, postId);
   }

   public void likeCountMinus(int postId) {
      String sql = "update freeboard set like_count=like_count-1 where post_id=?";
      jdbc.update(sql, postId);
   }

   public int getLikeCount(int postId) {
      String sql = "select like_count from freeboard where post_id=?";
      return jdbc.queryForObject(sql, Integer.class, postId);
   }
   
   public List<FreeBoardDTO> myContentList(String loginId){         //마이페이지 내 게시글 모아보기 리스트 & 댓글 갯수 포함
      String sql = "select f.*, (select count(*) from freeboard_reply r where r.post_id = f.post_id) as reply_count "
                 + "from freeboard f where f.member_id = ? order by f.post_id desc";
      return jdbc.query(sql, new BeanPropertyRowMapper<>(FreeBoardDTO.class), loginId);
   }
   public boolean isWriter(int postId, String memberId) {
       String sql = "select count(*) from freeboard where post_id=? and member_id=?";
       return jdbc.queryForObject(sql, Integer.class, postId, memberId) > 0;
   }


}