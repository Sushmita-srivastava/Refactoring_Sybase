<jsp:include page="cdg_header.jsp" />
      <div class="main-panel">
<div class="content-wrapper d-flex align-items-center text-center bg-light">
        <div class="row flex-grow">
          <div class="col-lg-4 mx-auto">
            <div class="row align-items-center d-flex flex-row">
              <div class="col-lg-12 text-lg-right pr-lg-12">
              </div>
              <div class="col-lg-12 error-page-divider text-lg-left pl-lg-12">
                <h2>SORRY!</h2>
                <h3 class="font-weight-light">Please try again later!!</h3>
                <h4 class="font-weight-light">${exception}</h4>
            	<h4 class="font-weight-light">${datetime}</h4>
            	<h4 class="font-weight-light">${url}</h4>
                
              </div>
            </div>
            <div class="row mt-5">
            	
              <div class="col-12 text-center mt-xl-2">
                <a class="font-weight-medium" href="/extraction/error">Back to Home</a>
              </div>
            </div>
          </div>
        </div>
        </div>
    </div>
  </div>
