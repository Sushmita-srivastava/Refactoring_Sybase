<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="col-sm-6">
	<label>Service Account *</label> <select name="service_account"
		id="service_account" class="form-control">
		<option value="" selected disabled>Select Service Account...</option>
		<c:forEach items="${sa}" var="sa">
			<option value="${sa}">${sa}</option>
		</c:forEach>
	</select>
</div>
<div class="col-sm-6">
	<label>Target Bucket *</label> <select name="target_bucket"
		id="target_bucket" class="form-control">
		<option value="" selected disabled>Select Target Bucket...</option>
		<c:forEach items="${buck}" var="buck">
			<option value="${buck}">${buck}</option>
		</c:forEach>
	</select>
</div>
