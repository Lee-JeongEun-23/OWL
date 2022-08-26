<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="editBox" class="hidden">
    <div class="card">
        <div class="card-body">
            <div class="col-md-10 offset-1">
                <div class="compose-content">
                    <h3 class="text-center">Notice Edit</h3><br>
                        <div class="form-group">
                            <input type="text" class="form-control bg-transparent" name="title" id="editTitle" placeholder="제목을 입력해주세요">
                        </div>
                        <div class="form-group">
                            <textarea class="form-control bg-light" rows="10" cols="60" id="noticeEditNote" name="content"></textarea>
                        </div>
              		  <div class="card m-b-0">
                       <div class="card-header" id="headingOne">
                            <h5 class="mb-0">
                                <i class="fas fa-download mr-2 " aria-hidden="true"></i>
                                <span id="noticeEditFileCount">첨부파일</span>
                            </h5>
                    </div> 
                    
                        <ul class=" m-4" id="noticeEditFiles">

                        </ul>
                   </div>
                    <h5 class="m-b-20"><i class="fa fa-paperclip m-r-5 f-s-18"></i>&nbsp;파일첨부</h5>
                        <div class="form-group">
                            <div class="fallback">
                                <input class="l-border-1" name="noticeMultipartFiles" id="noticeEditMultipartFiles" type="file" multiple="multiple">
                            </div>
                         </div>         
                        
                        <div class="form-group text-center">
                            <input type="button"
                                class="btn btn-primary m-b-30 m-t-15 f-s-14 p-l-20 p-r-20 m-r-10 mr-2" onclick="noticeEditOk()" value="확인">
                            <input type="button" class="btn btn-dark m-b-30 m-t-15 f-s-14 p-l-20 p-r-20" onclick="cancelNotice()"  value="취소">
                        </div>
                </div>
            </div>
        </div>
    </div>
</div>
