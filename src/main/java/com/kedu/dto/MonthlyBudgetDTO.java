package com.kedu.dto;

public class MonthlyBudgetDTO {

   private int budgetId;
   private String memberId;
   private String budgetMonth;
   private int budgetAmount;

   public MonthlyBudgetDTO() {
   }

   public int getBudgetId() {
      return budgetId;
   }

   public void setBudgetId(int budgetId) {
      this.budgetId = budgetId;
   }

   public String getMemberId() {
      return memberId;
   }

   public void setMemberId(String memberId) {
      this.memberId = memberId;
   }
   public MonthlyBudgetDTO(int budgetId, String memberId, String budgetMonth, int budgetAmount) {
	super();
	this.budgetId = budgetId;
	this.memberId = memberId;
	this.budgetMonth = budgetMonth;
	this.budgetAmount = budgetAmount;
}

public String getBudgetMonth() {
      return budgetMonth;
   }

   public void setBudgetMonth(String budgetMonth) {
      this.budgetMonth = budgetMonth;
   }

   public int getBudgetAmount() {
      return budgetAmount;
   }

   public void setBudgetAmount(int budgetAmount) {
      this.budgetAmount = budgetAmount;
   }
}