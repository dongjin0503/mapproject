package com.kedu.dto;

	public class AdminDashboardDTO {

		private String month;
		private int count;
		private String gender;
		private String ageGroup;

		public AdminDashboardDTO() {
		}

		public AdminDashboardDTO(String month, int count, String gender, String ageGroup) {
			super();
			this.month = month;
			this.count = count;
			this.gender = gender;
			this.ageGroup = ageGroup;
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
	}
	

