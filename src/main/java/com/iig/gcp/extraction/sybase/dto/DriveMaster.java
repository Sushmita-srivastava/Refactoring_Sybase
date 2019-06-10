package com.iig.gcp.extraction.sybase.dto;

public class DriveMaster {
	
	private int drive_id;
	private String drive_name ;
	private String drive_path;
	private String project_id;
	public int getDrive_id() {
		return drive_id;
	}
	public void setDrive_id(int drive_id) {
		this.drive_id = drive_id;
	}
	public String getDrive_name() {
		return drive_name;
	}
	public void setDrive_name(String drive_name) {
		this.drive_name = drive_name;
	}
	public String getDrive_path() {
		return drive_path;
	}
	public void setDrive_path(String drive_path) {
		this.drive_path = drive_path;
	}
	public String getProject_id() {
		return project_id;
	}
	public void setProject_id(String project_id) {
		this.project_id = project_id;
	}
}
