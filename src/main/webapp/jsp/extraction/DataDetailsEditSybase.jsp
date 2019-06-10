<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
$(document).ready(function() {
	if(${rec_count}>10)
	{
		document.getElementById("sh").style.display="block";
	}
});
	function loadcheck1(val) {
		document.getElementById("schdiv").innerHTML = "";
		document.getElementById("datadivx").innerHTML = "";
		if (val == 'ind_loadx') {
			$("#loading").show();
			document.getElementById("sh").style.display="none";
			var src_val = document.getElementById("src_val").value;
			var src_sys_id = document.getElementById("feed_id1").value;
			$
					.post(
							'${pageContext.request.contextPath}/extraction/DataDetailsEditSybase1',
							{
								src_sys_id : src_sys_id,
								src_val : src_val
							}, function(data) {
								$("#loading").hide();
								$('#datadivx').html(data);
								enableForm(DataDetails);
							});
		} else if (val == 'bulk_loadx') {
			document.getElementById("sh").style.display="block";
			document.getElementById("but").style.display="none";
			document.getElementById("datadivx").innerHTML="";
		}
	}
</script>
<c:choose>
	<c:when test="${rec_count<=10}">
		<div class="form-group row" id="load_type1" style="width: 100%;">
			<label class="col-sm-3 col-form-label">Upload Type</label>
			<div class="col-sm-4">
				<div class="form-check form-check-info">
					<label class="form-check-label"> <input type="radio"
						class="form-check-input" name="bulkx" id="bulkx1"
						value="ind_loadx" onclick="disableForm(DataDetails);loadcheck1(this.value)">
						Individual Load Type<i class="input-helper"></i>
					</label>
				</div>
			</div>
			<div class="col-sm-4">
				<div class="form-check form-check-info">
					<label class="form-check-label"> <input type="radio"
						class="form-check-input" name="bulkx" id="bulkx2"
						value="bulk_loadx" onclick="loadcheck1(this.value)"> Bulk
						Load Type<i class="input-helper"></i>
					</label>
				</div>
			</div>
		</div>
	</c:when>
</c:choose>
<div id="sh" style="display:none;">
<script>
	function bulkjsonconstruct() {
		var errors = [];
		var selection = $("input[name='radio']:checked").val();
		if (selection == 'create') {
			var feed_id = document.getElementById("feed_id").value;
			var src_val = document.getElementById("src_val").value;
			var file = document.getElementById("file").value;
			if (document.getElementById("file").files.length == 0) {
				errors[errors.length] = "Upload File Details";
			}
			if (errors.length > 0) {
				reportErrors(errors);
				return false;
			}
			$("#loading").show();			
			$('#DataDetails')
					.attr('action',
							'${pageContext.request.contextPath}/extraction/CreateBulkLoadDetails')
					.attr('enctype', "multipart/form-data");
		} else if (selection == 'edit') {
			var feed_id = document.getElementById("feed_id1").value;
			var src_val = document.getElementById("src_val").value;
			var file = document.getElementById("file").value;
			$("#loading").show();
			$('#DataDetails')
					.attr('action',
							'${pageContext.request.contextPath}/extraction/EditBulkLoadDetails')
					.attr('enctype', "multipart/form-data");
		}
	}
</script>
	<input type="hidden" name="connection_id" id="connection_id"
		class="form-control" value="${conn_val.connection_id}"> 
	<div id="bulk_load">
		<div class="form-group">
			<a href='${href1}' target="_blank">Download
				the Bulk Upload Details Template here!</a> </br></br>
				<a href='${pageContext.request.contextPath}/${href2}' target="_blank">Download
				the previously submitted PSV File here!</a></br>
				<input type="file" id="file"
				name="file" enctype="multipart/form-data"
				class="file-upload-default">
			<div class="input-group col-xs-12">
				<input type="text"
					class="form-control form-control1 file-upload-info" name="file"
					disabled placeholder="Upload File Details"> <span
					class="input-group-append">
					<button
						class="file-upload-browse btn-rounded btn btn-gradient-info"
						type="button">Browse</button>
				</span>
			</div>
		</div>
		<button onclick="return bulkjsonconstruct();" id="upload"
			class="btn btn-rounded btn-gradient-info mr-2">Upload</button>
	</div>
	<script src="../../assets/js/file-upload.js"></script>
</div>
<div id="datadivx"></div>