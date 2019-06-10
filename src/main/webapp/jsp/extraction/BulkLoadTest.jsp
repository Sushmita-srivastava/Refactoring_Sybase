<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<input type="hidden" name="connection_id" id="connection_id"
	class="form-control" value="${conn_val.connection_id}">


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
<div id="bulk_load">
	<div class="form-group">
		<a href='${href1}' target="_blank">Download
			the Bulk Upload Details Template here!</a> <input type="file" id="file"
			name="file" enctype="multipart/form-data" class="file-upload-default">
		<div class="input-group col-xs-12">
			<input type="text"
				class="form-control form-control1 file-upload-info" name="file"
				disabled placeholder="Upload File Details"> <span
				class="input-group-append">
				<button class="file-upload-browse btn-rounded btn btn-gradient-info"
					type="button">Browse</button>
			</span>
		</div>
	</div>
	<button onclick="return bulkjsonconstruct();" id="upload"
		class="btn btn-rounded btn-gradient-info mr-2">Upload</button>
</div>
<script src="../../assets/js/file-upload.js"></script>