package com.iig.gcp.extraction.sybase.service;

import java.io.File;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.json.JSONException;

import com.iig.gcp.extraction.sybase.dto.ConnectionMaster;
import com.iig.gcp.extraction.sybase.dto.CountryMaster;
import com.iig.gcp.extraction.sybase.dto.DataDetailBean;
import com.iig.gcp.extraction.sybase.dto.DriveMaster;
import com.iig.gcp.extraction.sybase.dto.ReservoirMaster;
import com.iig.gcp.extraction.sybase.dto.RunFeedsBean;
import com.iig.gcp.extraction.sybase.dto.SourceSystemDetailBean;
import com.iig.gcp.extraction.sybase.dto.SourceSystemMaster;
import com.iig.gcp.extraction.sybase.dto.TargetMaster;
import com.iig.gcp.extraction.sybase.dto.TempDataDetailBean;

public interface ExtractionService {

	public String invokeRest(String json,String url) throws UnsupportedOperationException, Exception ;
	public ArrayList<ConnectionMaster> getConnections(String src_val, String project_id) throws Exception;
	public ArrayList<TargetMaster> getTargets(String project_id) throws Exception;
	public TargetMaster getTargets1(int tgt) throws Exception;
	public ConnectionMaster getConnections1(String src_val,int src_sys_id) throws Exception;
	public ConnectionMaster getConnections2(String src_val,int conn_id, String project_id) throws Exception;
	public String getExtType(int src_sys_id) throws Exception;
	public String getExtType1(String src_unique_name) throws Exception;
	public ArrayList<SourceSystemMaster> getSources(String src_val, String project_id) throws Exception;
	public ArrayList<SourceSystemDetailBean> getSources1(String src_val,int src_sys_id) throws Exception;
	public ArrayList<String> getTables(String src_val,int conn_id, String schema_name, String project_id,String db_name) throws Exception;
	public ArrayList<String> getFields(String id,String src_val,String table_name,int conn_id, String schema_name, String project_id,String db_name) throws Exception;
	public ArrayList<CountryMaster> getCountries() throws Exception;
	public ArrayList<ReservoirMaster> getReservoirs() throws Exception;
	public ArrayList<DataDetailBean> getData(int src_sys_id,String src_val, int conn_id,String project_id,String db_name) throws Exception;
	public int checkNames(String sun) throws Exception;
	public ArrayList<String> getSchema(String src_val,int conn_id, String project_id,String db_name) throws Exception;
	public ArrayList<String> getSystem(String project) throws Exception, Exception;
	public String getSystemName(int system) throws Exception;
	public ArrayList<DriveMaster> getDrives(String project_id) throws Exception;
	public ArrayList<DriveMaster> getDrives1(int src_sys_id) throws Exception;
	public DriveMaster getDrivesDetails(int drive_id) throws Exception;
	public ArrayList<String> getSchemaData(String src_val,int src_sys_id) throws Exception;
	public void updateLoggerTable(String src_unique_name) throws Exception;
	public ArrayList<String> getGoogleProject(String project_id) throws Exception;
	public ArrayList<String> getServiceBucket(String project, String project_id) throws Exception;
	public ArrayList<String> getRunFeeds(String project_id) throws Exception;
	public ArrayList<RunFeedsBean> getLastRunFeeds(String project_id , String feed) throws Exception;
	public ArrayList<String> getHivedbList(String project_id) throws Exception;
	public ArrayList<TempDataDetailBean> getTempData(int src_sys_id,String src_val,String project_id) throws Exception;
	public String getBulkDataTemplate(int src_sys_id) throws Exception;		
	public ArrayList<String> getKafkaTopic() throws Exception;
	public ArrayList<String> getColList(String table_name) throws Exception;
	public String getDatabaseData(String src_val, int src_sys_id) throws Exception;
	public String getJsonFromFile(File file,String user,String project,int src_sys_id) throws Exception;
	public String getJsonFromFeedSequence(String project,String src_sys_id) throws JSONException;
	public int getRecCount(int src_sys_id) throws Exception;
	public String invokeRestAsyncronous(String json, String url) throws UnsupportedOperationException, Exception;
	public String getFeedName (int src_sys_id) throws Exception;
	public ArrayList<TempDataDetailBean> getInProgressTempData(int src_sys_id, String src_val, String project_id) throws Exception;
	public ArrayList<TempDataDetailBean> getValidatedTempData(int src_sys_id, String src_val, String project_id) throws Exception;
}
