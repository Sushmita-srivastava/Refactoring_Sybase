package com.iig.gcp.extraction.sybase.dto;

public class SourceSystemDetailBean {
	
	private int src_sys_id;
	private String src_unique_name ;
	private String src_sys_desc;
	private String country_code;
	private String extraction_type;
	private String target;
	private int connection_id;
	private String service_account_name;
	private int reservoir_id;
	
	public int getSrc_sys_id() {
		return src_sys_id;
	}
	public void setSrc_sys_id(int src_sys_id) {
		this.src_sys_id = src_sys_id;
	}
	public String getSrc_unique_name() {
		return src_unique_name;
	}
	public void setSrc_unique_name(String src_unique_name) {
		this.src_unique_name = src_unique_name;
	}
	public String getSrc_sys_desc() {
		return src_sys_desc;
	}
	public void setSrc_sys_desc(String src_sys_desc) {
		this.src_sys_desc = src_sys_desc;
	}
	public String getCountry_code() {
		return country_code;
	}
	public void setCountry_code(String country_code) {
		this.country_code = country_code;
	}
	public String getExtraction_type() {
		return extraction_type;
	}
	public void setExtraction_type(String extraction_type) {
		this.extraction_type = extraction_type;
	}
	public String getTarget() {
		return target;
	}
	public void setTarget(String target) {
		this.target = target;
	}
	public int getConnection_id() {
		return connection_id;
	}
	public void setConnection_id(int connection_id) {
		this.connection_id = connection_id;
	}
	public String getService_account_name() {
		return service_account_name;
	}
	public void setService_account_name(String service_account_name) {
		this.service_account_name = service_account_name;
	}
	public int getReservoir_id() {
		return reservoir_id;
	}
	public void setReservoir_id(int reservoir_id) {
		this.reservoir_id = reservoir_id;
	}
	
}
