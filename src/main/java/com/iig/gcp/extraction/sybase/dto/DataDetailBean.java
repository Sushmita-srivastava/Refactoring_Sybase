package com.iig.gcp.extraction.sybase.dto;

import java.util.ArrayList;

public class DataDetailBean {
	
	private String schema_name ;
	private String table_name ;
	private String column_name;
	private String where_clause;
	private String fetch_type;
	private String incr_column;
	private String cols;
	private String unsel_cols;
	public String getSchema_name() {
		return schema_name;
	}
	public void setSchema_name(String schema_name) {
		this.schema_name = schema_name;
	}
	public String getTable_name() {
		return table_name;
	}
	public void setTable_name(String table_name) {
		this.table_name = table_name;
	}
	public String getColumn_name() {
		return column_name;
	}
	public void setColumn_name(String column_name) {
		this.column_name = column_name;
	}
	public String getWhere_clause() {
		return where_clause;
	}
	public void setWhere_clause(String where_clause) {
		this.where_clause = where_clause;
	}
	public String getFetch_type() {
		return fetch_type;
	}
	public void setFetch_type(String fetch_type) {
		this.fetch_type = fetch_type;
	}
	public String getIncr_column() {
		return incr_column;
	}
	public void setIncr_column(String incr_column) {
		this.incr_column = incr_column;
	}
	public String getCols() {
		return cols;
	}
	public void setCols(String cols) {
		this.cols = cols;
	}
	public String getUnsel_cols() {
		return unsel_cols;
	}
	public void setUnsel_cols(String unsel_cols) {
		this.unsel_cols = unsel_cols;
	}
}
