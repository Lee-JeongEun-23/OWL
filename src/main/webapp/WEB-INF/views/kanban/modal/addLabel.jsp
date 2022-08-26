<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- <style>

.link-gray {
    color: #586069!important;
}

.link-gray:hover {
    color: #326295!important;
}

.newLabelSection {
	padding: 10px;
	background-color: #ebedf0;
	border: 1px solid #dcdee0;
}

.labelList {
	margin-bottom: 5px;
}


.badgeIconinList {
	display: inline-block;
	font-size: large;
	font-weight: bold;
	padding: 3px;
	color: black;
	margin-right: 7px;
	border-radius: 2px;
}

#labelList {
 padding : 10px 60px 10px 50px;
 	overflow-y : auto;
	max-height: 300px;
}
</style> -->



<div id="addLabelModal" class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title w-100 font-weight-bold">
					<i class="fas fa-bookmark mr-2"></i> Label Box
				</h4>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				
					<input type="hidden" id="projectIdx" name="projectIdx" value="${project.projectIdx}">
					<div class="row">
						<!-- label make section -->
						<div class="col-lg-5 newLabelSection">
							<div class="form-group" id="colorform">
								<h5>Color</h5>
								<input type="text" class="complex-colorpicker form-control"name="labelcolor" id="labelcolor"> <br> <br>
								<h5>Label name</h5>
								<input type="text" class="form-control input-default" name="labelname" id="labelname">
							</div>
							<hr>
							<input type="button" class="btn btn-primary text-right" id="addLabelBtn" value="Create label" />
							<input type="button" class="hidden btn btn-primary text-right " id="editLabelBtn" value="Edit" />
							<input type="button" class="hidden btn btn-primary text-right" id="backBtn" value="Back" />
							

						</div>

						<div class="col-lg-6 labelListSection" id="labelList">
							
						</div>

					</div>
				
			</div>
		</div>
	</div>
</div>


