<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="container-fluid pt-3 h-100 w-100 themeChange">
     <div id="noticeBox">
       <!--  <div class="card"> -->
            <div class="card-body"> 
                <h3 class="text-center themeChangeLetter">Notice</h3>
                <div id="noticeTableBox">
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered text-center themeChangeLetter" id="noticeTable">
                            <thead>
                                <tr>
                                    <th width="10%">NO</th>
                                    <th width="50%">제목</th>
                                    <th width="15%">작성자</th>
                                    <th width="15%">작성일</th>
                                    <th width="10%">조회수</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="emptyNoticeBox" class="text-center m-5 hidden">
                    <hr>
                    <h2 class="mt-4 mb-4">작성된 공지 사항이 없습니다.</h2>
                    <p class="font-pen">공지사항을 작성해주세요.</p>
                    <hr>
                </div>
                
               <c:if test="${project.authority eq 'ROLE_PM'}">
	                <div class="text-right mt-3 ">
	                    <button class="btn btn-primary" onclick="writeNotice()"><i class="fas fa-pencil-alt"></i>&nbsp;글쓰기</button>
	                </div>
               </c:if>
            </div>
        </div>
<!--     </div> -->

    <!-- Wirte -->
    <jsp:include page="write.jsp"/>
    
    <!-- Detail -->
    <jsp:include page="detail.jsp"/>
    <!-- Detail -->
    <jsp:include page="edit.jsp"/>
</div>