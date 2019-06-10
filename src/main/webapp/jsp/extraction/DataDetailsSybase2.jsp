<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="form-group" id="incc${id}" style="display: none;">
	<label>Select Incremental Column *</label> <select class="form-control"
		id="incr_col${id}" name="incr_col${id}">
		<option value="" selected disabled>Incremental Column...</option>
		<c:forEach var="fields" items="${fields}">
			<option value="${fields}">${fields}</option>
		</c:forEach>
	</select>
</div>

<div>
	<div
		style="float: left; width: 50%; height: 25px; font-weight: bold; text-align: center;">Available
		Fields</div>
	<div
		style="float: left; width: 50%; height: 25px; font-weight: bold; text-align: center;">Selected
		Fields</div>
	<div
		style="float: left; width: 0%; height: 25px; font-weight: bold; text-align: center;display:none;">Tokenized
		Fields</div>
</div>
<div>
	<div
		style="float: left; width: 50%; height: 300px; overflow-y: scroll;"
		id="avl${id}" ondrop="drop(event,this)" ondragover="allowDrop(event)">
		<c:choose>
			<c:when test="${fields==''}">
				
			</c:when>
			<c:otherwise>
			<button id="but${id}" name="but${id}" value="*" class="btn btn-dark"
				draggable="true" ondragstart="drag(event)"
				style="width: 90%; margin: 5px; padding: 10px 0px;"
				onclick="return false;">Select All</button>
			<c:forEach var="fields" items="${fields}">
				<button id="${fields}${id}" name="${fields}${id}" value="${fields}"
					class="btn btn-dark" draggable="true" ondragstart="drag(event)"
					style="width: 90%; margin: 5px; padding: 10px 0px;"
					onclick="return false;">${fields}</button>
			</c:forEach>	
			</c:otherwise>
		</c:choose>
	</div>
	<div
		style="float: left; width: 50%; height: 300px; overflow-y: scroll;"
		id="sel${id}" ondrop="drop(event,this)" ondragover="allowDrop(event)">
		<c:if test="${fields==''}">
			<button id="but${id}" name="but${id}" value="*" class="btn btn-dark"
			draggable="true" ondragstart="drag(event)"
			style="width: 90%; margin: 5px; padding: 10px 0px;"
			onclick="return false;">Select All</button>
		</c:if>
		</div>
	<div
		style="float: left; width: 0%; height: 300px; overflow-y: scroll;display:none"
		id="tok${id}" ondrop="drop(event,this)" ondragover="allowDrop(event)"></div>
</div>

<input type="hidden" name="col_name${id}" id="col_name${id}"
	class="form-control">
<input type="hidden" name="columns_name${id}" id="columns_name${id}"
	class="form-control">
<input type="hidden" name="token${id}" id="token${id}"
	class="form-control">
<div class="form-group">
	<label>Where Condition *</label>
	<textarea class="form-control" id="where_clause${id}"
		name="where_clause${id}" style="width: 100%;"
		placeholder="column1='filter1' and (column2>'filter2' or column3<'filter3')"></textarea>
</div>

<script>
	/*var cnt = document.getElementById('counter').value;
	var	select = document.getElementById('col_name' + cnt);
	multi(select, {});*/
	document.getElementById('but').style.display = "block";
</script>