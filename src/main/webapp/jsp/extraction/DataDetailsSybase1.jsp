<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<input type="hidden" name="connection_id" id="connection_id"
	class="form-control" value="${conn_val.connection_id}">

<div id="ind_load${id}">
	<div id="tbl_fld${id}">
		<div class="form-group row">
			<div class="col-sm-4">
				<label>Select Table *</label> 
				
				<input list="tables${id}" name="table_name${id}" id="table_name${id}" class="form-control" onchange="disableForm(DataDetails);getcols(this.id)">
			  	<datalist id="tables${id}">
			    	<c:forEach items="${tables}" var="tables">
						<option value="${schema_name}.${tables}">
					</c:forEach>
			  	</datalist>
				
				<!-- <select class="form-control"
					id="table_name${id}" name="table_name${id}"
					onchange="getcols(this.id,this.value)">
					<option value="" selected disabled>Table...</option>
					<c:forEach items="${tables}" var="tables">
						<option value="${schema_name}.${tables}">${tables}</option>
					</c:forEach>
				</select>-->
			</div>
			<div class="col-sm-4">
				<label>Select Columns *</label> <select class="form-control"
					id="cole${id}" name="cole${id}" onchange="disableForm(DataDetails);getcols(this.id)">
							<option value="all" selected>Select All</option>
							<option value="custom">Custom</option>
				</select>
			</div>
			<div class="col-sm-4">
				<label>Load Type *</label> <select class="form-control"
					id="fetch_type${id}" name="fetch_type${id}"
					onchange="disableForm(DataDetails);getcols(this.id)">
					<c:choose>
						<c:when test="${ext_type=='Real'}">
							<option value="full" selected>Full Load</option>
						</c:when>
						<c:otherwise>
							<option value="full" selected>Full Load</option>
							<option value="incr">Incremental Load</option>
						</c:otherwise>
					</c:choose>
				</select>
			</div>
		</div>
		<div id="fldd${id}"></div>
	</div>
</div>