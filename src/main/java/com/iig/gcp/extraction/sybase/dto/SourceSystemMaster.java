package com.iig.gcp.extraction.sybase.dto;

public class SourceSystemMaster {
	
	private int src_sys_id;
	private String src_unique_name ;
	private String src_sys_desc;
	private String country_code;
	private String table_list;
	private String file_list;
	private String db_name;
	
	public String getTable_list() {
		return table_list;
	}
	public void setTable_list(String table_list) {
		this.table_list = table_list;
	}
	public String getFile_list() {
		return file_list;
	}
	public void setFile_list(String file_list) {
		this.file_list = file_list;
	}
	
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
	public String getDb_name() {
		return db_name;
	}
	public void setDb_name(String db_name) {
		this.db_name = db_name;
	}
	
}
