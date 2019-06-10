<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<link href="${pageContext.request.contextPath}/assets/css/bootstrap-table.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/pagination.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-table.min.js"></script>
<input type="hidden" name="tbl_eimvalidation" id="tbl_eimvalidation" value="${stat}">
<input type="hidden" id="tbl_x" value='${tbl_x}' name="tbl_x"/>
<input type="hidden" id="tbl_y" value='${tbl_y}' name="tbl_y"/>
<input type="hidden" id="tbl_z" value='${tbl_z}' name="tbl_z"/>

<p>Duplicate records will be removed after metadata validation</p>
<div class="row">
			<div class="col-md-12" >
			<table id="tbl_dashboard" 
			class="table table-hover table-sm table-striped table-bordered shadow p-3 mb-5 bg-white rounded table-condensed"
			data-show-header="true"
			data-classes="table table-hover table-striped table-sm table-bordered shadow p-3 mb-5 bg-white rounded table-condensed" 
			data-toggle="table"  
			data-striped="true"
		    data-sort-name="Feed Id"
		    data-sort-order="desc"
		   	data-pagination="true"  
		   	data-id-field="name" 
		   	data-page-size="5"
		   	data-page-list="[5, 10, 25, 50, 100, ALL]" >
	            <thead>
	              <tr>
	              	<th data-sortable="true" onclick="myFunction(this)">
	                  Table Name
	                </th>
	                <th data-sortable="true">
	                 Fetch type
	                </th>
	              	<th data-sortable="true">
	                 Validation Flag
	                </th>
	                <th data-sortable="true">
	                Error Message
	                </th>
	              </tr>
	            </thead>
                <tbody>
               <c:forEach var="row" items="${arrddb}">
                 <tr>
                 	<td><c:out value="${row.table_name}" /></td>
					<td><c:out value="${row.fetch_type}" /></td>
					<td><c:out value="${row.validation_flag}" /></td>
					<td><c:out value="${row.error_message}" /></td>
				</tr>
             </c:forEach>
                  
                </tbody>
        	</table>
        	</div>
</div>

	

<script>
function myFunction(x) {
    alert("Row index is: " + x.rowIndex);
}

</script>
