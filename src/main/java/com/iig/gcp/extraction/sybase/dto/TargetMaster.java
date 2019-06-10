package com.iig.gcp.extraction.sybase.dto;

public class TargetMaster {

	private int target_conn_sequence;
	private String target_unique_name;
	private String target_type;
	private String gcp_project;
	private String gcp_service_account;
	private String gcp_bucket;
	private String hdp_knox_host;
	private int hdp_knox_port;
	private String hdp_user;
	private byte[] hdp_encrypted_password;
	private byte[] encrypted_key;
	private String hdfs_gateway;
	private String hdp_hdfs_path;
	private String materialization_flag;
	private String partition_flag;
	private String hive_gateway;
	private String jks_path;
	private int drive_sequence;
	private String unix_data_path;
	private String system_name;

	public int getTarget_conn_sequence() {
		return target_conn_sequence;
	}

	public void setTarget_conn_sequence(int target_conn_sequence) {
		this.target_conn_sequence = target_conn_sequence;
	}

	public String getTarget_unique_name() {
		return target_unique_name;
	}

	public void setTarget_unique_name(String target_unique_name) {
		this.target_unique_name = target_unique_name;
	}

	public String getTarget_type() {
		return target_type;
	}

	public void setTarget_type(String target_type) {
		this.target_type = target_type;
	}

	public String getGcp_project() {
		return gcp_project;
	}

	public void setGcp_project(String gcp_project) {
		this.gcp_project = gcp_project;
	}

	public String getGcp_service_account() {
		return gcp_service_account;
	}

	public void setGcp_service_account(String gcp_service_account) {
		this.gcp_service_account = gcp_service_account;
	}

	public String getGcp_bucket() {
		return gcp_bucket;
	}

	public void setGcp_bucket(String gcp_bucket) {
		this.gcp_bucket = gcp_bucket;
	}

	public String getHdp_knox_host() {
		return hdp_knox_host;
	}

	public void setHdp_knox_host(String hdp_knox_host) {
		this.hdp_knox_host = hdp_knox_host;
	}

	public int getHdp_knox_port() {
		return hdp_knox_port;
	}

	public void setHdp_knox_port(int hdp_knox_port) {
		this.hdp_knox_port = hdp_knox_port;
	}

	public String getHdp_user() {
		return hdp_user;
	}

	public void setHdp_user(String hdp_user) {
		this.hdp_user = hdp_user;
	}

	public byte[] getHdp_encrypted_password() {
		return hdp_encrypted_password;
	}

	public void setHdp_encrypted_password(byte[] hdp_encrypted_password) {
		this.hdp_encrypted_password = hdp_encrypted_password;
	}

	public byte[] getEncrypted_key() {
		return encrypted_key;
	}

	public void setEncrypted_key(byte[] encrypted_key) {
		this.encrypted_key = encrypted_key;
	}

	public String getHdfs_gateway() {
		return hdfs_gateway;
	}

	public void setHdfs_gateway(String hdfs_gateway) {
		this.hdfs_gateway = hdfs_gateway;
	}

	public String getHdp_hdfs_path() {
		return hdp_hdfs_path;
	}

	public void setHdp_hdfs_path(String hdp_hdfs_path) {
		this.hdp_hdfs_path = hdp_hdfs_path;
	}

	public String getMaterialization_flag() {
		return materialization_flag;
	}

	public void setMaterialization_flag(String materialization_flag) {
		this.materialization_flag = materialization_flag;
	}

	public String getPartition_flag() {
		return partition_flag;
	}

	public void setPartition_flag(String partition_flag) {
		this.partition_flag = partition_flag;
	}

	public String getHive_gateway() {
		return hive_gateway;
	}

	public void setHive_gateway(String hive_gateway) {
		this.hive_gateway = hive_gateway;
	}

	public String getJks_path() {
		return jks_path;
	}

	public void setJks_path(String jks_path) {
		this.jks_path = jks_path;
	}

	public int getDrive_sequence() {
		return drive_sequence;
	}

	public void setDrive_sequence(int drive_sequence) {
		this.drive_sequence = drive_sequence;
	}

	public String getUnix_data_path() {
		return unix_data_path;
	}

	public void setUnix_data_path(String unix_data_path) {
		this.unix_data_path = unix_data_path;
	}

	public String getSystem_name() {
		return system_name;
	}

	public void setSystem_name(String system_name) {
		this.system_name = system_name;
	}

}