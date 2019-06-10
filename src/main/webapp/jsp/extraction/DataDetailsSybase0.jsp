<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
document.getElementById('bord').style.display = "block";
</script>

<div class="form-group row" id="schm_div1">
<div id="countt1" class="col-sm-1">
		<b>1.</b>
	</div>
	<div class="col-sm-9">
		<label>Schema Name *</label> <input list="schemas1"
			name="schema_name1" id="schema_name1" class="form-control"
			onchange="disableForm(DataDetails);getsch(this.id,this.value)">
		<datalist id="schemas1">
			<c:forEach items="${schema_name}" var="schema_name">
				<option value="${schema_name}">
			</c:forEach>
		</datalist>
	</div>
	<div class="col-sm-2">
		<button id="del1" type="button"
			class="btn btn-rounded btn-gradient-danger mr-2"
			onclick="delblock(this.id)">X</button>
	</div>
	<!-- <select name="schema_name1"
		id="schema_name1" class="form-control" onchange="getsch(this.id,this.value)">
		<option value="" selected disabled>Schema Name ...</option>
		<c:forEach items="${schema_name}" var="schema_name">
			<option value="${schema_name}">${schema_name}</option>
		</c:forEach>
	</select>-->
</div>
<div id="datdiv1"></div>