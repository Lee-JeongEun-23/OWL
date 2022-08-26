<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	
<div id="addIssueModal" class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">New Issue</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
			<form  id="addIssueForm" class="addContent">
			    <%-- <input type="hidden" id="projectIdx" name="projectIdx" value="${project.projectIdx}"> --%>
 				<div class="row">
					<div class="col-8">
						<div class="form-group">
							<input type="text" class="form-control input-default" placeholder="Issue Title" name="issueTitle" id="issueTitle">
						</div>
						<div class="form-group">
 							 <textarea class="form-control bg-light" rows="10" cols="50" placeholder="Issue Content" id="isContent" name="content"></textarea>
							 <input type="file" name="multipartFiles" id="multipartFiles" multiple="multiple"> 
						</div>
					</div>
					<div class="col-4">
					<div class="form-group">
					<div class="row">
						<div class="col-4">Assignee</div>	
						<div class="col-8">
							<select class="select2 form-control custom-select" name="assigned" id="assigned">

							</select>
						</div>
					
					</div>
						</div>
						<hr>
					<div class="form-group">
						<div class="row">
						<div class="col-4">Label</div>	
						<div class="col-8">
							<select class="select2 form-control custom-select" name="labelIdx" id="labelIdx">
								
							</select>
						</div>									
					</div>
						</div>
						<hr>
					<div class="form-group">
						<div class="row">
						<div class="col-4">Priority</div>	
						<div class="col-8">
							<select class="select2 form-control custom-select" name="priorityCode" id="priorityCode">
								<option value="">Select</option>
								<option value="LOW">low</option>
								<option value="MEDIUM">medium</option>
								<option value="HIGH">high</option>
								<option value="URGENT">urgent</option>
								
							</select>
						</div>									
					</div>
						</div>
						<hr>
					<div class="form-group">
						<div class="row">
						<div class="col-4">Due Date</div>	
						<div class="col-8">                                
                           <input type="text" class="form-control" id="datepicker-autoclose" placeholder="yyyy-mm-dd" name="dueDate" >
                         </div>	
					</div>
					</div>
				</div>
			</div> 
					<div class="modal-footer text-right">
					<c:if test="${project.authority eq 'ROLE_PM'}">
					<input type="button" class="btn btn-primary InsertIssueBtn" data-type="sendToAll" value="Save changes">
					</c:if>
					
					<c:if test="${project.authority eq 'ROLE_PROJECTMEMBER'}">
					<input type="button" class="btn btn-primary InsertIssueBtn" data-type="sendPm" value="Send PM">
					</c:if>
					
					<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</form>
		</div>
	</div>
</div>
</div>


