<jsp:include page="../cdg_header.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
	function jsonconstruct(val) {
		var feed_name = document.getElementById("feed_name").value;
		var feed_desc = document.getElementById("feed_desc").value;
		var src_connection_id = document.getElementById("src_connection_id").value;
		var targetx = document.getElementById("targetx").value;
		var feed_extract_type = document.getElementById("feed_extract_type").value;
		var country_code = document.getElementById("country_code").value;
		var errors = [];

		if (!checkLength(feed_name)) {
			errors[errors.length] = "Feed Name";
		}
		if (!checkLength(feed_desc)) {
			errors[errors.length] = "Feed Description";
		}
		if (!checkLength(src_connection_id)) {
			errors[errors.length] = "Source";
		}
		if (!checkLength(targetx)) {
			errors[errors.length] = "Target";
		}
		if (!checkLength(feed_extract_type)) {
			errors[errors.length] = "Extraction Type";
		}
		if (!checkLength(country_code)) {
			errors[errors.length] = "Country";
		}
		if (errors.length > 0) {
			reportErrors(errors);
			return false;
		}
		$("#loading").show();
		multisel('targetx', 'target');
		var data = {};
		document.getElementById('button_type').value = val;
		$(".form-control").serializeArray().map(function(x) {
			data[x.name] = x.value;
		});
		var x = '{"header":{},"body":{"data":'
				+ JSON.stringify(data) + '}}';
		document.getElementById('x').value = x;
		//alert(x);
		//console.log(x);
		document.getElementById('ExtractData').submit();
	}
	function sch(val) {
		if (val == "Batch") {
			document.getElementById('scheduling_div').style.display = "block";
		} else if (val == "Real") {
			document.getElementById('scheduling_div').style.display = "none";
		}
	}
	$(document).ready(function() {
		$("#feed_name").keyup(function() {
			var sun = $(this).val();
			if (sun != '') {
				$.ajax({
					type : "POST",
					url : "${pageContext.request.contextPath}/extraction/SystemDetails1",
					data : {
						sun : sun
					},
					cache : false,
					success : function(html) {
						$("#res").html(html).show();
					}
				});
			}
			return false;
		});
		$("#src_sys").change(function() {
			document.getElementById("cud").style.display="block";
			$("#loading").show();
			if (document.getElementById("src_sys").value == "") {
				window.location.reload();
			} else {
				var src_sys = $(this).val();
				var src_val = document.getElementById("src_val").value;
				$.post('${pageContext.request.contextPath}/extraction/SystemDetailsEdit', {
					src_sys : src_sys,
					src_val : src_val
				}, function(data) {
					$("#loading").hide();
					$('#cud').html(data);
					enableForm(ExtractData);
				});
			}
		});
		$("#success-alert").hide();
        $("#success-alert").fadeTo(10000,10).slideUp(2000, function(){
        });   
 $("#error-alert").hide();
        $("#error-alert").fadeTo(10000,10).slideUp(2000, function(){
         });
	});
	function chk() {
		  var checkBox = document.getElementById("mt");
		  var text = document.getElementById("encrypt");
		  if (checkBox.checked == true){
		    text.value='Y';
		  } else {
			text.value='N';
		  }
		}	
	function funccheck(val) {
		if (val == 'create') {
			//window.location.reload();
			$("#loading").show();
			$("#sysfunc").hide();
			$("#cud").hide();
			window.location.href="${pageContext.request.contextPath}/extraction/SystemDetails";
		} else {
			$("#cud").hide();
			document.getElementById('sysfunc').style.display = "block";
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
						<p class="card-description">Feed Details</p>
						<%
               if(request.getAttribute("successString") != null) {
               %>
            <div class="alert alert-success" id="success-alert">
               <button type="button" class="close" data-dismiss="alert">x</button>
               ${successString}
            </div>
            <%
               }
               %>
            <%
               if(request.getAttribute("errorString") != null) {
               %>
            <div class="alert alert-danger" id="error-alert">
               <button type="button" class="close" data-dismiss="alert">x</button>
               ${errorString}
            </div>
            <%
               }
               %>
						<form class="forms-sample" id="ExtractData" name="ExtractData"
							method="POST" action="${pageContext.request.contextPath}/extraction/SystemDetails2"
							enctype="application/json">
							<input type="hidden" name="x" id="x" value=""> <input
								type="hidden" name="target" id="target" class="form-control"
								value=""> <input type="hidden" name="src_val"
								id="src_val" value="${src_val}"> <input type="hidden" name="project"
								id="project" class="form-control" value="${project}"> <input
								type="hidden" name="user" id="user" class="form-control"
								value="${usernm}">
								<input type="hidden" name="encrypt"
								id="encrypt" value="" class="form-control">
								<input type="hidden" name="button_type" id="button_type" value="">
								
							<div class="form-group row">
								<label class="col-sm-3 col-form-label">Source Feed</label>
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
											value="edit" onclick="funccheck(this.value)"> Edit/View
										</label>
									</div>
								</div>
							</div>
							<div class="form-group" id="sysfunc" style="display: none;">
								<label>Select Source Feed</label> <select name="src_sys" id="src_sys"
									class="form-control" onchange="disableForm(ExtractData)">
									<option value="" selected disabled>Select Source Feed ...</option>
									<c:forEach items="${src_sys_val}" var="src_sys_val">
										<option value="${src_sys_val.src_sys_id}">${src_sys_val.src_unique_name}</option>
									</c:forEach>
								</select>
							</div>
							<div id="cud">								
							<fieldset class="fs">
								<div class="form-group row">
									<div class="col-sm-6">
										<label>Unique Extract Name *</label> <input type="text"
											class="form-control" id="feed_name"
											name="feed_name" placeholder="Unique Extract Name">
										<div id="res" style="font-size: 0.7em; text-align: center;"></div>
									</div>
									<div class="col-sm-6">
										<label>Extract Description *</label> <input type="text"
											class="form-control" id="feed_desc" name="feed_desc"
											placeholder="Extract Description">
									</div>
								</div>
								<div class="form-group">
									<label>Select Source *</label> <select class="form-control"
										id="src_connection_id" name="src_connection_id">
										<option value="" selected disabled>${src_val}
											Sources...</option>
										<c:forEach items="${conn_val}" var="conn_val">
											<option value="${conn_val.connection_id}">${conn_val.connection_name}</option>
										</c:forEach>
									</select>
								</div>
								<div class="form-group">
									<label>Select Target *</label> <select name="targetx"
										id="targetx" class="form-control" multiple="multiple">
										<c:forEach items="${tgt}" var="tgt">
											<option value="${tgt.target_conn_sequence}">${tgt.target_unique_name}</option>
										</c:forEach>
									</select>
								</div>
								<div class="form-group row">
									<div class="col-sm-6">
										<label>Extraction Type *</label> <select
											name="feed_extract_type" id="feed_extract_type"
											class="form-control" onchange="sch(this.value);">
											<option value="" selected disabled>Extraction Type
												...</option>
											<option value="Real">One Time Full Extract</option>
											<option value="Batch">Scheduled Batch Run</option>
											<option value="Event">Event Based</option>
										</select>
									</div>
									<div class="col-sm-6">
										<label>Country *</label> <select class="form-control"
											id="country_code" name="country_code">
											<option value="" selected disabled>Country ...</option>
											<c:forEach items="${countries}" var="countries">
												<option value="${countries.country_code}">${countries.country_name}</option>
											</c:forEach>
										</select>
									</div>
								</div>
												<div class="form-group" style="display:none;">
													<div class="form-check form-check-flat form-check-info">
														<label class="form-check-label"> <input
															type="checkbox" name="mt" id="mt" class="form-check-input"
															onclick="chk()">
															Enable Data Encryption <i class="input-helper"></i></label>
													</div>
												</div>
								<div id="scheduling_div" style="display: none;">
									<!-- <div class="form-group">
										<label>Reservoir Id</label> <select name="reservoir_name"
											id="reservoir_name" class="form-control">
											<option value="" selected disabled>Reservoir Id ...</option>
											<c:forEach items="${reservoir}" var="reservoir">
												<option value="${reservoir.reservoir_name}">${reservoir.reservoir_name} - ${reservoir.reservoir_desc}</option>
											</c:forEach>
										</select>
									</div>-->
								</div>
							</fieldset>
							<button onclick="return jsonconstruct('onboardSystem');"
								class="btn btn-rounded btn-gradient-info mr-2">Save</button>
								</div>
						</form>
					</div>
				</div>
			</div>
		</div>

		<script>
			var select = document.getElementById('targetx');
			multi(select, {});
		</script>
<jsp:include page="../cdg_footer.jsp" />