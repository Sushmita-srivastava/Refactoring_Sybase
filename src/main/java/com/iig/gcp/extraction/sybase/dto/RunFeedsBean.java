package com.iig.gcp.extraction.sybase.dto;

public class RunFeedsBean {

	private String feed_name;
	private String run_id;
	private String extract_date;
	private String extraction_type;
	private String start_time;
	private String end_time;
	private String status;
	public String getFeed_name() {
		return feed_name;
	}
	public void setFeed_name(String feed_name) {
		this.feed_name = feed_name;
	}
	public String getRun_id() {
		return run_id;
	}
	public void setRun_id(String run_id) {
		this.run_id = run_id;
	}
	public String getExtraction_type() {
		return extraction_type;
	}
	public void setExtraction_type(String extraction_type) {
		this.extraction_type = extraction_type;
	}
	public String getStart_time() {
		return start_time;
	}
	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}
	public String getEnd_time() {
		return end_time;
	}
	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getExtract_date() {
		return extract_date;
	}
	public void setExtract_date(String extract_date) {
		this.extract_date = extract_date;
	}

}
	