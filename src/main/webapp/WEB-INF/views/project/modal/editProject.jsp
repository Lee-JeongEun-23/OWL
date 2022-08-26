<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   <div class="modal fade" id="editProject">
         <div class="modal-dialog modal-dialog-centered" role="document">
	             <form class="modal-content editContent">
				<div class="modal-header text-center">
					<h4 class="modal-title" id="myProjectTitle"></h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
 		             <h5>Color</h5>
 		             <input type="hidden" name="projectIdx"  id="projectIdx"> 
		             <input type="text" id="nowColor" class="complex-colorpicker form-control" >
                     <br>                        
                     <br>                
                     <h5>Favorite</h5>
                     <div style="position:relative;">
                     <p>해당 프로젝트를 즐겨찾기에 추가하시겠습니까?</p>                   
					<div class="favoriteBtn" id="favoriteBtn">
						  <input type="checkbox" class="favoriteCheckbox">
						  <div class="knobs"></div>
						  <div class="layer"></div>
					</div>
		             <br>
                 </div>                
                 <div class="modal-footer edit">
                 		<input type="hidden" id="realProName" value="">
                     <button type="button" class="btn btn-primary" data-editidx="" data-dismiss="modal" id="editBtn">적용하기</button>
                 </div>
             </div>
         </form>
     </div>
     </div>