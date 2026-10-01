package com.kedu.dto;

public class Store_ServiceDTO {

	private int service_id;
	private int store_id;
	private String service_name;
	private int price;
	
	public Store_ServiceDTO() {
		
	}
	
	public Store_ServiceDTO(int service_id , int store_id , String service_name , int price) {
		this.service_id = service_id;
		this.store_id = store_id;
		this.service_name = service_name;
		this.price = price;
	}
	
	public int getService_id() {
		return service_id;
	}
	public void setService_id(int service_id) {
		this.service_id = service_id;
	}

	public int getStore_id() {
		return store_id;
	}

	public void setStore_id(int store_id) {
		this.store_id = store_id;
	}

	public String getService_name() {
		return service_name;
	}

	public void setService_name(String service_name) {
		this.service_name = service_name;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}
}
