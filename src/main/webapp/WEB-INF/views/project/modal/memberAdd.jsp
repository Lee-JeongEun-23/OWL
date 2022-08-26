<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
	.memberDeleteButton{
		cursor: pointer;
	}
</style>

<div id="memberEditModal" class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header text-center">
				<h4 class="modal-title w-100 font-weight-bold">
					<i class="icon-settings mr-2"></i>프로젝트 멤버 설정
				</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body modal-scroll mx-3">
				<small class="text-muted">더 많은 사람을 초대하여 원활한 의사소통으로 업무를 효율적으로 처리해보세요.</small><br/>			
				<small class="text-muted">회사 동료뿐만 아니라 외부 협업자도 파트너로 초대할 수 있습니다.</small><br/>
				<label class="mt-3 mb-3">초대 메일</label>
					<div class="form-row">
						<input type="email" id="addProjectMemeberEmail"  class="form-control" placeholder="추가할 멤버를 입력해주세요" 
									onKeypress="javascript:if(event.keyCode==13 || event.keyCode==188 || event.keyCode==32) {addProjectMember()}">
					</div>
				<!--  멤버 삭제   -->
				<label class="mt-3 mb-3">멤버 리스트</label> (<span id="addMemberCount"> 0명 </span>)
					<div >
						<div id="addMemberBox">
						</div>
		                 <div class="text-center mt-3">
		                     <input type="button" id="addMemberOk" class="btn btn-primary btn-lg"  value="초대 메일 보내기">
		                 </div>
					</div>				
			</div>
		</div>
	</div>
</div>