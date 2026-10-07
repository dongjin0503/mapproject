package com.kedu.dto;

import java.sql.Timestamp;

public class PartyDTO {

   private int partyId;
   private String hostId;
   private int storeId;
   private String address;
   private String storeName;
   private String title;
   private String contents;
   private Timestamp meetDate;
   private String joinType;
   private int minPeople;
   private int maxPeople;
   private String genderRule;
   private Integer minAge;
   private Integer maxAge;
   private String question;
   private Timestamp regdate;
   private String imageSysName;

   public PartyDTO() {
   }
   

   public PartyDTO(int partyId, String hostId, int storeId, String address, String storeName, String title,
         String contents, Timestamp meetDate, String joinType, int minPeople, int maxPeople, String genderRule,
         Integer minAge, Integer maxAge, String question, Timestamp regdate, String imageSysName) {
      super();
      this.partyId = partyId;
      this.hostId = hostId;
      this.storeId = storeId;
      this.address = address;
      this.storeName = storeName;
      this.title = title;
      this.contents = contents;
      this.meetDate = meetDate;
      this.joinType = joinType;
      this.minPeople = minPeople;
      this.maxPeople = maxPeople;
      this.genderRule = genderRule;
      this.minAge = minAge;
      this.maxAge = maxAge;
      this.question = question;
      this.regdate = regdate;
      this.imageSysName = imageSysName;
   }


   public int getPartyId() {
      return partyId;
   }


   public void setPartyId(int partyId) {
      this.partyId = partyId;
   }


   public String getHostId() {
      return hostId;
   }


   public void setHostId(String hostId) {
      this.hostId = hostId;
   }


   public int getStoreId() {
      return storeId;
   }


   public void setStoreId(int storeId) {
      this.storeId = storeId;
   }


   public String getAddress() {
      return address;
   }


   public void setAddress(String address) {
      this.address = address;
   }


   public String getStoreName() {
      return storeName;
   }


   public void setStoreName(String storeName) {
      this.storeName = storeName;
   }


   public String getTitle() {
      return title;
   }


   public void setTitle(String title) {
      this.title = title;
   }


   public String getContents() {
      return contents;
   }


   public void setContents(String contents) {
      this.contents = contents;
   }


   public Timestamp getMeetDate() {
      return meetDate;
   }


   public void setMeetDate(Timestamp meetDate) {
      this.meetDate = meetDate;
   }


   public String getJoinType() {
      return joinType;
   }


   public void setJoinType(String joinType) {
      this.joinType = joinType;
   }


   public int getMinPeople() {
      return minPeople;
   }


   public void setMinPeople(int minPeople) {
      this.minPeople = minPeople;
   }


   public int getMaxPeople() {
      return maxPeople;
   }


   public void setMaxPeople(int maxPeople) {
      this.maxPeople = maxPeople;
   }


   public String getGenderRule() {
      return genderRule;
   }


   public void setGenderRule(String genderRule) {
      this.genderRule = genderRule;
   }


   public Integer getMinAge() {
      return minAge;
   }


   public void setMinAge(Integer minAge) {
      this.minAge = minAge;
   }


   public Integer getMaxAge() {
      return maxAge;
   }


   public void setMaxAge(Integer maxAge) {
      this.maxAge = maxAge;
   }


   public String getQuestion() {
      return question;
   }


   public void setQuestion(String question) {
      this.question = question;
   }


   public Timestamp getRegdate() {
      return regdate;
   }


   public void setRegdate(Timestamp regdate) {
      this.regdate = regdate;
   }
   

   public String getImageSysName() {
      return imageSysName;
   }

   public void setImageSysName(String imageSysName) {
      this.imageSysName = imageSysName;
   }
   
}
