<jsp:include page="../cdg_header.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
$(document).ready(function() {
	$("#feed_id").change(function() {
		document.getElementById('load_type').style.display = "inline-flex";
		document.getElementById('schdiv').innerHTML = "";
		document.getElementById('datadiv').innerHTML = "";
	});
	$("#feed_id1").change(function() {
		$("#loading").show();
		document.getElementById('load_type').style.display = "none";
		document.getElementById('but').style.display = "none";
		document.getElementById('schdiv').innerHTML = "";
		document.getElementById('datadiv').innerHTML = "";
		var src_sys_id = document.getElementById("feed_id1").value;
		var src_val = document.getElementById("src_val").value;
		$.post('${pageContext.request.contextPath}/extraction/DataDetailsEditSybase',
		{
			src_sys_id : src_sys_id,
			src_val : src_val
		},
		function(data) {
			$("#loading").hide();
			document.getElementById('bord').style.display = "block";
			$('#datadiv').html(data);
			enableForm(DataDetails);
		});
	});
	$("#success-alert").hide();
	$("#success-alert").fadeTo(10000, 10).slideUp(2000,
		function() {
		
	});
	$("#error-alert").hide();
		$("#error-alert").fadeTo(10000, 10).slideUp(2000,
		function() {
	});
});

function funccheck(val) {
	if (val == 'create') {
		//window.location.reload();
		window.location.href = "${pageContext.request.contextPath}/extraction/DataDetails";
	} else if (val == 'edit') {
		document.getElementById('feed_id').style.display = "none";
		document.getElementById('but').style.display = "none";
		document.getElementById('feed_id1').style.display = "block";
		document.getElementById('load_type').style.display = "none";
		document.getElementById('bord').style.display = "none";
		document.getElementById('schdiv').innerHTML = "";
		document.getElementById('datadiv').innerHTML = "";
	}
}
function loadcheck(val) {
	document.getElementById("schdiv").innerHTML="";
	document.getElementById("datadiv").innerHTML="";
	if (val == 'ind_load') {
		document.getElementById("schdiv").style.display="block";
		var selection = $("input[name='radio']:checked").val();
		var src_val = document.getElementById("src_val").value;
		if (selection == 'create') {
			$("#loading").show();
			var src_sys_id = document.getElementById("feed_id").value;
			$.post('${pageContext.request.contextPath}/extraction/DataDetailsSybase0',
			{
				src_sys_id : src_sys_id,
				src_val : src_val
			}, function(data) {
				$("#loading").hide();
				$('#schdiv').html(data);
				enableForm(DataDetails);
			});
		} else if (selection == 'edit') {
			$("#loading").show();
			var src_sys_id = document.getElementById("feed_id1").value;
			$.post('${pageContext.request.contextPath}/extraction/DataDetailsEditSybase',
			{
				src_sys_id : src_sys_id,
				src_val : src_val
			}, function(data) {
				$("#loading").hide();
				$('#datadiv').html(data);
				enableForm(DataDetails);
			});
		}
	} else if (val == 'bulk_load') {
		alert("in bulk load");
		document.getElementById("schdiv").style.display="none";
		
		var selection = $("input[name='radio']:checked").val();
		if(document.getElementById("feed_id1").style.display==="none")
		{
			var src_sys_id = document.getElementById("feed_id").value;
			alert("src_sys_id 111  "+src_sys_id);
		}
		else
		{
			
			var src_sys_id = document.getElementById("feed_id1").value;
			alert("src_sys_id 222 "+src_sys_id);
		}

		alert("in line 104");
		document.getElementById("bord").style.display="block";
		alert("in line 106")
	//document.getElementById("Schdiv").innerHTML="";
		alert("in line 108")
		document.getElementById("but").style.display="none";
		alert("in line 110");
		$.post('${pageContext.request.contextPath}/extraction/BulkLoadTest',
		{
			src_sys_id : src_sys_id,
			src_val : src_val,
			selection : selection
		}, function(data) {
			
			$('#datadiv').html(data)
		});
	}
}
function getsch(id, val) {
	$("#loading").show();
	var in1 = id.slice(-1);
	var in2 = id.slice(-2, -1);
	if (in2 === "e")
		;
	else {
		in1 = id.slice(-2);
	}
	var id = in1;
	var schema_name = val;
	var src_val = document.getElementById("src_val").value;
	if(document.getElementById("feed_id1").style.display==="none")
	{
		var src_sys_id = document.getElementById("feed_id").value;
	}
	else
	{
		var src_sys_id = document.getElementById("feed_id1").value;
	}
	$
			.post(
					'${pageContext.request.contextPath}/extraction/DataDetailsSybase1',
					{
						id : id,
						src_sys_id : src_sys_id,
						src_val : src_val,
						schema_name : schema_name
					}, function(data) {
						$("#loading").hide();
						$('#datdiv' + id).html(data);
						for (var j = 1; j <=id; j++) {
							var vl = document.getElementById('table_name' + j).value;
							var curr = document.getElementById('tables'+id);
							for (var k = 0; k < curr.options.length; k++) {
								if (curr.options[k].value === vl)
								
									curr.options[k].remove();
								
							}
						}
						enableForm(DataDetails);
					});
}
function getcols(id) {
	$("#loading").show();
	var in1 = id.slice(-1);
	var in2 = id.slice(-2, -1);
	if (in2 === "e")
		;
	else {
		in1 = id.slice(-2);
	}
	var id = in1;
	var table_name = document.getElementById("table_name"+id).value;
	var src_val = document.getElementById("src_val").value;
	var connection_id = document.getElementById("connection_id").value;
	var schema_name = document.getElementById("schema_name"+id).value;
	var fetch_type = document.getElementById("fetch_type"+id).value;
	var cols = document.getElementById("cole"+id).value;
	if(fetch_type == "full" && cols == "all")
	{
		$.post('${pageContext.request.contextPath}/extraction/DataDetailsSybase22',
		{
			id : id
		}, function(data) {
			$("#loading").hide();
			$("#fldd"+id).html(data);
			enableForm(DataDetails);
		});
	} else {
		$.post('${pageContext.request.contextPath}/extraction/DataDetailsSybase2',
		{
			id : id,
			src_val : src_val,
			table_name : table_name,
			connection_id : connection_id,
			schema_name : schema_name
		}, function(data) {
			$("#loading").hide();
			$("#fldd"+id).html(data);
			enableForm(DataDetails);
		});
		if (fetch_type == "incr") {
			document.getElementById("incc"+id).style.display = "block";
		} else if (fetch_type == "full") {
			document.getElementById("incc"+id).style.display = "none";
		} 
	}
}

function dup_div() {
	var i = document.getElementById('counter').value;
	i++;
	$(function() {
		$('<hr />').insertBefore('#schm_div'+i);
	});
	var clone = $("#schm_div1").clone().attr('id', 'schm_div' + i)
			.insertAfter("#schm_div1");
	/*clone.find("select").each(function() {
		$(this).attr({
			'id': function(_, id) { return id.slice(0,-1) + i },
		    'name': function(_, name) { return name.slice(0,-1) + i },
		    'value': ''               
		});
	}).end().appendTo("#datadiv");*/
	clone.find("div[id=countt1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return (isNaN(id.slice(-2, -1)) ? (id.slice(0, -1)+i) : (id.slice(0, -2)+i))
			},
			'value' : ''
		});
		$(this).html("<b>"+i+".</b>");
	}).end().appendTo("#datadiv");
	clone.find("input[id!=schema_name1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return (isNaN(id.slice(-2, -1)) ? (id.slice(0, -1)+i) : (id.slice(0, -2)+i))
			},
			'name' : function(_, name) {
				return (isNaN(name.slice(-2, -1)) ? (name.slice(0, -1)+i) : (name.slice(0, -2)+i))
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone.find("input[id=schema_name1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			},
			'name' : function(_, name) {
				return name.slice(0, -1) + i
			},
			'list' : function(_, list) {
				return list.slice(0, -1) + i
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone.find("datalist[id=schemas1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			}
		});
	}).end().appendTo("#datadiv");
	clone.find("button[id=del1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			}
		});
	}).end().appendTo("#datadiv");
	var clone1 = $("#datdiv1").clone().attr('id', 'datdiv' + i)
			.insertAfter("#datdiv1");
	clone1.find("input[id!=table_name1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return (isNaN(id.slice(-2, -1)) ? (id.slice(0, -1)+i) : (id.slice(0, -2)+i))
			},
			'name' : function(_, name) {
				return (isNaN(name.slice(-2, -1)) ? (name.slice(0, -1)+i) : (name.slice(0, -2)+i))
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone1.find("input[id=table_name1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			},
			'name' : function(_, name) {
				return name.slice(0, -1) + i
			},
			'list' : function(_, list) {
				return list.slice(0, -1) + i
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone1.find("datalist[id=tables1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			}
		});
	}).end().appendTo("#datadiv");
	clone1.find("textarea[id=where_clause1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			},
			'name' : function(_, name) {
				return name.slice(0, -1) + i
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone1.find("select[id=fetch_type1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			},
			'name' : function(_, name) {
				return name.slice(0, -1) + i
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone1.find("select[id=cole1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			},
			'name' : function(_, name) {
				return name.slice(0, -1) + i
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone1.find("select[id=incr_col1]").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				return id.slice(0, -1) + i
			},
			'name' : function(_, name) {
				return name.slice(0, -1) + i
			},
			'value' : ''
		});
	}).end().appendTo("#datadiv");
	clone1.find("div").each(function() {
		$(this).attr({
			'id' : function(_, id) {
				if (id)
					return (isNaN(id.slice(-2, -1)) ? (id.slice(0, -1)+i) : (id.slice(0, -2)+i))
			},
			'name' : function(_, name) {
				if (name)
					return (isNaN(name.slice(-2, -1)) ? (name.slice(0, -1)+i) : (name.slice(0, -2)+i))
			}
		});
	}).end().appendTo("#datadiv");
	//$('#schema_name' + i).find('option').remove().end().append(
	//		'<option value="">Schema ...</option>').val('');
	$('#table_name' + i).find('option').remove().end().append(
			'<option value="">Table ...</option>').val('');
	$('#col_name' + i).find('option').remove().end().append(
			'<option value="">Columns ...</option>').val('');
	$('#avl' + i).empty();
	$('#sel' + i).empty();
	$('#tok' + i).empty();
	document.getElementById('counter').value = i;
}
function allowDrop(ev) {
	ev.preventDefault();
}
function drag(ev) {
	ev.dataTransfer.setData("text", ev.target.id);
}
function drop(ev, el) {
	ev.preventDefault();
	var data = ev.dataTransfer.getData("text");
	el.appendChild(document.getElementById(data));
}

function delblock(id)
{
	var i=document.getElementById('counter').value;
	if(i==1)
		return false;
	id = (isNaN(id.slice(-2, -1)) ? (id.slice(-1)) : (id.slice(-2)));
	$('#schm_div'+id).remove();
	$('#datdiv'+id).remove();
	
	if(id===i);
	else
	{	//sort order by element inspection to be maintained
		$("#schm_div"+i).attr("id","schm_div"+id);
		$("#countt"+i).html("<b>"+id+".</b>");
		$("#countt"+i).attr("id","countt"+id);
		$("#schema_name"+i).attr("name","schema_name"+id);
		$("#schema_name"+i).attr("list","schemas"+id);
		$("#schema_name"+i).attr("id","schema_name"+id);
		$("#schemas"+i).attr("id","schemas"+id);
		$("#del"+i).attr("id","del"+id);
		$("#datdiv"+i).attr("id","datdiv"+id);
		$("#ind_load"+i).attr("id","ind_load"+id);
		$("#tbl_fld"+i).attr("id","tbl_fld"+id);
		$("#table_name"+i).attr("name","table_name"+id);
		$("#table_name"+i).attr("list","table_name"+id);
		$("#table_name"+i).attr("id","table_name"+id);
		$("#tables"+i).attr("id","tables"+id);
		$("#cole"+i).attr("name","cole"+id);
		$("#cole"+i).attr("id","cole"+id);
		$("#fetch_type"+i).attr("name","fetch_type"+id);
		$("#fetch_type"+i).attr("id","fetch_type"+id);
		$("#fldd"+i).attr("id","fldd"+id);
		$("#incc"+i).attr("id","incc"+id);
		$("#incr_col"+i).attr("name","incr_col"+id);
		$("#incr_col"+i).attr("id","incr_col"+id);
		$("#avl"+i).attr("id","avl"+id);
		$("#sel"+i).attr("id","sel"+id);
		$("#tok"+i).attr("id","tok"+id);
		$("#col_name"+i).attr("name","col_name"+id);
		$("#col_name"+i).attr("id","col_name"+id);
		$("#columns_name"+i).attr("name","columns_name"+id);
		$("#columns_name"+i).attr("id","columns_name"+id);
		$("#token"+i).attr("name","token"+id);
		$("#token"+i).attr("id","token"+id);
		$("#where_clause"+i).attr("name","where_clause"+id);
		$("#where_clause"+i).attr("id","where_clause"+id);
		$('#avl'+i).find("button").each(function(){
			$(this).attr('name',   (isNaN($(this).attr('name').slice(-2, -1)) ? ($(this).attr('name').slice(0, -1)+id) : ($(this).attr('name').slice(0, -2)+id)));
			$(this).attr('id',   (isNaN($(this).attr('id').slice(-2, -1)) ? ($(this).attr('id').slice(0, -1)+id) : ($(this).attr('id').slice(0, -2)+id)));
		    });
		$('#sel'+i).find("button").each(function(){
			$(this).attr('name',   (isNaN($(this).attr('name').slice(-2, -1)) ? ($(this).attr('name').slice(0, -1)+id) : ($(this).attr('name').slice(0, -2)+id)));
			$(this).attr('id',   (isNaN($(this).attr('id').slice(-2, -1)) ? ($(this).attr('id').slice(0, -1)+id) : ($(this).attr('id').slice(0, -2)+id)));
		    });
		$('#tok'+i).find("button").each(function(){
			$(this).attr('name',   (isNaN($(this).attr('name').slice(-2, -1)) ? ($(this).attr('name').slice(0, -1)+id) : ($(this).attr('name').slice(0, -2)+id)));
			$(this).attr('id',   (isNaN($(this).attr('id').slice(-2, -1)) ? ($(this).attr('id').slice(0, -1)+id) : ($(this).attr('id').slice(0, -2)+id)));
		    });
	}
	i--;
	document.getElementById('counter').value=i;
}

function jsonconstruct() {
	for (var y = 1; y <= document.getElementById("counter").value; y++) {
		var col="";
		var ch = document.querySelectorAll("#sel"+y+" button");
		for (var i = 0; i<ch.length; i++) {
			if(ch[i].value==='*') {
				col="*";
				break;
			}
			else {
			col=col+","+ch[i].value;
			}
		}
		if(col!="*") {
			col=col.substring(1);
		}
		document.getElementById("col_name"+y).value=col;
		document.getElementById("columns_name"+y).value=col;
		var tok="";
		var ch1 = document.querySelectorAll("#tok"+y+" button");
		for (var i = 0; i<ch1.length; i++) {
			if(ch1[i].value==='*') {
				tok="*";
				break;
			}
			else {
			tok=tok+","+ch1[i].value;
			}
		}
		if(tok!="*") {
			tok=tok.substring(1);
		}
		document.getElementById("token"+y).value=tok;
		if (document.getElementById("where_clause" + y).value === "") {
			document.getElementById("where_clause" + y).value = "1=1";
		}
		else
		{
			var str=document.getElementById("where_clause"+y).value;
			document.getElementById("where_clause"+y).value=str.replace(/'/g,"'");
		}
	}
	
	var errors = [];
	var selection = $("input[name='radio']:checked").val();
	if (selection == 'create') {
		var feed_id = document.getElementById("feed_id").value;
		var upload_type = $("input[name='bulk']:checked").val();
		if (!checkLength(feed_id)) {
			errors[errors.length] = "Feed Name";
		}
		if (!checkLength(upload_type)) {
			errors[errors.length] = "Upload Type";
		}
		if (upload_type == "ind_load") {
			var ct = document.getElementById("counter").value;
			for (var i = 1; i <= ct; i++) {
				var schema = document.getElementById("schema_name" + i).value;
				if (!checkLength(schema)) {
					errors[errors.length] = "Schema Name " + i;
				} else {
					var tbl = document.getElementById("table_name" + i).value;
					if (!checkLength(tbl)) {
						errors[errors.length] = "Table Name " + i;
					} else {
						var col = document.getElementById("col_name" + i).value;
						if (!checkLength(col)) {
							errors[errors.length] = "Column Names " + i;
						}
					}
				}
			}
		}
		if (upload_type == "bulk_load") {
			if (document.getElementById("file").files.length == 0) {
				errors[errors.length] = "Upload File Details";
			}
		}
	} else {
		var feed_id = document.getElementById("feed_id1").value;
		if (!checkLength(feed_id)) {
			errors[errors.length] = "Feed Name";
		}
		var ct = document.getElementById("counter").value;
		for (var i = 1; i <= ct; i++) {
			var schema = document.getElementById("schema_name" + i).value;
			if (!checkLength(schema)) {
				errors[errors.length] = "Schema Name " + i;
			} else {
				var tbl = document.getElementById("table_name" + i).value;
				if (!checkLength(tbl)) {
					errors[errors.length] = "Table Name " + i;
				} else {
					var col = document.getElementById("col_name" + i).value;
					if (!checkLength(col)) {
						errors[errors.length] = "Column Names " + i;
					}
				}
			}
		}
	}
	if (errors.length > 0) {
		reportErrors(errors);
		return false;
	}
	
	$("#loading").show();

	var data = {};
	$(".form-control").serializeArray().map(function(x) {
		data[x.name] = x.value;
	});
	var x = '{"header":{},"body":{"data":' + JSON.stringify(data) + '}}';
	document.getElementById('x').value = x;
	//alert(x);
	//console.log(x);
	document.getElementById('DataDetails').submit();
}
</script>

<div class="main-panel">
	<div class="content-wrapper">
		<div class="row">
			<div class="col-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">Data Extraction</h4>
						<p class="card-description">Data Details</p>
						<%
							if (request.getAttribute("successString") != null) {
						%>
						<div class="alert alert-success" id="success-alert">
							<button type="button" class="close" data-dismiss="alert">x</button>
							${successString}
						</div>
						<%
							}
						%>
						<%
							if (request.getAttribute("errorString") != null) {
						%>
						<div class="alert alert-danger" id="error-alert">
							<button type="button" class="close" data-dismiss="alert">x</button>
							${errorString}
						</div>
						<%
							}
						%>
						<form class="forms-sample" id="DataDetails" name="DataDetails"
							method="POST"
							action="${pageContext.request.contextPath}/extraction/DataDetailsSybase3"
							enctype="application/json">
							<input type="hidden" name="x" id="x" value=""> <input
								type="hidden" name="src_val" id="src_val" value="${src_val}">
							<input type="hidden" name="project" id="project"
								class="form-control" value="${project}"> <input
								type="hidden" name="user" id="user" class="form-control"
								value="${usernm}">
								<input type="hidden" name="counter" id="counter" class="form-control" value="1">

							<div class="form-group row">
								<label class="col-sm-3 col-form-label">Data Tables</label>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-check-input" name="radio" id="radio1"
											checked="checked" value="create"
											onclick="funccheck(this.value)"> Create
										</label>
									</div>
								</div>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-check-input" name="radio" id="radio2"
											value="edit" onclick="funccheck(this.value)">
											Edit/View
										</label>
									</div>
								</div>
							</div>

							<div class="form-group">
								<label>Source Feed Name *</label> <select name="feed_id"
									id="feed_id" class="form-control">
									<option value="" selected disabled>Source Feed Name
										...</option>
									<c:forEach items="${src_sys_val1}" var="src_sys_val1">
										<option value="${src_sys_val1.src_sys_id}">${src_sys_val1.src_unique_name}</option>
									</c:forEach>
								</select> <select name="feed_id1" id="feed_id1" class="form-control" 
									style="display: none;"onchange="disableForm(DataDetails);">
									<option value="" selected disabled>Source Feed Name
										...</option>
									<c:forEach items="${src_sys_val2}" var="src_sys_val2">
										<option value="${src_sys_val2.src_sys_id}">${src_sys_val2.src_unique_name}</option>
									</c:forEach>
								</select>
							</div>
							<div class="form-group row" id="load_type"
								style="display: none; width: 100%;">
								<label class="col-sm-3 col-form-label">Upload Type</label>
								<div class="col-sm-4">
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-check-input" name="bulk" id="bulk1"
											value="ind_load" onclick="disableForm(DataDetails);loadcheck(this.value)">
											Individual Load Type
										</label>
									</div>
								</div>
								<div class="col-sm-4">
								
									<div class="form-check form-check-info">
										<label class="form-check-label"> <input type="radio"
											class="form-check-input" name="bulk" id="bulk2"
											value="bulk_load" onclick="loadcheck(this.value)">
											Bulk Load Type
										</label>
									</div>
								</div>
							</div>
							<fieldset id="bord" class="fs" style="display:none;">
							<div id="schdiv"></div>
							<div id="datadiv"></div>
							</fieldset>
	<div id="but" style="display:none;">
	<div class="form-group" style="float: right; margin: 5px;">
		<button id="add" type="button"
			class="btn btn-rounded btn-gradient-info mr-2" onclick="return dup_div();">+</button>
	</div>
	<button onclick="return jsonconstruct();"
		class="btn btn-rounded btn-gradient-info mr-2">Save</button>
	</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../cdg_footer.jsp" />