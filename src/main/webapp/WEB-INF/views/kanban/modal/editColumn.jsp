<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div id="editColumnModal" class="modal fade" tabindex="-1" role="dialog"
	aria-hidden="true">
	<div class="modal-dialog modal-md">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Edit Column</h4>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body" style="margin-left: 10px">
				<form action="" method="post">
					<div class="row">
						<h5>Column name</h5>
						<input type="text" class="form-control input-default" name="colname" id="editcolName">
						<input type="hidden" name="colIdx" id="editcolIdx" >
					</div>
					<div class="modal-footer text-right">
						<input type="button" class="btn btn-primary" id="editColumnBtn" value="Edit Column" onclick="editColname()">
						<button type="button" class="btn btn-primary" data-dismiss="modal" >Close</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>


