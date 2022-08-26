<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<div id="addColumnModal" class="modal fade" tabindex="-1" role="dialog"
	aria-hidden="true">
	<div class="modal-dialog modal-md">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">New Column</h4>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body" style="margin-left: 10px">
				<input type="hidden" id="projectIdx" name="projectIdx" value="${project.projectIdx}">
				<div class="row">
					<h5>Column name</h5>
					<input type="text" class="form-control input-default" placeholder="Write column name" name="colname" id="colname"
							onKeypress="javascript:if(event.keyCode==13) {$('#InsertColumnBtn').click();}">
				</div>
				<div class="modal-footer text-right">
					<input type="button" class="btn btn-primary" id="InsertColumnBtn" value="Create Column">
					<!-- onKeypress="javascript:if(event.keyCode==13) {insertColumn(); }" -->
					<button type="button" class="btn btn-primary" data-dismiss="modal" >Close</button>
				</div>
			</div>
		</div>
	</div>
</div>


