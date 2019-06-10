//switch functionality -start
	function switchfun(){
		 var checkBox = document.getElementById("myCheck");
		    var text = document.getElementById("text");
		    if (checkBox.checked == true){
		    	//alert('hello');
		      //  text.style.display = "block";
		    } else {
		    	//alert('friends');
		       //text.style.display = "none";
		    }
	}
	//switch functionality -end

		//home button function-start
		function homebutton(){
			//alert("test");
			window.location.href="${pageContext.request.contextPath}/";
		}
		//home button function-end



$(document).ready(function() {
	
	
//-------------------Starting HIP Dashboard (1)--------------------------------
	//fetch the job filer values using feedid-Start
						$("#feedIdFilter")
								.change(
										function() {
											var feed_id = $(this).val();
											alert("onchange-dropdown"+feed_id);
											var s = document.getElementById('feedid_s');
								            s.value = feed_id;
								            var date = document.getElementById('datepicker').value;
								            if(feed_id!='' && date==''){
										//	document.getElementById('feedid_s').style.value = "";
												alert(feed_id);
											$.post('/hip/feedIdFilter',
															{
																feed_id : feed_id
															},
															function(data) {
																alert("indata"+data);
																//console.log(data);
																
															});
											
								            }else{
								            	alert("in else");
								            	$.post('${pageContext.request.contextPath}/hip/datefilter',
														{
															feedIdFilter : feed_id,
															date:date
														},
														function(data) {
															
															$('#adddetails')
															.html(
																	data);
											        	  
											        	  var x = document
															.getElementById("x").value;
													var y = document
															.getElementById("y").value;
													var newx = x
															.split(',');
													var newy = y
															.split(',');
													//var a=[180801,180802,180805];
													//var b=[26.0000,13.0000,18];
													newx[0] = newx[0]
															.replace(
																	"[",
																	"");
													newy[0] = newy[0]
															.replace(
																	"[",
																	"")
													newx[newx.length - 1] = newx[newx.length - 1]
															.replace(
																	"]",
																	"");
													newy[newy.length - 1] = newy[newy.length - 1]
															.replace(
																	"]",
																	"");
													
													var areaData = {

															labels : newx,
															datasets : [ {
																label : 'Duration of Feed in Minutes',
																data : newy,
																backgroundColor : [
																		//'rgba(255, 159, 64,  0.2)',
																		'rgba(54, 162, 235, 0.2)',
																		'rgba(255, 206, 86, 0.2)',
																		'rgba(75, 192, 192, 0.2)',
																		'rgba(153, 102, 255, 0.2)',
																		'rgba(255, 159, 64, 0.2)',
																		'rgba(255, 99, 132, 0.2)'],
																borderColor : [
																		//'rgba(255, 159, 64, 1)',
																		//'rgba(255,99,132,1)',
																		'rgba(54, 162, 235, 1)',
																		'rgba(255, 206, 86, 1)',
																		'rgba(75, 192, 192, 1)',
																		'rgba(153, 102, 255, 1)',
																		'rgba(255, 159, 64, 1)' ],
																borderWidth : 1,
																fill : true, // 3: no fill
															} ]
														};

														var areaOptions = {
															plugins : {
																filler : {
																	propagate : true
																}
															}
														}

														if ($("#areaChart").length) {
															var areaChartCanvas = $(
																	"#areaChart")
																	.get(
																			0)
																	.getContext(
																			"2d");
															var areaChart = new Chart(
																	areaChartCanvas,
																	{
																		type : 'line',
																		data : areaData,
																		options : areaOptions
																	});
														}


															
														});
										    	
										    	
										    
												
											
								            	
								            }

										});

						//fetch the job filer values using feedid-End

						//search button-start

						$("#feedid_s")
								.keyup(
										function() {
											var feed_id = $(this).val();
												alert("keyup"+feed_id);
											var s = document.getElementById('feedIdFilter');
								            s.value = feed_id;
								            var date = document.getElementById('datepicker').value;
											
											//feed id available check-start
											if (feed_id != '' && date =='') {
												
												alert(feed_id);
												$.ajax({ 
													
													type: "POST",
											          url: "${pageContext.request.contextPath}/hip/filterSearch",
											          data: {feed_id: feed_id},
											          cache: false,
											          success: function(data) {
											        	  
											        	 // alert(data);
											        	  $('#adddetails')
															.html(
																	data);
											        	  
											        	  var x = document
															.getElementById("x").value;
													var y = document
															.getElementById("y").value;
													var newx = x
															.split(',');
													var newy = y
															.split(',');
													//var a=[180801,180802,180805];
													//var b=[26.0000,13.0000,18];
													newx[0] = newx[0]
															.replace(
																	"[",
																	"");
													newy[0] = newy[0]
															.replace(
																	"[",
																	"")
													newx[newx.length - 1] = newx[newx.length - 1]
															.replace(
																	"]",
																	"");
													newy[newy.length - 1] = newy[newy.length - 1]
															.replace(
																	"]",
																	"");

													var areaData = {

														labels : newx,
														datasets : [ {
															label : 'Duration of Feed in Minutes',
															data : newy,
															backgroundColor : [
																	//'rgba(255, 99, 132, 0.2)',
																	'rgba(54, 162, 235, 0.2)',
																	'rgba(255, 206, 86, 0.2)',
																	'rgba(75, 192, 192, 0.2)',
																	'rgba(153, 102, 255, 0.2)',
																	'rgba(255, 159, 64, 0.2)',
																	'rgba(255, 99, 132, 0.2)'],
															borderColor : [
																	//'rgba(255, 159, 64, 1)',
																	//'rgba(255,99,132,1)',
																	'rgba(54, 162, 235, 1)',
																	'rgba(255, 206, 86, 1)',
																	'rgba(75, 192, 192, 1)',
																	'rgba(153, 102, 255, 1)',
																	'rgba(255, 159, 64, 1)' ],
															borderWidth : 1,
															fill : true, // 3: no fill
														} ]
													};

													var areaOptions = {
														plugins : {
															filler : {
																propagate : true
															}
														}
													}

													if ($("#areaChart").length) {
														var areaChartCanvas = $(
																"#areaChart")
																.get(
																		0)
																.getContext(
																		"2d");
														var areaChart = new Chart(
																areaChartCanvas,
																{
																	type : 'line',
																	data : areaData,
																	options : areaOptions
																});
													}

											        	  
											        	  
											        	  
											          }
													
													
												});
												
												
												
											}else{

										    	
										    	
										    	$.post(
														'${pageContext.request.contextPath}/hip/datefilter',
														{
															feedIdFilter : feed_id,
															date:date
														},
														function(data) {
															
															$('#adddetails')
															.html(
																	data);
											        	  
											        	  var x = document
															.getElementById("x").value;
													var y = document
															.getElementById("y").value;
													var newx = x
															.split(',');
													var newy = y
															.split(',');
													//var a=[180801,180802,180805];
													//var b=[26.0000,13.0000,18];
													newx[0] = newx[0]
															.replace(
																	"[",
																	"");
													newy[0] = newy[0]
															.replace(
																	"[",
																	"")
													newx[newx.length - 1] = newx[newx.length - 1]
															.replace(
																	"]",
																	"");
													newy[newy.length - 1] = newy[newy.length - 1]
															.replace(
																	"]",
																	"");
													
													var areaData = {

															labels : newx,
															datasets : [ {
																label : 'Duration of Feed in Minutes',
																data : newy,
																backgroundColor : [
																		//'rgba(255, 99, 132, 0.2)',
																		'rgba(54, 162, 235, 0.2)',
																		'rgba(255, 206, 86, 0.2)',
																		'rgba(75, 192, 192, 0.2)',
																		'rgba(153, 102, 255, 0.2)',
																		'rgba(255, 159, 64, 0.2)',
																		'rgba(255, 99, 132, 0.2)'],
																borderColor : [
																		//'rgba(255, 159, 64, 1)',
																		//'rgba(255,99,132,1)',
																		'rgba(54, 162, 235, 1)',
																		'rgba(255, 206, 86, 1)',
																		'rgba(75, 192, 192, 1)',
																		'rgba(153, 102, 255, 1)',
																		'rgba(255, 159, 64, 1)' ],
																borderWidth : 1,
																fill : true, // 3: no fill
															} ]
														};

														var areaOptions = {
															plugins : {
																filler : {
																	propagate : true
																}
															}
														}

														if ($("#areaChart").length) {
															var areaChartCanvas = $(
																	"#areaChart")
																	.get(
																			0)
																	.getContext(
																			"2d");
															var areaChart = new Chart(
																	areaChartCanvas,
																	{
																		type : 'line',
																		data : areaData,
																		options : areaOptions
																	});
														}


															
														});
										    	
										    	
										    
												
											}
											
										
										});

						//search button-end
						
						
						$('#clear').click(function() {
						    location.reload();
						});
						
						
					/*	//datepiker
					//	$("#datepicker").datepicker();
					    $("#datepicker").datepicker({ 
					        dateFormat: "dd-mm-yyyy", 
					        onSelect: function(){
					        var selected = $(this).val();
					        alert(selected);
					        }
					    });
*/
						
					   // $( "#datepicker" ).datepicker({ dateFormat: "dd-mm-yyyy" });

						$("#datepicker").on("change",function(){
						    var date = $(this).val();
						   
						    
						    var feedIdFilter = document.getElementById('feedIdFilter').value;
						    
						   // alert("feedIdFilter"+feedIdFilter+"date"+date);
						    
						    if (feedIdFilter != '' && date!='') {
						    	
						    	
						    	$.post(
										'${pageContext.request.contextPath}/hip/datefilter',
										{
											feedIdFilter : feedIdFilter,
											date:date
										},
										function(data) {
											
											$('#adddetails')
											.html(
													data);
							        	  
							        	  var x = document
											.getElementById("x").value;
									var y = document
											.getElementById("y").value;
									var newx = x
											.split(',');
									var newy = y
											.split(',');
									//var a=[180801,180802,180805];
									//var b=[26.0000,13.0000,18];
									newx[0] = newx[0]
											.replace(
													"[",
													"");
									newy[0] = newy[0]
											.replace(
													"[",
													"")
									newx[newx.length - 1] = newx[newx.length - 1]
											.replace(
													"]",
													"");
									newy[newy.length - 1] = newy[newy.length - 1]
											.replace(
													"]",
													"");
									
									var areaData = {

											labels : newx,
											datasets : [ {
												label : 'Duration of Feed in Minutes',
												data : newy,
												backgroundColor : [
														//'rgba(255, 99, 132, 0.2)',
														'rgba(54, 162, 235, 0.2)',
														'rgba(255, 206, 86, 0.2)',
														'rgba(75, 192, 192, 0.2)',
														'rgba(153, 102, 255, 0.2)',
														'rgba(255, 159, 64, 0.2)',
														'rgba(255, 99, 132, 0.2)',],
												borderColor : [
														//'rgba(255, 159, 64, 1)',
														//'rgba(255,99,132,1)',
														'rgba(54, 162, 235, 1)',
														'rgba(255, 206, 86, 1)',
														'rgba(75, 192, 192, 1)',
														'rgba(153, 102, 255, 1)',
														'rgba(255, 159, 64, 1)' ],
												borderWidth : 1,
												fill : true, // 3: no fill
											} ]
										};

										var areaOptions = {
											plugins : {
												filler : {
													propagate : true
												}
											}
										}

										if ($("#areaChart").length) {
											var areaChartCanvas = $(
													"#areaChart")
													.get(
															0)
													.getContext(
															"2d");
											var areaChart = new Chart(
													areaChartCanvas,
													{
														type : 'line',
														data : areaData,
														options : areaOptions
													});
										}


											
										});
						    	
						    	
						    }
						    
						});
//-------------------Ending HIP Dashboard (1)--------------------------------

//------------------ Starting HIP Dashboard(2) -------------------------------				

	//HIP2 Feed Id Dropdown:Start 
	/*$("#hip2FeedidDropdown").change(function() {
		var feed_id = $(this).val();
		var feed_id_search = document.getElementById('hip2FeedidSearch');
		feed_id_search.value = feed_id;
        //var date = document.getElementById('datepicker').value;
		  if (feed_id != '') {
			  $.post('/hip2/getFeedTables',
						{
				  			feed_id : feed_id,	
						},
						function(data) {
							$('#hip2FeedtableDropdown').html(data);
						}
						
			  );
			  
		  }
	});*/
	//HIP2 Feed Id Dropdown:End
	
	//HIP2 Feed Id Search:Start 
	/*$("#hip2FeedidDropSearch").change(function() {
		var feed_id = $(this).val();
		var feed_id_dropdown = document.getElementById('hip2FeedidDropdown');
		feed_id_dropdown.value = feed_id;
        //var date = document.getElementById('datepicker').value;
		  if (feed_id != '') {
			  $.post('${pageContext.request.contextPath}/hip2/getFeedTables',
						{
				  			feed_id : feed_id,	
						},
						function(data) {
							$('#hip2FeedtableDropdown').html(data);
						}
						
			  );
			  
		  }
	});*/
	//HIP2 Feed Id Search:End




						
//------------------ Ending HIP Dashboard(2) ----------------------------------	
});




function feedpage(){
	document.getElementById('feedpage').style.display = "block";
	document.getElementById('tablepage').style.display = "none";
}

function tablepage(){
	document.getElementById('feedpage').style.display = "none";
	document.getElementById('tablepage').style.display = "block";
}

