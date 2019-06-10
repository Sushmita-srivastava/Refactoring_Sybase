<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ page import="javax.servlet.http.*"%>

<!DOCTYPE html>
<html lang="en">

<head>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Juniper Home</title>
  <!-- plugins:css -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/iconfonts/mdi/css/materialdesignicons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/vendor.bundle.base.css">
  <!-- endinject -->
  <!-- inject:css -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style2.css">
  <!-- endinject -->
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico" />
  <!-- Include multi.js -->
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/multi.min.css">
  <script src="${pageContext.request.contextPath}/assets/js/multi.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>
  <script type="text/javascript">
  function tog(ids)
  {
	  if(ids=="max")
	{
	  document.getElementById("min").style.display="block";
	  document.getElementById("max").style.display="none";
	}
	  if(ids=="min")
	{
		document.getElementById("max").style.display="block";
		document.getElementById("min").style.display="none";
	}
  }
  function multisel(src_id,tgt_id)
  {
		var el = document.getElementById(src_id);
		var result = "";
		var options = el.options;
		var opt;
		for (var i = 0, iLen = options.length; i < iLen; i++) {
			opt = options[i];
			if (opt.selected) {
				if(opt.value==="*")
				{
					result="";
					for (var j = 0, jLen = options.length; j < jLen; j++) {
						opt1 = options[j];
						if(opt1.value!="*")
						{
							result=result+","+opt1.value;
						}
					}
					break;
				}
				else
				{
					result=result+","+opt.value;
				}
			}
		}
		result=result.substring(1);
		document.getElementById(tgt_id).value=result;
  }
  
  function multisel1(src_id,tgt_id)
  {
		var el = document.getElementById(src_id);
		var result = "";
		var options = el.options;
		var opt;
		for (var i = 0, iLen = options.length; i < iLen; i++) {
			opt = options[i];
			if (opt.selected) {
				if(opt.value==="*")
				{
					result="*";
					break;
				}
				else
				{
					result=result+","+opt.value;
				}
			}
		}
		if(result!="*") {
			result=result.substring(1);
		}
		document.getElementById(tgt_id).value=result;
  } 
  
  function disableForm(theform) {
      if (document.all || document.getElementById) {
          for (i = 0; i < theform.length; i++) {
          var formElement = theform.elements[i];
              if (true) {
                  formElement.disabled = true;
              }
          }
      }
  }

function enableForm(theform) {
      if (document.all || document.getElementById) {
          for (i = 0; i < theform.length; i++) {
          var formElement = theform.elements[i];
              if (true) {
                  formElement.disabled = false;
              }
          }
      }
  }
  </script>
   <style>
.cust {
  width:95%;
  margin:5px;
  padding:0.875rem 0.5rem;
}
  
.row1 {
  display: flex;
  flex-wrap: wrap;
  padding: 0 4px;
}

/* Create four equal columns that sits next to each other */
.column1,.column2 {
  flex: 16.66%;
  max-width: 16.66%;
  padding: 0 5px;
}

.column1 img {
  margin-top: 8px;
  vertical-align: middle;
  width: 150px;
  height: 175px;
  border: 1px solid black;
}
.column2 img {
  margin-top: 8px;
  vertical-align: middle;
  width: 150px;
  border: 1px solid black;
}
/* Responsive layout - makes a two column-layout instead of four columns */
@media screen and (max-width: 800px) {
  .column1,.column2 {
    flex: 50%;
    max-width: 50%;
  }
}
/* Responsive layout - makes the two columns stack on top of each other instead of next to each other */
@media screen and (max-width: 600px) {
  .column1,.column2{
    flex: 100%;
    max-width: 100%;
  }
}
#bgDiv {
  position:fixed;
  top:0px;
  bottom:0px;
  left:260px;
  right:0px;
  overflow:hidden;
  padding:0;
  margin:0;
  background-color:white;
  filter:alpha(opacity=25);
  opacity:0.25;
  z-index:1000;
}

.fs {
  border:1px groove #DCDCDC;
  padding:10px;
  margin:10px;
  border-radius:10px;
}
.leg {
  font-size:0.8em;
  font-weight:bold;
}

#loading {
   width: 100%;
   height: 100%;
   top: 0;
   left: 0;
   position: static;
   display: block;
   opacity: 1;
   z-index: 99;
   text-align: center;
}

#loading-image {
  position: fixed;
  top: 250px;
  left: 700px;
  z-index: 99;
}

</style>
</head>
<body>
  <div class="container-scroller" >
  <div id="loading" style="display:none" >
		<img id="loading-image" src="${pageContext.request.contextPath}/assets/img/load.gif" alt="Loading..." />
	</div>
    <!-- partial:partials/_navbar.html -->
    <nav class="navbar default-layout-navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
	      <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
	       <a class="navbar-brand brand-logo" href="/parent"><img src="${pageContext.request.contextPath}/assets/img/juniper.jpg" alt="logo"/></a>
	        <a class="navbar-brand brand-logo-mini" href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/assets/img/junipersmall.jpg" alt="logo"/></a>
	      </div>
    
      <div class="navbar-menu-wrapper d-flex align-items-stretch">
      	<div class="navbar-nav navbar-nav-left">
			<font color="black"><b>${project_name}</b></font>&nbsp<font size="2" color="blue"><b>(SYBASE)</b></font>
        </div>
        <ul class="navbar-nav navbar-nav-right">
          <li class="nav-item nav-profile dropdown">
            <a class="nav-link dropdown-toggle" id="profileDropdown" href="#" data-toggle="dropdown" aria-expanded="false">
              <div class="nav-profile-img">
              
           <c:choose>
			    <c:when test="${user_name=='admin'}"><img src="${pageContext.request.contextPath}/assets/img/faces/jiten.jpg" alt="image"></c:when>
			    <c:when test="${user_name=='vaibhav'}"><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:when>
			    <c:when test="${user_name=='abhishek'}"><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:when>
			    <c:when test="${user_name=='test'}"><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:when>
			    <c:otherwise><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:otherwise>
			</c:choose>
			 
                <span class="availability-status online"></span>             
              </div>
              <div class="nav-profile-text">
                <p class="mb-1 text-black">${user_name}</p>
              </div>
            </a>
            <div class="dropdown-menu navbar-dropdown" aria-labelledby="profileDropdown">
              <a class="dropdown-item" href="#">
                <i class="mdi mdi-account-circle mr-2 text-success"></i>
                Profile
              </a>
              <div class="dropdown-divider"></div>
             <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                <i class="mdi mdi-logout mr-2 text-primary"></i>
                Logout
              </a>
            </div>
          </li>
           <li class="nav-item nav-logout d-none d-lg-block">
           <a class="nav-link" href="${pageContext.request.contextPath}/parent">
              <i class=" mdi mdi-home"></i>
            </a> 
          </li>
          <li class="nav-item d-none d-lg-block full-screen-link">
            <a class="nav-link">
              <i class="mdi mdi-fullscreen" id="fullscreen-button"></i>
            </a>
          </li>
          <li class="nav-item nav-logout d-none d-lg-block">
           <a class="nav-link" href="${pageContext.request.contextPath}/logout">
              <i class="mdi mdi-power"></i>
            </a> 
          </li>
        </ul>
        <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
          <span class="mdi mdi-menu"></span>
        </button>
      </div>
    </nav>
    <!-- partial -->
    <div class="container-fluid page-body-wrapper">
      <!-- partial:partials/_sidebar.html -->
      <nav class="sidebar sidebar-offcanvas" id="sidebar">
        <ul class="nav">
          <li class="nav-item nav-profile">
            <a href="#" class="nav-link">
              <div class="nav-profile-image">
                <c:choose>
			   <c:when test="${user_name=='admin'}"><img src="${pageContext.request.contextPath}/assets/img/faces/jiten.jpg" alt="image"></c:when>
			    <c:when test="${user_name=='vaibhav'}"><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:when>
			    <c:when test="${user_name=='abhishek'}"><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:when>
			    <c:when test="${user_name=='test'}"><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:when>
			    <c:otherwise><img src="${pageContext.request.contextPath}/assets/img/faces/face.png" alt="image"></c:otherwise>
			</c:choose>
                <span class="login-status online"></span> <!--change to offline or busy as needed-->              
              </div>
              <div class="nav-profile-text d-flex flex-column">
                <span class="font-weight-bold mb-2">${user_name}</span>
                <span class="text-secondary text-small">Application User</span>
              </div>
              <i class="mdi mdi-bookmark-check text-success nav-profile-badge"></i>
            </a>
          </li>
        <li class="nav-item">
   <a class="nav-link" data-toggle="collapse" href="#extraction" aria-expanded="false" aria-controls="extraction"> <span class="menu-title">Data Extraction</span> <i class="menu-arrow"></i> <i class="mdi mdi-database menu-icon"></i> </a> 
   <div class="collapse" id="extraction">
      <ul class="nav flex-column sub-menu">
         <li class="nav-item"> <a class="nav-link" href="/extraction/ConnectionDetailsSybase"> Source Details </a></li>
         <li class="nav-item"> <a class="nav-link" href="/extraction/TargetDetails"> Target Details </a></li>
         <li class="nav-item"> <a class="nav-link" href="/extraction/SystemDetails"> Feed Details </a></li>
         <li class="nav-item"> <a class="nav-link" href="/extraction/DataDetails"> Data Details </a></li>
         <li class="nav-item"> <a class="nav-link" href="/extraction/FeedDetails"> Feed Validation </a></li>
         <li class="nav-item"> <a class="nav-link" href="/extraction/ExtractData"> Extract Data </a></li>
         <li class="nav-item"> <a class="nav-link" href="/extraction/ViewFeedRun"> View Feed Runs </a></li>
      </ul>
   </div>
</li>
        </ul>
      </nav>
