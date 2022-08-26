<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
.lineSort {
    line-height: 64px;
}	

ul{
 list-style:none;
}
</style>
<div id="newChat" class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header text-center">
				<h4 class="modal-title w-100 font-weight-bold">
					<i class="far fa-comments"></i> 새로운 채팅
				</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body modal-scroll mx-3">
				<!--  멤버 추가  -->
				<form action="" method="post">
					<label class="m-t-20">타이틀</label>
					<div class="form-row">
						<div class="form-group col-md-12 pr-0  pt-2 pb-2">
							<input id="chatRoomTitle" type="email" name="member" class="form-control"placeholder="채팅방 타이틀을 입력해주세요.">
						</div>
					</div>
				</form>
				<!--  멤버 삭제   -->
				<label class="m-t-20">멤버 리스트</label>
				<ul id="ulUserList" class="collection" style="padding-left:0;">
           
<!-- 				 <div class="input-group ">
					<div class="form-control pt-2 pb-2">
						<i class="fas fa-user iconSizeBig"></i> 홍길동(hong@gmail.com)
					</div>
					<div class="input-group-append">
						<span class="input-group-text">
						<i class="far fa-times-circle font-weight-bold iconSizeBig"></i></span>
					</div>
				</div>
			
				<div class="input-group ">
					<div class="form-control pt-2 pb-2">
						<i class="fas fa-user iconSizeBig"></i> 김콜린(kim@gmail.com)
					</div>
					<div class="input-group-append">
						<span class="input-group-text">
						<i class="far fa-times-circle font-weight-bold iconSizeBig"></i> </span>
					</div>
				</div>  -->
				 </ul>
                 <div class="modal-footer">
                     <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="onCreateClick()">생성하기</button>
                 </div>
			</div>
		</div>
	</div>
</div>
