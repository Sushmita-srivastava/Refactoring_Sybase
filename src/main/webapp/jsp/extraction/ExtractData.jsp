<jsp:include page="../cdg_header.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
	function jsonconstruct() {
     alert("1");
		
		var ext_type = document.getElementById("ext_type").value;
		if (ext_type == "Batch") {
			document.getElementById("cron").value = cron_construct();
		}
		var data = {};
		$(".form-control").serializeArray().map(function(x) {
			data[x.name] = x.value;
		});
		var x = '{"header":{},"body":{"data":' + JSON.stringify(data) + '}}';
		document.getElementById('x').value = x;
	alert(x);
	console.log(x);
		document.getElementById('ExtractData').submit();
	}
	/* function jsonconstruct1() {
		var ext_type = document.getElementById("ext_type").value;
		if (ext_type == "Batch") {
			document.getElementById("cron").value = cron_construct();
		}
		var data = {};
		$(".form-control").serializeArray().map(function(x) {
			data[x.name] = x.value;
		});
		var x = '{"header":{},"body":{"data":' + JSON.stringify(data) + '}}';
		document.getElementById('x').value = x;
		alert(x);
		console.log(x);
		$('#ExtractData').attr('action',
				'${pageContext.request.contextPath}/extraction/ExtractData3');
		document.getElementById('ExtractData').submit();
	} */
	$(document)
			.ready(
					function() {
						$("#feed_name")
								.change(
										function() {
											$("#loading").show();
											var feed_name = $(this).val();
								alert("feed_name "+feed_name)
											var src_val = document
													.getElementById("src_val").value;
								alert("src_val "+src_val)
											if (src_val == "Sybase") {
												$("#selectExtractmode").show();
												alert(src_val)
											}
											$
													.post(
															'${pageContext.request.contextPath}/extraction/ExtractData1',
															{
																feed_name : feed_name,
																src_val : src_val
															},
															function(data) {
																$("#loading").hide();
																$('#datdyn1')
																		.html(
																				data);
																enableForm(ExtractData);
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
		

		if (val == 'nifi') {
			$("#datdyn1").show();
			$("#datdyn2").hide();

		} else if (val == 'nativec') {
			$("#datdyn2").show();
			$("#datdyn1").hide();

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
						<p class="card-description">Extract Data</p>
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
						<form class="forms-sample" id="ExtractData" name="ExtractData"
							method="POST"
							action="${pageContext.request.contextPath}/extraction/ExtractData2"
							enctype="application/json">
							<input type="hidden" name="x" id="x" value=""> <input
								type="hidden" name="src_val" id="src_val" value="${src_val}">
							<input type="hidden" name="cron" id="cron" class="form-control"
								value=""> <input type="hidden" name="project"
								id="project" class="form-control" value="${project}"> <input
								type="hidden" name="user" id="user" class="form-control"
								value="${usernm}">
							<div class="form-group">
								<label>Source Feed Name *</label> <select name="feed_name"
									id="feed_name" class="form-control" onchange="disableForm(ExtractData)">
									<option value="" selected disabled>Source Feed Name
										...</option>
									<c:forEach items="${src_sys_val}" var="src_sys_val">
										<option value="${src_sys_val.src_unique_name}">${src_sys_val.src_unique_name}</option>
									</c:forEach>
								</select>
							</div>
							
							<div class="form-group row" id="selectExtractmode"
								style="display: none;">
								<label class="col-sm-3 col-form-label">Extract Mode</label>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-control form-check-input" name="extraction_mode" id="radio1"
											checked="checked" value="N"
											> Nifi
											Driver
										</label>
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-control form-check-input" name="extraction_mode" id="radio2"
											value="C" >
											Sybase Jconnect
										</label>
									</div>
								</div>
							</div>
							<div id="datdyn1"></div>
							<!-- <div id="datdyn2" style="display: none;">
								<button id="nativetype" onclick="jsonconstruct1();"
									class="btn btn-rounded btn-gradient-info mr-2">Extract</button>
							</div> -->
						</form>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../cdg_footer.jsp" />