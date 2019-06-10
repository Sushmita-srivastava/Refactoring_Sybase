package com.iig.gcp.extraction.sybase.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.nio.client.CloseableHttpAsyncClient;
import org.apache.http.impl.nio.client.HttpAsyncClients;
import org.apache.http.util.EntityUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.iig.gcp.constants.SybaseConstants;
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
import com.iig.gcp.extraction.utils.CSV;
import com.iig.gcp.extraction.utils.ConnectionUtils;
import com.iig.gcp.extraction.utils.EncryptionUtil;
import com.opencsv.CSVWriter;

@Service
public class ExtractionServiceImpl implements ExtractionService {

	@Autowired
	private ConnectionUtils ConnectionUtils;
	private static String SCHEDULER_MASTER_TABLE = "JUNIPER_SCH_MASTER_JOB_DETAIL";
	
	private static final Logger logger =  LogManager.getLogger(ExtractionServiceImpl.class);

	@Override
	public String invokeRest(String json, String url) throws UnsupportedOperationException, Exception {
		String resp = null;
		CloseableHttpClient httpClient = HttpClientBuilder.create().build();
		
		
		System.out.println(">>>>>>>>>>>"+url);
		
		
		HttpPost postRequest = new HttpPost(url);
		
	
		postRequest.setHeader("Content-Type", "application/json");
		StringEntity input = new StringEntity(json);
		postRequest.setEntity(input);
		System.out.println("Executing POST Request!");
		HttpResponse response = httpClient.execute(postRequest);
		String response_string = EntityUtils.toString(response.getEntity(), "UTF-8");
		
		System.out.println("response_string>>>"+response_string);
		
		if (response.getStatusLine().getStatusCode() != 200) {
			resp = "Error" + response_string;
			throw new Exception("Error" + response_string);
		} else {
			resp = response_string;
		}
		
	
		return resp;
	}
	
	@Override
	public String invokeRestAsyncronous(String json, String url) throws UnsupportedOperationException, Exception {
		String resp = null;
		CloseableHttpAsyncClient httpclient = HttpAsyncClients.createDefault();
		try{
			
			// Start the client 
			httpclient.start();
		// Execute request
			final HttpPost request1 = new HttpPost(url);
			request1.setHeader("Content-type", "application/json");
			StringEntity input = new StringEntity(json);
			request1.setEntity(input);
			Future<HttpResponse> future = httpclient.execute(request1, null);
			long number = 2L;
			HttpResponse response1 = future.get(number, TimeUnit.SECONDS );
			resp="Started";
		}catch(Exception e){
			resp="Started";
			logger.info(e.getMessage());
		}finally {
			httpclient.close();
		}
		return resp;
	}	
		
				
	@Override
	public ArrayList<String> getRunFeeds(String projectId) throws Exception {
		ArrayList<String> arr = new ArrayList<String>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("SELECT DISTINCT n.FEED_UNIQUE_NAME FROM  JUNIPER_EXT_NIFI_STATUS n LEFT JOIN JUNIPER_PROJECT_MASTER p"
					+ " ON n.PROJECT_SEQUENCE=p.PROJECT_SEQUENCE WHERE p.PROJECT_ID=? AND UPPER(n.PG_TYPE)='SYBASE'");
			pstm.setString(1, projectId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				arr.add(rs.getString(1));
			}

		} catch (SQLException e) {
			logger.error(e.getMessage());
		} finally {
			pstm.close();
			connection.close();
		}
		return arr;
	}

	@Override
	public ArrayList<RunFeedsBean> getLastRunFeeds(String project_id, String feed) throws Exception {
		ArrayList<RunFeedsBean> arr = new ArrayList<RunFeedsBean>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"SELECT n.FEED_UNIQUE_NAME,n.RUN_ID, TO_CHAR(TO_DATE(n.EXTRACTED_DATE,'YYYMMDD'),'DD-MON-YY'),f.EXTRACTION_TYPE|| ' ' ||n.PG_TYPE,n.JOB_START_TIME,n.JOB_END_TIME,UPPER(n.STATUS) FROM  JUNIPER_EXT_NIFI_STATUS n LEFT JOIN JUNIPER_EXT_FEED_MASTER f ON n.FEED_UNIQUE_NAME=f.FEED_UNIQUE_NAME and n.PROJECT_SEQUENCE=f.PROJECT_SEQUENCE LEFT JOIN JUNIPER_PROJECT_MASTER p ON f.PROJECT_SEQUENCE=p.PROJECT_SEQUENCE WHERE p.PROJECT_ID=? and n.FEED_UNIQUE_NAME=? ORDER BY n.EXTRACTED_DATE");
			pstm.setString(1, project_id);
			pstm.setString(2, feed);

			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				RunFeedsBean runf = new RunFeedsBean();
				runf.setFeed_name(rs.getString(1));
				runf.setRun_id(rs.getString(2));
				runf.setExtract_date(rs.getString(3));
				runf.setExtraction_type(rs.getString(4));
				runf.setStart_time(rs.getString(5));
				runf.setEnd_time(rs.getString(6));
				runf.setStatus(rs.getString(7));
				arr.add(runf);
			}

		} catch (SQLException e) {
			logger.info("Throwing Exception "+e.getMessage());
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}

		return arr;
	}

	@Override
	public ArrayList<ConnectionMaster> getConnections(String srcVal, String projectId) throws Exception {
		// TODO Auto-generated method stub
		Connection connection = null;
		ConnectionMaster conn = null;
		PreparedStatement pstm = null;
		ArrayList<ConnectionMaster> arrConnectionMaster = new ArrayList<ConnectionMaster>();
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"SELECT SRC_CONN_SEQUENCE,SRC_CONN_NAME,host_name,port_no,username,password,database_name,service_name,system_sequence,drive_sequence,encrypted_encr_key from JUNIPER_EXT_SRC_CONN_MASTER where SRC_CONN_TYPE=? and project_sequence = (select project_sequence from juniper_project_master where project_id=?)");
			pstm.setString(1, srcVal);
			pstm.setString(2, projectId);

			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				conn = new ConnectionMaster();
				conn.setConnection_id(rs.getInt(1));
				conn.setConnection_name(rs.getString(2));
				conn.setHost_name(rs.getString(3));
				conn.setPort_no(rs.getString(4));
				conn.setUsername(rs.getString(5));
				conn.setPassword(rs.getBytes(6));
				conn.setDatabase_name(rs.getString(7));
				
		    	//conn.setService_name(rs.getString(8));
				conn.setSystem(getSystemName(rs.getInt(9)));
				conn.setDrive_id(rs.getInt(10));
				DriveMaster dm = getDrivesDetails(rs.getInt(10));
				conn.setDrive_name(dm.getDrive_name());
				conn.setDrive_path(dm.getDrive_name());
				conn.setEncrypt(rs.getBytes(11));
				arrConnectionMaster.add(conn);
			}
		} catch (SQLException e) {
			logger.info(e.getMessage());
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}

		return arrConnectionMaster;
	}

	@Override
	public ArrayList<TargetMaster> getTargets(String projectId) throws Exception {
		ArrayList<TargetMaster> arr = new ArrayList<TargetMaster>();
		TargetMaster tm = null;
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"select TARGET_CONN_SEQUENCE,target_unique_name from JUNIPER_EXT_TARGET_CONN_MASTER where project_sequence=(select project_sequence from juniper_project_master where project_id='"
							+ projectId + "')");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				tm = new TargetMaster();
				tm.setTarget_conn_sequence(rs.getInt(1));
				tm.setTarget_unique_name(rs.getString(2));
				arr.add(tm);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			logger.error(e.getMessage());
		} finally {
			pstm.close();
			connection.close();
		}
		return arr;
	}

	@Override
	public TargetMaster getTargets1(int tgt) throws Exception {
		TargetMaster tm = null;
		Connection connection = null;
		PreparedStatement pstm = null;
		PreparedStatement pstm1 = null;
		try {
			String typ = null;
			connection = ConnectionUtils.getConnection();
			pstm1 = connection.prepareStatement("select " + "a.target_type from JUNIPER_EXT_TARGET_CONN_MASTER a where a.TARGET_CONN_SEQUENCE=" + tgt);
			ResultSet rs1 = pstm1.executeQuery();
			while (rs1.next()) {
				typ = rs1.getString(1);
			}
			System.out.println(tgt);
			if (typ.equalsIgnoreCase("gcs")) {
				pstm = connection.prepareStatement("select " + "a.target_unique_name,a.target_type,b.gcp_project,b.service_account_name,b.bucket_name,a.system_sequence"
						+ " from JUNIPER_EXT_TARGET_CONN_MASTER a, JUNIPER_EXT_GCP_MASTER b where a.gcp_sequence=b.gcp_sequence and a.target_conn_sequence=" + tgt);
				ResultSet rs = pstm.executeQuery();
				while (rs.next()) {
					tm = new TargetMaster();
					tm.setTarget_unique_name(rs.getString(1));
					tm.setTarget_type(rs.getString(2));
					tm.setGcp_project(rs.getString(3));
					tm.setGcp_service_account(rs.getString(4));
					tm.setGcp_bucket(rs.getString(5));
					tm.setSystem_name(getSystemName(rs.getInt(6)));
				}
			} else if (typ.equalsIgnoreCase("hdfs")) {
				pstm = connection.prepareStatement("select " + "a.target_unique_name,a.target_type,a.hdp_knox_host,a.hdp_knox_port,a.hdp_user,a.hdp_encrypted_password,a.encrypted_key,"
						+ "a.hdfs_gateway,a.hdp_hdfs_path,a.materialization_flag,a.partition_flag,a.hive_gateway,a.system_sequence"
						+ " from JUNIPER_EXT_TARGET_CONN_MASTER a where a.target_conn_sequence=" + tgt);
				ResultSet rs = pstm.executeQuery();
				while (rs.next()) {
					tm = new TargetMaster();
					tm.setTarget_unique_name(rs.getString(1));
					tm.setTarget_type(rs.getString(2));
					tm.setHdp_knox_host(rs.getString(3));
					tm.setHdp_knox_port(rs.getInt(4));
					tm.setHdp_user(rs.getString(5));
					tm.setHdp_encrypted_password(rs.getBytes(6));
					tm.setEncrypted_key(rs.getBytes(7));
					tm.setHdfs_gateway(rs.getString(8));
					tm.setHdp_hdfs_path(rs.getString(9));
					tm.setMaterialization_flag(rs.getString(10));
					tm.setPartition_flag(rs.getString(11));
					tm.setHive_gateway(rs.getString(12));
					tm.setSystem_name(getSystemName(rs.getInt(13)));
				}
			}
		} catch (ClassNotFoundException | SQLException e) {
			System.out.println("Exception occured " + e);
			
			throw e;
		} finally {
			pstm.close();
			pstm1.close();
			connection.close();
		}
		return tm;
	}

	@Override
	public ConnectionMaster getConnections1(String srcVal, int srcSysId) throws Exception {
		// TODO Auto-generated method stub
		Connection connection = null;
		PreparedStatement pstm = null;
		ConnectionMaster conn = new ConnectionMaster();
		
		
		System.out.println("src_val in service   "+srcVal);
		System.out.println("src_sys_id in service   "+srcSysId);
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"select a.SRC_CONN_SEQUENCE from JUNIPER_EXT_FEED_MASTER b,JUNIPER_EXT_FEED_SRC_TGT_LINK a" + " where a.feed_sequence=b.feed_sequence and a.FEED_SEQUENCE=" + srcSysId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				conn.setConnection_id(rs.getInt(1));
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return conn;
	}

	@Override
	public ConnectionMaster getConnections2(String srcVal, int connId, String projectId) throws Exception {
		// TODO Auto-generated method stub
		Connection connection = null;
		ConnectionMaster conn = new ConnectionMaster();
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"select src_conn_sequence,src_conn_name,src_conn_type,host_name,port_no,username,password,database_name,service_name,system_sequence from JUNIPER_EXT_SRC_CONN_MASTER where project_sequence=(select project_sequence from juniper_project_master where project_id='"
							+ projectId + "')" + " and src_conn_sequence=" + connId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				conn.setConnection_id(rs.getInt(1));
				conn.setConnection_name(rs.getString(2));
				conn.setConnection_type(rs.getString(3));
				conn.setHost_name(rs.getString(4));
				conn.setPort_no(rs.getString(5));
				conn.setUsername(rs.getString(6));
				conn.setPassword(rs.getBytes(7));
				conn.setDatabase_name(rs.getString(8));
				//conn.setService_name(rs.getString(9));
				conn.setSystem(getSystemName(rs.getInt(10)));
			}
			connection.close();
		} catch (ClassNotFoundException | SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return conn;
	}

	@Override
	public String getExtType(int srcSysId) throws Exception {
		String val = null;
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select extraction_type from JUNIPER_EXT_FEED_MASTER where feed_sequence=" + srcSysId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				val = rs.getString(1);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return val;
	}

	@Override
	public String getExtType1(String srcUniqueName) throws Exception {
		String val = null;
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();

			// Check if job is already scheduled for extraction, if yes we dont need to need
			// to schdule this again.
			String checkIfJobIsInMasterQuery = "select " + "CASE\r\n" + "    WHEN master.weekly_flag = 'Y'  THEN concat('Weekly on ', master.week_run_day)\r\n"
					+ "    WHEN master.daily_flag = 'Y'   THEN concat('Daily at ', substr(master.job_schedule_time, 1, 5))\r\n"
					+ "    WHEN master.monthly_flag = 'Y' THEN concat('Monthly on ', master.month_run_day)\r\n"
					+ "    WHEN master.yearly_flag = 'Y'  THEN concat('Yearly on month ', master.month_run_val)\r\n" + "END AS consolidated_schedule " + "from " + SCHEDULER_MASTER_TABLE + " master "
					+ "where batch_id='" + srcUniqueName + "'";
			pstm = connection.prepareStatement(checkIfJobIsInMasterQuery);
			ResultSet rs = pstm.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}

			String extractionTypeQuery = "select extraction_type from JUNIPER_EXT_FEED_MASTER " + "where feed_unique_name='" + srcUniqueName + "'";
			pstm = connection.prepareStatement(extractionTypeQuery);
			rs = pstm.executeQuery();
			while (rs.next()) {
				val = rs.getString(1);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return val;
	}

	@Override
	public ArrayList<String> getTables(String srcVal, int connId, String schemaName, String projectId, String dbName) throws Exception {
		ArrayList<ConnectionMaster> arrcm = getConnections(srcVal, projectId);
		ArrayList<String> arrTbl = new ArrayList<String>();
		String query = null, connectionUrl = null, host = null, port = null, username = null, db = null, database = null;
		byte[] password = null, encrypt = null;
		Connection serverConnection = null;
		Statement st = null;
		for (ConnectionMaster cm : arrcm) {
			if (connId == cm.getConnection_id()) {
				host = cm.getHost_name();
				port = cm.getPort_no();
				username = cm.getUsername();
				password = cm.getPassword();
//				service = cm.getService_name();
				database= cm.getDatabase_name();
				encrypt = cm.getEncrypt();
			}
		}
		try {
			//query = "select distinct table_name from all_tables where owner='" + schema_name + "' order by table_name";
			
			query="select convert(varchar(30),o.name) AS table_name from sysobjects o where type = 'U'order by table_name";
			
			
			Class.forName("com.sybase.jdbc4.jdbc.SybDriver");
			connectionUrl = "jdbc:sybase:Tds:" + host + ":" + port + "/" + schemaName + "";
			String pass = EncryptionUtil.decyptPassword(encrypt, password);
			serverConnection = DriverManager.getConnection(connectionUrl, username, pass);
			st = serverConnection.createStatement();

			ResultSet rs2 = st.executeQuery(query);
			while (rs2.next()) {
				arrTbl.add(rs2.getString(1));
			}
		} catch (SQLException e1) {
			System.out.println("Exception occured " + e1);
			throw e1;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			st.close();
			serverConnection.close();
		}
		return arrTbl;
	}

	@Override
	public ArrayList<String> getFields(String id, String srcVal, String tableName, int connId, String schemaName, String projectId, String dbName) throws Exception {
		ArrayList<ConnectionMaster> arrcm = getConnections(srcVal, projectId);
		ArrayList<String> arrFld = new ArrayList<String>();
		String query = null, connectionUrl = null, host = null, port = null, username = null, db = null, database = null;
		byte[] password = null, encrypt = null;
		Connection serverConnection = null;
		Statement st = null;
		for (ConnectionMaster cm : arrcm) {
			if (connId == cm.getConnection_id()) {
				host = cm.getHost_name();
				port = cm.getPort_no();
				username = cm.getUsername();
				password = cm.getPassword();
				database = cm.getDatabase_name();
				encrypt = cm.getEncrypt();
			}
		}
System.out.println("table name>>>>>>>>>>>   "+tableName);
		String tbls[] = tableName.split(",");
		for (int i = 0; i < tbls.length; i++) {
			try {
				String tblsx[] = tbls[i].split("\\.");
				//query = "SELECT column_name FROM all_tab_cols where table_name='" + tblsx[1] + "' and owner='" + schema_name + "' and column_id is not null order by column_name";
				query="select b.name as coulumnName from sysobjects a left join syscolumns b on a.id=b.id where a.name='"+tblsx[1]+"'";
				System.out.println("query"+query);
				Class.forName("com.sybase.jdbc4.jdbc.SybDriver");
				connectionUrl = "jdbc:sybase:Tds:" + host + ":" + port + "/" + database;
				String pass = EncryptionUtil.decyptPassword(encrypt, password);
				serverConnection = DriverManager.getConnection(connectionUrl, username, pass);
				st = serverConnection.createStatement();
				ResultSet rs2 = st.executeQuery(query);
				while (rs2.next()) {
					arrFld.add(rs2.getString(1));
				}
			} catch (SQLException e1) {
				System.out.println("Exception occured " + e1);
				throw e1;
			} catch (ClassNotFoundException e) {
				System.out.println("Exception occured " + e);
				throw e;
			} finally {
				st.close();
				serverConnection.close();
			}
		}
		return arrFld;
	}

	@Override
	public ArrayList<SourceSystemMaster> getSources(String srcVal, String projectId) throws Exception {
		SourceSystemMaster ssm = null;
		ArrayList<SourceSystemMaster> arrssm = new ArrayList<SourceSystemMaster>();
		Connection connection = null;
		PreparedStatement pstm = null;
		
		
		System.out.println("Source>>>"+srcVal);
		System.out.println("project_id>>>"+projectId);
		
		try {
		
			connection = ConnectionUtils.getConnection();
			String query = "select feed_sequence,feed_unique_name, " + "rtrim(xmlagg(XMLELEMENT(e,table_sequence,',').EXTRACT('//text()')).GetClobVal(),',') tbl_seq " + "from " + "("
					+ "select a.FEED_SEQUENCE,a.FEED_UNIQUE_NAME,c.table_sequence " + "from " + "JUNIPER_EXT_FEED_MASTER a " + "inner join JUNIPER_EXT_FEED_SRC_TGT_LINK b "
					+ "on a.feed_sequence=b.feed_sequence " + "left outer join JUNIPER_EXT_TABLE_MASTER c " + "on a.feed_sequence=c.feed_sequence "
					+ "where a.project_sequence=(select project_sequence from juniper_project_master where project_id = '" + projectId + "') "
					+ "and b.src_conn_sequence in (select src_conn_sequence from JUNIPER_EXT_SRC_CONN_MASTER where src_conn_type='" + srcVal + "') " + ") "
					+ "group by feed_sequence,feed_unique_name order by feed_unique_name,feed_sequence";
			
			
			
			pstm = connection.prepareStatement(query);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				ssm = new SourceSystemMaster();
				ssm.setSrc_sys_id(rs.getInt(1));
				ssm.setSrc_unique_name(rs.getString(2));
				ssm.setTable_list(rs.getString(3));
				arrssm.add(ssm);
			}
			
			
			System.out.println("arrsm    "+arrssm.size());
			
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arrssm;
	}

	@Override
	public ArrayList<SourceSystemDetailBean> getSources1(String srcVal, int srcSysId) throws Exception {
		SourceSystemDetailBean ssm = null;
		ArrayList<SourceSystemDetailBean> arrssm = new ArrayList<SourceSystemDetailBean>();
		Connection connection = null;
		Statement stat = null;
		ResultSet rs = null;
		try {
			connection = ConnectionUtils.getConnection();
			String query = "select feed_sequence,feed_unique_name,feed_desc,country_code,extraction_type,src_conn_sequence, "
					+ "listagg(target_unique_name,',') within group (order by feed_sequence,feed_unique_name,feed_desc,country_code,extraction_type,src_conn_sequence) " + "from ("
					+ "select a.FEED_SEQUENCE,a.FEED_UNIQUE_NAME,a.FEED_DESC,a.COUNTRY_CODE,a.EXTRACTION_TYPE,c.target_unique_name,b.SRC_CONN_SEQUENCE " + "from "
					+ "JUNIPER_EXT_FEED_MASTER a inner join JUNIPER_EXT_FEED_SRC_TGT_LINK b on a.feed_sequence=b.feed_sequence "
					+ "left outer join JUNIPER_EXT_TARGET_CONN_MASTER c on b.target_sequence=c.target_conn_sequence " + "where a.FEED_SEQUENCE=" + srcSysId + ") "
					+ "group by feed_sequence,feed_unique_name,feed_desc,country_code,extraction_type,src_conn_sequence "
					+ "order by feed_sequence,feed_unique_name,feed_desc,country_code,extraction_type,src_conn_sequence";
			stat = connection.createStatement();
			rs = stat.executeQuery(query);
			while (rs.next()) {
				ssm = new SourceSystemDetailBean();
				ssm.setSrc_sys_id(rs.getInt(1));
				ssm.setSrc_unique_name(rs.getString(2));
				ssm.setSrc_sys_desc(rs.getString(3));
				ssm.setCountry_code(rs.getString(4));
				ssm.setExtraction_type(rs.getString(5));
				ssm.setConnection_id(rs.getInt(6));
				ssm.setTarget(rs.getString(7));
				arrssm.add(ssm);
			}
			connection.close();
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			stat.close();
			rs.close();
			connection.close();
		}
		return arrssm;
	}

	@Override
	public ArrayList<CountryMaster> getCountries() throws Exception {
		CountryMaster cm = null;
		ArrayList<CountryMaster> arrcm = new ArrayList<CountryMaster>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select country_code,country_name from JUNIPER_REGION_COUNTRY_MASTER order by country_name");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				cm = new CountryMaster();
				cm.setCountry_code(rs.getString(1));
				cm.setCountry_name(rs.getString(2));
				arrcm.add(cm);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arrcm;
	}

	@Override
	public ArrayList<ReservoirMaster> getReservoirs() throws Exception {
		ReservoirMaster rm = null;
		ArrayList<ReservoirMaster> arrrm = new ArrayList<ReservoirMaster>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select reservoir_id,reservoir_name,reservoir_desc from reservoir_master where reservoir_status='Y' and lower(reservoir_desc) like '%extraction%'");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				rm = new ReservoirMaster();
				rm.setReservoir_id(rs.getInt(1));
				rm.setReservoir_name(rs.getString(2));
				rm.setReservoir_desc(rs.getString(3));
				arrrm.add(rm);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arrrm;
	}

	@Override
	public int getRecCount(int srcSysId) throws Exception {
		Connection connection = null;
		PreparedStatement pstm = null;
		int cnt = 0;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select count(1) from JUNIPER_EXT_TABLE_MASTER where FEED_SEQUENCE=" + srcSysId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				cnt = rs.getInt(1);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return cnt;
	}

	@Override
	public ArrayList<DataDetailBean> getData(int srcSysId, String srcVal, int connId, String projectId, String dbName) throws Exception {
		DataDetailBean ddb = null;
		ArrayList<DataDetailBean> arrddb = new ArrayList<DataDetailBean>();
		ConnectionMaster conn = getConnections1(srcVal, srcSysId);
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select regexp_substr(table_name, '[^.]+', 1, 1) as schema_name,regexp_substr(table_name, '[^.]+$', 1, 1) as table_name,"
					+ "columns,where_clause,fetch_type,incr_col from JUNIPER_EXT_TABLE_MASTER where FEED_SEQUENCE=" + srcSysId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				ddb = new DataDetailBean();
				ddb.setSchema_name(rs.getString(1));
				ddb.setTable_name(rs.getString(2));
				ArrayList<String> arrs = new ArrayList<String>();
				//if (rs.getString(3).equalsIgnoreCase("all")) {
					//arrs = getFields("1", src_val, rs.getString(1) + "." + rs.getString(2), conn_id, rs.getString(1), project_id, db_name);
					//String fieldString = String.join(",", arrs);
					//ddb.setColumn_name(fieldString);
				//} else {
					ddb.setColumn_name(rs.getString(3).toLowerCase());
				//}
				ddb.setWhere_clause(rs.getString(4));
				ddb.setFetch_type(rs.getString(5));
				ddb.setIncr_column(rs.getString(6));
				if (rs.getString(3).equalsIgnoreCase("all") && rs.getString(5).equalsIgnoreCase("full"));
				else {
					ArrayList<String> agf = getFields("1", srcVal, rs.getString(1) + "." + rs.getString(2), conn.getConnection_id(), rs.getString(1), projectId, dbName);
					String cols = agf.toString();
					cols = cols.substring(1, cols.length() - 1).replace(", ", ",");
					ddb.setCols(cols);
					for (String temp : arrs) {
						agf.remove(temp);
					}
					String unselCols = agf.toString();
					unselCols = unselCols.substring(1, unselCols.length() - 1).replace(", ", ",");
					ddb.setUnsel_cols(unselCols);
				}
				arrddb.add(ddb);
			}
		} catch (ClassNotFoundException | SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arrddb;
	}

	@Override
	public int checkNames(String sun) throws Exception {
		Connection connection = null;
		int stat = 0;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select FEED_UNIQUE_NAME from JUNIPER_EXT_FEED_MASTER where FEED_UNIQUE_NAME='" + sun + "'");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				stat = 1;
				break;
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return stat;
	}

	@Override
	public ArrayList<String> getSchema(String srcVal, int connId, String projectId, String dbName) throws Exception {
		ArrayList<ConnectionMaster> arrcm = getConnections(srcVal, projectId);
		ArrayList<String> arrTbl = new ArrayList<String>();
		String query = null, connectionUrl = null, host = null, port = null, username = null, db = null, database = null;
		byte[] password = null, encrypt = null;
		Connection serverConnection = null;
		Statement st = null;
		for (ConnectionMaster cm : arrcm) {
			if (connId == cm.getConnection_id()) {
				host = cm.getHost_name();
				port = cm.getPort_no();
				username = cm.getUsername();
				password = cm.getPassword();
				db = cm.getDatabase_name();
				database = cm.getDatabase_name();
				encrypt = cm.getEncrypt();
			}
		}
		try {
			//query = "select distinct owner from all_tables where upper(owner) not like '%SYS%' and upper(owner) not like '%XDB%'";
			query = "select d.name from sysdatabases d";
			//changing query to list down all databases here
			Class.forName("com.sybase.jdbc4.jdbc.SybDriver");
			connectionUrl = "jdbc:sybase:Tds:" + host + ":" + port;// + "/" + service;
			System.out.println("************connectionurl******  "+connectionUrl);

			String pass = EncryptionUtil.decyptPassword(encrypt, password);
			serverConnection = DriverManager.getConnection(connectionUrl, username, pass);
			st = serverConnection.createStatement();
			ResultSet rs2 = st.executeQuery(query);
			
			
			System.out.println("************fetchsize"+rs2.getFetchSize());
			
			
			while (rs2.next()) {
				arrTbl.add(rs2.getString(1));
			}
		} catch (Exception e1) {
			System.out.println("Exception occured " + e1);
			throw e1;
		} finally {
			serverConnection.close();
		}
		return arrTbl;
	}

	public ArrayList<String> getSchemaData(String srcVal, int srcSysId) throws Exception {
		String sch = "";
		Connection connection = null;
		PreparedStatement pstm = null;
		ArrayList<String> sch1 = new ArrayList<String>();
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select table_name from JUNIPER_EXT_TABLE_MASTER where FEED_SEQUENCE=" + srcSysId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				sch = rs.getString(1).split("\\.")[0];
				sch1.add(sch);
			}
			connection.close();
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return sch1;
	}

	public ArrayList<String> getSystem(String project) throws Exception {
		ArrayList<String> sys = new ArrayList<String>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select a.system_name from JUNIPER_SYSTEM_MASTER a");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				sys.add(rs.getString(1));
			}
			connection.close();
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return sys;
	}

	public String getSystemName(int system) throws Exception {
		String sys = null;
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select a.system_name from JUNIPER_SYSTEM_MASTER a where system_sequence=" + system);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				sys = rs.getString(1);
			}
			connection.close();
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return sys;
	}

	@Override
	public ArrayList<DriveMaster> getDrives(String projectId) throws Exception {
		DriveMaster dm = null;
		ArrayList<DriveMaster> arrdm = new ArrayList<DriveMaster>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();

			// PreparedStatement pstm = connection.prepareStatement("select
			// drive_sequence,drive_name,mounted_path,project_sequence from
			// JUNIPER_EXT_DRIVE_MASTER");

			pstm = connection.prepareStatement(
					"select drive_sequence,drive_name,mounted_path,project_sequence from JUNIPER_EXT_DRIVE_MASTER where project_sequence=(select project_sequence from juniper_project_master where project_id='"
							+ projectId + "')");

			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				dm = new DriveMaster();
				dm.setDrive_id(rs.getInt(1));
				dm.setDrive_name(rs.getString(2));
				dm.setDrive_path(rs.getString(3));
				dm.setProject_id(rs.getString(4));
				arrdm.add(dm);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arrdm;
	}

	@Override
	public ArrayList<DriveMaster> getDrives1(int srcSysId) throws Exception {
		DriveMaster dm = null;
		ArrayList<DriveMaster> arrdm = new ArrayList<DriveMaster>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"select c.drive_name,c.mounted_path from JUNIPER_EXT_FEED_SRC_TGT_LINK a, JUNIPER_EXT_SRC_CONN_MASTER b, JUNIPER_EXT_DRIVE_MASTER c where a.SRC_CONN_SEQUENCE=b.SRC_CONN_SEQUENCE and b.DRIVE_SEQUENCE=c.DRIVE_SEQUENCE and a.FEED_SEQUENCE="
							+ srcSysId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				dm = new DriveMaster();
				dm.setDrive_name(rs.getString(1));
				dm.setDrive_path(rs.getString(2));
				arrdm.add(dm);
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arrdm;
	}

	@Override
	public DriveMaster getDrivesDetails(int driveId) throws Exception {
		DriveMaster dm = new DriveMaster();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select c.drive_sequence,c.drive_name,c.mounted_path from JUNIPER_EXT_DRIVE_MASTER c where c.DRIVE_SEQUENCE=" + driveId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				dm.setDrive_id(rs.getInt(1));
				dm.setDrive_name(rs.getString(2));
				dm.setDrive_path(rs.getString(3));
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return dm;
	}

	@Override
	public void updateLoggerTable(String srcUniqueName) throws Exception {

		// TODO Auto-generated method stub
		String src_id = null;
		Connection connection = null;
		PreparedStatement pstm = null;
		Statement statement;
		ResultSet rs = null;
		String query = null;
		try {
			connection = ConnectionUtils.getConnection();

			// Delete all the entries for specific Src ID
			query = "DELETE FROM LOGGER_MASTER WHERE FEED_ID='" + srcUniqueName + "'";
			statement = connection.createStatement();
			statement.execute(query);

			// Get Source ID from Src Name
			pstm = connection.prepareStatement("select FEED_SEQUENCE from JUNIPER_EXT_FEED_MASTER where FEED_UNIQUE_NAME='" + srcUniqueName + "'");
			rs = pstm.executeQuery();
			while (rs.next()) {
				src_id = rs.getString(1);
			}
			// Get Source Details from Src Id
			query = "SELECT SRC_CONN_NAME,SRC_CONN_TYPE,S.SYSTEM_EIM, HOST_NAME FROM JUNIPER_EXT_SRC_CONN_MASTER C\r\n"
					+ "INNER JOIN  JUNIPER_EXT_FEED_SRC_TGT_LINK L ON C.SRC_CONN_SEQUENCE=L.SRC_CONN_SEQUENCE \r\n"
					+ "INNER JOIN JUNIPER_SYSTEM_MASTER S ON C.system_sequence=S.system_sequence WHERE l.FEED_SEQUENCE=" + src_id;
			pstm = connection.prepareStatement(query);
			rs = pstm.executeQuery();
			while (rs.next()) {
				query = "INSERT ALL \r\n" + " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Source','Name','" + rs.getString(1) + "')\r\n"
						+ " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Source','Type','" + rs.getString(2) + "')\r\n"
						+ " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Source','Host','" + rs.getString(4) + "')\r\n"
						+ " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Source','EIM','" + rs.getString(3) + "')\r\n" + "SELECT * FROM dual";
				statement = connection.createStatement();
				statement.execute(query);
			}

			// Get Target Details from Src ID
			query = "SELECT TARGET_UNIQUE_NAME,TARGET_TYPE,S.SYSTEM_EIM,case when UPPER(TRIM((target_type))='HDFS' then hdp_knox_host else gcp_project end as target_host FROM JUNIPER_EXT_TARGET_CONN_MASTER C\r\n"
					+ "INNER JOIN  JUNIPER_EXT_FEED_SRC_TGT_LINK L ON C.TARGET_CONN_SEQUENCE=L.TARGET_SEQUENCE \r\n"
					+ "INNER JOIN JUNIPER_SYSTEM_MASTER S ON C.system_sequence=S.system_sequence\r\n"
					+ "left outer join juniper_ext_gcp_master G on G.gcp_sequence  = C.gcp_sequence WHERE l.FEED_SEQUENCE=" + src_id;
			pstm = connection.prepareStatement(query);
			rs = pstm.executeQuery();
			int target_num=1;
			while (rs.next()) {
				query = "INSERT ALL \r\n" + " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Target"+target_num+"','Name','" + rs.getString(1) + "')\r\n"
						+ " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Target"+target_num+"','Type','" + rs.getString(2) + "')\r\n"
						+ " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Target"+target_num+"','Host','" + rs.getString(4) + "')\r\n"
						+ " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Target"+target_num+"','EIM','" + rs.getString(3) + "')\r\n" + "SELECT * FROM dual";
				statement = connection.createStatement();
				statement.execute(query);
				target_num++;
			}
			// Get Scheduling Information
			query = "SELECT DISTINCT \r\n" + "					CASE WHEN SCHEDULE_TYPE = 'R' AND DAILY_FLAG = 'Y' THEN 'DAILY'\r\n"
					+ "					WHEN SCHEDULE_TYPE = 'R' AND  WEEKLY_FLAG = 'Y' THEN 'WEEKLY'\r\n" + "					WHEN SCHEDULE_TYPE = 'R' AND  MONTHLY_FLAG = 'Y' THEN 'MONTHLY' \r\n"
					+ "					WHEN SCHEDULE_TYPE = 'R' AND  YEARLY_FLAG = 'Y' THEN 'YEARLY'\r\n" + "                    WHEN SCHEDULE_TYPE = 'O' THEN 'AD-HOC'\r\n"
					+ "                    WHEN SCHEDULE_TYPE = 'F' THEN 'FILE-WATCHER'\r\n" + "                    WHEN SCHEDULE_TYPE = 'K' THEN 'KAFKA-WATCHER' \r\n"
					+ "                    WHEN SCHEDULE_TYPE = 'A' THEN 'API-WATCHER'\r\n" + "					ELSE ''\r\n" + "					END AS \"FREQUENCY\",\r\n"
					+ "					JOB_SCHEDULE_TIME \r\n" + "					from JUNIPER_SCH_MASTER_JOB_DETAIL where LOWER(BATCH_ID)='" + srcUniqueName.toLowerCase() + "'";
			pstm = connection.prepareStatement(query);
			rs = pstm.executeQuery();
			while (rs.next()) {
				query = "INSERT ALL \r\n" + " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Scheduling','Frequency','" + rs.getString(1)
						+ "')\r\n" + " INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Scheduling','Time','" + rs.getString(2) + "')\r\n"
						+ "SELECT * FROM dual";
				System.out.println("6: " + query);
				statement = connection.createStatement();
				statement.execute(query);
			}
			// Get Table List Information
			query = "select TABLE_NAME from JUNIPER_EXT_TABLE_MASTER where FEED_SEQUENCE=" + src_id + " UNION ALL select FILE_NAME from JUNIPER_EXT_FILE_MASTER where FEED_SEQUENCE=" + src_id;
			pstm = connection.prepareStatement(query);
			rs = pstm.executeQuery();
			while (rs.next()) {
				query = "INSERT INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Table','Name','" + rs.getString(1) + "')";
				statement = connection.createStatement();
				statement.execute(query);
			}
			// Insert Platform Information
			query = "INSERT INTO LOGGER_MASTER (FEED_ID,CLASSIFICATION,SUBCLASSIFICATION,VALUE)  values('" + srcUniqueName + "','Transfer','Platform','JUNIPER')";
			statement = connection.createStatement();
			statement.execute(query);
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
	}

	@Override
	public ArrayList<String> getGoogleProject(String projectId) throws Exception {
		ArrayList<String> arr = new ArrayList<String>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"select gcp_project from JUNIPER_EXT_GCP_MASTER where project_sequence=(select project_sequence from juniper_project_master where project_id='" + projectId + "')");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				arr.add(rs.getString(1));
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arr;
	}

	@Override
	public ArrayList<String> getServiceBucket(String project, String projectId) throws Exception {
		ArrayList<String> arr = new ArrayList<String>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"select bucket_name,service_account_name from JUNIPER_EXT_GCP_MASTER where project_sequence=(select project_sequence from juniper_project_master where project_id='" + projectId
							+ "')" + "and gcp_project='" + project + "'");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				arr.add(rs.getString(1) + "|" + rs.getString(2));
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arr;
	}

	@Override
	public String getBulkDataTemplate(int srcSysId) throws Exception {
		// TODO Auto-generated method stub
		String val = null;
		Connection connection = null;
		String yemi = "Bulk_Upload_Sample.psv";
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			PreparedStatement feed_seq = null;
			
			pstm = connection.prepareStatement(
					"select SUBSTR(TABLE_NAME,1,INSTR(TABLE_NAME,'.')-1) AS SCHEMA_NAME, SUBSTR(TABLE_NAME,INSTR(TABLE_NAME,'.')+1) AS TABLE_NAME, VIEW_FLAG AS IS_VIEW, COLUMNS AS COLUMNS_NAME,WHERE_CLAUSE,FETCH_TYPE,INCR_COL,'Y' as VALIDATION_FLAG,'NA' as ERROR_MESSAGE from JUNIPER_EXT_TABLE_MASTER where feed_sequence=" + srcSysId
					+ " union select SUBSTR(TABLE_NAME,1,INSTR(TABLE_NAME,'.')-1) AS SCHEMA_NAME, SUBSTR(TABLE_NAME,INSTR(TABLE_NAME,'.')+1) AS TABLE_NAME, VIEW_FLAG AS IS_VIEW, COLUMNS AS COLUMNS_NAME,WHERE_CLAUSE,FETCH_TYPE,INCR_COL,'Y' as VALIDATION_FLAG,'NA' as ERROR_MESSAGE from JUNIPER_EXT_TABLE_MASTER_TEMP where feed_sequence=" + srcSysId);
			ResultSet rs = pstm.executeQuery();
			@SuppressWarnings("deprecation")
			CSVWriter csvWriter = new CSVWriter(new FileWriter(yemi),'|',
			CSVWriter.NO_QUOTE_CHARACTER,
			CSVWriter.DEFAULT_ESCAPE_CHARACTER,
			"\r\n");
			
			List<String[]> rows = new LinkedList<String[]>();
			csvWriter.writeNext(new String[] {"ROW_NO","SCHEMA_NAME","TABLE_NAME","IS_VIEW","COLUMNS_NAME","WHERE_CLAUSE","FETCH_TYPE","INCR_COL","VALIDATION_FLAG","ERROR_MESSAGE"});

			int i = 1;
			while (rs.next()) {
					csvWriter.writeNext(new String[]{Integer.toString(i),rs.getString("SCHEMA_NAME"),rs.getString("TABLE_NAME"),rs.getString("IS_VIEW"),
					               rs.getString("COLUMNS_NAME"),rs.getString("WHERE_CLAUSE"),rs.getString("FETCH_TYPE"),
					rs.getString("INCR_COL"),rs.getString("VALIDATION_FLAG"),rs.getString("ERROR_MESSAGE")});
				i++;
			}
			csvWriter.close();
		} catch (SQLException | IOException e1) {
			throw e1;
		} finally {
			connection.close();
			pstm.close();
		}
		return yemi;
	}

	@Override
	public ArrayList<TempDataDetailBean> getTempData(int srcSysId, String srcVal, String projectId) throws Exception {
		TempDataDetailBean ddb = null;
		String dbName = null;
		ArrayList<TempDataDetailBean> arrddb = new ArrayList<TempDataDetailBean>();
		ConnectionMaster conn = getConnections1(srcVal, srcSysId);
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			String query = "select table_name, columns, where_clause, fetch_type, incr_col,validation_flag,error_message from JUNIPER_EXT_TABLE_MASTER_TEMP where feed_sequence=" + srcSysId
					+ " union " + "select table_name, columns, where_clause, fetch_type, incr_col,'Y','null' from JUNIPER_EXT_TABLE_MASTER where feed_sequence=" + srcSysId;
			System.out.println(query);
			pstm = connection.prepareStatement(query);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				ddb = new TempDataDetailBean();
				ddb.setTable_name(rs.getString(1));
				ddb.setSchema(rs.getString(1).split("\\.")[0]);
				ddb.setColumn_name(rs.getString(2));
				ddb.setWhere_clause(rs.getString(3));
				ddb.setFetch_type(rs.getString(4));
				ddb.setIncremental_column(rs.getString(5));
				ddb.setValidation_flag(rs.getString(6));
				ddb.setError_message(rs.getString(7));
				arrddb.add(ddb);
			}
			connection.close();
			System.out.println("Extracted the complete data");
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}

		return arrddb;
	}

	@Override
	public ArrayList<String> getHivedbList(String projectId) throws Exception {
		ArrayList<String> arr = new ArrayList<String>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("SELECT DISTINCT db_name FROM  juniper_ext_hive_table_list");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				arr.add(rs.getString(1));
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arr;
	}

	@Override
	public ArrayList<String> getKafkaTopic() throws Exception {
		ArrayList<String> arr = new ArrayList<String>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("SELECT kafka_topic FROM  juniper_ext_kafka_topic_master");
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				arr.add(rs.getString(1));
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arr;
	}

	@Override
	public ArrayList<String> getColList(String tableName) throws Exception {
		ArrayList<String> arr = new ArrayList<String>();
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement(
					"SELECT DISTINCT n.FEED_UNIQUE_NAME FROM  JUNIPER_EXT_NIFI_STATUS n LEFT JOIN JUNIPER_PROJECT_MASTER p ON n.PROJECT_SEQUENCE=p.PROJECT_SEQUENCE WHERE p.PROJECT_ID=?");
			pstm.setString(1, tableName);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				arr.add(rs.getString(1));
			}
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return arr;
	}

	public String getDatabaseData(String srcVal, int srcSysId) throws Exception {
		String sch = "";
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
			connection = ConnectionUtils.getConnection();
			pstm = connection.prepareStatement("select table_name from JUNIPER_EXT_TABLE_MASTER where FEED_SEQUENCE=" + srcSysId);
			ResultSet rs = pstm.executeQuery();
			while (rs.next()) {
				sch = rs.getString(1).split("\\.")[0];
			}
			connection.close();
		} catch (SQLException e) {
			System.out.println("Exception occured " + e);
			throw e;
		} finally {
			pstm.close();
			connection.close();
		}
		return sch;
	}

	@Override
	public String getJsonFromFile(File file, String user, String project, int srcSysId) throws Exception {
		String str = "";
		ConnectionMaster conn = getConnections1("Oracle", srcSysId);
		try (InputStream in = new FileInputStream(file)) {
			CSV csv = new CSV(true, '|', in);
			List<String> fieldNames = null;
			if (csv.hasNext())
				fieldNames = new ArrayList<>(csv.next());
			List<Map<String, String>> list = new ArrayList<>();
			int counter = 1;
			while (csv.hasNext()) {
				List<String> x = csv.next();
				while (x.size() <= 10) {
					x.add("");
				}
				Map<String, String> obj = new LinkedHashMap<>();
				for (int i = 0; i < fieldNames.size(); i++) {
					obj.put(fieldNames.get(i).toLowerCase() + counter, x.get(i));
				}
				list.add(obj);
				counter++;
			}
			ObjectMapper mapper = new ObjectMapper();
			mapper.enable(SerializationFeature.INDENT_OUTPUT);
			str = mapper.writeValueAsString(list);
			str = "{\"header\":{},\"body\":{\"data\":" + str + "}}";
			JSONObject jsonObject = new JSONObject(str);
			JSONObject getObject = jsonObject.getJSONObject("body");
			JSONArray getArray = getObject.getJSONArray("data");
			JSONObject json = new JSONObject();
			String schema, table, view, col, where, type, incr, val, err;
			for (int i = 0; i < getArray.length(); i++) {
				JSONObject objectInArray = getArray.getJSONObject(i);
				schema = objectInArray.getString("schema_name" + (i + 1));
				table = objectInArray.getString("table_name" + (i + 1));
				view = objectInArray.getString("is_view" + (i + 1));
				col = objectInArray.getString("columns_name" + (i + 1));
				where = objectInArray.getString("where_clause" + (i + 1));
				type = objectInArray.getString("fetch_type" + (i + 1));
				incr = objectInArray.getString("incr_col" + (i + 1));
				val = objectInArray.getString("validation_flag" + (i + 1));
				err = objectInArray.getString("error_message" + (i + 1));
				// str = "{\"header\":{},\"body\":{\"data\":{" +
				// "\"schema_name"+i+"\":\""+schema+"\"" + "}}";
				if (where.equalsIgnoreCase("")) {
					where = "1=1";
				}
				else
				{
					where = where.replace("'","'");
				}
				json.put("schema_name" + (i + 1), schema);
				json.put("table_name" + (i + 1), schema + "." + table);
				json.put("is_view" + (i + 1), view);
				json.put("columns_name" + (i + 1), col);
				json.put("where_clause" + (i + 1), where);
				json.put("fetch_type" + (i + 1), type);
				json.put("incr_col" + (i + 1), incr);
				json.put("validation_flag" + (i + 1), val);
				json.put("error_message" + (i + 1), err);
			}
			json.put("project", project);
			json.put("user", user);
			json.put("counter", counter - 1);
			json.put("feed_id", srcSysId);
			json.put("connection_id", conn.getConnection_id());
			str = "{\"header\":{},\"body\":{\"data\":" + json + "}}";
		}
		return str;
	}

	@Override
	public String getJsonFromFeedSequence(String project, String srcSysId) throws JSONException {
		JSONArray arrayMetadata = new JSONArray();
		JSONObject itemMetadata = new JSONObject();

		JSONArray arrayMetadataPre = new JSONArray();
		JSONObject itemMetadataPre = new JSONObject();

		JSONArray arrayMetadataFirst = new JSONArray();
		JSONObject itemMetadataFirst = new JSONObject();
		itemMetadata.put("feed_sequence", srcSysId);
		itemMetadata.put("project_id", project);
		arrayMetadata.put(itemMetadata);
		itemMetadataPre.put("data", arrayMetadata);
		arrayMetadataPre.put(itemMetadataPre);
		itemMetadataFirst.put("body", arrayMetadataPre);
		arrayMetadataFirst.put(itemMetadataFirst);
		String jsonAarraymetadataStr = arrayMetadataFirst.toString().replace("[", "").replace("]", "");
		return jsonAarraymetadataStr;
	}
	
	@Override
	public String getFeedName (int srcSysId) throws Exception{
		     String sch = "";
			 Connection connection = null;
			 PreparedStatement pstm = null;
			 try { 
						connection = ConnectionUtils.getConnection();
						pstm = connection.prepareStatement("select feed_unique_name from JUNIPER_EXT_FEED_MASTER where FEED_SEQUENCE="+ srcSysId);
						ResultSet rs = pstm.executeQuery();
						while (rs.next()) { 
								sch = rs.getString(1);
						}connection.close();
			 } catch (SQLException e) {
						throw e;
			 } finally {
							pstm.close();
							connection.close();
			 }
			return sch;
	}

	@Override
	public ArrayList<TempDataDetailBean> getInProgressTempData(int srcSysId, String srcVal, String projectId) throws Exception {
		TempDataDetailBean ddb = null;
		String dbName = null;
		ArrayList<TempDataDetailBean> arrddb = new ArrayList<TempDataDetailBean>();
		ConnectionMaster conn = getConnections1(srcVal, srcSysId);
		Connection connection = null;
		PreparedStatement pstm = null;
		try { 
					connection = ConnectionUtils.getConnection();
					String query = "select table_name,columns,where_clause,fetch_type,incr_col,validation_flag,error_message from JUNIPER_EXT_TABLE_MASTER_TEMP where feed_sequence =" + srcSysId
																+ " and validation_flag='N' and error_message IS NULL";
					pstm = connection.prepareStatement(query);
					ResultSet rs = pstm.executeQuery();
					System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>rs  "+rs.getFetchSize());
					
					
					
					while (rs.next()) {
						
						
									ddb = new TempDataDetailBean();
									ddb.setTable_name(rs.getString(1));
									ddb.setSchema(rs.getString(1).split("\\.")[0]);
									ddb.setColumn_name(rs.getString(2));
									ddb.setWhere_clause(rs.getString(3));	
									ddb.setFetch_type(rs.getString(4));
									ddb.setIncremental_column(rs.getString(5));	
									ddb.setValidation_flag(rs.getString(6));
									ddb.setError_message(rs.getString(7));	
									arrddb.add(ddb);
					}				
					connection.close();
		} catch (SQLException e) {
					throw e;
		} finally {
					pstm.close();
					connection.close();
		}
		return arrddb;
	}	
	

	@Override
	public ArrayList<TempDataDetailBean> getValidatedTempData(int srcSysId, String srcVal, String projectid) throws Exception{
		TempDataDetailBean ddb = null;
		String db_name = null;
		ArrayList<TempDataDetailBean> arrddb = new ArrayList<TempDataDetailBean>();
		ConnectionMaster conn = getConnections1(srcVal, srcSysId);
		Connection connection = null;
		PreparedStatement pstm = null;
		try {
					connection = ConnectionUtils.getConnection();
					String query = "select table_name, columns, where_clause, fetch_type, incr_col, validation_flag,error_message from JUNIPER_EXT_TABLE_MASTER_TEMP where feed_sequence =" + srcSysId
													+ " and validation_flag='N' and error_message IS NOT NULL";
					pstm = connection.prepareStatement(query);
					ResultSet rs = pstm.executeQuery();
					while (rs.next()) {
									ddb = new TempDataDetailBean();
									ddb.setTable_name(rs.getString(1));
									ddb.setSchema(rs.getString(1).split("\\.")[0]);
									ddb.setColumn_name(rs.getString(2));
									ddb.setWhere_clause(rs.getString(3));	
									ddb.setFetch_type(rs.getString(4));
									ddb.setIncremental_column(rs.getString(5));	
									ddb.setValidation_flag(rs.getString(6));
									ddb.setError_message(rs.getString(7));	
									arrddb.add(ddb);
					}				
					connection.close();
		} catch (SQLException e) {
					throw e;
		} finally {
					pstm.close();
					connection.close();
		}
		return arrddb;
	}	
}
