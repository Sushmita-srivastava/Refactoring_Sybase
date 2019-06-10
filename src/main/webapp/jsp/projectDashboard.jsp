<jsp:include page="cdg_header.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/multi.min.css">

<div class="main-panel">
	<div class="content-wrapper">
		<div class="row">
			<div class="col-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						
    
  <div class="row">

	    <div class="col-md-4">
					<div class="card p-4 bg-gradient-primary card-img-holder text-white" >
						<div class="media">
							<div class="media-body media-text-right" id="x1">
								<h2><a href="#fd" style="text-decoration:underline;font-weight:bold; cursor:pointer;color:white">${feedno}</a></h2><p>No. of Feeds Registered</p>
							</div>
						</div>
					</div>
				</div>
				
		 <div class="col-md-4">
					<div class="card p-4 bg-gradient-danger card-img-holder text-white">
						<div class="media">
							<div class="media-body media-text-right" id="x1">
								<h2><a href="#ud" style="text-decoration:underline;font-weight:bold; cursor:pointer;color:white">${userno}</a></h2><p >No. of Users Registered</p>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card p-4 bg-gradient-dark card-img-holder text-white">
						<div class="media">
							<div class="media-body media-text-right" id="x1">
								<h2>${feedrunning}</h2><p >No. of Feeds Running</p>
							</div>
						</div>
					</div>
				</div>
		 
		   
		
	    
</div>

	

			<br><br>
			<div class="row">
				<p class="card-description">Current Feed Runs</p>
			<table id="dashboard1" 
			class="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			data-show-header="true"
			data-classes="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			 data-toggle="table"  
			data-striped="true"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name2" 
		   	data-page-size="5"
		   	data-page-list="[5, 10, 25, 50, 100, ALL] " > 
	             <thead>
	              <tr>
	              <th data-sortable="true" onclick="myFunction(this)"  >
	                  Job Id
	                </th>
	                <th data-sortable="true"  >
	                  Batch Id 
	                </th>    
	                <th data-sortable="true"  >
	                  Extract Date 
	                </th>
	                <th data-sortable="true"  >
	                  Start Time 
	                </th>    
	                <th data-sortable="true"  >
	                  End Time 
	                </th>
	                    	                       	
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${cruns}">
                 <tr>
                 	<td><c:out value="${row.job_id}"/></td>
                 	<td ><c:out value="${row.batch_id}" /></td>
					<td><c:out value="${row.extract_date}" /></td>
					<td ><c:out value="${row.start_time}" /></td>
					<td><c:out value="${row.end_time}" /></td>
     
			
				</tr>
             </c:forEach>
                               
                </tbody>
        	</table>
 </div>       	
			<br><br>
			
<div class="row">
				<p class="card-description">Last Feed Runs</p>
			<table id="dashboard1" 
			class="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			data-show-header="true"
			data-classes="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			 data-toggle="table"  
			data-striped="true"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name2" 
		   	data-page-size="5"
		   	data-page-list="[5, 10, 25, 50, 100, ALL] " > 
	             <thead>
	              <tr>
	              <th data-sortable="true" onclick="myFunction(this)"  >
	                  Job Id
	                </th>
	                <th data-sortable="true"  >
	                  Batch Id 
	                </th>    
	                <th data-sortable="true"  >
	                  Extract Date 
	                </th>
	                <th data-sortable="true"  >
	                  Start Time 
	                </th>    
	                <th data-sortable="true"  >
	                  End Time 
	                </th>
	                    	                       	
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${lruns}">
                 <tr>
                 	<td><c:out value="${row.job_id}"/></td>
                 	<td ><c:out value="${row.batch_id}" /></td>
					<td><c:out value="${row.extract_date}" /></td>
     				<td ><c:out value="${row.start_time}" /></td>
					<td><c:out value="${row.end_time}" /></td>
			
				</tr>
             </c:forEach>
                               
                </tbody>
        	</table>
 </div>       	
			<br><br>
<div class="row">
				<p class="card-description">Upcoming Feed Runs</p>

			<table id="dashboard1" 
			class="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			data-show-header="true"
			data-classes="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			 data-toggle="table"  
			data-striped="true"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name2" 
		   	data-page-size="5"
		   	data-page-list="[5, 10, 25, 50, 100, ALL] " > 
	             <thead>
	              <tr>
	              <th data-sortable="true" onclick="myFunction(this)"  >
	                  Job Id
	                </th>
	                <th data-sortable="true"  >
	                  Batch Id 
	                </th>    
	                <th data-sortable="true"  >
	                  Extract Date 
	                </th>
	                <th data-sortable="true"  >
	                  Start Time 
	                </th>    
	                    	                       	
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${uruns}">
                 <tr>
                 	<td><c:out value="${row.job_id}"/></td>
                 	<td ><c:out value="${row.batch_id}" /></td>
					<td><c:out value="${row.extract_date}" /></td>
     				<td ><c:out value="${row.start_time}" /></td>
					<td><c:out value="${row.end_time}" /></td>
			
				</tr>
             </c:forEach>
                               
                </tbody>
        	</table>
        	</div>
			<br><br>
<div class="row">
				<p class="card-description">Failures</p>
			
			<table id="dashboard1" 
			class="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			data-show-header="true"
			data-classes="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			 data-toggle="table"  
			data-striped="true"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name2" 
		   	data-page-size="5"
		   	data-page-list="[5, 10, 25, 50, 100, ALL] " > 
	             <thead>
	              <tr>
	              <th data-sortable="true" onclick="myFunction(this)"  >
	                  Feed Name
	                </th>
	                <th data-sortable="true"  >
	                  Extract Date 
	                </th>    
	                <th data-sortable="true"  >
	                  Feed Type 
	                </th>
	                <th data-sortable="true"  >
	                  Run Id 
	                </th>
	                <th data-sortable="true"  >
	                  Start Time 
	                </th>
	                    	                       	
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${fruns}">
                 <tr>
                 	<td ><c:out value="${row.feed_name}" /></td>
                 	<td><c:out value="${row.extract_date}" /></td>
                 	<td><c:out value="${row.feed_type}" /></td>
                 	<td><c:out value="${row.run_id}"/></td>
                 	<td><c:out value="${row.start_time}"/></td>
				</tr>
             </c:forEach>
                               
                </tbody>
        	</table>
        	</div>
        	
        	<br><br>
			<div class="row" id="fd" class="section">
				<p class="card-description">Feeds Registered</p>
			
			<table id="ft" 
			class="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			data-show-header="true"
			data-classes="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			 data-toggle="table"  
			data-striped="true"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name2" 
		   	data-page-size="5" 
		   	data-page-list="[5, 10, 25, 50, 100, ALL] " > 
	             <thead>
	              <tr>
	              <th data-sortable="true" onclick="myFunction(this)"  >
	                  Feed Name
	                </th>
	             <th data-sortable="true" onclick="myFunction(this)"  >
	                  Feed Type
	                </th>
	                    	                       	
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${feeds}">
                 <tr>
                 	<td><c:out value="${row.feed_name}"/></td>
                 	<td ><c:out value="${row.feed_type}" /></td>
			
				</tr>
             </c:forEach>
                               
                </tbody>
        	</table>
        	
 </div>       	
 <br><br>
			<div class="row" id="ud" class="section">
				<p class="card-description">Users Registered</p>
			<table id="ut" 
			class="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			data-show-header="true"
			data-classes="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			 data-toggle="table"  
			data-striped="true"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name2" 
		   	data-page-size="5"
		   	data-page-list="[5, 10, 25, 50, 100, ALL] " > 
	             <thead>
	              <tr>
	              <th data-sortable="true" onclick="myFunction(this)"  >
	                  User Sequence
	                </th>
	                <th data-sortable="true"  >
	                  User Id 
	                </th>    
	                <th data-sortable="true"  >
	                 User Name 
	                </th>
	                    	                       	
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${users}">
                 <tr>
                 	<td><c:out value="${row.user_seq}"/></td>
                 	<td ><c:out value="${row.user_id}" /></td>
					<td><c:out value="${row.user_name}" /></td>
				</tr>
             </c:forEach>
                               
                </tbody>
        	</table>
 </div>       	
        	
 	</div>
	</div>
	</div>
	</div>       	

	
	<jsp:include page="cdg_footer.jsp" />
	
	
        	
		<script src="../../assets/js/bootstrap.min.js"></script>
		<script
			src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>	