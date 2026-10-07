package com.kedu.dto;

import java.sql.Date;

public class LedgerDTO {

   private int ledgerId;
   private String memberId;
   private Date ledgerDate;
   private String type;
   private String category;
   private int amount;
   private String memo;

   public LedgerDTO() {
   }

   public LedgerDTO(int ledgerId, String memberId, Date ledgerDate, String type, String category, int amount,
      String memo) {
   super();
   this.ledgerId = ledgerId;
   this.memberId = memberId;
   this.ledgerDate = ledgerDate;
   this.type = type;
   this.category = category;
   this.amount = amount;
   this.memo = memo;
}

public int getLedgerId() {
      return ledgerId;
   }

   public void setLedgerId(int ledgerId) {
      this.ledgerId = ledgerId;
   }

   public String getMemberId() {
      return memberId;
   }

   public void setMemberId(String memberId) {
      this.memberId = memberId;
   }

   public Date getLedgerDate() {
      return ledgerDate;
   }

   public void setLedgerDate(Date ledgerDate) {
      this.ledgerDate = ledgerDate;
   }

   public String getType() {
      return type;
   }

   public void setType(String type) {
      this.type = type;
   }

   public String getCategory() {
      return category;
   }

   public void setCategory(String category) {
      this.category = category;
   }

   public int getAmount() {
      return amount;
   }

   public void setAmount(int amount) {
      this.amount = amount;
   }

   public String getMemo() {
      return memo;
   }

   public void setMemo(String memo) {
      this.memo = memo;
   }
}