<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
.comment_img {
background-color: #326295;
width:50px; 
height: 50px; 
line-height: 50px;
border-radius:50%;
text-align: center;
font-weight: 900;
font-size: 16px;
color: #f8f9fa;
}
</style>
<p class="hidden" id="noticeBoardIdx"></p> 
<div class="container-fluid mt-2 hidden" style="padding: 25px;" id="noticeDetailBox">
    <div class="row">
        <div class="card w-100">
            <div class="card-title mb-0">
                <div class="ml-3">
                	<!-- TITEL -->
                    <h2 id="noticeTitle"></h2>
                </div>
            </div>
            <hr class="mt-1">
            <div class="card-body mt-0 mb-0" id="noticeContent" style="border: 1px solid; border-color:#e9e9e9; min-height: 350px" >
            	<!-- CONTENT -->
            </div>
            <div class="accordion" id="accordionExample">
                <div class="card m-b-0">
                    <div class="card-header" id="headingOne">
                        <a data-toggle="collapse" data-target="#collapseOne" aria-expanded="false"
                            aria-controls="collapseOne" class="collapsed">
                            <h5 class="mb-0">
                                <i class="fas fa-download mr-2 " aria-hidden="true"></i>
                                <span id="noticeFileCount">첨부파일 (4)</span>
                            </h5>
                        </a>
                    </div>
                    <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample" >
                        <ul class=" m-4" id="noticeFiles">
                            <li class="mb-2" style="font-size: 16px">
                                <a href="#"><i class="far fa-save"></i>&nbsp;&nbsp;<span> 어쩌구.txt</span></a>
                            </li>
                            <li class="mb-2" style="font-size: 16px">
                                <a href="#"><i class="far fa-save"></i>&nbsp;&nbsp;<span> 어쩌구.txt</span></a>
                            </li>
                            <li class="mb-2" style="font-size: 16px">
                                <a href="#"><i class="far fa-save"></i>&nbsp;&nbsp;<span> 어쩌구.txt</span></a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
    	<div class="col-6 ">
    		<div class="text-left">
    			<button class="btn btn-primary mr-1" onclick="setNoticeData()"><i class="fas fa-chevron-left"></i> 뒤로가기</button>
   			</div>
    	</div>
    	<c:if test="${project.authority eq 'ROLE_PM'}">
	    	<div class="col-6">
		    	<div class="text-right">
			        <button class="btn btn-primary ml-1" id="editNoticeBtn" onclick="editNoticeSetView()">수정</button>
			        <button class="btn btn-danger ml-1" onclick="deleteNotice()">삭제</button>
		    	</div>
	    	</div>
    	</c:if>
    </div>
</div>