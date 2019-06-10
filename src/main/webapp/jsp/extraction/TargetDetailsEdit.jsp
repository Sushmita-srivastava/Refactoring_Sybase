<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<fieldset class="fs">
	<div>
		<div id="dyn1">
			<div class="form-group row">
				<div class="col-sm-6">
					<label>Target Name *</label> <input type="text"
						class="form-control" id="target_unique_name"
						name="target_unique_name" placeholder="Target Name"
						value="${tgtx.target_unique_name}">
				</div>
				<div class="col-sm-6">
					<label>Target Type *</label> <select name="target_type"
						id="target_type" class="form-control"
						onchange="sys_typ(this.id,this.value)">
						<c:if test="${tgtx.target_type=='gcs' || tgtx.target_type=='GCS'}">
							<option value="GCS" selected="selected">Google Cloud
								Storage</option>
							<option value="HDFS">Hadoop File System</option>
						</c:if>
						<c:if
							test="${tgtx.target_type=='hdfs' || tgtx.target_type=='HDFS'}">
							<option value="GCS">Google Cloud Storage</option>
							<option value="HDFS" selected="selected">Hadoop File
								System</option>
						</c:if>
					</select>
				</div>
			</div>
			<div id="g1" class="gx"
				<c:if test="${tgtx.target_type=='gcs' || tgtx.target_type=='GCS'}">
			style="display:block;"
			</c:if>
				<c:if test="${tgtx.target_type=='hdfs' || tgtx.target_type=='HDFS'}">
			style="display:none;"
			</c:if>>
				<div class="form-group row">
					<div class="col-sm-12">
						<label>Target Project *</label> <select name="target_project"
							id="target_project" class="form-control">
							<c:forEach items="${tproj}" var="tproj">
								<c:choose>
									<c:when test="${tproj==tgtx.gcp_project}">
										<option value="${tproj}" selected>${tproj}</option>
									</c:when>
									<c:otherwise>
										<option value="${tproj}">${tproj}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="form-group row" id="gdyn">
					<div class="col-sm-6">
						<label>Service Account *</label> <input type="text"
							class="form-control" id="service_account" name="service_account"
							placeholder="Service Account" value="${tgtx.gcp_service_account}">
					</div>
					<div class="col-sm-6">
						<label>Target Bucket *</label> <input type="text"
							class="form-control" id="target_bucket" name="target_bucket"
							placeholder="Target Bucket" value="${tgtx.gcp_bucket}">
					</div>
				</div>
			</div>
			<div id="h1" class="hx"
				<c:if test="${tgtx.target_type=='gcs' || tgtx.target_type=='GCS'}">
			style="display:none;"
			</c:if>
				<c:if test="${tgtx.target_type=='hdfs' || tgtx.target_type=='HDFS'}">
			style="display:block;"
			</c:if>>
				<div class="form-group row">
					<div class="col-sm-3">
						<label>Knox Host *</label> <input type="text" class="form-control"
							id="knox_host" name="knox_host" placeholder="Knox Host"
							value="${tgtx.hdp_knox_host}">
					</div>
					<div class="col-sm-3">
						<label>Knox Port *</label> <input type="text" class="form-control"
							id="knox_port" name="knox_port" placeholder="Knox Port"
							value="${tgtx.hdp_knox_port}">
					</div>
					<div class="col-sm-3">
						<label>Username *</label> <input type="text" class="form-control"
							id="username" name="username" placeholder="Username"
							value="${tgtx.hdp_user}">
					</div>
					<div class="col-sm-3">
						<label>Password *</label> <input type="password"
							class="form-control" id="password" name="password"
							placeholder="Password" value="">
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-6">
						<label>HDFS Gateway *</label> <input type="text"
							class="form-control" id="hdfs_gateway"
							name="hdfs_gateway" placeholder="HDFS Gateway" value="${tgtx.hdfs_gateway}">
					</div>
					<div class="col-sm-6">
						<label>HDFS Path *</label> <input type="text" class="form-control"
							id="hadoop_path" name="hadoop_path" placeholder="HDFS Path"
							value="${tgtx.hdp_hdfs_path}">
					</div>
				</div>
				<div class="form-group">
					<div class="form-check form-check-flat form-check-info">
						<c:if
							test="${tgtx.materialization_flag=='y' || tgtx.materialization_flag=='Y'}">
							<label class="form-check-label"> <input type="checkbox"
								name="mt" id="mt" class="form-check-input" onclick="chk()"
								checked="checked"> Enable Materialization <i
								class="input-helper"></i></label>
						</c:if>
						<c:if
							test="${tgtx.materialization_flag=='n' || tgtx.materialization_flag=='N'}">
							<label class="form-check-label"> <input type="checkbox"
								name="mt" id="mt" class="form-check-input" onclick="chk()">
								Enable Materialization <i class="input-helper"></i></label>
						</c:if>
					</div>
				</div>
				<c:if test="${tgtx.materialization_flag=='y' || tgtx.materialization_flag=='Y'}">
				<div id="hivediv">
					<div class="form-group row">
						<div class="col-sm-6">
							<label>Hive JDBC URL *</label> <input type="text"
								class="form-control" id="hive_gateway" name="hive_gateway"
								placeholder="Hive JDBC URL" value="${tgtx.hive_gateway}">
						</div>
						<div class="col-sm-6">
							<label>Load Type *</label> <select name="partition_flag"
								id="partition_flag" class="form-control">
								<c:if test="${tgtx.partition_flag=='y' || tgtx.partition_flag=='Y'}">
								<option value="Y" selected>Partitioned Data</option>
								<option value="N">New Database</option>
								</c:if>
								<c:if test="${tgtx.partition_flag=='n' || tgtx.partition_flag=='N'}">
								<option value="N" selected>New Database</option>
								<option value="Y">Partitioned Data</option>
								</c:if>
							</select>
						</div>
					</div>
				</div>
				</c:if>
			</div>
			<div id="u1" class="ux" style="display: none;">
				<div class="form-group row">
					<div class="col-sm-6">
						<label>Disk Drive *</label> <select name="drive_id" id="drive_id"
							class="form-control">
							<option value="" selected disabled>Select Disk Drive ...</option>
							<c:forEach items="${drive}" var="drive">
								<option value="${drive.drive_id}">${drive.drive_name}-
									${drive.drive_path}</option>
							</c:forEach>
						</select>
					</div>
					<div class="col-sm-6">
						<label>Data Path *</label> <input type="text" class="form-control"
							id="data_path" name="data_path" placeholder="Data Path">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label>System *</label> <input type="text" class="form-control"
					id="system" name="system" placeholder="System"
					value="${tgtx.system_name}" readonly="readonly">
			</div>
		</div>
	</div>
	<!-- <div class="form-group" style="float: right; position:relative; margin: 5px;">
									<button id="add" type="button"
										class="btn btn-rounded btn-gradient-info mr-2"
										onclick="return dup_div();">+</button>
								</div>-->
</fieldset>
<button onclick="return jsonconstruct('updTarget');"
	class="btn btn-rounded btn-gradient-info mr-2">Update</button>
<button onclick="return jsonconstruct('delTarget');"
	class="btn btn-rounded btn-gradient-info mr-2">Delete</button>