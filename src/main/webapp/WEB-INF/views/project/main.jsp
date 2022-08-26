<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<c:set var="project" value="${project}" scope="request" />
<html>

<c:set var="projectIdx" value="${project.projectIdx}" scope="request"/>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>OWL</title>
    <jsp:include page="../include/headTag.jsp" />
    <link href="resources/css/project.css" rel="stylesheet">
    <!--  dashboard css -->
    <link href="resources/css/dashBoard.css" rel="stylesheet">

    <!-- DataTable -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.css" />
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.6.1/js/dataTables.buttons.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.6.1/js/buttons.html5.min.js"></script>
 	

	
    <!-- SummerNote -->
    <link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote.css" rel="stylesheet">
    <script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<!-- Toast Calendar -->
	<link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.css" />
	<script src="resources/plugin/calendar/projectCalendars.js"></script>
    <script src="resources/plugin/calendar/schedules.js"></script>
	<!-- If you use the default popups, use this. -->
	<link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
	<link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
    
    <script src="resources/js/notice.js"></script>
    <script src="resources/js/dashBoard.js"></script>
    <script src="resources/js/kanban.js"></script>
    <script src="resources/js/drive.js"></script>
    
    <script src="resources/js/project.js"></script>
    
    <link href="resources/css/drive.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="resources/css/kanban.css" />
    <script type="text/javascript">
        $(function () {	
            setTheme("${setting.themeColor}", "${setting.font}");
            setEmoji();
            initProjcet("${member.email}","${member.name}","${project.projectIdx}", "${project.projectName}", "${project.projectColor}","${project.startDate}", "${project.endDate}");

            $(".tui-full-calendar-layout.tui-view-8").addClass("hidden");
            $(".tui-full-calendar-layout.tui-view-8.tui-view-13").removeClass("hidden");
            $.ajax({
        		url:"GetProjectList.do",
        		data: {projectIdx: ${project.projectIdx}},
        		success:function(data){   		
        		    calendar = new CalendarInfo();
        				calendar.id = String(data.projectIdx);
        			    calendar.name = data.projectName;
        			    calendar.color = '#ffffff';
        			    calendar.bgColor = data.projectColor;
        			    calendar.dragBgColor = data.projectColor;
        			    calendar.borderColor = data.projectColor;
        			    addCalendar(calendar);		    						
        		    setSchedules();
        		}
            });
    		
			$.ajax({
				url : "GetIssue.do",
				data : {'projectIdx' :  ${project.projectIdx} },
				success : function(data) {
					var openCount = 0;
					var closeCount = 0;
					 $.each(data, function(index,element) {
							if(element.issueProgress== "OPEN"){
								openCount ++;		
							}else if(element.issueProgress == "CLOSED"){
								closeCount ++;
							}				
					});
				}
			});
            
            let oldMenu = $("#projectMenu li:nth-child(2)");
            $("#projectMenu li").on("click", function () {
                console.log("click!!!!");
                if($(this).children(".nav-link").attr("href") == "#project")
					return;
				
                let oldTab = $(oldMenu.children(".nav-link").attr("href"));
                oldMenu.removeClass("active");
                oldTab.removeClass("active show");

                $(this).addClass("active");
                let currentTab = $($(this).children(".nav-link").attr("href"));
                currentTab.addClass("active show");
                oldMenu = $(this);

                setChageView(currentTab.attr("id"));
            });
	
            $('#memberCheckModal').on('show.bs.modal', function(){
				$("#projectMemebers").empty();
			 	$.ajax({
			 		type: "POST",
                    url: "GetProjectMember.do",
                    data: { projectIdx: ${project.projectIdx}},
                    success: function (data) {
                        $("#projectMemebersBox").empty();
                        let error = "onerror='this.src=\"resources/images/login/profile.png\"'";
                        $.each(data, function(index, element){
                            let control = "<li class='mt-3'>"
			                				+ "	<img class='rounded-circle' width='40' src='upload/member/"+element.profilePic+"' "+error+"   alt='user'>"
			                				+ " 	<label class='ml-3 text-left' style='width: 250px'> "+element.name+" ( "+element.email+" ) </label>";

               				if(index == 0){
               					control += "<span class='ml-1 roleBadge pm' style='padding-top : 5px;'></span>";
               				}else{
            					control += "<span class='ml-1 roleBadge member' style='padding-top : 5px;'></span>";		
               				}	
               				
               				
               				if("${project.authority}" == 'ROLE_PM'){
               					if(index != 0){
               				control += "<a href='javascript:void(0)' data-toggle='dropdown' id = 'dropdownBtn' aria-haspopup='true' aria-expanded='false' style='float: right'>"; 
               				control +=  "<i class='fas fa-ellipsis-v'></i></a>";
               				control +=  "<div class='dropdown-menu' aria-labelledby='dropdownBtn'>";
               				control +=  "<ul class='list-style-none'>";
               				control +=  "<li class='pl-3'><a href='#' onclick='deleteMember( " +'"'+ element.email+'"'+")'>멤버 퇴출</a></li>";
               				control +=  "<li class='pl-3'><a href='#' onclick='transferAuthority(" +'"'+ element.email +'"'+")'>PM 양도</a></li>";
               				control +=  "</ul>";
               				control += "</div>";
               					}
               				}	 
               				control+= "</li>";
           					$("#projectMemebersBox").append(control);
                         }) 
                    },
                    error: function () {
                        console.log("GetProjectMember error");
                    }
				}) 
              });

            $('#memberEditModal').on('hidden.bs.modal', function(){
                $("#addMemberBox").empty();
               $("#addMemberOk").val("초대 메일 전송");
               $("#addMemberCount").text("0명");
             });
            
            $("#addMemberOk").click(function () {
                let addProjectMembers = [];
                $('.addProjectMembers').each(function(){
                	addProjectMembers.push($(this).val());
                  })

                if(addProjectMembers.length < 1) return;

                $.ajaxSettings.traditional = true;
                $(this).val("초대 메일 전송중...");
                $.ajax({
                    type: "POST",
                    url: "AddProjectMember.do",
                    data: {
                        projectIdx: ${project.projectIdx},
                        projectName: "${project.projectName}",
                        pm : "${member.name}",
                        addProjectMembers: addProjectMembers
                    },
                    success: function (data) {
                        console.log("addMemberOk success");
                        $("#memberEditModal").modal("hide");
                        $("#sendMemberCount").text(addProjectMembers.length);
                        $("#sendMembers").empty();
                        $.each(addProjectMembers, function(){
	                        $("#sendMembers").append("<h5> - "+this+"</h5>")
                         })
                        $("#openJoinProjectMemberModal").click();
                    },
                    error: function () {
                        console.log("addMemberOk error");
                    }
                });
            })    
            
            checkAlarmView();  
        }); 
        
        function setChageView(target) {
            if (target === "dash")
            	setProjectDashBoard();
            else if (target === "calendar")
            	refreshScheduleVisibility();
            else if (target === "kanban"){
                console.log("-----------------칸반 뷰 전환 -------------------");
            	changeKanbanView("list");
                setKanbanData();
            }   
            else if (target === "notice")
                setNoticeData();
            else if (target === "drive")
                setDriveData();
        }

        function setDriveData() {
            console.log("in setDriveData");
            /*  $.ajax({
                    type : "POST",
                    url : "GetDrive.do",
                    data : {projectIdx : ${project.projectIdx}},
                    success : function(data) {
                        console.log("setDriveData success");
                        $("#drive").html(data);
                    }, error : function(){
                    	console.log("setDriveData error");
                    }
                });  */
        }

        function addProjectMember() {
            let addProjectMembers = $('.addProjectMembers').toArray();
            let addEmail = $("#addProjectMemeberEmail").val();
            $("#addProjectMemeberEmail").val("");
            let regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
            if (!addEmail.match(regExp) || addProjectMembers.includes(addEmail)) {
                return;
            }

            $("#addMemberCount").text((addProjectMembers.length+1) + "명");
            let control = "<div class='input-group'>" 
			               + "<input type='hidden' class='addProjectMembers' name='addProjectMembers' value='" + addEmail + "'>" 
			               + "	<div class='form-control'>" 
			               + "		<i class='fas fa-envelope mr-2 iconSizeBig'></i>" + addEmail 
			               + "	</div>" 
			               + "	<div class='input-group-append memberDeleteButton'>" 
			               + "		<span class='input-group-text'><i class='far fa-times-circle font-weight-bold iconSizeBig'></i></span>" 
			               + "	</div>" 
			               + "</div>";
            $("#addMemberBox").prepend(control);

            $(".memberDeleteButton").click(function () {
                $(this).parent().remove();
            })
        }
        // 칸반 --> 

    	    
			
    	    
    	    function closeFn() {
    	      	$("#-99Column").hide();
    	    	$("#-1Column").hide();
    	       }    
 	       function outProject(){
 	 	     if("${project.authority}" == 'ROLE_PM'){
 	 	    		warningAlert("프로젝트 매니저 양도를 먼저해주십시오.");
					return; 
 	 	     } 
	    	  Swal.fire({
 	    		  title: '[${project.projectName}] 탈퇴',
 	    		  text: "정말로 프로젝트에서 나가시겠습니까?",
 	    		  showCancelButton: true,
 	    		  confirmButtonColor: '#3085d6',
 	    		  cancelButtonColor: '#d33',
 	    		  confirmButtonText: '탈퇴',
 	    		  cancelButtonText: '취소'
 	    		}).then((result) => {
 	    		  if (result.value) {
 	 	    		  $.ajax({
 	 	 	    		  	type : "POST",
							url : "OutProject.do",
							data : {projectIdx :  ${project.projectIdx}},
							success : function(data) {
								if(data){
									Swal.fire(
								      '탈퇴 완료',
								      '메인화면으로 이동합니다.',
								      'success'
								    ).then((result)=>{
								    	location.href="Main.do";
								    })
								}else{
									Swal.fire(
								      '탈퇴 실패',
								      '프로젝트 탈퇴 실패하였습니다.',
								      'error'
								    )
								}
							},
							error: function() {
								Swal.fire(
							      '탈퇴 실패',
							      'Your file has been deleted.',
							      'error'
							    )
							}
						})
 	    		  }
 	    		}) 	 	     
 	       }
 	       function deleteMember(memberEmail) {
 	    	  Swal.fire({
 	    		  title: '멤버 퇴출',
 	    		  text: memberEmail + "(을)를 정말로 프로젝트에서 퇴출하겠습니까?",
 	    		  showCancelButton: true,
 	    		  confirmButtonColor: '#3085d6',
 	    		  cancelButtonColor: '#d33',
 	    		  confirmButtonText: '퇴출',
 	    		  cancelButtonText: '취소'
 	    		}).then((result) => {
 	    		  if (result.value) {
 	    	  $.ajax({
 	    		  	type : "POST",
					url : "ExitMember.do",
					data : {projectIdx :  ${project.projectIdx}, email : memberEmail },
					success : function(data) {
						if(data){
							Swal.fire(
						      '멤버 퇴출 완료',
						      'success'
						    ).then((result)=>{
						    	//setChageView("dash");
						    	location.href="Project.do?projectIdx="+ ${project.projectIdx};
						    })
						}else{
							Swal.fire(
						      '삭제 실패',
						      '멤버 퇴출을 실패하였습니다.',
						      'error'
						    )
						}
					},
					error: function() {
						Swal.fire(
					      '삭제 실패',
					      'Your file has been deleted.',
					      'error'
					    )
					}
				})
 	 	    }
 	    })
 	  }
 	       function transferAuthority(memberEmail) {
 	    	  Swal.fire({
 	    		  title: '권한변경',
 	    		  text: "정말로 프로젝트에서 프로젝트 매니저 권한을 양도하겠습니까? 프로젝트 멤버로 권한이 변경됩니다.",
 	    		  showCancelButton: true,
 	    		  confirmButtonColor: '#3085d6',
 	    		  cancelButtonColor: '#d33',
 	    		  confirmButtonText: '확인',
 	    		  cancelButtonText: '취소'
 	    		}).then((result) => {
 	    	if (result.value) {
  	    	  $.ajax({
	    		  	type : "POST",
					url : "TransferAuthority.do",
					data : {projectIdx :  ${project.projectIdx}, email : memberEmail },
					success : function(data) {
						if(data){
							Swal.fire(
						      '권한 변경 완료',
						      'success'
						    ).then((result)=>{
						    //	setChageView("dash");
						    	location.href="Project.do?projectIdx="+ ${project.projectIdx};
						    })
						}else{
							Swal.fire(
						      '권한 변경 실패',
						      '권한 변경을 실패하였습니다.',
						      'error'
						    )
						}
					},
					error: function() {
						Swal.fire(
					      '권한 변경 실패',
					      'Your file has been deleted.',
					      'error'
					    )
					}
				})		
	 	    }
 	   })
 	}	   

 	function checkAlarmView(){
 	 	if(${isAlarm}){
 	 	 	let view = "${view}";
 	 	 	let targetIdx = "${targetIdx}";

 	 	 	if(view == "notice"){
 	 	 		$("#projectMenu li a[href='#notice']").click();
 	 	 		setDetailData(targetIdx);
 	 	 	}else if(view.startsWith("issue")){
 	 	 		$("#projectMenu li a[href='#kanban']").click();
 	 	 		setKanbanDetail(targetIdx);
 	 	 		
 	 	 		if(view == "issueMention")
					$("#kanbanAccordion>a[href='#kanbanCommentBox']]").click();
	 		}
 	 	}
 	}
    </script>
    <style type="text/css">
        .iconSizeBig {
            font-size: 1.2rem;
            line-height: 2rem;
            color: #326295;
        }
    </style>
</head>

<body class="projectBody">
    <!-- LOADER -->
    <div class="preloader">
        <div class="lds-ripple">
            <div class="lds-pos"></div>
            <div class="lds-pos"></div>
        </div>
    </div>

    <div id="main-wrapper">

        <!-- TOP -->
        <jsp:include page="../include/top.jsp" />

        <!-- SIDE BAR -->
        <jsp:include page="../include/sideBar.jsp" />

        <!-- CONTENT BOX -->
        <div class="page-wrapper">
            <!-- CONTENT MAIN -->
            <div class="container-fluid themeChange" style="background-color: white;padding:0" >

                <!-- <div class="row">
					<div class="col-md-12">dfgdfgdsfds
					</div>
				</div> -->
                <div id="tab-menu">
                    <div class="row">
                        <div class="col-md-11">
                            <div id="tab-btn">
                                <ul id="projectMenu" class="nav nav-tabs" role="tablist"
                                    style="border-bottom-width: 0px;">
                                  <li class="nav-item" style="width:auto; margin-left: 10px; margin-right: 10px;">
                                        <a class="nav-link" href="#project" style="font-size: 20px; height: 51.979166px; padding-top: 12px; width: max-content;">${project.projectName}</a>
                                    </li>
                                    <li class="nav-item active">
                                        <a class="nav-link" data-toggle="tab" href="#dash">Dash Board</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#calendar">Calendar</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#kanban">Kanban Board</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#notice">Notice</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" data-toggle="tab" href="#drive">Drive</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="dropdown col-md-1 mt-2 text-center">
                            <a href="javascript:void(0)" data-toggle="dropdown" id="dropdownMenuButton"
                                aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-user-cog iconSizeBig pt-2"></i></a>
                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                <ul class="list-style-none">
                                    <li class="pl-3"><a href="#memberEditModal" data-toggle="modal">프로젝트 멤버 추가</a></li>
                                    <li class="pl-3"><a href="#memberCheckModal" data-toggle="modal">프로젝트 정보 확인</a></li>
                                    <li class="pl-3"><a href="#" onclick="outProject()">프로젝트 탈퇴</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-content">
                    <div class=" tab-pane fade active show" id="dash" role="tabpanel">
                        <!-- 대시보드  -->
                        <jsp:include page="../dashBoard/projectDashboard.jsp" />
                    </div>
                    <div class=" tab-pane fade" id="calendar" role="tabpanel">
                        <jsp:include page="../calendar/projectCalendar.jsp" />
                    </div>
                    <div class=" tab-pane fade" id="kanban" role="tabpanel">
                        <jsp:include page="../kanban/kanban.jsp" />
                    </div>
                    <div class=" tab-pane fade" id="notice" role="tabpanel">
                        <jsp:include page="../notice/notice.jsp" />
                    </div>
                    <div class=" tab-pane fade" id="drive" role="tabpanel">
                        <jsp:include page="../drive/drive.jsp" />
                    </div>
                </div>
            </div>

            <!-- BOTTOM -->
            <jsp:include page="../include/bottom.jsp" />
        </div>

    </div>

    <!-- MODAL -->
    <jsp:include page="modal/memberAdd.jsp" />
    <jsp:include page="modal/joinProjectMember.jsp" />
    <jsp:include page="modal/memberCheck.jsp" /> 
</body>