package com.iig.gcp.extraction.sybase.dto;

public class KafkaTopic {
	private String project_id;
	public String getProject_id() {
		return project_id;
	}
	public void setProject_id(String project_id) {
		this.project_id = project_id;
	}
	public String getKafka_topic() {
		return kafka_topic;
	}
	public void setKafka_topic(String kafka_topic) {
		this.kafka_topic = kafka_topic;
	}
	public String getCreated_dt() {
		return created_dt;
	}
	public void setCreated_dt(String created_dt) {
		this.created_dt = created_dt;
	}
	private String kafka_topic;
	private String created_dt;
}