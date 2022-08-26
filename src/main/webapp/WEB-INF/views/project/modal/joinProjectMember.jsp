<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<input type="hidden" id="openJoinProjectMemberModal" data-toggle="modal" data-target="#joinProjectMemberModal">
<div class="modal fade" id="joinProjectMemberModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header text-center" style="border-bottom: 0px">
                <div class="text-center" style="width: 100%">
                    <img class="mt-4 mb-3 ml-5" src="resources/images/owl_logo_fit.png" style="width: 100px">
                </div>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body mx-3">
                <div class="text-center">
                    <img class="mb-3" src="resources/images/login/mailbox.png" style="width: 150px">
                    <h3 class="mt-5 mb-5"> 초대 메일 <span id="sendMemberCount">1</span>건이 발송되었습니다!</h3>
                    <div id="sendMembers">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
