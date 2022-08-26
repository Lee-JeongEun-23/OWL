<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link href="https://fonts.googleapis.com/css?family=East+Sea+Dokdo|Gamja+Flower|Yeon+Sung&display=swap" rel="stylesheet">
 <link rel="manifest" href="manifest.json"/>
 <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css" rel="stylesheet">
<link href="resources/plugin/emoji/css/emoji.css" rel="stylesheet">
<script src="resources/plugin/emoji/js/config.js"></script>
<script src="resources/plugin/emoji/js/util.js"></script>
<script src="resources/plugin/emoji/js/jquery.emojiarea.js"></script>
<script src="resources/plugin/emoji/js/emoji-picker.js"></script>

<script>
    //const userEmail = "${member.email}";
    //const userName = "${member.name}";
    //console.log(userEmail + "/" + userName);
    $(function () {
    	setEmoji();
		$('#userImgTop').attr("src","upload/member/${member.profilePic}");
		$('#userImgToggle').attr("src","upload/member/${member.profilePic}");
		$("#userNameToggle").text("${member.name}");
		$("#userEmailToggle").text("${member.email}");
		
		$("#userToggle").hide();
		$("#alarmToggle").hide();
		$("#settingToggle").hide();
		$("#chatToggle").hide();

		$("#userBtn").click(function() {
			$("#alarmToggle").hide();
			$("#settingToggle").hide();
			$("#chatToggle").hide();
			$("#userToggle").animate({width:'toggle'},350);
		});

		$("#chatBtn").click(function() {
			$("#userToggle").hide();
			$("#alarmToggle").hide();
			$("#settingtoggle").hide();
		 	$("#chatToggle").animate({width:'toggle'},350);
		});

		$("#alarmBtn").click(function() {
			$("#userToggle").hide();
			$("#chatToggle").hide();
			$("#settingToggle").hide();
			$("#alarmToggle").animate({width:'toggle'},350);
		});

		$("#settingBtn").click(function() {
			$("#userToggle").hide();
			$("#chatToggle").hide();
			$("#alarmToggle").hide();
			$("#settingToggle").animate({width:'toggle'},350);
			
		});	

		
	 $("#settingBtn").on({
		    mouseover: function (event) {
		    	$("#setIcon").addClass("fa-spin");
		    },
		    mouseleave: function (event) {
		    	$("#setIcon").removeClass("fa-spin");
		    }
		});
	$(".clickIcon").click(function() {
		let iconChange = $(this).find(".chevronIcon");
		 if($(iconChange).hasClass("fa-chevron-right")) {
			$(iconChange).removeClass("fa-chevron-right").addClass("fa-chevron-down");
			//$(iconChange).addClass("fa-chevron-down");
		} else {
			$(iconChange).removeClass("fa-chevron-down").addClass("fa-chevron-right");
			//$(iconChange).addClass("fa-chevron-right");
		} 
		
	});

	$("#chatNoticeMoreBtn").click(function() {
		$("#chatNoticeDetail").removeClass("hidden");
		$("#chatNoticePreview").addClass("hidden");
		});
	$("#chatNoticeBackBtn").click(function() {
		$("#chatNoticePreview").removeClass("hidden");
		$("#chatNoticeDetail").addClass("hidden");
		});
	$("#chatUserList").click(function() {
		console.log("채팅방 view");
		$("#chattingRoomIn").removeClass("hidden");
		$("#chattingList").addClass("hidden");
	});
	$("#chatBackBtn").click(function() {
		console.log("백 버튼");
		$("#chattingList").removeClass("hidden");
		$("#chattingRoomIn").addClass("hidden");
		});
	$("#noticeAsideBtn").click(function() {
		if($("#chatNotideAside").hasClass("hidden")) {
		$("#chatNoticeDetail").addClass("hidden");
		$("#chatNotideAside").removeClass("hidden");
		}
		});
	$("#chatNotideAside").click(function() {
		$("#chatNoticePreview").removeClass("hidden");
		$("#chatNotideAside").addClass("hidden");
		});

 	//이슈 컨펌할때, comfirmOk버튼 클릭시

 	$('#comfirmBtn').click(function() {
		$.ajax({
			url:"IssueComfirmfromPM.do",
			data : {issueIdx : $('#comfirmissueIdx').val()},
			success : function(data) {

	        	successAlert("Issue가 추가되었습니다.");
	        	$('#confirmIssueModal').modal("hide"); //닫기 
				
			},error : function() {
				console.log('error');

			}
			})
		});


 	//이슈 컨펌할때, reject버튼 클릭시
	$('#rejectBtn').click(function() {

		$.ajax({
			url : "IssueRejectfromPM.do",
			data : {'rejectreason' : $('#rejectreason').val(), 'issueIdx' : $('#comfirmissueIdx').val()},
			success : function(data) {

				successAlert("Issue가 반려되었습니다.");
	        	$('#confirmIssueModal').modal("hide");

        	    sendNoticePushToOne($('#comfirmCreator').text(), $('#comfirmTitle').text()+ "이슈생성은", "PM이 거절 하였습니다.")
	        	pushNoticeToOne($('#projectissueIdx').val(),$('#projectName').val(), $('#comfirmTitle').text()+ " 이슈가 반려되었습니다.", "kanbanIssueToPm", $('#comfirmCreator').text(), $('#comfirmissueIdx').val(), "tomember");

			},error : function() {
				console.log('IssueRejectfromPM error');
				}
			});
		});
	



	$('#confirmIssueModal').on('hidden.bs.modal', function(e){
		$('#rejectreason').val("");
	});
	
	
	}); // $function () 끝

	function setEmoji(){
	    window.emojiPicker = new EmojiPicker({
	        emojiable_selector: '[data-emojiable=true]',
	        assetsPath: 'resources/plugin/emoji/img/',
	        popupButtonClasses: 'fa fa-smile-o'
	      });

	      window.emojiPicker.discover();
	}
	
	function Search(){
		$('.ChatList').empty();   
		var plus = "";
		plus += "<input type='text' id='searchChat' style='width: 75%; height:30px; float:left; margin-top: 10px;'>&emsp; <span style='cursor:pointer;' onclick='Cancle()'><i class='fas fa-times'></i></span>";
		plus += "<a href='#' data-toggle='modal' data-target='#newChat' style='float: right;'>&emsp;<i class='fas fa-comment-medical'></i>&emsp;</a>";
		$('.ChatList').append(plus);
	}

	function Cancle(){
		$('.ChatList').empty();   
		var plus = "";	
		plus += "<a href='#' data-toggle='modal' data-target='#newChat' style='float: right;'><i class='fas fa-comment-medical'></i>&emsp;</a>";
		plus += "<span id='searchChatname' onclick='Search()'><i class='fas fa-search'></i>&emsp;</span><br>";
		$('.ChatList').append(plus);
	}

	
	//알람 이슈체크 이슈 컨펌할때 모달창 띄우는 함수 
	function comfirmIssueModal(issueidx, projectName, flag) {

		$.ajax({
			url : "GetIssueDetail.do",
			type: "POST",
			data : {issueIdx : issueidx},
			success : function(data) {
				console.log('!!!!!!!!!!!!!!!!!');
				console.log(data);
				let labelname = '<span class="badgeIcon float-left" style="background-color: '+data.labelColor+'">'+data.labelName+'</span>';
				let files = "  ";
				
 				$.each (data.files, function(index, element) {
					files += element.fileName + "  ";
				}); 

				$('#comfirmTitle').text(data.issueTitle);
				$('#comfirmIdx').html('<input type="hidden" id="comfirmissueIdx" value="'+data.issueIdx+'"><input type="hidden" id="projectissueIdx" value="'+data.projectIdx+'"><input type="hidden" id="projectName" value="'+projectName+'">');		
				$('#comfirmTitle').text(data.issueTitle);
				$('#comfirmContent').html(data.content);
				$('#comfirmCreator').text(data.creator);
				$('#comfirmAssignee').text(data.assigned);
				$('#comfirmFilename').html(files);
				$('#comfirmLabel').html(labelname);
				$('#comfirmPriority').text(data.priorityCode);
				$('#comfirmDuedate').text(data.dueDate); 
				
 				if(flag == "tomember") {
					$('#rejectreason').addClass("hidden");

					$.ajax({
						url : "GetcomfirmReason.do",
						data : {issueIdx : $('#comfirmissueIdx').val()},
						success : function(data) {
							console.log('GetcomfirmReason in');
							console.log(data);
						$('#rejectreasonadd').text(data);
						$('#comfirmBtn').hide();
						$('#rejectBtn').hide();
						
						},error : function() {
						console.log('error in');
						
						}
						
					});
				};
			}
		
		});
	
	}
</script>
<style>

ul {
display: block;
}

.grade1 {
	z-index :10;
}
.hrGray {
	color : #b7babd;
}

.iconMargin {
	margin-right: 17px;
}

.coloricon {
	padding: 15px;
	width: 25px;
	height: 25px;
	margin-right: 10px;
	border: 2px solid #BDBDBD;
	border-radius: 5px;
	cursor : pointer;
}

.whiteColor {
	color: #fff;
}

.whieColor:hover {
	color: #fff;
}

.setting-box {
	margin-top: 20px;
	font-family: 'Noto Sans KR', sans-serif;
}


  .toggleOption {
	margin-right:0px;
 	margin-top:697px;
	background: #326295;
	height: 2081%;
	width: 310px;
	position: absolute;
	right:0;
	z-index : -20;
} 


#userImg, .coloricon {
	border: 3px solid #fcf9f5;
	box-shadow: 1px 1px 1px 1px #BDBDBD;
}

#userImg:hover, .coloricon:hover {
	border: 3px solid #BDBDBD;
}

#settingToggle, #alarmToggle, #chatToggle, #userToggle {
	padding-left: 1%;
	padding-right: 1%;
}


.chat_list-group-item {
  position: relative;
  display: block;
  padding: 0.75rem 1.25rem;
  margin-bottom: -1px;
  background-color: #fff;
  border: 1px solid rgba(0, 0, 0, 0.125); 

}


.chat_list-group-item:first-child {
    border-top-left-radius: 0.25rem;
    border-top-right-radius: 0.25rem;
}

.chat_list-group-item:last-child {
    margin-bottom: 0;
    border-bottom-right-radius: 0.25rem;
    border-bottom-left-radius: 0.25rem;
}

.chat_list-group-item-action {
  width: 100%;
  color: #495057;
  text-align: inherit; }

.chat_img {
	width: 42px;
	height: 42px;
	border: 3px solid #fcf9f5;
	box-shadow: 1px 1px 1px 1px #BDBDBD;
	margin-top : 10px;
	margin-right: 10px;
}

.media {
  display: flex;
  align-items: flex-start; }
	
	
.h5{
    margin-bottom: 0.5rem;
    font-family: inherit;
    font-weight: 700;
    line-height: 1.2;
    color: inherit;
}


#searchChat {
	border-right: 0px;
	border-top: 0px;
	boder-left: 0px;
	boder-bottom: 3px solid #326295;
	background-color: rgba(255, 255, 255, 0);
	border-left-width: 0px;
	color: #326295;
}

#searchChatname {
	cursor: pointer;
	float: right;
}

#searchChatname:hover {
	color: #326295;
}

#chatTitle img {
	margin-top: 10px;
	width: 40px;
	height: 40px;
	margin-right: 10px;
}


.media h5 {
	font-size: 15px;
	font-weight: bold;
}


.custom-menu {
	z-index: 1000;
	position: absolute;
	padding: 2px;
	background-color: #f0f3f7;
	text-align: center;
}


.activity {
	height: 15px;
	width: 15px;
	border-radius: 50%;
	display: inline-block;
	position: absolute;
	border: 3px solid #fff;
	bottom: .4rem;
	right: 0rem;
	padding: 0;
	background-color: #326295; /*#ff763b*/
	left: 30px;
	top: 37px;
}

.activity.off {
	background-color: lightgrey;
}
.accordionBody {  
	max-height: 650px; 
	overflow: auto;
}
.top_card {
	border-radius: 0.25rem;
}
/* 채팅방  css */
.chatImgBorder {
	border: 2px solid #BDBDBD;
}
.chatbg{
	background-color: #326295 !important;
}
#chatBackBtn:hover{
	cursor: pointer;
}
.ownBubble {
	border-radius: 16px 16px 0 16px;
}
.otherBubble {
	border-radius: 16px 16px 16px 0;
	background-color: #dbd9d9 !important;
}

.notiBadge{
    font-weight: 400;
    padding: 0.35em 0.45em;
    display: inline-block;
    padding: 0.25em 0.4em;
    font-size: 75%;
    font-weight: 700;
    line-height: 1;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    border-radius: 0.25rem;
    color: black;
    height: 1.25rem;
    width: 1.25rem;
    line-height: 0.875rem;
    font-size: 0.75rem;
    position: absolute;
    right: 4px;
    top: 10px;
}
.notiBadge-pill{
	padding-right: 0.6em;
    padding-left: 0.6em;
    border-radius: 10rem;
}
.gradient-1  {
   background-color: #a5c5e8;
   color : white;
}
.emoji-wysiwyg-editor{
	height: 50px !important;
}
</style>


<header class="topbar" data-navbarbg="skin5">
<input id="curUserEmail" type="hidden">
    <nav class="navbar top-navbar navbar-expand-md navbar-dark">
        <div class="navbar-header">
            <!-- This is for the sidebar toggle which is visible on mobile only -->
            <a class="nav-toggler waves-effect waves-light d-block d-md-none" href="javascript:void(0)"><i class="ti-menu ti-close"></i></a>
            <!-- ============================================================== -->
            <!-- Logo -->
            <!-- ============================================================== -->
            <a class="navbar-brand" href="Index.do">
                <!-- Logo icon -->
                <b class="logo-icon p-l-10">
                    <!--You can put here icon as well // <i class="wi wi-sunset"></i> //-->
                    <!-- Dark Logo icon -->
                    &nbsp;<img src="resources/images/logo_dj.png" alt="homepage" class="light-logo" style="margin-bottom: 10px;"/>
                   
                </b>
                <!--End Logo icon -->
                 <!-- Logo text -->
                <span class="logo-text">
                     <!-- dark Logo text -->
                     <img src="resources/images/OWL_LOGO_BEIGE.png" alt="homepage" class="light-logo" />
                    
                </span>

            </a>
            <!-- ============================================================== -->
            <!-- End Logo -->
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- Toggle which is visible on mobile only -->
            <!-- ============================================================== -->
            <a class="topbartoggler d-block d-md-none waves-effect waves-light" href="javascript:void(0)" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><i class="ti-more"></i></a>
        </div>
        <!-- ============================================================== -->
        <!-- End Logo -->
        <!-- ============================================================== -->
        <div class="navbar-collapse collapse grade1" id="navbarSupportedContent" data-navbarbg="skin5">
            <!-- ============================================================== -->
            <!-- toggle and nav items -->
            <!-- ============================================================== -->
            <!-- Hamburger Icon -->
            <ul class="navbar-nav float-left mr-auto">   
                <li class="nav-item d-none d-md-block">
                	<a class="nav-link sidebartoggler waves-effect waves-light" href="javascript:void(0)" data-sidebartype="mini-sidebar">
                		<i class="mdi mdi-menu font-24"></i>
                	</a>
                </li>
            </ul>
            
            <!-- ============================================================== -->
            <!-- Right side toggle and nav items -->
            <!-- ============================================================== -->
            <ul class="navbar-nav float-right">

                <!-- User profile and search -->
                <!-- ============================================================== -->
                <li class="nav-item iconMargin">
                    <a class="nav-link text-muted waves-effect waves-dark pro-pic" href="javascript:void(0)" id="userBtn">
                    	<img id="userImgTop" onerror="this.src='resources/images/login/profile.png'" height="35" width="35" alt="" style="border-radius:50%;">
                    </a>
                </li>
               
                  <!-- Chatting Icon -->
                 <li class="nav-item iconMargin">
                  <a class="nav-link waves-effect waves-dark" href="javascript:void(0)" id="chatBtn"> 
                   	 	<i class="far fa-comment fa-lg"></i>
                    </a>
                </li>
                
                <!-- Alarm Icon -->
                <li class="nav-item iconMargin">
                    <a class="nav-link waves-effect waves-dark" href="javascript:void(0)" id="alarmBtn" > 
                    	<i class="far fa-bell fa-lg"></i>
                    	<!-- 알람 숫자 notification badge  -->
                    	<span id="numOfNotice" class="notiBadge notiBadge-pill gradient-1">0</span>
                    </a>
                </li>
                

            </ul>
            
            
            <!-- toggle content Start-->
            <!-- user toggle  -->
			<div class="toggleOption " id="userToggle"  style="padding-top: 0px;">
				<div class="text-center setting-box mt-5">
					<div class="user-img c-pointer position-relative">
					<a href="#" data-toggle="modal" data-target="#myProfileSetModal">
						<img id="userImgToggle" onerror="this.src='resources/images/login/profile.png'" class="rounded-circle" alt="" id="userImg" height="100" width="100">
						</a>
					</div>
					<h4 id="userNameToggle" class="mt-3 mb-1 " style="color:white; padding-top: 10px;"></h4>
					<p id="userEmailToggle" class="mt-2 whiteColor"></p>
				</div>
				<hr>
				<div class="text-center setting-box">
					
					<a href="Logout.do" class="whiteColor"><i class="icon-key"></i> <span>Logout</span></a>
					
				
				</div>
			</div>
			
			<!-- 채팅 목록 토글 -->
			<div class="toggleOption" id="chatToggle" style="padding-top: 0px; z-index: -20;">

				
				<div class="setting-box" id="chattingList">
					<div class="ChatList" style="margin-top : 30px"> 
					<a href="#" data-toggle="modal" data-target="#newChat" style=" float: right;" class="whiteColor" onclick="setAddUserList()">
						<i class="fas fa-comment-medical fa-lg"></i>&emsp;</a>					
					<span class ="whiteColor" id="searchChatname" onclick="Search()"><i class="fas fa-search fa-lg"></i>&emsp;</span>
				<br>
				</div>
				<hr>
					 <ul class="list-group" id="ulRoomList">
                         <li class="chat_list-group-item chat_list-group-item-action flex-column align-items-start chatList"  style="height: 106px;">           
                       </li>
						<li class="chat_list-group-item chat_list-group-item-action flex-column align-items-start"  style="height: 106px;">                                
                       </li>
                       <li class="chat_list-group-item chat_list-group-item-action flex-column" style="height: 106px;" id="chatroom" >					                                             
                       </li> 	       
                    </ul>
                    <!-- 채팅 유정 목록 유엘 끝 -->
				</div>	
				
				<!--  채팅방 view -->	
			<div class="setting-box hidden" id="chattingRoomIn">
					 <ul class="list-group">
                         <li class="chat_list-group-item chat_list-group-item-action flex-column align-items-start" style="height: 665px;">
             				<div class="row">
             					<div class="text-left">
             						<a class="" href="javascript:void(0)" id="chatBackBtn"> 
    									<i class="fas fa-chevron-left font-22 ml-1" >
    									</i>
    								</a>
    							</div>
    							<div class="col-10">
    								<div class="text-center">
    								<h5 id="roomTitle" class="d-inline">Family_c</h5>
    								<h4 class="text-muted d-inline ml-2">(5)</h4>
    								</div>
    							</div>
    							<!-- style="right:12px;top:0px; position: absolute;"  -->
    							<div class="dropdown" style="right:12px;top:0px; position: absolute;"> 
    							<a href="javascript:void(0)" data-toggle="dropdown" id="dropdownChatButton" aria-haspopup="true" aria-expanded="false" style="float:right">
    							<i class="mdi mdi-menu font-24 mt-1" style="right:0px;top:0px; position: absolute;"></i></a>
    							<div class="dropdown-menu  dropdown-menu-right" aria-labelledby="dropdownChatButton">
						       	<ul class="list-style-none">
								     <li class="pl-3"><a href="#" onclick="leaveRoom()">나가기</a></li>
								</ul>
								</div>
								 </div> 
   							</div>
   								<hr>
                                <div id="chatBox" class="chat-box scrollable" style="height:510px;">
                                    <!--chat Row -->
                                    <ul id ="ulMessageList" class="chat-list" style="overflow: auto;">
                                    <!--chat Row -->
                                    <!-- background-color: #dbd9d9;  -->
                                    
                                    <!--  채팅 미리보기 공지 -->
                                        <li class="chat-item mt-0" style="padding:10px; background-color: rgba(219, 217, 217, 0.5); " id="chatNoticePreview">
                                           <div class="row">
                                           <div class="col-11 pr-0">
                                               <div class="chat-img"> <i class="fas fa-bullhorn btn-circle" style="background-color: #326295;color: white;padding-top: 12px;padding-left: 12px;"></i>
                                                	</div>	
                                                	 <div class="chat-content pl-0" style="max-height: 42px; overflow: hidden">
                                                	축 콜린 장가 가는 날  식장은 복정역 날짜는 2월 22일입니다. 기쁜자리에 함께해주시길바랍니다.
                                                	</div>
                                                	</div>
                                                	<div class="col-1 p-0">
                                                	<i class="fas fa-chevron-down font-20" style="padding-top:12px;" id="chatNoticeMoreBtn"></i>
                                                	</div>	
                                           </div>	
                                        </li>
                                         <!--  채팅 공지 자세히보기  -->
                                        <li class="chat-item mt-0 pb-0  hidden" style="padding:10px; background-color: rgba(219, 217, 217, 0.5); " id="chatNoticeDetail">
                                           <div class="row">
                                           <div class="col-11 pr-0">
                                               <div class="chat-img"> <i class="fas fa-bullhorn btn-circle" style="background-color: #326295;color: white;padding-top: 12px;padding-left: 12px;"></i>
                                                	</div>	
                                                	 <div class="chat-content pl-0">
                                                	축 콜린 장가 가는 날  식장은 복정역 날짜는 2월 22일입니다. 기쁜자리에 함께해주시길 바랍니다.
                                                	</div>
                                                	</div>
                                                	<div class="col-1 p-0">
                                                	<i class="fas fa-chevron-up font-20" style="padding-top:12px;" id="chatNoticeBackBtn"></i>
                                                	</div>	
                                           </div>
                                             <div class="row text-center" style="border-top: 1px solid  #BDBDBD">
                                           <div class="col-6" style="border-right:1px solid  #BDBDBD;padding:6px;">다시 열지 않음</div>
                                           <div class="col-6" style="padding:6px;" id="noticeAsideBtn">접어두기</div>
                                           </div>	
                                        </li>
                                        <!--  채팅방 공지 접어두기 -->  
                                        
                                         <div class="chat-img hidden" id="chatNotideAside"style="position: absolute;right:0; top:0"> <i class="fas fa-bullhorn btn-circle op-5" style="background-color: #326295;color: white;padding-top: 12px;padding-left: 12px;"></i>
                                               </div>
                                          
                                        <!--chat Row -->
                                        <!-- <li class="chat-item" style="margin-top:10px;">
                                            <div class="chat-img"><img src="resources/images/user/group.png" alt="user" class="chatImgBorder"></div>
                                            <div class="chat-content pl-2 ">
                                                <h6 class="font-medium">콜린</h6>
                                                <div class="box bg-light-info otherBubble">저 장가갑니다. 축하해주세요.</div>
                                            </div>
                                            <div class="chat-time">10:56 am</div>
                                        </li>
                                        chat Row
                                        <li class="chat-item" style="margin-top:10px;">
                                            <div class="chat-img"><img src="resources/images/user/group.png" alt="user" class="chatImgBorder"></div>
                                            <div class="chat-content pl-2">
                                                <h6 class="font-medium">이정은</h6>
                                                <div class="box bg-light-info otherBubble">아악 콜린 축하해요!!!</div>
                                            </div>
                                            <div class="chat-time">10:57 am</div>
                                        </li>
                                        chat Row
                                        <li class="odd chat-item" style="margin-top:10px;">
                                            <div class="chat-content">
                                                <div class="box bg-light-inverse chatbg ownBubble">그래서 날짜는 언제인가요?</div>
                                                <br>
                                            </div>
                                            <div class="chat-time">10:59 am</div>
                                        </li> -->
                                    </ul>
                               </div>	
 							<div class="card-body border-top p-0">
                                <div class="row">
                                    <div class="col-9">
                                        <div class="input-field m-t-0 m-b-0" >
	                                         <p class="lead emoji-picker-container mt-0">
	                                        	<textarea class="form-control border-0 mb-0 mt-2" id="textarea1"  data-emojiable="true"  placeholder="메시지를 입력해주세요"></textarea>
	                  						 </p>
                                        </div>
                                    </div>
                                    <div class="col-3">
                                        <a class="btn-circle btn-md btn-cyan float-right text-white chatbg mt-2" href="javascript:void(0)" onclick="saveMessages()"><i class="fas fa-paper-plane"></i></a>
                                    </div>
                                </div>
                            </div>
                       </li>
                    </ul>
                    <!-- 채팅 유정 목록 유엘 끝 -->
              </div>
		</div>
		
					<!--  알람 토글  -->
			<div class="toggleOption" id="alarmToggle"  style="padding-top: 0px;">
					
					<div class="setting-box">
				        <div class="card top_card ">
                            <div class="card-body" style="padding:20px;">
                                <div id="accordion-three" class="accordion">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 id="noticeAccordion" class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseOne4" aria-expanded="false" aria-controls="collapseOne4">공지사항 <span id="numOfNoticeBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i>
                                            </h5>
                                        </div>
                                        <div id="collapseOne4" class="collapse" data-parent="#accordion-three" data-from="notice" style="line-height:2em;">
                                            <div class="card-body pt-3 accordionBody" id="noticeBoard">
                                            <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">구매계획</span>
                                            	프로젝트 기간이 연장되었습니다. <span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div>
                                           
                                           -->
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseTwo5" aria-expanded="false" aria-controls="collapseTwo5">드라이브 <span id="numOfDriveBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseTwo5" class="collapse" data-parent="#accordion-three" data-from="drive" style="line-height:2em;">
                                            <div id="driveBoard" class="card-body pt-3 accordionBody">
                                            <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">구매계획</span>
                                            	'file.jpg'파일이 업로드 되었습니다. <span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div> -->
                                            
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseThree6" aria-expanded="false" aria-controls="collapseThree6">이슈 <span id="numOfIssueBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseThree6" class="collapse" data-parent="#accordion-three" data-from="KanbanIssue" style="line-height:2em;">
                                            <div id="issueBoard" class="card-body pt-3 accordionBody">
                                            <!-- <div class="mt-2 col-md-12"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">구매계획</span>
                                            	'[view]로그인 view 구현' 이슈가 등록되었습니다.<span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div>
                                            <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                             <span class="badge badge-primary badge-pill mr-1" style="background-color: red; font-size:13px; color: black;">PM</span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">구매계획</span>
                                            	칸반보드 view 구현'이슈가 승인 요청을 있습니다. <span class="ml-1"><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                             </div> -->
                                 
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseThree7" aria-expanded="false" aria-controls="collapseThree7">멘션 <span id="numOfMentionBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseThree7" class="collapse" data-parent="#accordion-three" data-from="mention" style="line-height:2em;">
                                            <div id="mentionBoard"class="card-body pt-3 accordionBody">
                                             <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">구매계획</span>
                                            	배인영님이 언급하였습니다. 
                                            	<span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div> -->
                                            </div>
                                        </div>
                                    </div>
                                    
                                   <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseThree8" aria-expanded="false" aria-controls="collapseThree7">이슈체크 <span id="numOfCheckBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseThree8" class="collapse" data-parent="#accordion-three" data-from="mention" style="line-height:2em;">
                                            <div id="issueCheckBoard" class="card-body pt-3 accordionBody">
                                             <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">구매계획</span>
                                            	배인영님이 언급하였습니다. 
                                            	<span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div> -->
                                            </div>
                                        </div>
                                    </div>
                                    
                                    
                                    
                                </div>
                            </div>
                        </div>
                     </div>	
				</div>  
		
	
			
        </div>
        
    </nav>
</header>

      
      <!-- <script type="text/javascript" src="resources/js/underscore-min.js"></script> 언더스코어 제이에스는 태그정보를 뷰단에 어펜드할 때 편리하다-->          
	<!-- The core Firebase JS SDK is always required and must be listed first -->
	<script src="https://www.gstatic.com/firebasejs/7.6.2/firebase-app.js"></script>     
      <!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#available-libraries -->
	<script src="https://www.gstatic.com/firebasejs/7.6.2/firebase-analytics.js"></script>	
	<!-- firebase database -->
	<script src="https://www.gstatic.com/firebasejs/7.6.2/firebase-database.js"></script>
	<!-- firebase cloud store... for uploading and downloading large object -->
	<script src="https://www.gstatic.com/firebasejs/7.6.2/firebase-firestore.js"></script>
	<!-- firebase cloud messaging... for sending notification -->
	<script src="https://www.gstatic.com/firebasejs/7.6.2/firebase-messaging.js"></script>
 <script>
//Your web app's Firebase configuration
 var firebaseConfig = {
   apiKey: "AIzaSyCUWhwHawfZnngksqB7RstHZJVC_fQloeg",
   authDomain: "owl-chat-c27f1.firebaseapp.com",
   databaseURL: "https://owl-chat-c27f1.firebaseio.com",
   projectId: "owl-chat-c27f1",
   storageBucket: "owl-chat-c27f1.appspot.com",
   messagingSenderId: "626219367568",
   appId: "1:626219367568:web:84d90164e32b237822ac15",
   measurementId: "G-7FX553N3RH"
 };
 // Initialize Firebase
 firebase.initializeApp(firebaseConfig);
 firebase.analytics();
 
//Get a reference to the database service
 const database = firebase.database();
//푸시 알람을 위한 변수 설정..
const messaging = firebase.messaging();

messaging.usePublicVapidKey("BFnhctOfkdVv_GNMgVeHgA0C2n1-wJTGCLV_GlZDhpTMNvqAE-SY8pdtyT6NREqxgdSRR44x_SWjZYTZNEWY8n0");


	
      //채팅기능을 위한 유저 기본 정보(이름,이메일,프로필사진) 글로벌 변수에 저장
      const curName = "${member.name}";
      const curEmail = "${member.email}"; 
      const curProfilePic = "${member.profilePic}";
	  
      //파이어베이스에 데이터 저장을 위한 글로벌 변수 초기화
      const SPLIT_CHAR = '@spl@'; //채팅방에 여러 유저의 이름 혹은 유저 키값을 저장할 대 사용되는 구분자.
      var roomFlag; //유저가 참여하고 있는 채팅방의 상태를 저장하긴 위한 플래그
		var roomUserList; // 챗방 유저리스트  			
		var roomUserName; // 챗방 유저 이름 
		var roomId;		//채팅방에 부여되는 아이디
		var roomTitle; 	//채팅방 제목
    	  
      console.log("현재 접속중인 유저 정보" + curName+"/"+curEmail+"/"+curProfilePic);

      
   
          
        
          
		 
        //웹의 경우 firebase messaging 을 이용한 푸시 알람을 이용할 경우.. 먼저 유저의 권한을 얻어야 한다. 권한을 얻기 위한 함수..
		var setCloudMessaging = function () { 
			//메세징 			
			messaging.requestPermission() 
			.then(function(){ 
				console.log('메세징 권한 획득'); 
				return messaging.getToken(); 
				}) 
				.then(function(token){ 
					console.log('fcm token : ', token); 
					})				
					.catch(function(e){ 
						console.log('메세징 권한 획득 중 에러', e); 
						}); 
			}


		//푸시 알람 을 위한 권한 설정 처리... 온로드 함수 들 보다 먼저 실행 되게 하기 위해 다큐먼트 점 레디로 걸어 났다.
		$(document).ready(setCloudMessaging());
			
		var saveFCMToken = function(){ 
			//로그인 후에 fcm 정보를 검색하여 저장 
			console.log("token 파베 디비 저장 함수.....");
			var cbGetToekn = function(token){ 
				console.log('setLogin fcmId get : ', token);				
				var userUid = curUserKey; 
				var fcmIdRef= database.ref('FcmId/' +userUid); 
				fcmIdRef.set(token); 
				} 
			firebase.messaging().getToken() 
			.then(cbGetToekn.bind(this)) 
			.catch(function(e){ 
				console.log('fcmId 확인 중 에러 저장실패... : ', e); 
				}) 
			}
		messaging.onMessage((payload) => {
			  console.log('Message received. ', payload);
		});

		
		   
		// This registration token comes from the client FCM SDKs.
		var registrationToken = 'cFNEXcwYabMl48AAxV0ES_:APA91bFbrquzfvQpyI0bplrs7Pl7KeuNLPxiOIYBldokpJA8PfJ0RJLeTx5imgIBNYaNCfwRwPJO--ibXkL8BcDuVqisRtXhQpmznYtyis58LFFpk-P-X5jy3EbXf-V44elGUJ2bDl0r';




        
		
		function sendNotification(msgTo, title, msg){			
		        $.ajax({
		                 type : 'POST',
		                 url : "https://fcm.googleapis.com/fcm/send",
		                 headers : {
		                     Authorization : 'key=' + 'AAAAkc2VPJA:APA91bHuIlRWU1_zwByAErvgVTu4fSJmxlOOYFwXv6hoRbiQcV1iQDTcbL278aQstA_wXFpO5JbGh_-3OvD8HHmv1-4VBiWSqVwNd-xGWpHdUCLqMiXgfKY5zt5Dbfh-IHws4JB4KNXT'
		                 },
		                 contentType : 'application/json',
		                 dataType: 'json',
		                 data: JSON.stringify({"to": msgTo,  "priority" : "high", "notification": {"title": title,"body":msg}}),
		                 success : console.log("sendNotification Success"),
		                 error : console.log("sendNotification Fail") 
		             }) ;
			}

			
		function sendNoticePushAll(rawtitle, rawMsg, currentProjectIdx) {
			var msg = myConvertMsg(rawMsg);
			var title = "<공지사항>" + rawtitle;
			$.ajax({
					url: "MyProjectsMatesFull.do",
					type: "POST",
					dataType: 'json',
					data : { email : curEmail
						      }, 
					success: function (data) {
					    var projectIdxGrouped = new Set();				    
						$.each(data, function(index, value) {          									
						  if(value.projectIdx == currentProjectIdx){							 					  
							  var userKey;							  							  
							 var myRootRef = database.ref();
				        	  myRootRef.child("Emails").orderByChild('email').equalTo(value.email).once('value', function(data){
				        		  data.forEach(function(childSnapshot) {
										userKey = childSnapshot.key;										
										database.ref("FcmId/"+userKey).once('value',fcmSnapshot => { 											
											var mytoken = fcmSnapshot.val();											
											sendNotification(mytoken, title, msg);
										});
			       		 		});
				        	  })		      
						  }	
						});				
					},
					error: function(xhr, status, error){
				         var errorMessage = xhr.status + ': ' + xhr.statusText
				         alert('Error - ' + errorMessage);
				     } 
				});
		}




		function sendNoticePushToOne(email, title, rawMsg) {
				var msg = myConvertMsg(rawMsg);
				var myRootRef = database.ref();
				myRootRef.child("Emails").orderByChild('email').equalTo(email).once('value', function(data){
				data.forEach(function(childSnapshot) {
					userKey = childSnapshot.key;
					database.ref("FcmId/"+userKey).once('value',fcmSnapshot => { 
							const mytoken = fcmSnapshot.val();
							sendNotification(mytoken, title, msg);
						});
			       });
				})		      					
		   }


		//탑 부분 종 누르면...   공지 사항 보이기~~
		function pushNoticeToAll(projectIdx, projectName, title, from, targetIdx) {
			var noticeRef = database.ref('Notice/'+ projectIdx);
			var noticeRefKey = noticeRef.push().key	
			// 수정중
			//노티스 정보 파베 저장	
			database.ref('Notice/' + projectIdx+'/'+ noticeRefKey).update({
				projectIdx: projectIdx,
        	    projectName: projectName,
        	    title: title,
        	    creatFrom: from,
        	    targetIdx : targetIdx
        	  });
      	  	//노티즈 정보를 유저별 저장
			saveNoticeByUser(noticeRefKey, projectName, title, projectIdx, from, targetIdx);
		}

		function pushNoticeToOne(projectIdx, projectName, title, from, pmemail, targetIdx, msg) {
			var noticeRef = database.ref('Notice/'+ projectIdx);
			var noticeRefKey = noticeRef.push().key;	

			//노티스 정보 파베 저장	
			database.ref('Notice/' + projectIdx+'/'+ noticeRefKey).update({
				projectIdx: projectIdx,
        	    title: title,
        	    creatFrom: from,
        	    targetIdx : targetIdx,
        	    msg : msg
        	  });
      	  	//노티즈 정보를 유저별 저장
			saveNoticeByUserForOne(noticeRefKey, projectName, title, projectIdx, from, pmemail, targetIdx, msg);
		}


		function saveNoticeByUserForOne(noticeRefKey, projectName, title, projectIdx, from, email, targetIdx, msg){
			var myRootRef = database.ref();
      	    myRootRef.child("Emails").orderByChild('email').equalTo(email).once('value', function(data){
      		  data.forEach(function(childSnapshot) {
						userKey = childSnapshot.key;						
						//유저별 노티스 저장
						database.ref('NoticesByUser/'+ userKey +'/' + noticeRefKey).update({
							projectIdx: projectIdx,
			        	    title: title,
			        	    readOk : 'false',
			        	    creatFrom: from,
			        	    targetIdx : targetIdx,
			        	    msg : msg
			        	  });;
 		 		});
      	      })

			}

		function saveNoticeByUser(noticeRefKey, projectName, title, projectIdx, from, targetIdx) {
			$.ajax({
				url: "MyProjectsMatesFull.do",
				type: "POST",
				dataType: 'json',
				data : { email : curEmail }, 
				success: function (data) {
				    var projectIdxGrouped = new Set();
				    
					$.each(data, function(index, value) {          				
					  console.log(value);
					  console.log("풀리스트" +value.name + " / " + value.email + " / " + value.profilePic + " / " + value.projectIdx);
					  console.log(value.projectIdx);
					  console.log(projectIdx);
					  if(value.projectIdx == projectIdx){

						  var userKey;
						  
						  //프로젝트 내에 각 유저별 노티스 정보 파베 저장
						 var myRootRef = database.ref();
						 
			        	  myRootRef.child("Emails").orderByChild('email').equalTo(value.email).once('value', function(data){
			        		  data.forEach(function(childSnapshot) {
									userKey = childSnapshot.key;
									//유저별 노티스 저장
									database.ref('NoticesByUser/'+ userKey +'/' + noticeRefKey).update({
										projectIdx: projectIdx,
						        	    title: title,
						        	    readOk : 'false',
						        	    creatFrom: from,
						        	    targetIdx : targetIdx
						        	  });
		       		 		});
			        	  })		      
					  }	
					});				
				},
				error: function(xhr, status, error){
			         var errorMessage = xhr.status + ': ' + xhr.statusText
			         alert('Error - ' + errorMessage);
			     } 
			});

			}

			function loadPushNotice(curUserKey){				        
	              var noticesByUserRef = database.ref('NoticesByUser/'+ curUserKey);
             
	                 document.getElementById('noticeBoard').innerHTML = ''; //공지사항 화면 리셋                 
	                 document.getElementById('issueBoard').innerHTML = ''; //이슈 화면 리셋 
	                 document.getElementById('driveBoard').innerHTML = ''; //드라이브 화면 리셋
	                 document.getElementById('mentionBoard').innerHTML = '';//멘션 화면 리셋
	                 document.getElementById('issueCheckBoard').innerHTML = '';//이슈체크 화면 리셋


	                 
	                 noticesByUserRef.off(); 
	                 
					var checkRead = function(data){
						console.log("노티스 밸류는??", data);
						var noticeKey =data.key;						
						var noticeValue = data.val(); 		

						noticeListUp(noticeKey, noticeValue);
						} 
					noticesByUserRef.on('child_added', checkRead.bind(this)); 
					//noticesByUserRef.on('child_changed', checkRead.bind(this)); 

				}

			function deleteNoticeTop(event){
				console.log("sdfsdfsdfsdf" + event.parentElement.getAttribute("data-noticeKey"));
				var noticeKey = event.parentElement.getAttribute("data-noticeKey");
				
				database.ref('NoticesByUser/'+ curUserKey +'/' + noticeKey).remove();

				loadPushNotice(curUserKey);

				}


			function numOfNotreadNotices(curUserKey){				
                
	              var noticesByUserRef = database.ref('NoticesByUser/'+ curUserKey);

	             console.log("curUserKey" + curUserKey);
	             
					noticesByUserRef.orderByChild('readOk').equalTo('false').once('value', function(data){
						var numOfNotice = data.numChildren(); 
						$('#numOfNotice').html(numOfNotice);
						
						
						});

					
					noticesByUserRef.orderByChild('creatFrom').equalTo('notice').once('value', function(data){					
						var numOfUnread = 0;						
						data.forEach(function(childsnapshot){
							var childVal = childsnapshot.val();                               
                                if(childVal.readOk == 'false'){
                                	numOfUnread++;
                                    }
							})
						$('#numOfNoticeBoard').html(numOfUnread);
						});
					
					noticesByUserRef.orderByChild('creatFrom').equalTo('kanbanIssue').once('value', function(data){
						var numOfUnread = 0;						
						data.forEach(function(childsnapshot){ 
							var childVal = childsnapshot.val();                                
                                if(childVal.readOk == 'false'){
                                	numOfUnread++;
                                    }
							})
						$('#numOfIssueBoard').html(numOfUnread);											
						});

					
					noticesByUserRef.orderByChild('creatFrom').equalTo('drive').once('value', function(data){
						var numOfUnread = 0;						
						data.forEach(function(childsnapshot){ 
							var childVal = childsnapshot.val();                                
                                if(childVal.readOk == 'false'){
                                	numOfUnread++;
                                    }
							})
						$('#numOfDriveBoard').html(numOfUnread);											
						});
					
					noticesByUserRef.orderByChild('creatFrom').equalTo('mention').once('value', function(data){
						var numOfUnread = 0;						
						data.forEach(function(childsnapshot){  
							var childVal = childsnapshot.val();                               
                                if(childVal.readOk == 'false'){
                                	numOfUnread++;
                                    }
							})
						$('#numOfMentionBoard').html(numOfUnread);
						
						
						});

					noticesByUserRef.orderByChild('creatFrom').equalTo('kanbanIssueToPm').once('value', function(data){
						var numOfUnread = 0;						
						data.forEach(function(childsnapshot){  
							var childVal = childsnapshot.val();                               
                                if(childVal.readOk == 'false'){
                                	numOfUnread++;
                                    }
							})
						$('#numOfCheckBoard').html(numOfUnread);
						
						
						});
					

			}


			 function numOfNotreadMessages(roomId){								              
	              var MessagesByUser = database.ref('MessagesByUser/'+ curUserKey + '/' + roomId);	            	             	             
	              MessagesByUser.orderByChild('readOk').equalTo('false').once('value', function(data){
	            	 numOfMessages = data.numChildren(); 												
						document.getElementById(roomId).innerHTML = numOfMessages;												
				    });	  	
			    }
 
			
			
			function saveReadNotice(){
				let name = this.getAttribute("data-from")
				let arrNoticeKey = document.querySelectorAll('div[data-type="'+name+'"]');
				arrNoticeKey.forEach(function(item, index){
					let noticeKey = item.getAttribute("data-noticeKey");
					let projectIdx = item.getAttribute("data-projectIdx");
					let targetIdx = item.getAttribute("data-targetIdx");
					let title = item.getAttribute("data-title");
					console.log("notice key 찍히나요???" + noticeKey);
					database.ref('NoticesByUser/'+ curUserKey +'/' + noticeKey).update({
						creatFrom : name,
		        	    projectIdx: projectIdx,
		        	    title: title,
		        	    readOk : 'true',
		        	    title: title,
		        	    targetIdx : targetIdx
		        	  });
				});
        	  numOfNotreadNotices(curUserKey);
			}

			//읽은 메세지 처리
			function saveReadMessage(messageRefKey){															
				database.ref('MessagesByUser/'+ curUserKey +'/' + roomId+'/' + messageRefKey).update({
						readOk : 'true'
		        	  });									
			}

			function noticeListUp(noticeKey, noticeValue) {
				$.ajax({
					url : "GetProjectList.do",
					data : {projectIdx : noticeValue.projectIdx},
					success : function(data){
						let noticeTags = '<div id="'+ noticeKey+'" class="mt-2" data-type="'+ noticeValue.creatFrom+'" data-noticeKey="'+ noticeKey+ '" data-projectIdx="'+ data.projectIdx+ '" data-targetIdx="'+ noticeValue.targetIdx+ '" data-title="'+ noticeValue.title+'" style="display: flex;">'
												+ '	<span class="mr-1"><i class="far fa-bell fa-lg"></i></span>';
						let linkElement = '	<span class="badge badge-primary badge-pill mr-1" style="background-color: ' + data.projectColor +'; font-size:13px; color: '+getTextColorFromBg(data.projectColor)+'">' +data.projectName+ '</span>'+ noticeValue.title ; 					

						if(noticeValue.creatFrom == 'notice'){	
							noticeTags	 += getNoticeFormTag(noticeValue.projectIdx, noticeValue.targetIdx, linkElement, "notice");	
							$("#noticeBoard").append(noticeTags);
						}else if(noticeValue.creatFrom == 'kanbanIssue'){
							noticeTags	 += getNoticeFormTag(noticeValue.projectIdx, noticeValue.targetIdx, linkElement, "issue");	
							$("#issueBoard").append(noticeTags);
						}else if(noticeValue.creatFrom == 'drive'){
							noticeTags	 += getNoticeFormTag(noticeValue.projectIdx, noticeValue.targetIdx, linkElement, "drive");	
							$("#driveBoard").append(noticeTags);
						}else if( noticeValue.creatFrom== 'mention'){      
							noticeTags	 += getNoticeFormTag(noticeValue.projectIdx, noticeValue.targetIdx, linkElement, "issueMention");	              	 
							$("#mentionBoard").append(noticeTags);
						}else if(noticeValue.creatFrom == 'kanbanIssueToPm'){

							noticeTags	 += "<a href='#' data-toggle='modal' data-target='#confirmIssueModal' onclick='comfirmIssueModal("+noticeValue.targetIdx+", \""+data.projectName+"\", \""+noticeValue.msg+"\")'>" +linkElement+ "</a>"
											+  '</div>';  
							$("#issueCheckBoard").append(noticeTags);			
						}
					},
					error : function(){
						console.log("in noticeListUp error");
					}
				});

			}


			
			//멤버가 피엠에게 이슈를 보내면   화면 처리 함수..
			function pmNoticeListUp(noticeKey, projectName, title, from){
				var pmNoticeTags ='<div id="'+ noticeKey+'" class="mt-2" data-type="KanbanIssue" data-noticeKey="'+ noticeKey+ 
				 '" data-projectName="'+ projectName+ '" data-title="'+ title+'"><a href="#" data-toggle="modal" data-target="#confirmIssueModal"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>'+
				 +'<span class="badge badge-primary badge-pill mr-1" style="background-color: red; font-size:13px; color: black;">PM</span>'
	           '<span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">' 
	            + projectName + '</span>'+ title +
	             '<span class="ml-1" onclick="deleteNotice(this)"><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span></a>'+
	            '</div>';

				$("#issueCheckBoard").append(pmNoticeTags);
				
				}
			
			
			
		
			
	      //유저가 채팅기능 버튼을 눌렀을 때 작동하는 콜백 함수... 목적은.. firebase database 유저 정보저장(메세지 읽기, 쓰기를 위해 특정키 부여 누군인지 구분하기 위해 필요)
		  //그리고 이미 디비에 있으면...키 값을 불러서 해당 유저와 관련된 정보를 보여 주는 데 활용 할 수 있다...    
          function writeUserData(name, email, imageUrl) {
		       return new Promise(function(resolve){//유저의 채팅방 설정에 유저키가 필요하므로 프라미스를 이용해서 먼저 유저키를 가져 오고 then 을 이용 유저의 채팅방 설정.
		        	  var myRootRef = database.ref();
		        	  //SQL에서 where 조건을 줘서 select 하는 것이랑 비슷한 파이어베이스 쿼리 쿼리
		        	  myRootRef.child("Emails").orderByChild('email').equalTo(email).once('value', function(data){		          	   		          	    
						var myResult = data.val();
						var userKey;
						if(myResult == null){//신규회원 이메일 등록을 통한 유아디 생성과.. 유저 데이터 등록 필요														
							var newUser = database.ref('Emails/').push({email :email});//push를 하면 해당 트리에 unique key 자동 생성
							 userKey = newUser.key;							
							database.ref('Users/' + newUser.key).set({//위에서 생성 된 키를 이용해서 Users 에 개별 유저 정보 저장
				        	    userName: name,
				        	    email: email,
				        	    profile_picture : imageUrl
				        	  });				        	 
							}else{//이미 파이어베이스 디비에 있는 회원이므로 키값을 뽑아내서... 채팅 정보 저장에 활용								
								data.forEach(function(childSnapshot) {
									userKey = childSnapshot.key;		              				            				
		         		 		});
							}						
						resolve(userKey);
		          	});			         
			     });
        	}

        	function getNoticeFormTag(projectIdx, targetIdx, linkElement, view){
            	let action = view != "drive" ? "Project.do?projectIdx="+projectIdx:"#";
				return "<form action='"+action+"' method='post'>"
						+ "	<input type='hidden' value='true' name='isAlarm'>"
						+ "	<input type='hidden' value='"+view+"' name='view'>"
						+ "	<input type='hidden' value='"+targetIdx+"' name='targetIdx'>"
						+ "	<a href='javascript:void(0);' onclick='goDetailFromAlarm(this)'>" +linkElement+ "</a>"
						+ '	<span class="ml-1" onclick="deleteNotice(this)"><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>'
						+ "</form>"		
						+  '</div>';
           	}
       
				


				

				var loadOnlineStatus = function(){
					console.log("로드 온라인 스테이터스 함수 타기는 하니??? 작동하는 거야 머야??"); 
					var usersConnectionRef = database.ref('UsersConnection'); 
					usersConnectionRef.off(); 
					var cbUserConnection = function(data){ 
						var connKey =data.key;						
						var connValue = data.val(); 						
						var onlineIcon = document.querySelector('#li' + connKey+' .userOnline');						
						if(onlineIcon != null){ 
							if(connValue.connection === true){ 
								onlineIcon.classList.add('user-online'); 
								}else{ 
									onlineIcon.classList.remove('user-online'); 
									} 
							} 
						} 
					usersConnectionRef.on('child_added', cbUserConnection.bind(this)); 
					usersConnectionRef.on('child_changed', cbUserConnection.bind(this)); 

					}

				

				
				/** * loadUserList 에서 데이터를 받아 왔을 때 */ 
				/* function getUserList(snapshot) { 
					var userListHtml = ''; 
					var cbDisplayUserList = function(data){ 
						var val = data.val(); 
						if(data.key !== this.auth.currentUser.uid){ 
							userListHtml += _.template(this.userTemplate)({targetUserUid : data.key, profileImg : val.profileImg, userName : val.userName}); 
							} 
						} 
					snapshot.forEach(cbDisplayUserList.bind(this)); 
					this.ulUserList.innerHTML = userListHtml; 
					}
 */
				
			



			

			//채팅방 유적 목록 클릭시 실행 되는 펑션// 
			//현재 프로젝트에서는 사용 되지 않는 함수... 원래는 채팅 가능한 유저 목록을 뿌려주고.. 클릭하면 채팅방이 열리는 함수....
          function onUserListClick(event){
                roomFlag = 'tabUserList';//유저 리스트를 클릭했다는 플래그				
				var curUserKey = $('#curUserKey').val();
				document.getElementById('aBackBtn').classList.remove('hiddendiv'); // 백버튼 노출 
				document.getElementById('aInvite').classList.remove('hiddendiv'); // 초대 버튼 노툴 			

				var targetUserUid = event.getAttribute('data-targetUserUid'); 
							
				var targetUserName = event.getAttribute('data-username'); 

				

				
				//바로 위 코드 까지는 워킹~~ 아래 코드는 해당 유저를 클릭시 이미 챗방이 만들어 져 잇으면 데이타를 가져오기 위한 코드
				var roomListTarget = document.querySelectorAll('[data-roomType="ONE_VS_ONE"][data-roomOneVSOneTarget="'
										+ targetUserUid +'"]')[0]; 
				
				
				
				if(roomListTarget){ // null 이 아니면 여기가 핵심이다.  룰리스트 타겟있으면 새로운 방 아이디를 만들지 않는다.
					roomListTarget.click(); 
					}else{ // 메세지 로드 
						//roomTitle = targetUserName+'님 과의 대화'; 
						roomUserList = [targetUserUid, curUserKey]; // 챗방 유저리스트  			
						roomUserName = [targetUserName, curName] // 챗방 유저 이름 
						roomId = '@make@' + curUserKey +'@time@' + yyyyMMddHHmmsss(); 
						console.log("새로운 상대와의 채팅이 시작 되면 룸 아이디 생성.. 그 값은요??>>>>>>>>>>>>" +roomId);
						openChatRoom(); // 파라미터 추가
						}

				
            }
          

		  function pressEnter(ev) {
				if(ev.keyCode === 13){ //엔터키 키코드가 입력이 되면 
					ev.preventDefault();
					saveMessages($("#chattingRoomIn .emoji-wysiwyg-editor:first").text()); 
			  }
		  }
		

          function openChatRoom(roomTitle, roomLength) {
             
        	  //loadRoomList(roomId); 
        	  window.isOpenRoom = true; // 방이 열린 상태인지 확인하는 플래그 값 
        	  if(roomTitle){ //상단 타이틀 변경 
            	  document.getElementById('roomTitle').innerHTML = roomTitle; 
            	  $("#roomTitle").siblings().eq(0).text(" ("+roomLength+") ");
           	  }  
        	  loadMessageList(); //메세지 로드 
              $('#tabMessageList').click();
            		      	
           }


			//챗방 초대를 위한 모달 창 세팅을 위한 함수
          function setAddUserList() {
			 
              //온라인 상태인지 아닌지 확인하고.. 유저리스에 아이콘 색 변경을 위한 함수..
        	  loadOnlineStatus();	
              
        	  curUserKey= window.curUserKey;
			  roomUserList = [window.curUserKey]; // 챗방 유저리스트  	
			  roomUserName = [curName]; // 챗방 유저 이름 
			  roomId = '@make@' + curUserKey +'@time@' + yyyyMMddHHmmsss();
        	 
        	  var arrAddUserList = Array.prototype.slice.call($('#ulUserList li'));	 
        	  arrAddUserList.forEach(cbArrayForEach);
           }


          var cbArrayForEach = function(item){
        	 //유저 셀렉티드 클래스 초기화	
        	  item.classList.remove('user-selected');		  
        	  //체크 표시 제거 하기
            	 $(item).find("#userChecked").addClass("hidden"); 
        	  	item.addEventListener('click',userSelected); 
    	  } 		


          function userSelected(){
      	  if(Array.prototype.slice.call(this.classList).indexOf('user-selected') == -1){ 
          	 
          	  this.classList.add('user-selected'); 
          	  $(this).find("#userChecked").removeClass("hidden");
          	  
          	  }else{ 
              	 this.classList.remove('user-selected'); 
             		 $(this).find("#userChecked").addClass("hidden");  
             	             	 
              	  } 
      	  }

      	  
          /** * 메세지 로드 */ 
          function loadMessageList(){                          
              var myKey = $('#curUserKey').val();                           
              var messageRef = database.ref('Messages/'+roomId);
              if(roomId){ 
                 document.getElementById('ulMessageList').innerHTML = ''; //메세지 화면 리셋                                               
                 messageRef.off();//메세지에 달려 있는 파이어베이스 이벤트 제거. 이렇게 하지 않으면 이벤트가 중복되어 트리거 된다.                           	  
                 messageRef.limitToLast(50).on('child_added', function(data){                    	
                     	var msgKey = data.val();                    	
           			 	messageListUp(data.key, msgKey.profileImg, msgKey.timestamp, msgKey.userName, msgKey.message, msgKey.uid);              				
	           			//채팅창 자동 스크롤 다운...  
	           			 document.getElementById("chatBox").scrollTop = document.getElementById("chatBox").scrollHeight;
	           			//로드 되서 읽은 메세지 처리 함수 
						saveReadMessage(data.key);
						//읽지 않은 메세지 숫자 정보 리드
						numOfNotreadMessages(roomId);
                     }); 
              }else{
           	      messageRef.limitToLast(50).on('child_added', function(data){
                   
             	  data.forEach(function(childSnapshot) {
							var msgKey = childSnapshot.key;        				
                 }); 
           	  });
           }        	                       
         }
			




          /** 채팅방 목록리스트 호출 */
  		function loadRoomList(uid) {
			var ulRoomList = document.getElementById('ulRoomList');			
			var roomRef = database.ref('RoomsByUser/'+ uid);										 			
			roomRef.off(); 			
			roomRef.orderByChild('timestamp').on('value', function(snapshot){
				document.getElementById('ulRoomList').innerHTML='';				
				var arrRoomListHtml = [];
				snapshot.forEach(function(data){
						var val = data.val();  
						var roomId = data.key,
						lastMessage = val.lastMessage, 
						profileImg = val.profileImg, 
						roomTitle = val.roomTitle, // +"/"+eachRoomTitle, 
						roomUserName =val.roomUserName, 
						roomUserList = val.roomUserList, 
						roomType = val.roomType, 
						roomOneVSOneTarget = val.roomOneVSOneTarget, 
						datetime = timestampToTimeForRoomList(val.timestamp); 
						//유저가 참여 하고 있는 룸정보를 불러 올때 읽지 않은 메세지가 있으면 그 수를 카운트 하는 함수
						numOfNotreadMessages(roomId);						
						arrRoomListHtml.push(roomListUp(roomId, roomTitle, roomUserName,roomType, roomOneVSOneTarget, roomUserList, lastMessage, datetime));
						
					}); 		
				var reversedRoomList = arrRoomListHtml.reverse();				
				reversedRoomList.forEach(function(item, index){
					//console.log("여기를 타야 그 챗방 리스트를 뿌려 줄수 있다... 과연...." + item);
					$('#ulRoomList').append(item);
					}); 
				});						
  	  		}

  		function onRoomListClick(event){			
  				$("#chattingRoomIn").removeClass("hidden");
  				$("#chattingList").addClass("hidden");				  		 	  		
  	  		roomFlag = 'tabRoomList'; //채팅방을 클릭했다는 것을 알기 위한 플래그 	  		
  			// 메세지 로드 
  			roomId = event.getAttribute('data-roomId'); 
  			roomTitle = event.getAttribute('data-roomTitle'); 
  			roomUserList = event.getAttribute('data-roomUserList').split('@spl@'); // 챗방 유저리스트  			
  			roomUserName = event.getAttribute('data-roomUserName').split('@spl@'); // 챗방 유저 이름 
  			openChatRoom(roomTitle, roomUserList.length);          			
  	  		}

  		/** * RoomList 화면 시간변환 */ 
  		var timestampToTimeForRoomList = function(timestamp){ 
  	  		var date = new Date(timestamp), 
  	  			year = date.getFullYear(), 
  	  			month = date.getMonth()+1, 
  	  			day = date.getDate(), 
  	  			hour = date.getHours(), 
  	  			minute = date.getMinutes(); 
  	  		var nowDate = new Date(), 
  	  			nowYear = nowDate.getFullYear(), 
  	  			nowMonth = nowDate.getMonth()+1, 
  	  			nowDay = nowDate.getDate(), 
  	  			nowHour = nowDate.getHours(), 
  	  			nowMinute = nowDate.getMinutes(); 
	  		var result; 
	  		if(year === nowYear && month === nowMonth && day === nowDay){ 
		  		result = pad(hour) +":" + pad(minute); 
		  	}else{ 
			  	result = pad(year) +"-" + pad(month) + "-" + pad(day); 
			  	} 
		  	return result; 

		  	}

	  	function pad(n) {
	  		return n > 9 ? "" + n: "0" + n;  		
		  	}

  		
 
 				/** * 메세지에 태그 입력시 변경하기 */ 
 			function myConvertMsg(html){ 				
	  			var tmp = document.createElement("DIV"); 
	  			tmp.innerHTML = html; 
	  			return tmp.textContent || tmp.innerText || ""; 
		 	}
			
			function saveMessages(inviteMessage) {					
				var msgDiv = $('#textarea1');				
				var msg = inviteMessage ? inviteMessage : $('#textarea1').val().trim();
								console.log($('#textarea1').val());					
								console.log(msg);					
				var curUserProfilePic = curProfilePic;
				var convertMsg = myConvertMsg(msg); //메세지 창에 에이치티엠엘 태그 입력 방지 코드.. 태그를 입력하면 대 공황 발생.. 그래서
				if(msg.length > 0){ 
					msgDiv.focus(); 
					msgDiv.val(""); 
					$("#chattingRoomIn .emoji-wysiwyg-editor:first").empty();
					var multiUpdates = {}; 
					var messageRef = database.ref('Messages/'+ roomId);
					var messageRefKey = messageRef.push().key	; // 메세지 키값 구하기 
					var roomUserListLength = roomUserList.length; 
					//UsersInRoom 데이터 저장
					if(document.getElementById('ulMessageList').getElementsByTagName('li').length === 0){ //메세지 처음 입력 하는 경우 
						var roomUserListLength = roomUserList.length; 
						for(var i=0; i < roomUserListLength; i++){ 
							multiUpdates['UsersInRoom/' +roomId+'/' + roomUserList[i]] = true;														
						} 						

						database.ref().update(multiUpdates); // 권한 때문에 먼저 저장해야함 
						loadMessageList(); //방에 메세지를 처음 입력하는 경우 권한때문에 다시 메세지를 로드 해주어야함 
					} 
					
					multiUpdates ={}; // 변수 초기화 

					//유저별 안 읽은 메세지 숫자 표시를 위한 파베 디비 저장 쿼리..
					if(roomUserListLength>1){
						for(var i=0; i < roomUserListLength; i++){ 							
							multiUpdates['MessagesByUser/' +roomUserList[i]+'/' + roomId+'/' + messageRefKey] = {
									readOk : 'false'								
									};  							
					         } 					
					database.ref().update(multiUpdates); 
					
					}	
															
					multiUpdates ={}; // 변수 초기화 

					//메세지 저장 
					multiUpdates['Messages/' + roomId + '/' + messageRefKey] = { 
							uid: curUserKey, 
							userName: curName, 
							message: convertMsg, // 태그 입력 방지
							profileImg: curProfilePic ? curProfilePic : 'noprofile.png', 
							timestamp: firebase.database.ServerValue.TIMESTAMP //서버시간 등록하기 
					} 

					//유저별 룸리스트 저장 
					var roomUserListLength = roomUserList.length;
					 
					if(roomUserList && roomUserListLength > 0){ 
						for(var i = 0; i < roomUserListLength ; i++){ 
							multiUpdates['RoomsByUser/'+ roomUserList[i] +'/'+ roomId] = { 
								roomId : roomId,
								roomTitle : roomTitle, 
								roomUserName : roomUserName.join('@spl@'), 
								roomUserList : roomUserList.join('@spl@'), 
								roomType : roomUserListLength > 2 ? 'MULTI' : 'ONE_VS_ONE', 
								roomOneVSOneTarget : roomUserListLength == 2 && i == 0 ? roomUserList[1] : // 1대 1 대화이고 i 값이 0 이면 
									roomUserListLength == 2 && i == 1 ? roomUserList[0] // 1대 1 대화 이고 i값이 1이면 
									: '', // 나머지 
								lastMessage : convertMsg, 
								profileImg : curProfilePic ? curProfilePic : 'noprofile.png', 
								timestamp: firebase.database.ServerValue.TIMESTAMP 
							}; 
						} 
					} 
					database.ref().update(multiUpdates);

					//RoomsByUser 디비 업데이트 후 다시 챗방 리스트 다시 로드										
					loadRoomList(curUserKey);			
				} 
		   }



          
          /** * 현재날짜 yyyyMMddHHmmsss형태로 반환 */ 
          var yyyyMMddHHmmsss =function(){ 
              var vDate = new Date(); 
              var yyyy = vDate.getFullYear().toString(); 
              var MM = (vDate.getMonth() + 1).toString(); 
              var dd = vDate.getDate().toString(); 
              var HH = vDate.getHours().toString(); 
              var mm = vDate.getMinutes().toString(); 
              var ss = vDate.getSeconds().toString(); 
              var sss= vDate.getMilliseconds().toString(); 
              return yyyy + (MM[1] ? MM : '0'+MM[0]) + (dd[1] ? dd : '0'+dd[0]) + (HH[1] ? HH : '0'+ HH[0]) + (mm[1] ? mm : '0'+ mm[0]) + (ss[1] ? ss : '0'+ss[0])+ sss; 
              };

          
              /** * timestamp를 날짜 시간 으로 변환 */ 
              var timestampToTime = function(timestamp){ 
                  var date = new Date(timestamp), 
                  	  year = date.getFullYear(), 
                  	  month = date.getMonth()+1, 
                  	  day = date.getDate(), 
                  	  hour = date.getHours(), 
                  	  minute = date.getMinutes(), 
                  	  week = new Array('일', '월', '화', '수', '목', '금', '토'); 
              	  var convertDate = year + "년 "+month+"월 "+ day +"일 ("+ week[date.getDay()] +") "; 
              	  var convertHour=""; 
              	  if(hour < 12){ 
                  	  convertHour = "오전 " + pad(hour) +":" + pad(minute); 
                  	  }else if(hour === 12){ 
                      	  convertHour = "오후 " + pad(hour) +":" + pad(minute); 
                      	  }else{ convertHour = "오후 " + pad(hour - 12) +":" + pad(minute); 
                      	  } 
              	  return convertDate + convertHour; 

              }

              
          

          var rootRef = database.ref();

		  //채팅방 만들기 버튼 눌렀을 때 유저 목록 뿌려 주는 함수....	
          var userListUp = function(targetuid, name, userpic, email){
        	  var userProPic = 	(userpic ? 'upload/member/'+ userpic : 'resources/images/login/profile.png'); 
        	  let errorSource = "this.src='resources/images/login/profile.png'";
        	  var userTemplate = '<li id="li' + targetuid +'" data-targetUserUid="' +targetuid + '" data-username="' + name+ 
        	          	  					  '" data-useremail="' + email + '" class="collection-item avatar list">'+ 
        	          	  				  		'<div class="input-group ">'+
        	          	  				  			'<div class="form-control pt-2 pb-2">'+
        	          	  				  				'<img src="' + userProPic + '" alt="" class="circle mr-3" height="35" width="35" onerror="'+errorSource+'">'+ 
        	          	  				  				 name + '('+email+')'+
        	          	  				  				'<i class="fas fa-globe font-20 mt-1 mr-1 userOnline"></i>'+
        	          	  				  				'<i id ="userChecked" class="fas fa-check float-right font-20 mt-1 mr-1 hidden" style="color:red"></i>'+
        	          	  				  			'</div>'+                      
        	          	  				   		'</div>'+
        	          	  				   	'</li>';  

        	  $('#ulUserList').append(userTemplate);

              }
          
	
          var messageListUp= function(key, profileImg, timestamp, userName, message, uid){
              let time = timestampToTime(timestamp);        
              let userProPic = 	(profileImg ? 'upload/member/'+ profileImg : 'resources/images/login/profile.png');			 
              let messageTemplate;
              //초대메세지 처리
			  if(message.lastIndexOf("님이 초대되었습니다.")>0){
				  messageTemplate = '<li  class="text-center chat-item mt-2 mb-3" data-key="' + key + '">'
				  								+ '<b>'+ message+'</b>'
				  								+ '</li>';
				  $('#ulMessageList').append(messageTemplate);
				  return;
			  }	
			  //퇴장 메세지 처리
			  if(message.lastIndexOf("님이 나가셨습니다.")>0){
				  
				 				  messageTemplate = '<li  class="text-center chat-item mt-2 mb-3" data-key="' + key + '">'
				  			  								+ '<b>'+ message+'</b>'
				  			  								+ '</li>';
				  
				  				  $('#ulMessageList').append(messageTemplate);
				  				  return;
				   			  }	
   			  //채팅방에서 상대방은 왼쪽 나의 메세지는 오른 쪽으로.				  
			  if(uid == curUserKey) {
				  messageTemplate = '<li id="li' + key  + '" class="odd chat-item" style="margin-top:10px;" data-key="' + key + '">'+			
					'<div class="chat-content">'+			
					'<div class="box bg-light-inverse chatbg ownBubble">'+ message + '</div>'+
					'<br>'+
					'</div>'+
					'<div class="chat-time">'+ time + '</div>'+
					'</li>';

				  }else{
					  messageTemplate = '<li id="li' + key  + '" class="chat-item" style="margin-top:10px;" data-key="' + key + '">'+
						'<div class="chat-img"><img src="'+ userProPic +'" alt="user" class="chatImgBorder" onerror="this.src=\'resources/images/login/profile.png\'"></div>'+
						'<div class="chat-content pl-2 ">'+
						'<h6 class="font-medium">'+ userName + '</h6>'+
						'<div class="box bg-light-info otherBubble">'+ message + '</div>'+
						'<div class="chat-time">'+ time + '</div>'+
						'</li>';
					  }        	   									          
        	  $('#ulMessageList').append(messageTemplate);       	       	  
          } 


         

          function leaveRoom(){       	              
        	  				saveMessages(curName + "님이 나가셨습니다.");//나가기 채팅방에 메세지 처리
        	  				$("#chattingList").removeClass("hidden");
        	          		$("#chattingRoomIn").addClass("hidden");
        	  				database.ref('RoomsByUser/'+ curUserKey +'/'+roomId).remove();        	  				        	              	
        	          }

          

         

          var roomListUp = function(roomId, roomTitle, roomUserName,roomType, roomOneVSOneTarget, roomUserList, lastMessage, datetime){
        	    var userProPic = 	(curProfilePic ? curProfilePic : 'resources/images/user/noprofile.png');
				var roomTemplate = '<li id="liRoom' + roomId + '" data-roomId="' + roomId + '" data-roomTitle="' 
									+ roomTitle+ '" data-roomUserName="'+roomUserName+ '" data-roomType="'+roomType+'" data-roomOneVSOneTarget="'
									+roomOneVSOneTarget+'" data-roomUserList="'+roomUserList +
									'" class="chat_list-group-item chat_list-group-item-action flex-column align-items-start chatList" onclick="onRoomListClick(this)">'
	            					+'<div class="d-flex w-100 justify-content-between" id="chatTitle">'+
	            		                '<div class="media">'+
	            		                  '<img src="resources/images/user/group.png" class="rounded-circle chat_img" alt="" id="userImg">'+
	            		                  '<h5 style="margin-top: 18px;">'+roomTitle+'</h5>'+
	            		                '</div>'+
	            		                '<small style="float:right;">'+datetime+'</small>'+
	            		             '</div>'+
	            		              '<ul>'+
             								'<li class="d-flex justify-content-between align-items-center">'+
             			                                                      lastMessage+ 
               									'<span id="'+ roomId +'" class="badge badge-primary badge-pill" style="background-color: #326295"></span>'+
               								'</li>'+
          								'</ul>'+
          							'</li>';	  
	     
					return roomTemplate;	
              }

          
          function onBackBtnClick(){ 
              window.isOpenRoom = false; 
              document.getElementById('aBackBtn').classList.add('hiddendiv'); 
              document.getElementById('aInvite').classList.add('hiddendiv'); 
              console.log("백 버튼 누르면 룸 플래그 값은 ??" + roomFlag);
              document.getElementById(roomFlag).click(); 
              document.getElementById('spTitle').innerText = 'OWL Chat Room'; 
              document.getElementById('ulMessageList').innerHTML='';
              
               
              }


			
          function onCreateClick(){
        	  roomTitle = $('#chatRoomTitle').val(); 			  
        	  var arrInviteUserList = Array.prototype.slice.call($('.user-selected'));        	 
        	  var arrInviteUserListLength = arrInviteUserList.length;       	 
        	  var arrInviteUserName = []; 
        	  var updates = {}; 
        	  for(var i=0; i < arrInviteUserListLength; i++){ 
            	  var inviteUserUid = arrInviteUserList[i].getAttribute('data-targetUserUid'); 
            	  var inviteUserName = arrInviteUserList[i].getAttribute('data-username') + '님'; 
            	  updates['UsersInRoom/'+ roomId +'/'+ inviteUserUid] = true; 
            	  //arrInviteUserList[i].outerHTML = ''; 
            	  roomUserList.push(inviteUserUid); 
            	  roomUserName.push(inviteUserName); 
            	  arrInviteUserName.push(inviteUserName); 
            	  } 

        	  roomUserList.sort(); 			 
			  var arrRoomList = Array.prototype.slice.call($('#ulRoomList > li'));       	          	     
				//이미 같은 멤버로 만들어진 채팅방이 있는지 확인하고 있으면 해당 방으로 이동하는 기능        	 
      	      arrRoomList.forEach(function(item, index){
				var aroomUserList = item.getAttribute('data-roomUserList').split('@spl@');
      	        if(JSON.stringify(roomUserList)==JSON.stringify(aroomUserList)){     	    	      	    	 
      	    	 isRoom(item);//같은방이 있는 경우 얼럿 창 띄우고.. 오케이 하면 해당 방으로 이동하는 함수....
          	           }     		
      	         });
      	      database.ref().update(updates); //UsersInRoom DB 저장
      	      //초대 메세지 
      	      arrInviteUserName.forEach(function(item, index){
      	     	  saveMessages(item + '이 초대되었습니다.');     	    	
          	    });           
      	      //새로생성된 방으로 이동하기 처리
      	      var justCreatedRoom = document.getElementById('liRoom' + roomId);     	    
      	          onRoomListClick(justCreatedRoom);
      	                

           }

          function isRoom(item) {
        	  var txt;
        	  var r = confirm("이미 방이 존재 합니다. 해당 방으로 이동 할까요???");
        	  if (r == true) {
        	    console.log("룸 아이디를 알고 있으니까... 해당 룸아이디를 가지고.. 방으로이동..");
        	    onRoomListClick(item);
        	  } 
        	}	


			
          console.log("널인가???" + curName + " / " + curEmail);


          function checkOnline(){ 
              var userUid = curUserKey; 
              var myConnectionsRef = database.ref('UsersConnection/'+userUid+'/connection'); 
              var lastOnlineRef = database.ref('UsersConnection/'+userUid+'/lastOnline'); 
              var connectedRef = database.ref('.info/connected'); 
              connectedRef.on('value', function(snap) { 
                  if (snap.val() === true) { 
                      myConnectionsRef.set(true); // 연결 단절 이벤트 
                      myConnectionsRef.onDisconnect().set(false); 
                      lastOnlineRef.onDisconnect().set(firebase.database.ServerValue.TIMESTAMP); 
                      } 
                  }); 
              }

			//채팅 및 푸시 알람 기능 초기화
			function owlInit(curUserKey){
				//채팅방 룸 정보 로딩
				loadRoomList(curUserKey);
                //유저 접속 상태 저장 체크...
                checkOnline();	
                //fcm 토큰은 미리 받아 올수 있는데... 현재 유저의 uid 를 fb db 에서 가져 와야 해서.. 위치가..여기..이 함수는 fb db 에 fcm token wjwkd gksms gkatn
    			saveFCMToken();
    			//노티스 정보 로드 없
    			loadPushNotice(curUserKey);
    			//읽지 않은 노티수 숫자 표시 함수
    			numOfNotreadNotices(curUserKey);
    			 //온로드 뒤에 백 버튼 리스너 달기
        		$('#aBackBtn').click(onBackBtnClick);
        		 //채팅 초대창 모달 띄우기
    		    $('#dnModal').modal(); 				 
    			//채팅방 초대 modal 설정 
    			$('#dvAddUser').modal();  
    		    //초대 모달창에서 초대 버튼 클릭시  체크된 인원을 현재 챗방에 추가하는 클릭 리스너
    			$('#onCreateClick').click(onCreateClick);       			
    			//공지사항 아코디언 오픈시 이벤트 리스너....
    			$('#collapseOne4, #collapseTwo5, #collapseThree6, #collapseThree7').on('shown.bs.collapse', saveReadNotice);
    			//채팅방 메세지 입력창 엔터를 누를 경우 메세지 저장 함수 리스너 달기
    			$("#chattingRoomIn .emoji-wysiwyg-editor:first").keydown(pressEnter);
				}

		  // 초기화 를 위한 온로드 함수... 같은 프로제트에 있는 유저목록과 프로젝트 채팅방을 만들기 위한 정보를 디비에서 뽑아낸다.	
          $(function(){           
			var curUserKey;
			//현재 접속한 유저의 파이어베이스 유저키 값을 불러와 채팅방 기본정보 설정..					
            writeUserData(curName, curEmail, curProfilePic).then(function(resolvedData){
				console.log("현재 사용자의 user 키는용???>>" + resolvedData + "<<<<<");
                $('#curUserKey').val(resolvedData);//html 태그에 
                curUserKey = $('#curUserKey').val();//요 함수 내에세 활용하기 위한 변수 정의
                window.curUserKey = resolvedData;//윈도우 객체에 담아 다른 함수에서 활욜
                owlInit(resolvedData);
                  
              }); 

            //같은 프로젝트에 있는 유저 정보를 뽑아오는 아젝스...요걸로 채팅 가능한 유저들 리스트 화면 뿌려 준다.
      		$.ajax({
      			url: "MyProjectsMates.do",
      			type: "POST",
      			dataType: 'json',
      			data : { email : curEmail,
      				     name : curName }, 
      			success: function (data) {
      				console.log("뷰단으로 데이터 들어 오나요?? >" + data);   				
      				$.each(data, function(index, value) {          				    				  
      				  console.log(value.name + " / " + value.email + " / " + value.profilePic);    				
      				writeUserData(value.name, value.email, value.profilePic).then(function(resolvedData){          				    					
    				//목록을 뿌리기위한 태크 뭉치들이 들어 있는 함수 콜
    				userListUp(resolvedData, value.name, value.profilePic, value.email);						
      					});
      				});	
      			},
      			error: function(xhr, status, error){
          			console.log("아잭스 에러 터짐 ㅠㅠ");
      		         var errorMessage = xhr.status + ': ' + xhr.statusText
      		         alert('Error - ' + errorMessage);
      		     }
      		});			
      	});	
          
      </script>

	<!-- MyProfile Modal -->
	<jsp:include page="../member/myProfileSetting.jsp" />
	<jsp:include page="../chat/newChat.jsp" />
	<jsp:include page="../kanban/modal/comfirmIssue.jsp" />