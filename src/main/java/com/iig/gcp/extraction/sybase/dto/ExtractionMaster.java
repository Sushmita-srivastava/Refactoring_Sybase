package com.iig.gcp.extraction.sybase.dto;

public class ExtractionMaster {
	
	
	private int src_sys_id;
	private String src_unique_name;
	private String src_sys_type;
	private String country_code;
	private String storage_loc;
	private String host_name;
	private String port_no;
	private String username;
	private String password;
	private String database_name;
	private String service_name;
	private String table_names;
	private String incremental_cols;
	private int reservoir_id;
	private int schedule_id;
	
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
	public String getSrc_sys_type() {
		return src_sys_type;
	}
	public void setSrc_sys_type(String src_sys_type) {
		this.src_sys_type = src_sys_type;
	}
	public String getCountry_code() {
		return country_code;
	}
	public void setCountry_code(String country_code) {
		this.country_code = country_code;
	}
	public String getStorage_loc() {
		return storage_loc;
	}
	public void setStorage_loc(String storage_loc) {
		this.storage_loc = storage_loc;
	}
	public String getHost_name() {
		return host_name;
	}
	public void setHost_name(String host_name) {
		this.host_name = host_name;
	}
	public String getPort_no() {
		return port_no;
	}
	public void setPort_no(String port_no) {
		this.port_no = port_no;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getDatabase_name() {
		return database_name;
	}
	public void setDatabase_name(String database_name) {
		this.database_name = database_name;
	}
	public String getService_name() {
		return service_name;
	}
	public void setService_name(String service_name) {
		this.service_name = service_name;
	}
	public String getTable_names() {
		return table_names;
	}
	public void setTable_names(String table_names) {
		this.table_names = table_names;
	}
	public String getIncremental_cols() {
		return incremental_cols;
	}
	public void setIncremental_cols(String incremental_cols) {
		this.incremental_cols = incremental_cols;
	}
	public int getReservoir_id() {
		return reservoir_id;
	}
	public void setReservoir_id(int reservoir_id) {
		this.reservoir_id = reservoir_id;
	}
	public int getSchedule_id() {
		return schedule_id;
	}
	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}

	
}
