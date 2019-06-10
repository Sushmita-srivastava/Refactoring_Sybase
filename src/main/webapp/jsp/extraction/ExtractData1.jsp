<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<input type="hidden" name="ext_type" id="ext_type" value="${ext_type}">
<c:choose>
<c:when test="${ext_type=='Batch'}">
<jsp:include page="../cdg_scheduler.jsp" />
<button onclick="jsonconstruct();"
	class="btn btn-rounded btn-gradient-info mr-2">Schedule</button>
</c:when>
<c:when test="${ext_type=='Event'}">
<script>
	$(document).ready(function() {

		$("#dsradio1").on("change", function() {
			$("#ds1").show();
			$("#ds4").show();
			$("#ds2").hide();
			$("#ds3").hide();
		})
		$("#dsradio2").on("change", function() {
			$("#ds2").show();
			$("#ds1").hide();
			$("#ds3").hide();
			$("#ds4").hide();
		})
		   $("#dsradio3").on("change", function() {
			 $("#ds3").show();
			$("#ds1").hide();
			$("#ds2").hide();
			$("#ds4").hide();
			})   
	});
	
	
	</script> 
	
	 <script>
	function fun(val) {
		if (val == 'API') {
			document.getElementById('api_unique_key').value = Math.floor(Math.random()*1000000000);
			document.getElementById('sch_flag').value = 'A';
		} 
		else if (val == 'file watcher') {
			document.getElementById('sch_flag').value = 'F';
		} 
		else if (val == 'kafka') {
			document.getElementById('sch_flag').value = 'K';
		} 
		fi
	}
	</script>

								<div class="form-group row">
									<label class="col-sm-3 col-form-label">Schedule Type<span
										style="color: red">*</span></label>
									<div class="col-sm-3">
										<div class="form-check form-check-info">
											 <input type="radio"
												class="form-check-input" name="dsoptradioo" id="dsradio1"
												value="file watcher" class="form-control"  onclick="fun(this.value)"> File Watcher
										
										</div>
						
										<div class="row" id="ds1" style="display: none;">
									<div class="col-md-9"></div>
									<div class="col-md-12">
										<input type="text" class="form-control"
											placeholder="File watcher path" id="file_path" name="file_path">
									</div>
									</div>
									<br>
								<div class="row" id="ds4" style="display: none;">
									<div class="col-md-9"></div>
									<div class="col-md-12">
										<input type="text" class="form-control"
											placeholder="File name pattern" id="file_pattern" name="file_pattern">
									</div>
					</div>
									</div>
								
									  <div class="col-sm-3">
										<div class="form-check form-check-info">
											 <input type="radio"
												class="form-check-input" name="dsoptradioo" id="dsradio2"
												value="kafka" class="form-control"  onclick="fun(this.value)"> Kafka Topic
											
										</div> 
										<div class="form-group" id="ds2" style="display: none;">
			
				
	<select class="form-control"
		id="kafka_topic" name="kafka_topic">
		<option value="" selected disabled>Kafka name...</option>
		<c:forEach items="${kafka_topic}" var="kafka_topic">
			<option value="${kafka_topic}">${kafka_topic}</option>
		</c:forEach>
	</select>
								</div>
										</div> 										
								
								
									<div class="col-sm-3">
										<div class="form-check form-check-info">
											 <input type="radio"
												class="form-check-input" name="dsoptradioo" id="dsradio3"
												value="API" class="form-control" 
										 onclick="fun(this.value)"> API 
											
										</div>
										<div class="row" id="ds3" style="display: none;">
									<div class="col-md-9"></div>
									<div class="col-md-12">
										<input type="text" class="form-control" 
											placeholder="API Feed name" id="api_unique_key" name="api_unique_key">
											<input class="form-control"  
											 id="sch_flag" name="sch_flag" style="display: none;">
									</div>
								</div>
									</div>
									
									</div>	
<button onclick="jsonconstruct();"
	class="btn btn-rounded btn-gradient-info mr-2">Schedule</button>
</c:when>
<c:when test="${ext_type=='Real'}">
<script>
						document.getElementById('sch_flag').value = 'O';
						</script>
						<input class="form-control" id="sch_flag" name="sch_flag" style="display: none;">
<button onclick="jsonconstruct();"
	class="btn btn-rounded btn-gradient-info mr-2">Extract</button>
	<!--  <button onclick="jsonconstruct1();" 
	class="btn btn-rounded btn-gradient-info mr-2">Extract with C</button>-->
</c:when>
 <c:otherwise>
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
 </c:otherwise>
</c:choose>