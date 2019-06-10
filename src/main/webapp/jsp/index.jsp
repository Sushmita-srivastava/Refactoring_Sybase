<jsp:include page="cdg_header.jsp" />
<style>
body {
	  
	}
	 
	.thumbnail {
	    position:relative;
	    overflow:hidden;
	}
	 
	.caption {
	    position:absolute;
	    top:0;
	    right:0;
	    background:rgba(90, 90, 90, 0.75);
	    width:100%;
	    height:100%;
	    padding:2%;
	    display: none;
	    text-align: left;
	    color:#fff !important;
	    z-index:2;
	}
</style>
<script type="text/javascript">
$(document).ready(function() {
    $("[rel='tooltip']").tooltip();    
 
    $('.thumbnail').hover(
        function(){
            $(this).find('.caption').slideDown(250); //.fadeIn(250)
        },
        function(){
            $(this).find('.caption').slideUp(250); //.fadeOut(205)
        }
    ); 	
 });
</script>
<div class="main-panel">
	<div class="content-wrapper">
		<div class="row">
			<div class="col-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<div class="container">
								  <div class="row text-center text-lg-left">
									 <div class="thumbnail col-lg-3 col-md-4 col-xs-6">
								      	<a class="d-block mb-4 h-100" href="/extraction/ConnectionDetailsSybase">
								      		<img class="img-fluid img-thumbnail" src="${pageContext.request.contextPath}/assets/img/src_details.png" >
								      	</a>
								    </div>
								    <div class="thumbnail col-lg-3 col-md-4 col-xs-6">
								      	<a class="d-block mb-4 h-100" href="/extraction/TargetDetails">
								      		<img class="img-fluid img-thumbnail" src="${pageContext.request.contextPath}/assets/img/tgt_details.png">
								      	</a> 
								    </div>
								    <div class="thumbnail col-lg-3 col-md-4 col-xs-6">
								      <a href="/extraction/SystemDetails" class="d-block mb-4 h-100" >
								            <img class="img-fluid img-thumbnail" src="${pageContext.request.contextPath}/assets/img/feed_details.png">
								          </a>
								    </div>
								     <div class="thumbnail col-lg-3 col-md-4 col-xs-6">
								      <a href="/extraction/DataDetails" class="d-block mb-4 h-100">
								            <img class="img-fluid img-thumbnail" src="${pageContext.request.contextPath}/assets/img/data_details.png">
								          </a>
								    </div>
								    <div class="thumbnail col-lg-3 col-md-4 col-xs-6">
								     	<a class="d-block mb-4 h-100" href="/extraction/FeedDetails">
								     		<img class="img-fluid img-thumbnail" src="${pageContext.request.contextPath}/assets/img/feed_chk.png">
								     	</a> 
								    </div>
								    <div class="thumbnail col-lg-3 col-md-4 col-xs-6">
								      <a href="/extraction/ExtractData" class="d-block mb-4 h-100">
								            <img class="img-fluid img-thumbnail" src="${pageContext.request.contextPath}/assets/img/extract_data.png">
								          </a>
								    </div>
								    <div class="thumbnail col-lg-3 col-md-4 col-xs-6">
								      <a class="d-block mb-4 h-100" href="/extraction/ViewFeedRun">
								      	<img class="img-fluid img-thumbnail" src="${pageContext.request.contextPath}/assets/img/feed_runs.png">
								      </a> 
								    </div>
								  </div>
							</div>	
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="cdg_footer.jsp" />