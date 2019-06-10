<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="../cdg_header.jsp" />
    
<style>
.drop-down {
	position: relative;
}
</style>
<link href="../../assets/css/jquery-ui.css" rel="stylesheet">
<link href="../../assets/css/bootstrap.min2.css" rel="stylesheet">
<link rel="stylesheet"
	href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.min.css" />
<script>
$(document).ready(function() {
		
	
	$("#feedname").change(function() {
		
		var feed_val = $(this).val();
		$.post('${pageContext.request.contextPath}/extraction/FeedStatus', {
			feed_val : feed_val
		}, function(data) {
			$('#addFeedStatus').html(data);
		})
	
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
						<p class="card-description">View Feed Runs</p>
						<form class="forms-sample" id="ExtractHome" name="ExtractHome" method="post" action="/extraction/ViewFeedRun">
							<input type="hidden" name="src_val" id="src_val" value="">
							<div class="container">
								<div class="row text-center text-lg-left">
								<label>Select Feed</label> <select feed="feedname" id="feedname" class="form-control selectpicker" data-live-search="true">
									<option value="" selected disabled>Select Feed ...</option>
									<c:forEach items="${feedarr}" var="feedarr">
											<option value="${feedarr}">${feedarr}</option>
										</c:forEach>
									</select>
								</div>
								<br>
								 <div id="addFeedStatus"></div>
							</div>
						</form>
					</div>
				</div>
			</div>
			
			
		</div>		

 



<jsp:include page="../cdg_footer.jsp" />
<script src="../../assets/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>
		 

    