package com.iig.gcp.extraction.utils;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Configuration
@ComponentScan
class DataSourceConfig {
	
	@Autowired
	EncryptionUtil encryptionUtil;

	@Value("${spring.datasource.username}")
	private String user;

	@Value("${spring.datasource.password}")
	private String password;

	@Value("${spring.datasource.url}")
	private String dataSourceUrl;

	@Value("${spring.datasource.driver-class-name}")
	private String dataSourceClassName;

	@Value("${spring.datasource.poolName}")
	private String poolName;

	@Value("${spring.datasource.hikari.connectionTimeout}")
	private int connectionTimeout;

	@Value("${spring.datasource.hikari.maxLifetime}")
	private int maxLifetime;

	@Value("${spring.datasource.hikari.maximumPoolSize}")
	private int maximumPoolSize;

	@Value("${spring.datasource.hikari.minimumIdle}")
	private int minimumIdle;

	@Value("${spring.datasource.hikari.idleTimeout}")
	private int idleTimeout;
	
	@Value("${master.key.path}")
	private String master_key_path;

	@Bean
	public DataSource primaryDataSource() throws Exception {
		
		String content = encryptionUtil.readFile(master_key_path);
		byte[] base_pwd=org.apache.commons.codec.binary.Base64.decodeBase64(password);
		String orcl_decoded_pwd=EncryptionUtil.decryptText(base_pwd, EncryptionUtil.decodeKeyFromString(content));
		
		HikariConfig jdbcConfig = new HikariConfig();
        jdbcConfig.setPoolName(poolName);
        jdbcConfig.setMaximumPoolSize(maximumPoolSize);
        jdbcConfig.setMinimumIdle(minimumIdle);
        //jdbcConfig.setLeakDetectionThreshold(10000);
        jdbcConfig.setValidationTimeout(10000);
        jdbcConfig.setConnectionTestQuery("select sysdate from dual");
        jdbcConfig.setJdbcUrl(dataSourceUrl);
        jdbcConfig.setUsername(user);
        jdbcConfig.setPassword(orcl_decoded_pwd);
        return new HikariDataSource(jdbcConfig);
        
        
	}
}