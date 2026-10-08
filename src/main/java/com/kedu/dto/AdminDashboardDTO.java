package com.kedu.dto;

	public class AdminDashboardDTO {

		private String month;
		private int count;
		private String gender;
		private String ageGroup;
		private String category;
		private int createCount;
		private int joinCount;

		public AdminDashboardDTO() {
		}

		public AdminDashboardDTO(String month, int count, String gender, String ageGroup, String category, int createCount, int joinCount) {
			super();
			this.month = month;
			this.count = count;
			this.gender = gender;
			this.ageGroup = ageGroup;
			this.category = category;
			this.createCount = createCount;
			this.joinCount = joinCount;
		}

		public String getMonth() {
			return month;
		}

		public void setMonth(String month) {
			this.month = month;
		}

		public int getCount() {
			return count;
		}

		public void setCount(int count) {
			this.count = count;
		}
		
		public String getGender() {
			return gender;
		}
		
		public void setGender(String gender) {
			this.gender = gender;
		}

		public String getAgeGroup() {
			return ageGroup;
		}
		
		public void setAgeGroup(String ageGroup) {
			this.ageGroup = ageGroup;
		}

		public String getCategory() {
			return category;
		}

		public void setCategory(String category) {
			this.category = category;
		}

		public int getCreateCount() {
			return createCount;
		}

		public void setCreateCount(int createCount) {
			this.createCount = createCount;
		}

		public int getJoinCount() {
			return joinCount;
		}

		public void setJoinCount(int joinCount) {
			this.joinCount = joinCount;
		}
		
	}
	

