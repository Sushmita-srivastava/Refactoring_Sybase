
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/multi.min.css">
<link href="${pageContext.request.contextPath}/assets/css/pagination.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/bootstrap-table.min.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-table.min.js"></script>

<script>
function myFunction(x) {
    alert("Row index is: " + x.rowIndex);
}

function showtbls()
{

	}

</script>

			<br><br>
			<div class="form-group row ">

				<p class="card-description">Last Feed Runs</p>
			</div>
			<table id="dashboard1" 
			class="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			data-show-header="true"
			data-classes="table table-hover table-striped table-bordered shadow p-3 mb-5 bg-white rounded "
			 data-toggle="table"  
			data-striped="true"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name2" 
		   	data-page-size="10"
		   	data-page-list="[10, 20, 30, 40, 100, ALL] " > 
	             <thead>
	              <tr>
	              <th data-sortable="true" onclick="myFunction(this)"  >
	                  Extract Date
	                </th>
	                <th data-sortable="true"  >
	                  Run Id 
	                </th>    
	                <th data-sortable="true"  >
	                  Source Type 
	                </th>
	                <th data-sortable="true"  >
	                  Start Date
	                </th>         
	                <th data-sortable="true" >
	                  End Date
	                </th>
	                <th data-sortable="true" >
	                  Status
	                </th>         	                       	
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${runfeeds}">
                 <tr>
                 	<td><c:out value="${row.extract_date}"/></td>
                 	<td ><c:out value="${row.run_id}" /></td>
					<td><c:out value="${row.extraction_type}" /></td>
                 	<td><c:out value="${row.start_time}" /></td>
					<td><c:out value="${row.end_time}" /></td>
					<td><c:out value="${row.status}" /></td>
			
				</tr>
             </c:forEach>
                               
                </tbody>
        	</table>
        	

        	
		<script src="../../assets/js/bootstrap.min.js"></script>
		<script
			src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>
		 
