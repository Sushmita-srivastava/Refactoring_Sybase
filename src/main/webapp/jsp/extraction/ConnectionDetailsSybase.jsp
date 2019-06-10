<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="../cdg_header.jsp" />
<script>
	function jsonconstruct(val) {
		var connection_name = document.getElementById("connection_name").value;
		var host_name = document.getElementById("host_name").value;
		var port = document.getElementById("port").value;
		var user_name = document.getElementById("user_name").value;
		var password = document.getElementById("password").value;
		var db_name = document.getElementById("db_name").value;
		var system = document.getElementById("system").value;
		var errors = [];

		if (!checkLength(connection_name)) {
			errors[errors.length] = "Connection Name";
		}
		if (!checkLength(host_name)) {
			errors[errors.length] = "Host Name"; 
		}
		if (!checkLength(port) || !checkNumber(port)) {
			errors[errors.length] = "Port Number";
		}
		if (!checkLength(user_name)) {
			errors[errors.length] = "User Name";
		}
		if (!checkLength(password)) {
			errors[errors.length] = "Password";
		}
		if (!checkLength(db_name)) {
			errors[errors.length] = "Database Name";
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
		document.getElementById('button_type').value = val;
		$(".form-control").serializeArray().map(function(x) {
			data[x.name] = x.value;
		});
		var x = '{"header":{},"body":{"data":' + JSON.stringify(data) + '}}';
		document.getElementById('x').value = x;
		//console.log(x);
		alert(x);
		document.getElementById('ConnectionDetails').submit();
	}
	$(document)
			.ready(
					function() {
						$("#conn")
								.change(
										function() {
											$("#loading").show();
											var conn = $(this).val();
											var src_val = document
													.getElementById("src_val").value;
											$
													.post(
															'${pageContext.request.contextPath}/extraction/ConnectionDetailsEdit',
															{
																conn : conn,
																src_val : src_val
															}, function(data) {
																$("#loading").hide();
																$('#cud').html(data);
																enableForm(ConnectionDetails);
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

	function funccheck(val) {
		if (val == 'create') {
			//window.location.reload();
			window.location.href = "${pageContext.request.contextPath}/extraction/ConnectionDetailsSybase";
		} else {
			document.getElementById('connfunc').style.display = "block";
			document.getElementById('cud').innerHTML = "";
		}
	}
</script>
<div class="main-panel">
	<div class="content-wrapper">
		<div class="row">
			<div class="col-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">Data Extraction</h4>
						<p class="card-description">Connection Details</p>
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
						<script type="text/javascript">
							window.onload = function() {
								document.getElementById("host_name").value = "104.198.204.138";
								document.getElementById("port").value = "5000";
								document.getElementById("user_name").value = "sa";
								document.getElementById("password").value = "admin_ase";
								document.getElementById("db_name").value = "pubs2";
							}
						</script>
						<form class="forms-sample" id="ConnectionDetails"
							name="ConnectionDetails" method="POST"
							action="${pageContext.request.contextPath}/extraction/ConnectionDetails1"
							enctype="application/json">
							<input type="hidden" name="x" id="x" value=""> <input
								type="hidden" name="button_type" id="button_type" value="">
							<input type="hidden" name="src_val" id="src_val"
								value="${src_val}"><input type="hidden" name="project"
								id="project" class="form-control" value="${project}"> <input
								type="hidden" name="user" id="user" class="form-control"
								value="${usernm}">

							<div class="form-group row">
								<label class="col-sm-3 col-form-label">Connection</label>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-check-input" name="radio" id="radio1"
											checked="checked" value="create"
											onclick="funccheck(this.value)"> Create
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

							<div class="form-group" id="connfunc" style="display: none;">
								<label>Select Connection</label> <select name="conn" id="conn"
									class="form-control" onchange="disableForm(ConnectionDetails)">
									<option value="" selected disabled>Select Connection
										...</option>
									<c:forEach items="${conn_val}" var="conn_val">
										<option value="${conn_val.connection_id}">${conn_val.connection_name}</option>
									</c:forEach>
								</select>
							</div>
							<div id="cud">
								<fieldset class="fs">
									<div class="form-group row">
										<div class="col-sm-6">
											<label>Connection Name *</label> <input type="text"
												class="form-control" id="connection_name"
												name="connection_name" placeholder="Connection Name">
										</div>
										<div class="col-sm-6">
											<label>Connection Type *</label> <input type="text"
												class="form-control" id="connection_type"
												name="connection_type" value="${src_val}"
												readonly="readonly">
										</div>
									</div>
									<div class="form-group row">
										<div class="col-sm-3">
											<label>Host Name *</label> <input type="text"
												class="form-control" id="host_name" name="host_name"
												placeholder="Host Name">
										</div>
										<div class="col-sm-3">
											<label>Port Number *</label> <input type="text"
												class="form-control" id="port" name="port"
												placeholder="Port Number">
										</div>
										<div class="col-sm-3">
											<label>Username *</label> <input type="text"
												class="form-control" id="user_name" name="user_name"
												placeholder="Username">
										</div>
										<div class="col-sm-3">
											<label>Password *</label> <input type="password"
												class="form-control" id="password" name="password"
												placeholder="Password">
										</div>
									</div>
									<div class="form-group" id="service">
										<label>Database Name *</label> <input type="text"
											class="form-control" id="db_name" name="db_name"
											placeholder="Database Name">
									</div>
									<div class="form-group">
										<label>Select System *</label> <select name="system"
											id="system" class="form-control">
											<option value="" selected disabled>Select System...</option>
											<c:forEach items="${system}" var="system">
												<option value="${system}">${system}</option>
											</c:forEach>
										</select>
									</div>
								</fieldset>
								<button onclick="return jsonconstruct('addSybaseConnection');"
									class="btn btn-rounded btn-gradient-info mr-2">Test &
									Save</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../cdg_footer.jsp" />