<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="writeBox" class="hidden">
    <div class="card">
        <div class="card-body">
            <div class="col-md-10 offset-1">
                <div class="compose-content">
                    <h3 class="text-center">Notice</h3><br>

                    <form action="WriteNotice.do" id="noticeForm" enctype="multipart/form-data">
                        <div class="form-group">
                            <input type="text" class="form-control bg-transparent" name="title" id="title" placeholder="제목을 입력해주세요">
                        </div>
                        <div class="form-group">
                            <textarea class="form-control bg-light" rows="10" cols="60" id="noticeNote" name="content"></textarea>
                        </div>
                        <h5 class="m-b-20"><i class="fa fa-paperclip m-r-5 f-s-18"></i>&nbsp;파일첨부</h5>
                        <div class="form-group">
                            <div class="fallback">
                                <input class="l-border-1" name="noticeMultipartFiles" id="noticeMultipartFiles" type="file" multiple="multiple">
                            </div>
                        </div>
                        <div class="form-group text-center">
                            <input type="button"
                                class="btn btn-primary m-b-30 m-t-15 f-s-14 p-l-20 p-r-20 m-r-10 mr-2" onclick="writeNoticeOk()" value="확인">
                            <input type="button" class="btn btn-dark m-b-30 m-t-15 f-s-14 p-l-20 p-r-20" onclick="cancelNotice()"  value="취소">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
