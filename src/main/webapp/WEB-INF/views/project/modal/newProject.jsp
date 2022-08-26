<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
     <div class="modal fade" id="newProject">
         <div class="modal-dialog modal-dialog-centered" role="document">
             <form class="modal-content insertContent">
			<div class="modal-header text-center">
				<h4 class="modal-title">
					<i class="fas fa-desktop"></i>&nbsp; 프로젝트 생성
				</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
                 	 <h5>Name</h5>
                     <input type="text" id="projectTitle" style="width:100%; height: 40px;">
                     <br>
                     <br>
 		             <h5>Color</h5>
		             <input type="text" id="myColor" name="projectColor" class="complex-colorpicker form-control" value="#326295">
                     <br>                        
					<br>	
                     <h5>Date</h5>
		             <div id="daterangepicker" title="daterangepicker"></div>      
		             <br>
		             <br>                     
                 </div>
                 <div class="modal-footer">
                     <button type="button" class="btn btn-primary" data-dismiss="modal" id="insertBtn">생성하기</button>
                 </div>
             </form>
         </div>
     </div>