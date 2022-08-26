<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<div id="confirmIssueModal" class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Comfirm Issue</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
			<div class="row">
					<div class="col-8">
					<div id="comfirmIdx"></div>
						<div class="form-group" id="comfirmTitle">
							
						</div>
						<div class="form-group">
						<div class="contentbox" id="comfirmContent"></div>
						
						</div>
						<div class="form-group">
							<i class="far fa-file-alt fa-lg" ></i> <span id="comfirmFilename"></span>
						</div>
					</div>
					<div class="col-4 mt-5">
					<div class="form-group mb-3">
					<div class="row">
						<div class="col-4">Creator</div>	
						<div class="col-8" id="comfirmCreator">
						</div>
					
					</div>
						</div>
						<hr>
					<div class="form-group">
					<div class="row">
						<div class="col-4">Assignee</div>	
						<div class="col-8" id="comfirmAssignee">
						</div>
					
					</div>
						</div>
						<hr>
					<div class="form-group">
						<div class="row">
						<div class="col-4">Label</div>	
						<div class="col-8" id="comfirmLabel">
 						</div>									
					</div>
						</div>
						<hr>
					<div class="form-group">
						<div class="row">
						<div class="col-4">Priority</div>	
						<div class="col-8" id="comfirmPriority">
						</div>									
					</div>
						</div>
						<hr>
					<div class="form-group">
						<div class="row">
						<div class="col-4">Due Date</div>	
						<div class="col-8" id="comfirmDuedate">                                
                         </div>	
					</div>
					</div>
				</div>
				<br><br><br>
				<div class="mt-3">
					<i class="fas fa-stamp fa-2x"></i> <b>이슈사유</b>
						<input type="text" style=" min-height: 60px; max-width: 600px; min-width: 600px;" id="rejectreason"></div>
				</div> 
				<br>
					<div id="rejectreasonadd"></div>
				
					<div class="modal-footer text-right">
					<input type="button" class="btn btn-primary" id="comfirmBtn" value="Comfirm">
					<input type="button" class="btn btn-primary" id="rejectBtn" value="Reject">
					
				</div>
		</div>
	</div>
</div>
</div>


