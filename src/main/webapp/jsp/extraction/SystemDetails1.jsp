<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:if test="${stat eq 1}">
 <font color="red">Source Name already exists</font>
</c:if>
<c:if test="${stat eq 0}">
 <font color="green">Source Name is unique</font> 
</c:if>