<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div id="totalbody" class="container-fluid pt-3">
<input type="hidden" id="getAuthority" value="${project.authority}">

<input type="hidden" id="projectIdxNum">
    <div id="kanbanMainBox">

        <div class="row">

          <div class="float-left ml-4 mt-1" >	
                 <button class="btn kanbanViewBtn " id="kanbanTableView">
                     <i class="fas fa-list fa-2x"></i>
                 </button>
                 <button class="btn kanbanViewBtn active " id="kanbanIconView" disabled>
                     <i class="fas fa-th-large fa-2x"></i>
                 </button>
            </div>
            
            
            <div class="col-2" style="margin-left: 40px;">

                <button id="openIssueBtn" class="btn btn-primary">
                    <i class="fas fa-columns"></i>&nbsp;Open
                </button>

                <button id="closeIssueBtn" class="btn btn-primary">
                    <i class="fas fa-columns"></i>&nbsp;Closed
                </button>

                <button class="btn btn-primary btn-link hidden ml-3" id="searchReturnBtn">
                	<i class="fas fa-arrow-circle-left fa-3x"></i>
               </button>

            </div>
            <div class="col-8">
                <a href="#" data-toggle="modal" data-target="#addIssueModal">
                    <button id="addIssuebtn" class="btn btn-primary">
                        <i class="fas fa-italic"></i>&nbsp;New Issue
                    </button>
                </a>
			<c:if test="${project.authority eq 'ROLE_PM'}">
                <a href="#" data-toggle="modal" data-target="#addColumnModal">
                    <button class="btn btn-primary" id="addColumnBtn">
                        <i class="fas fa-columns"></i>&nbsp;New Column
                    </button>
                </a>
                <a href="#" data-toggle="modal" data-target="#addLabelModal">
                    <button class="btn btn-primary" >
                        <i class="fas fa-tag"></i>&nbsp;Make Label
                    </button>
                </a>
<!--                 --------------------알람 만들면 지울예정 ------------------------
              <a href="#" data-toggle="modal" data-target="#confirmIssueModal">
                    <button class="btn btn-primary" id="confirmBtn">
                        <i class="fas fa-tag"></i>&nbsp;Confirm Issue
                    </button>
                </a>
              ------------------------------------------------------------- -->
             </c:if>
            

             <div class="float-right">
                   <div class="input-group">
                        <input type="text" id="searchContent" class="form-control" placeholder="" aria-describedby="basic-addon2" >
                            <div class="input-group-append">
                                 <span class="input-group-text" id="basic-addon2" style="background-color: #326295">
                                 	<button class="btn btn-primary btn-link" id="kanbanSearchBtn">
                                 		<i class="fas fa-search" style="color:#f8f9fa"></i>
                                	 </button>
                                 </span>
                        </div>
                   </div>
              	</div>
               <div class="float-right">
                     <select id="searchSelectBox" class="select2 form-control custom-select" style="width: 100%; height:36px;" >
                        <option value="" selected="selected">Select</option>
                        <option value="Label">Label</option>
                        <option value="Assignee">Assignee</option>
                        <option value="Priority">Priority</option>
                     </select>
				</div>
			
            </div>
        </div>

        <div class="row" id="kanbanArea">

        	  <div class="col-md-10 mt-4 ml-4 mr-4 hidden" id="searchBox" >
	  			     <div class="table-responsive m-t-40" style="clear: both;">
                        <table class="table table-hover">
                            <thead>       
                            <tr>
	                	 		<th class="text-center">Label</th>
	                	  		<th class="text-center">IssueTitle</th>
	                	  		<th class="text-center">Assigned</th>
	                	  		<th class="text-center">Priority</th>
	                	  		<th class="text-center">Due Date</th>
	                	  	</tr>
                            </thead>
                           <tbody>
                            </tbody>
                        </table>
                     </div>
                   </div>
        
    	    <div class="col-md-12  hidden" id="kanbanTableViewBox" >
                <table id="kanbanTable" class="table table-hover table-bordered text-center">
                   <thead>
                       <tr>
                           <th width="5%">No</th>
                           <th width="10%">Label</th>
                           <th width="auto">Title</th>
                           <th width="15%">Assignee</th>
                           <th width="10%">Priority</th>
                           <th width="10%">Due Date</th>
                       </tr>
                   </thead>

                   <tbody> </tbody>
               </table>
        	</div>
            <!--  open issue -->
            <!--  openIssueColumn -->

            <div class="columnSection leftdoor d-none" id="-1Column">
                <div class="text-center mt-2 leftdoorheader">
                    <h4> Open Issue
                        <span class="float-right"><i class="fas fa-times cursor_pointer" onclick="closeFn()"></i></span>
                    </h4>
                </div>
                <ul class="connectedSortable columnBody sortableCol" style="background-color:#bdbbbb">

                </ul>
            </div>
            <!--  close issue -->
            <div class="columnSection d-none leftdoor" id="-99Column">
                <div class="text-center mt-2 leftdoorheader">
                    <h4>
                        Close Issue<span class="float-right">
                            <i class="fas fa-times cursor_pointer" onclick="closeFn()"></i></span>
                    </h4>
                </div>
                <ul class="connectedSortable columnBody sortableCol" style="background-color:#bdbbbb">
                    <li class="issuePiece d-none"></li>
                </ul>
            </div>
            <div id="kanbanIn"> </div>
        </div>
    </div>
    
    <!-- kanbanDetailBox  -->
    <jsp:include page="detail.jsp" />

</div>

<!-- add issue modal -->
<jsp:include page="modal/addIssue.jsp" />
<jsp:include page="modal/addColumn.jsp" />
<jsp:include page="modal/editColumn.jsp" />
<jsp:include page="modal/addLabel.jsp" />
<jsp:include page="modal/comfirmIssue.jsp" />