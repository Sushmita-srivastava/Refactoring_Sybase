<jsp:include page="../cdg_header.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
	function jsonconstruct(val) {
		var errors = [];
		var target_unique_name = document.getElementById("target_unique_name").value;
		var target_type = document.getElementById("target_type").value;
		var system = document.getElementById("system").value;
		if (target_type == 'GCS') {
			var target_project = document.getElementById("target_project").value;
			var service_account = document.getElementById("service_account").value;
			var target_bucket = document.getElementById("target_bucket").value;
			if (!checkLength(target_project)) {
				errors[errors.length] = "Target Project";
			}
			if (!checkLength(service_account)) {
				errors[errors.length] = "Service Account";
			}
			if (!checkLength(target_bucket)) {
				errors[errors.length] = "Target Bucket";
			}
		}
		if (target_type == 'HDFS') {
			var knox_host = document.getElementById("knox_host").value;
			var knox_port = document.getElementById("knox_port").value;
			var username = document.getElementById("username").value;
			var password = document.getElementById("password").value;
			var hdfs_gateway = document.getElementById("hdfs_gateway").value;
			var hadoop_path = document.getElementById("hadoop_path").value;
			if (!checkLength(knox_host)) {
				errors[errors.length] = "Knox Host";
			}
			if (!checkLength(knox_port) || !checkNumber(knox_port)) {
				errors[errors.length] = "Knox Port";
			}
			if (!checkLength(username)) {
				errors[errors.length] = "Username";
			}
			if (!checkLength(password)) {
				errors[errors.length] = "Password";
			}
			if (!checkLength(hdfs_gateway)) {
				errors[errors.length] = "HDFS Gateway";
			}
			if (!checkLength(hadoop_path)) {
				errors[errors.length] = "HDFS Path";
			}
		}
		if (!checkLength(target_unique_name)) {
			errors[errors.length] = "Target Name";
		}
		if (!checkLength(target_type)) {
			errors[errors.length] = "Target Type";
		}
		if (!checkLength(system)) {
			errors[errors.length] = "System";
		}

		if (errors.length > 0) {
			reportErrors(errors);
			return false;
		}
		$("#loading").show();
		var data = {};
		if (document.getElementById("materialization_flag").value == "")
			document.getElementById("materialization_flag").value = 'N';
		document.getElementById('button_type').value = val;
		$(".form-control").serializeArray().map(function(x) {
			data[x.name] = x.value;
		});
		var x = '{"header":{},"body":{"data":' + JSON.stringify(data) + '}}';
		document.getElementById('x').value = x;
		//alert(x);
		//console.log(x);
		document.getElementById('TargetDetails').submit();
	}
	var i = 1;
	function dup_div() {
		var dyn = document.getElementById('dyn1');
		var dyndiv = dyn.cloneNode(true);
		var x = ++i;
		dyndiv.id = "dyn" + i;
		dyndiv.getElementsByTagName('input')[0].id = "target_unique_name" + i;
		dyndiv.getElementsByTagName('input')[0].name = "target_unique_name" + i;
		dyndiv.getElementsByTagName('select')[0].id = "target_type" + i;
		dyndiv.getElementsByTagName('select')[0].name = "target_type" + i;
		dyndiv.getElementsByTagName('input')[1].id = "target_project" + i;
		dyndiv.getElementsByTagName('input')[1].name = "target_project" + i;
		dyndiv.getElementsByTagName('input')[2].id = "service_account" + i;
		dyndiv.getElementsByTagName('input')[2].name = "service_account" + i;
		dyndiv.getElementsByTagName('input')[3].id = "target_bucket" + i;
		dyndiv.getElementsByTagName('input')[3].name = "target_bucket" + i;
		dyndiv.getElementsByTagName('input')[4].id = "knox_url" + i;
		dyndiv.getElementsByTagName('input')[4].name = "knox_url" + i;
		dyndiv.getElementsByTagName('input')[5].id = "hadoop_path" + i;
		dyndiv.getElementsByTagName('input')[5].name = "hadoop_path" + i;
		dyndiv.getElementsByTagName('input')[6].id = "username" + i;
		dyndiv.getElementsByTagName('input')[6].name = "username" + i;
		dyndiv.getElementsByTagName('input')[7].id = "password" + i;
		dyndiv.getElementsByTagName('input')[7].name = "password" + i;
		dyndiv.getElementsByClassName('gx')[0].id = "g" + i;
		dyndiv.getElementsByClassName('hx')[0].id = "h" + i;
		dyn.parentNode.appendChild(dyndiv);
		document.getElementById('counter').value = i;
	}
	function sys_typ(id, val) {
		var in1 = id.slice(-1);
		var in2 = id.slice(-2, -1);
		if (in2 === "e")
			;
		else {
			in1 = id.slice(-2);
		}
		var in3 = 'g' + in1;
		var in4 = 'h' + in1;
		var in5 = 'u' + in1;
		if (val === "GCS") {
			document.getElementById("g1").style.display = "block";
			document.getElementById("h1").style.display = "none";
			//document.getElementById(in5).style.display = "none";
		} else if (val === "HDFS") {
			document.getElementById("h1").style.display = "block";
			document.getElementById("g1").style.display = "none";
			//document.getElementById(in5).style.display = "none";
		} else if (val === "Unix") {
			document.getElementById("g1").style.display = "block";
			document.getElementById("h1").style.display = "none";
			//document.getElementById(in4).style.display = "none";
		}
	}

	function chg() {
		$("#cud").show();
		$("#loading").show();
		if (document.getElementById("tgt").value == "") {
			window.location.reload();
		} else {
			var tgt = document.getElementById("tgt").value;
			$
					.post(
							'${pageContext.request.contextPath}/extraction/TargetDetailsEdit',
							{
								tgt : tgt
							}, function(data) {
								$("#loading").hide();
								$('#cud').html(data);
								enableForm(TargetDetails);
							});
		}
	}

	function funccheck(val) {
		if (val == 'create') {
			//window.location.reload();
			$("#loading").show();
			$("#tgtfunc").hide();
			$("#cud").hide();
			window.location.href = "${pageContext.request.contextPath}/extraction/TargetDetails";
		} else {
			$("#cud").hide();
			document.getElementById('tgtfunc').style.display = "block";
		}
	}

	function chk() {
		var checkBox = document.getElementById("mt");
		var text = document.getElementById("materialization_flag");
		if (checkBox.checked == true) {
			text.value = 'Y';
			document.getElementById("hivediv").style.display = "block";
		} else {
			text.value = 'N';
			document.getElementById("hivediv").style.display = "none";
		}
	}

	$(document)
			.ready(
					function() {
						$("#target_project")
								.change(
										function() {
											$("#loading").show();
											var project1 = document
													.getElementById('target_project').value;
											$
													.post(
															'${pageContext.request.contextPath}/extraction/TargetDetails0',
															{
																project1 : project1
															},
															function(data) {
																$("#loading").hide();
																$('#gdyn').html(data);
																enableForm(TargetDetails);
															});
										});
						$("#success-alert").hide();
						$("#success-alert").fadeTo(10000, 10).slideUp(2000,
								function() {
								});
						$("#error-alert").hide();
						$("#error-alert").fadeTo(10000, 10).slideUp(2000,
								function() {
								});
					});
</script>

<div class="main-panel">
	<div class="content-wrapper">
		<div class="row">
			<div class="col-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">Data Extraction</h4>
						<p class="card-description">Target Details</p>
						<%
							if (request.getAttribute("successString") != null) {
						%>
						<div class="alert alert-success" id="success-alert">
							<button type="button" class="close" data-dismiss="alert">x</button>
							${successString}
						</div>
						<%
							}
						%>
						<%
							if (request.getAttribute("errorString") != null) {
						%>
						<div class="alert alert-danger" id="error-alert">
							<button type="button" class="close" data-dismiss="alert">x</button>
							${errorString}
						</div>
						<%
							}
						%>
						<form class="forms-sample" id="TargetDetails" name="TargetDetails"
							method="POST"
							action="${pageContext.request.contextPath}/extraction/TargetDetails1"
							enctype="application/json">
							<input type="hidden" name="x" id="x" value=""> <input
								type="hidden" name="counter" id="counter" class="form-control"
								value="1"> <input type="hidden" name="button_type"
								id="button_type" value=""> <input type="hidden"
								name="materialization_flag" id="materialization_flag" value=""
								class="form-control"> <input type="hidden"
								name="project" id="project" class="form-control"
								value="${project}"> <input type="hidden" name="user"
								id="user" class="form-control" value="${usernm}">

							<div class="form-group row">
								<label class="col-sm-3 col-form-label">Target</label>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-check-input" name="radio" id="radio1"
											checked="checked" value="create"
											onclick="disableForm(TargetDetails);funccheck(this.value)"> Create
										</label>
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-check-input" name="radio" id="radio2"
											value="edit" onclick="funccheck(this.value)">
											Edit/View
										</label>
									</div>
								</div>
							</div>
							<div class="form-group" id="tgtfunc" style="display: none;">
								<label>Select Target</label> <select name="tgt" id="tgt"
									class="form-control" onchange="disableForm(TargetDetails);chg()">
									<option value="" selected disabled>Select Target ...</option>
									<c:forEach items="${tgt_val}" var="tgt_val">
										<option value="${tgt_val.target_conn_sequence}">${tgt_val.target_unique_name}</option>
									</c:forEach>
								</select>
							</div>
							<div id="cud">
								<fieldset class="fs">
									<div>
										<div id="dyn1">
											<div class="form-group row">
												<div class="col-sm-6">
													<label>Target Name *</label> <input type="text"
														class="form-control" id="target_unique_name"
														name="target_unique_name" placeholder="Target Name">
												</div>
												<div class="col-sm-6">
													<label>Target Type *</label> <select name="target_type"
														id="target_type" class="form-control"
														onchange="sys_typ(this.id,this.value)">
														<option value="" selected disabled>Target Type
															...</option>
														<option value="GCS" selected="selected">Google
															Cloud Storage</option>
														<option value="HDFS">Hadoop File System</option>
														<!-- <option value="Unix">Unix File System</option>-->
													</select>
												</div>
											</div>
											<div id="g1" class="gx">
												<div class="form-group row">
													<div class="col-sm-12">
														<label>Target Project *</label> <select
															name="target_project" id="target_project"
															class="form-control" onchange="disableForm(TargetDetails)">
															<option value="" selected disabled>Select Target
																Project...</option>
															<c:forEach items="${tproj}" var="tproj">
																<option value="${tproj}">${tproj}</option>
															</c:forEach>
														</select>
													</div>
												</div>
												<div class="form-group row" id="gdyn">
													<div class="col-sm-6">
														<label>Service Account *</label> <input type="text"
															class="form-control" id="service_account"
															name="service_account" placeholder="Service Account">
													</div>
													<div class="col-sm-6">
														<label>Target Bucket *</label> <input type="text"
															class="form-control" id="target_bucket"
															name="target_bucket" placeholder="Target Bucket">
													</div>
												</div>
											</div>
											<div id="h1" class="hx" style="display: none;">
												<div class="form-group row">
													<div class="col-sm-3">
														<label>Knox Host *</label> <input type="text"
															class="form-control" id="knox_host" name="knox_host"
															placeholder="Knox Host" value="https://35.243.138.100">
													</div>
													<div class="col-sm-3">
														<label>Knox Port *</label> <input type="text"
															class="form-control" id="knox_port" name="knox_port"
															placeholder="Knox Port" value="8443">
													</div>
													<div class="col-sm-3">
														<label>Username *</label> <input type="text"
															class="form-control" id="username" name="username"
															placeholder="Username" value="admin">
													</div>
													<div class="col-sm-3">
														<label>Password *</label> <input type="password"
															class="form-control" id="password" name="password"
															placeholder="Password" value="admin-password">
													</div>
												</div>
												<div class="form-group row">
													<div class="col-sm-6">
														<label>HDFS Gateway *</label> <input type="text"
															class="form-control" id="hdfs_gateway"
															name="hdfs_gateway" placeholder="HDFS Gateway" value="">
													</div>
													<div class="col-sm-6">
														<label>HDFS Path *</label> <input type="text"
															class="form-control" id="hadoop_path" name="hadoop_path"
															placeholder="HDFS Path"
															value="/apps/hive/warehouse/juniper_ingest">
													</div>
												</div>
												<div class="form-group">
													<div class="form-check form-check-flat form-check-info">
														<label class="form-check-label"> <input
															type="checkbox" name="mt" id="mt"
															class="form-check-input" onclick="chk()"> Enable
															Materialization <i class="input-helper"></i></label>
													</div>
												</div>
												<div id="hivediv" style="display: none;">
													<div class="form-group row">
														<div class="col-sm-6">
															<label>Hive JDBC URL *</label> <input type="text"
																class="form-control" id="hive_gateway"
																name="hive_gateway" placeholder="Hive JDBC URL" value="">
														</div>
														<div class="col-sm-6">
															<label>Load Type *</label> <select name="partition_flag"
																id="partition_flag" class="form-control">
																<option value="Y">Partitioned Data</option>
																<option value="N">New Database</option>
															</select>
														</div>
													</div>
												</div>
											</div>
											<div id="u1" class="ux" style="display: none;">
												<div class="form-group row">
													<div class="col-sm-6">
														<label>Disk Drive *</label> <select name="drive_id"
															id="drive_id" class="form-control">
															<option value="" selected disabled>Select Disk
																Drive ...</option>
															<c:forEach items="${drive}" var="drive">
																<option value="${drive.drive_id}">${drive.drive_name}
																	- ${drive.drive_path}</option>
															</c:forEach>
														</select>
													</div>
													<div class="col-sm-6">
														<label>Data Path *</label> <input type="text"
															class="form-control" id="data_path" name="data_path"
															placeholder="Data Path">
													</div>
												</div>
											</div>
											<div class="form-group">
												<label>Select System *</label> <select name="system"
													id="system" class="form-control">
													<option value="" selected disabled>Select
														System...</option>
													<c:forEach items="${system}" var="system">
														<option value="${system}">${system}</option>
													</c:forEach>
												</select>
											</div>
										</div>
									</div>
									<!-- <div class="form-group" style="float: right; position:relative; margin: 5px;">
									<button id="add" type="button"
										class="btn btn-rounded btn-gradient-info mr-2"
										onclick="return dup_div();">+</button>
								</div>-->
								</fieldset>
								<button onclick="return jsonconstruct('addTarget');"
									class="btn btn-rounded btn-gradient-info mr-2">Save</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../cdg_footer.jsp" />