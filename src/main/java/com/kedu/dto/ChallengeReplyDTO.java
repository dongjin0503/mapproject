package com.kedu.dto;

	public class ChallengeReplyDTO {

		private int challenge_reply_id;
		private int challenge_id;
		private String member_id;
		private String content;
		private Integer parent_reply_id;   // 댓글이면 null, 대댓글이면 부모 댓글 번호
		private String created_at;
		private String username;



		public ChallengeReplyDTO() {
		}

		public int getChallenge_reply_id() { return challenge_reply_id; }
		public void setChallenge_reply_id(int challenge_reply_id) { this.challenge_reply_id = challenge_reply_id; }

		public int getChallenge_id() { return challenge_id; }
		public void setChallenge_id(int challenge_id) { this.challenge_id = challenge_id; }

		public String getMember_id() { return member_id; }
		public void setMember_id(String member_id) { this.member_id = member_id; }

		public String getContent() { return content; }
		public void setContent(String content) { this.content = content; }

		public Integer getParent_reply_id() { return parent_reply_id; }
		public void setParent_reply_id(Integer parent_reply_id) { this.parent_reply_id = parent_reply_id; }

		public String getCreated_at() { return created_at; }
		public void setCreated_at(String created_at) { this.created_at = created_at; }
		public String getUsername() {
			return username;
		}

		public void setUsername(String username) {
			this.username = username;
		}
	}

	