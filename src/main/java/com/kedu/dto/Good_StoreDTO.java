package com.kedu.dto;

public class Good_StoreDTO {

	private int store_id;
	private String category;
	private String store_name;
	private String phone;
	private String address;
	private double latitude;
	private double longitude;
	//null 값 허용하기 위해 Integer 사용
	private Integer min_price;
	


	public Integer getMin_price() {
		return min_price;
	}

	public void setMin_price(Integer min_price) {
		this.min_price = min_price;
	}

	public int getStore_id() {
		return store_id;
	}

	public void setStore_id(int store_id) {
		this.store_id = store_id;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getStore_name() {
		return store_name;
	}

	public void setStore_name(String store_name) {
		this.store_name = store_name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public Good_StoreDTO(int store_id, String category, String store_name, String phone, String address,
			double latitude, double longitude) {
		super();
		this.store_id = store_id;
		this.category = category;
		this.store_name = store_name;
		this.phone = phone;
		this.address = address;
		this.latitude = latitude;
		this.longitude = longitude;
	}

	public Good_StoreDTO() {
		
	}
	
}
