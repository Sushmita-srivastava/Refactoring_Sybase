<jsp:include page="../cdg_header.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
	$(document).ready(function() {
		$("#feed_id").change(function() {
			var src_sys_id = $(this).val();
			var src_val = document.getElementById("src_val").value;
				$.post('${pageContext.request.contextPath}/extraction/FeedValidationDashboard', {
					src_sys_id : src_sys_id,
					src_val : src_val
				}, function(data) {
					$('#schdyn').html(data)
				});
		});
		$("#success-alert").hide();
        $("#success-alert").fadeTo(10000,10).slideUp(2000, function(){
        });   
		$("#error-alert").hide();
        $("#error-alert").fadeTo(10000,10).slideUp(2000, function(){
         });
	});
</script>

<div class="main-panel">
	<div class="content-wrapper">
		<div class="row">
			<div class="col-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">Feed Validation</h4>
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
						<form class="forms-sample" id="FeedDetails" name="FeedDetails"
							method="POST" action="${pageContext.request.contextPath}/extraction/FeedDetailsOracle0"
							enctype="application/json">
							<input type="hidden" name="x" id="x" value=""> <input
								type="hidden" name="src_val" id="src_val" value="${src_val}">
								<input type="hidden" name="project"
								id="project" class="form-control" value="${project}"> <input
								type="hidden" name="user" id="user" class="form-control"
								value="${usernm}">

							

							<div class="form-group">
								<label>Source Feed Name *</label> <select name="feed_id"
									id="feed_id" class="form-control">
									<option value="" selected disabled>Source Feed Name
										...</option>
									<c:forEach items="${src_sys_val1}" var="src_sys_val1">
										<option value="${src_sys_val1.src_sys_id}">${src_sys_val1.src_unique_name}</option>
									</c:forEach>
								</select>
							</div>
							
							<div id="schdyn"></div>
							<div id="datdyn"></div>
						</form>
					</div>
				</div>
			</div>
		</div>
<jsp:include page="../cdg_footer.jsp" />