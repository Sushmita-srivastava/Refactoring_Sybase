<script>
	function dow(id) {
		var x = '<select name="'+id+'" id="'+id+'" class="form-control" multiple="multiple">';
		x += '<option value="*">Select Days of Week</option><option value="*">All Days</option><option value="SUN">Sunday</option><option value="MON">Monday</option><option value="TUE">Tuesday</option><option value="WED">Wednesday</option><option value="THU">Thursday</option><option value="FRI">Friday</option><option value="SAT">Saturday</option>';
		x += '</select>';
		return x;
	}
	function looper(id, start, end) {
		var x = '<select name="'+id+'" id="'+id+'" class="form-control" multiple="multiple"><option value="*">Select Value...</option>';
		for (var i = start; i <= end; i++) {
			x += '<option value="'+i+'">' + i + '</option>';
		}
		x += '</select>';
		return x;
	}
	function sch_load(val) {
		var x, num, dow = '<select name="dy" id="dy" class="form-control"><option value="">Select Day of Week</option><option value="SUN">Sunday</option><option value="MON">Monday</option><option value="TUE">Tuesday</option><option value="WED">Wednesday</option><option value="THU">Thursday</option><option value="FRI">Friday</option><option value="SAT">Saturday</option></select>';
		document.getElementById("custom").style.display = "none";
	
		for (var i = 1; i <= 31; i++) {
			num += '<option value="'+i+'">' + i + '</option>';
		}
		if (val == 'h') {
			var x = '<div class="form-group"><label>The job will be executed every hour at 00 minutes.</label></div>';
		} else if (val == 'd') {
			var x = '<div class="form-group"><label>The job will be executed daily at the selected time.</label></div><div class="form-group"><label>Select Time</label><input type="time" name="tm" id="tm" class="form-control"></div>';
		} else if (val == 'w') {
			var x = '<div class="form-group"><label>The job will be executed weekly on the selected day at the selected time.</label></div><div class="form-group row"><div class="col-sm-6"><label>Select Day of Week</label>'
					+ dow
					+ '</div><div class="col-md-6"><label>Select Time</label><input type="time" name="tm" id="tm" class="form-control"></div></div>';
		} else if (val == 'm') {
			var x = '<div class="form-group"><label>The job will be executed monthly on the selected day at the selected time.</label></div><div class="form-group row"><div class="col-sm-6"><label>Select Day of Month</label><select name="dyt" id="dyt" class="form-control"><option value="">Select Day of Month</option>'
					+ num
					+ '</select></div><div class="col-sm-6"><label>Select Time</label><input type="time" name="tm" id="tm" class="form-control"></div></div>';
		} else if (val == 'y') {
			var x = '<div class="form-group"><label>The job will be executed yearly on the selected date at the selected time.</label></div><div class="form-group row"><div class="col-sm-6"><label>Select Date</label><input type="date" name="dt" id="dt" class="form-control"></div><div class="col-sm-6"><label>Select Time</label><input type="time" name="tm" id="tm" class="form-control"></div></div>';
		} else if (val == 'c') {
			var x = '<div class="form-group"><label>Create custom execution frequencies for your job from the below list.</label></div>';
			document.getElementById("custom").style.display = "block";
		}
		document.getElementById('sch_load').innerHTML = x;
	}
	function cron_construct() {
		var cron;
		var x = document.getElementById("frequency").value;
		if (x == "h") {
			cron = "0 * * * *";
		} else if (x == "d") {
			var t = document.getElementById("tm").value;
			var y = t.split(":");
			cron = y[1] + " " + y[0] + " * * *";
		} else if (x == "w") {
			var d = document.getElementById("dy").value;
			var t = document.getElementById("tm").value;
			var y = t.split(":");
			cron = y[1] + " " + y[0] + " * * " + d;
		} else if (x == "m") {
			var d = document.getElementById("dyt").value;
			var t = document.getElementById("tm").value;
			var y = t.split(":");
			cron = y[1] + " " + y[0] + " " + d + " * *";
		} else if (x == "y") {
			var d = document.getElementById("dt").value;
			var t = document.getElementById("tm").value;
			var y = t.split(":");
			var z = d.split("-");
			cron = y[1] + " " + y[0] + " " + z[2] + " " + z[1] + " *";
		} else if (x == "c") {
			var min = $('#mins').val();
			var hr = $('#hr').val();
			var dyt = $('#dyt').val();
			var mon = $('#mon').val();
			var dy = $('#dy').val();
			if (min == "")
				min = "*";
			if (hr == "")
				hr = "*";
			if (dyt == "")
				dyt = "*";
			if (mon == "")
				mon = "*";
			if (dy == "")
				dy = "*";
			cron = min + " " + hr + " " + dyt + " " + mon + " " + dy;
		}
		return cron;
	}

	document.getElementById('sch_flag').value = 'R';
	
</script>
<input class="form-control" id="sch_flag" name="sch_flag" style="display: none;">
<div class="form-group">
	<label>Select Frequency</label> <select class="form-control"
		name="frequency" id="frequency" onchange="sch_load(this.value);">
		
		<option value="" selected disabled>Select Frequency</option>
		<!-- <option value="h">Hourly</option> -->
		<option value="d">Daily</option>
		<option value="w">Weekly</option>
		<option value="m">Monthly</option>
		<option value="y">Yearly</option>
		<option value="c">Custom</option>
	</select>
</div>
<div id="sch_load"></div>
<div id="custom" style="display: none;">
	<div class="form-group row">
		<div class="col-sm-2">
			<label>Select Minute</label>
			<div id="mindiv"></div>
		</div>
		<div class="col-sm-2">
			<label>Select Hour</label>
			<div id="hrdiv"></div>
		</div>
		<div class="col-sm-3">
			<label>Select Day of Week</label>
			<div id="dowdiv"></div>
		</div>
		<div class="col-sm-3">
			<label>Select Day of Month</label>
			<div id="domdiv"></div>
		</div>
		<div class="col-sm-2">
			<label>Select Month</label>
			<div id="mondiv"></div>
		</div>
	</div>
</div>
<script>
	document.getElementById("mindiv").innerHTML = looper("mins", 0, 59);
	document.getElementById("hrdiv").innerHTML = looper("hr", 0, 23);
	document.getElementById("domdiv").innerHTML = looper("dyt", 1, 31);
	document.getElementById("mondiv").innerHTML = looper("mon", 1, 12);
	document.getElementById("dowdiv").innerHTML = dow("dy");
</script>