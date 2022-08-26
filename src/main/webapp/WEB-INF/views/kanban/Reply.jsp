<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">


</head>
<body>
  <div class="p-5 bg-light mt-3">
     	<div class="form-group">
     	
      	<textarea name="replyContent" id="replyContent" cols="30" rows="3" class="form-control" 
      		<c:choose>
	     		<c:when test="${sessionScope.email != null }">placeholder="Message"</c:when>
	     		<c:otherwise>placeholder="로그인해주세요." readonly</c:otherwise>
     		</c:choose>
      	></textarea>
          </div>
          <div class="text-right">
          	 <input id="reply" type="button" class="btn btn-primary " value="REPLY"
          	 	<c:if test="${sessionScope.email == null }">disabled</c:if>
          	 >
          </div>
    </div>
    
	<div class="col-md-12 tour-wrap">
		<h3 id="replyCount"  style="border-bottom: 1px solid #f2f2f2;">  </h3>
			<ul class="comment-list">
			<%-- <c:forEach var="reply" items="${ replies }"> --%>
			<!-- id="${reply.rIdx}"  -->
				<li class="comment box p-2 px-3 bg-light d-flex" >
					<div class="comment-body">
					<!-- ${ reply.id }  -->
						<h3 class="bold"> </h3>
						<div class="meta">
							 <%-- <fmt:formatDate pattern="yyyy-MM-dd   HH:mm:ss" />  --%>
							 <!-- value="${reply.rWDate}"  -->
						</div>
						<p>content</p> <!-- ${ reply.rContent } -->
						<%-- <c:if test="${reply.id == sessionScope.memberId || (sessionScope.email!=null && sessionScope.isAdmin == 'true')}">
							<input type="button" onclick="delReply('${reply.rIdx}')" class='btn del'  value="Delete">
						</c:if> --%>
					</div>
				</li>
			<%-- </c:forEach> --%>
			</ul>
	</div>
</body>
</html>