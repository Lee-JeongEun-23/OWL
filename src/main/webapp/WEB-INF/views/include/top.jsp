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
		console.log("????????? view");
		$("#chattingRoomIn").removeClass("hidden");
		$("#chattingList").addClass("hidden");
	});
	$("#chatBackBtn").click(function() {
		console.log("??? ??????");
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

 	//?????? ????????????, comfirmOk?????? ?????????

 	$('#comfirmBtn').click(function() {
		$.ajax({
			url:"IssueComfirmfromPM.do",
			data : {issueIdx : $('#comfirmissueIdx').val()},
			success : function(data) {

	        	successAlert("Issue??? ?????????????????????.");
	        	$('#confirmIssueModal').modal("hide"); //?????? 
				
			},error : function() {
				console.log('error');

			}
			})
		});


 	//?????? ????????????, reject?????? ?????????
	$('#rejectBtn').click(function() {

		$.ajax({
			url : "IssueRejectfromPM.do",
			data : {'rejectreason' : $('#rejectreason').val(), 'issueIdx' : $('#comfirmissueIdx').val()},
			success : function(data) {

				successAlert("Issue??? ?????????????????????.");
	        	$('#confirmIssueModal').modal("hide");

        	    sendNoticePushToOne($('#comfirmCreator').text(), $('#comfirmTitle').text()+ "???????????????", "PM??? ?????? ???????????????.")
	        	pushNoticeToOne($('#projectissueIdx').val(),$('#projectName').val(), $('#comfirmTitle').text()+ " ????????? ?????????????????????.", "kanbanIssueToPm", $('#comfirmCreator').text(), $('#comfirmissueIdx').val(), "tomember");

			},error : function() {
				console.log('IssueRejectfromPM error');
				}
			});
		});
	



	$('#confirmIssueModal').on('hidden.bs.modal', function(e){
		$('#rejectreason').val("");
	});
	
	
	}); // $function () ???

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

	
	//?????? ???????????? ?????? ???????????? ????????? ????????? ?????? 
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
/* ?????????  css */
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
                    	<!-- ?????? ?????? notification badge  -->
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
			
			<!-- ?????? ?????? ?????? -->
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
                    <!-- ?????? ?????? ?????? ?????? ??? -->
				</div>	
				
				<!--  ????????? view -->	
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
								     <li class="pl-3"><a href="#" onclick="leaveRoom()">?????????</a></li>
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
                                    
                                    <!--  ?????? ???????????? ?????? -->
                                        <li class="chat-item mt-0" style="padding:10px; background-color: rgba(219, 217, 217, 0.5); " id="chatNoticePreview">
                                           <div class="row">
                                           <div class="col-11 pr-0">
                                               <div class="chat-img"> <i class="fas fa-bullhorn btn-circle" style="background-color: #326295;color: white;padding-top: 12px;padding-left: 12px;"></i>
                                                	</div>	
                                                	 <div class="chat-content pl-0" style="max-height: 42px; overflow: hidden">
                                                	??? ?????? ?????? ?????? ???  ????????? ????????? ????????? 2??? 22????????????. ??????????????? ??????????????????????????????.
                                                	</div>
                                                	</div>
                                                	<div class="col-1 p-0">
                                                	<i class="fas fa-chevron-down font-20" style="padding-top:12px;" id="chatNoticeMoreBtn"></i>
                                                	</div>	
                                           </div>	
                                        </li>
                                         <!--  ?????? ?????? ???????????????  -->
                                        <li class="chat-item mt-0 pb-0  hidden" style="padding:10px; background-color: rgba(219, 217, 217, 0.5); " id="chatNoticeDetail">
                                           <div class="row">
                                           <div class="col-11 pr-0">
                                               <div class="chat-img"> <i class="fas fa-bullhorn btn-circle" style="background-color: #326295;color: white;padding-top: 12px;padding-left: 12px;"></i>
                                                	</div>	
                                                	 <div class="chat-content pl-0">
                                                	??? ?????? ?????? ?????? ???  ????????? ????????? ????????? 2??? 22????????????. ??????????????? ?????????????????? ????????????.
                                                	</div>
                                                	</div>
                                                	<div class="col-1 p-0">
                                                	<i class="fas fa-chevron-up font-20" style="padding-top:12px;" id="chatNoticeBackBtn"></i>
                                                	</div>	
                                           </div>
                                             <div class="row text-center" style="border-top: 1px solid  #BDBDBD">
                                           <div class="col-6" style="border-right:1px solid  #BDBDBD;padding:6px;">?????? ?????? ??????</div>
                                           <div class="col-6" style="padding:6px;" id="noticeAsideBtn">????????????</div>
                                           </div>	
                                        </li>
                                        <!--  ????????? ?????? ???????????? -->  
                                        
                                         <div class="chat-img hidden" id="chatNotideAside"style="position: absolute;right:0; top:0"> <i class="fas fa-bullhorn btn-circle op-5" style="background-color: #326295;color: white;padding-top: 12px;padding-left: 12px;"></i>
                                               </div>
                                          
                                        <!--chat Row -->
                                        <!-- <li class="chat-item" style="margin-top:10px;">
                                            <div class="chat-img"><img src="resources/images/user/group.png" alt="user" class="chatImgBorder"></div>
                                            <div class="chat-content pl-2 ">
                                                <h6 class="font-medium">??????</h6>
                                                <div class="box bg-light-info otherBubble">??? ???????????????. ??????????????????.</div>
                                            </div>
                                            <div class="chat-time">10:56 am</div>
                                        </li>
                                        chat Row
                                        <li class="chat-item" style="margin-top:10px;">
                                            <div class="chat-img"><img src="resources/images/user/group.png" alt="user" class="chatImgBorder"></div>
                                            <div class="chat-content pl-2">
                                                <h6 class="font-medium">?????????</h6>
                                                <div class="box bg-light-info otherBubble">?????? ?????? ????????????!!!</div>
                                            </div>
                                            <div class="chat-time">10:57 am</div>
                                        </li>
                                        chat Row
                                        <li class="odd chat-item" style="margin-top:10px;">
                                            <div class="chat-content">
                                                <div class="box bg-light-inverse chatbg ownBubble">????????? ????????? ????????????????</div>
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
	                                        	<textarea class="form-control border-0 mb-0 mt-2" id="textarea1"  data-emojiable="true"  placeholder="???????????? ??????????????????"></textarea>
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
                    <!-- ?????? ?????? ?????? ?????? ??? -->
              </div>
		</div>
		
					<!--  ?????? ??????  -->
			<div class="toggleOption" id="alarmToggle"  style="padding-top: 0px;">
					
					<div class="setting-box">
				        <div class="card top_card ">
                            <div class="card-body" style="padding:20px;">
                                <div id="accordion-three" class="accordion">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 id="noticeAccordion" class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseOne4" aria-expanded="false" aria-controls="collapseOne4">???????????? <span id="numOfNoticeBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i>
                                            </h5>
                                        </div>
                                        <div id="collapseOne4" class="collapse" data-parent="#accordion-three" data-from="notice" style="line-height:2em;">
                                            <div class="card-body pt-3 accordionBody" id="noticeBoard">
                                            <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">????????????</span>
                                            	???????????? ????????? ?????????????????????. <span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div>
                                           
                                           -->
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseTwo5" aria-expanded="false" aria-controls="collapseTwo5">???????????? <span id="numOfDriveBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseTwo5" class="collapse" data-parent="#accordion-three" data-from="drive" style="line-height:2em;">
                                            <div id="driveBoard" class="card-body pt-3 accordionBody">
                                            <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">????????????</span>
                                            	'file.jpg'????????? ????????? ???????????????. <span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div> -->
                                            
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseThree6" aria-expanded="false" aria-controls="collapseThree6">?????? <span id="numOfIssueBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseThree6" class="collapse" data-parent="#accordion-three" data-from="KanbanIssue" style="line-height:2em;">
                                            <div id="issueBoard" class="card-body pt-3 accordionBody">
                                            <!-- <div class="mt-2 col-md-12"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">????????????</span>
                                            	'[view]????????? view ??????' ????????? ?????????????????????.<span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div>
                                            <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                             <span class="badge badge-primary badge-pill mr-1" style="background-color: red; font-size:13px; color: black;">PM</span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">????????????</span>
                                            	???????????? view ??????'????????? ?????? ????????? ????????????. <span class="ml-1"><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                             </div> -->
                                 
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseThree7" aria-expanded="false" aria-controls="collapseThree7">?????? <span id="numOfMentionBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseThree7" class="collapse" data-parent="#accordion-three" data-from="mention" style="line-height:2em;">
                                            <div id="mentionBoard"class="card-body pt-3 accordionBody">
                                             <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">????????????</span>
                                            	??????????????? ?????????????????????. 
                                            	<span class="ml-1" ><i class="fas fa-times-circle" style="font-size: 1.2em"></i></span>
                                            </div> -->
                                            </div>
                                        </div>
                                    </div>
                                    
                                   <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0 collapsed clickIcon" data-toggle="collapse" data-target="#collapseThree8" aria-expanded="false" aria-controls="collapseThree7">???????????? <span id="numOfCheckBoard" class="badge badge-pill gradient-1">0</span><i class="fa fa-chevron-right chevronIcon" style="float:right"></i></h5>
                                        </div>
                                        <div id="collapseThree8" class="collapse" data-parent="#accordion-three" data-from="mention" style="line-height:2em;">
                                            <div id="issueCheckBoard" class="card-body pt-3 accordionBody">
                                             <!-- <div class="mt-2"><span class="mr-1"><i class="far fa-bell fa-lg"></i></span>
                                            <span class="badge badge-primary badge-pill mr-1" style="background-color: #ccccff; font-size:13px; color: black;">????????????</span>
                                            	??????????????? ?????????????????????. 
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

      
      <!-- <script type="text/javascript" src="resources/js/underscore-min.js"></script> ??????????????? ??????????????? ??????????????? ????????? ???????????? ??? ????????????-->          
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
//?????? ????????? ?????? ?????? ??????..
const messaging = firebase.messaging();

messaging.usePublicVapidKey("BFnhctOfkdVv_GNMgVeHgA0C2n1-wJTGCLV_GlZDhpTMNvqAE-SY8pdtyT6NREqxgdSRR44x_SWjZYTZNEWY8n0");


	
      //??????????????? ?????? ?????? ?????? ??????(??????,?????????,???????????????) ????????? ????????? ??????
      const curName = "${member.name}";
      const curEmail = "${member.email}"; 
      const curProfilePic = "${member.profilePic}";
	  
      //????????????????????? ????????? ????????? ?????? ????????? ?????? ?????????
      const SPLIT_CHAR = '@spl@'; //???????????? ?????? ????????? ?????? ?????? ?????? ????????? ????????? ??? ???????????? ?????????.
      var roomFlag; //????????? ???????????? ?????? ???????????? ????????? ???????????? ?????? ?????????
		var roomUserList; // ?????? ???????????????  			
		var roomUserName; // ?????? ?????? ?????? 
		var roomId;		//???????????? ???????????? ?????????
		var roomTitle; 	//????????? ??????
    	  
      console.log("?????? ???????????? ?????? ??????" + curName+"/"+curEmail+"/"+curProfilePic);

      
   
          
        
          
		 
        //?????? ?????? firebase messaging ??? ????????? ?????? ????????? ????????? ??????.. ?????? ????????? ????????? ????????? ??????. ????????? ?????? ?????? ??????..
		var setCloudMessaging = function () { 
			//????????? 			
			messaging.requestPermission() 
			.then(function(){ 
				console.log('????????? ?????? ??????'); 
				return messaging.getToken(); 
				}) 
				.then(function(token){ 
					console.log('fcm token : ', token); 
					})				
					.catch(function(e){ 
						console.log('????????? ?????? ?????? ??? ??????', e); 
						}); 
			}


		//?????? ?????? ??? ?????? ?????? ?????? ??????... ????????? ?????? ??? ?????? ?????? ?????? ?????? ?????? ?????? ???????????? ??? ????????? ?????? ??????.
		$(document).ready(setCloudMessaging());
			
		var saveFCMToken = function(){ 
			//????????? ?????? fcm ????????? ???????????? ?????? 
			console.log("token ?????? ?????? ?????? ??????.....");
			var cbGetToekn = function(token){ 
				console.log('setLogin fcmId get : ', token);				
				var userUid = curUserKey; 
				var fcmIdRef= database.ref('FcmId/' +userUid); 
				fcmIdRef.set(token); 
				} 
			firebase.messaging().getToken() 
			.then(cbGetToekn.bind(this)) 
			.catch(function(e){ 
				console.log('fcmId ?????? ??? ?????? ????????????... : ', e); 
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
			var title = "<????????????>" + rawtitle;
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


		//??? ?????? ??? ?????????...   ?????? ?????? ?????????~~
		function pushNoticeToAll(projectIdx, projectName, title, from, targetIdx) {
			var noticeRef = database.ref('Notice/'+ projectIdx);
			var noticeRefKey = noticeRef.push().key	
			// ?????????
			//????????? ?????? ?????? ??????	
			database.ref('Notice/' + projectIdx+'/'+ noticeRefKey).update({
				projectIdx: projectIdx,
        	    projectName: projectName,
        	    title: title,
        	    creatFrom: from,
        	    targetIdx : targetIdx
        	  });
      	  	//????????? ????????? ????????? ??????
			saveNoticeByUser(noticeRefKey, projectName, title, projectIdx, from, targetIdx);
		}

		function pushNoticeToOne(projectIdx, projectName, title, from, pmemail, targetIdx, msg) {
			var noticeRef = database.ref('Notice/'+ projectIdx);
			var noticeRefKey = noticeRef.push().key;	

			//????????? ?????? ?????? ??????	
			database.ref('Notice/' + projectIdx+'/'+ noticeRefKey).update({
				projectIdx: projectIdx,
        	    title: title,
        	    creatFrom: from,
        	    targetIdx : targetIdx,
        	    msg : msg
        	  });
      	  	//????????? ????????? ????????? ??????
			saveNoticeByUserForOne(noticeRefKey, projectName, title, projectIdx, from, pmemail, targetIdx, msg);
		}


		function saveNoticeByUserForOne(noticeRefKey, projectName, title, projectIdx, from, email, targetIdx, msg){
			var myRootRef = database.ref();
      	    myRootRef.child("Emails").orderByChild('email').equalTo(email).once('value', function(data){
      		  data.forEach(function(childSnapshot) {
						userKey = childSnapshot.key;						
						//????????? ????????? ??????
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
					  console.log("????????????" +value.name + " / " + value.email + " / " + value.profilePic + " / " + value.projectIdx);
					  console.log(value.projectIdx);
					  console.log(projectIdx);
					  if(value.projectIdx == projectIdx){

						  var userKey;
						  
						  //???????????? ?????? ??? ????????? ????????? ?????? ?????? ??????
						 var myRootRef = database.ref();
						 
			        	  myRootRef.child("Emails").orderByChild('email').equalTo(value.email).once('value', function(data){
			        		  data.forEach(function(childSnapshot) {
									userKey = childSnapshot.key;
									//????????? ????????? ??????
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
             
	                 document.getElementById('noticeBoard').innerHTML = ''; //???????????? ?????? ??????                 
	                 document.getElementById('issueBoard').innerHTML = ''; //?????? ?????? ?????? 
	                 document.getElementById('driveBoard').innerHTML = ''; //???????????? ?????? ??????
	                 document.getElementById('mentionBoard').innerHTML = '';//?????? ?????? ??????
	                 document.getElementById('issueCheckBoard').innerHTML = '';//???????????? ?????? ??????


	                 
	                 noticesByUserRef.off(); 
	                 
					var checkRead = function(data){
						console.log("????????? ???????????", data);
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
					console.log("notice key ???????????????" + noticeKey);
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

			//?????? ????????? ??????
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


			
			//????????? ???????????? ????????? ?????????   ?????? ?????? ??????..
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
			
			
			
		
			
	      //????????? ???????????? ????????? ????????? ??? ???????????? ?????? ??????... ?????????.. firebase database ?????? ????????????(????????? ??????, ????????? ?????? ????????? ?????? ???????????? ???????????? ?????? ??????)
		  //????????? ?????? ????????? ?????????...??? ?????? ????????? ?????? ????????? ????????? ????????? ?????? ?????? ??? ?????? ??? ??? ??????...    
          function writeUserData(name, email, imageUrl) {
		       return new Promise(function(resolve){//????????? ????????? ????????? ???????????? ??????????????? ??????????????? ???????????? ?????? ???????????? ?????? ?????? then ??? ?????? ????????? ????????? ??????.
		        	  var myRootRef = database.ref();
		        	  //SQL?????? where ????????? ?????? select ?????? ????????? ????????? ?????????????????? ?????? ??????
		        	  myRootRef.child("Emails").orderByChild('email').equalTo(email).once('value', function(data){		          	   		          	    
						var myResult = data.val();
						var userKey;
						if(myResult == null){//???????????? ????????? ????????? ?????? ????????? ?????????.. ?????? ????????? ?????? ??????														
							var newUser = database.ref('Emails/').push({email :email});//push??? ?????? ?????? ????????? unique key ?????? ??????
							 userKey = newUser.key;							
							database.ref('Users/' + newUser.key).set({//????????? ?????? ??? ?????? ???????????? Users ??? ?????? ?????? ?????? ??????
				        	    userName: name,
				        	    email: email,
				        	    profile_picture : imageUrl
				        	  });				        	 
							}else{//?????? ?????????????????? ????????? ?????? ??????????????? ????????? ????????????... ?????? ?????? ????????? ??????								
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
					console.log("?????? ????????? ??????????????? ?????? ????????? ????????? ???????????? ?????? ????????"); 
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

				

				
				/** * loadUserList ?????? ???????????? ?????? ?????? ??? */ 
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
				
			



			

			//????????? ?????? ?????? ????????? ?????? ?????? ??????// 
			//?????? ????????????????????? ?????? ?????? ?????? ??????... ????????? ?????? ????????? ?????? ????????? ????????????.. ???????????? ???????????? ????????? ??????....
          function onUserListClick(event){
                roomFlag = 'tabUserList';//?????? ???????????? ??????????????? ?????????				
				var curUserKey = $('#curUserKey').val();
				document.getElementById('aBackBtn').classList.remove('hiddendiv'); // ????????? ?????? 
				document.getElementById('aInvite').classList.remove('hiddendiv'); // ?????? ?????? ?????? 			

				var targetUserUid = event.getAttribute('data-targetUserUid'); 
							
				var targetUserName = event.getAttribute('data-username'); 

				

				
				//?????? ??? ?????? ????????? ??????~~ ?????? ????????? ?????? ????????? ????????? ?????? ????????? ????????? ??? ????????? ???????????? ???????????? ?????? ??????
				var roomListTarget = document.querySelectorAll('[data-roomType="ONE_VS_ONE"][data-roomOneVSOneTarget="'
										+ targetUserUid +'"]')[0]; 
				
				
				
				if(roomListTarget){ // null ??? ????????? ????????? ????????????.  ???????????? ??????????????? ????????? ??? ???????????? ????????? ?????????.
					roomListTarget.click(); 
					}else{ // ????????? ?????? 
						//roomTitle = targetUserName+'??? ?????? ??????'; 
						roomUserList = [targetUserUid, curUserKey]; // ?????? ???????????????  			
						roomUserName = [targetUserName, curName] // ?????? ?????? ?????? 
						roomId = '@make@' + curUserKey +'@time@' + yyyyMMddHHmmsss(); 
						console.log("????????? ???????????? ????????? ?????? ?????? ??? ????????? ??????.. ??? ???????????>>>>>>>>>>>>" +roomId);
						openChatRoom(); // ???????????? ??????
						}

				
            }
          

		  function pressEnter(ev) {
				if(ev.keyCode === 13){ //????????? ???????????? ????????? ?????? 
					ev.preventDefault();
					saveMessages($("#chattingRoomIn .emoji-wysiwyg-editor:first").text()); 
			  }
		  }
		

          function openChatRoom(roomTitle, roomLength) {
             
        	  //loadRoomList(roomId); 
        	  window.isOpenRoom = true; // ?????? ?????? ???????????? ???????????? ????????? ??? 
        	  if(roomTitle){ //?????? ????????? ?????? 
            	  document.getElementById('roomTitle').innerHTML = roomTitle; 
            	  $("#roomTitle").siblings().eq(0).text(" ("+roomLength+") ");
           	  }  
        	  loadMessageList(); //????????? ?????? 
              $('#tabMessageList').click();
            		      	
           }


			//?????? ????????? ?????? ?????? ??? ????????? ?????? ??????
          function setAddUserList() {
			 
              //????????? ???????????? ????????? ????????????.. ??????????????? ????????? ??? ????????? ?????? ??????..
        	  loadOnlineStatus();	
              
        	  curUserKey= window.curUserKey;
			  roomUserList = [window.curUserKey]; // ?????? ???????????????  	
			  roomUserName = [curName]; // ?????? ?????? ?????? 
			  roomId = '@make@' + curUserKey +'@time@' + yyyyMMddHHmmsss();
        	 
        	  var arrAddUserList = Array.prototype.slice.call($('#ulUserList li'));	 
        	  arrAddUserList.forEach(cbArrayForEach);
           }


          var cbArrayForEach = function(item){
        	 //?????? ???????????? ????????? ?????????	
        	  item.classList.remove('user-selected');		  
        	  //?????? ?????? ?????? ??????
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

      	  
          /** * ????????? ?????? */ 
          function loadMessageList(){                          
              var myKey = $('#curUserKey').val();                           
              var messageRef = database.ref('Messages/'+roomId);
              if(roomId){ 
                 document.getElementById('ulMessageList').innerHTML = ''; //????????? ?????? ??????                                               
                 messageRef.off();//???????????? ?????? ?????? ?????????????????? ????????? ??????. ????????? ?????? ????????? ???????????? ???????????? ????????? ??????.                           	  
                 messageRef.limitToLast(50).on('child_added', function(data){                    	
                     	var msgKey = data.val();                    	
           			 	messageListUp(data.key, msgKey.profileImg, msgKey.timestamp, msgKey.userName, msgKey.message, msgKey.uid);              				
	           			//????????? ?????? ????????? ??????...  
	           			 document.getElementById("chatBox").scrollTop = document.getElementById("chatBox").scrollHeight;
	           			//?????? ?????? ?????? ????????? ?????? ?????? 
						saveReadMessage(data.key);
						//?????? ?????? ????????? ?????? ?????? ??????
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
			




          /** ????????? ??????????????? ?????? */
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
						//????????? ?????? ?????? ?????? ???????????? ?????? ?????? ?????? ?????? ???????????? ????????? ??? ?????? ????????? ?????? ??????
						numOfNotreadMessages(roomId);						
						arrRoomListHtml.push(roomListUp(roomId, roomTitle, roomUserName,roomType, roomOneVSOneTarget, roomUserList, lastMessage, datetime));
						
					}); 		
				var reversedRoomList = arrRoomListHtml.reverse();				
				reversedRoomList.forEach(function(item, index){
					//console.log("????????? ?????? ??? ?????? ???????????? ?????? ?????? ??????... ??????...." + item);
					$('#ulRoomList').append(item);
					}); 
				});						
  	  		}

  		function onRoomListClick(event){			
  				$("#chattingRoomIn").removeClass("hidden");
  				$("#chattingList").addClass("hidden");				  		 	  		
  	  		roomFlag = 'tabRoomList'; //???????????? ??????????????? ?????? ?????? ?????? ????????? 	  		
  			// ????????? ?????? 
  			roomId = event.getAttribute('data-roomId'); 
  			roomTitle = event.getAttribute('data-roomTitle'); 
  			roomUserList = event.getAttribute('data-roomUserList').split('@spl@'); // ?????? ???????????????  			
  			roomUserName = event.getAttribute('data-roomUserName').split('@spl@'); // ?????? ?????? ?????? 
  			openChatRoom(roomTitle, roomUserList.length);          			
  	  		}

  		/** * RoomList ?????? ???????????? */ 
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

  		
 
 				/** * ???????????? ?????? ????????? ???????????? */ 
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
				var convertMsg = myConvertMsg(msg); //????????? ?????? ?????????????????? ?????? ?????? ?????? ??????.. ????????? ???????????? ??? ?????? ??????.. ?????????
				if(msg.length > 0){ 
					msgDiv.focus(); 
					msgDiv.val(""); 
					$("#chattingRoomIn .emoji-wysiwyg-editor:first").empty();
					var multiUpdates = {}; 
					var messageRef = database.ref('Messages/'+ roomId);
					var messageRefKey = messageRef.push().key	; // ????????? ?????? ????????? 
					var roomUserListLength = roomUserList.length; 
					//UsersInRoom ????????? ??????
					if(document.getElementById('ulMessageList').getElementsByTagName('li').length === 0){ //????????? ?????? ?????? ?????? ?????? 
						var roomUserListLength = roomUserList.length; 
						for(var i=0; i < roomUserListLength; i++){ 
							multiUpdates['UsersInRoom/' +roomId+'/' + roomUserList[i]] = true;														
						} 						

						database.ref().update(multiUpdates); // ?????? ????????? ?????? ??????????????? 
						loadMessageList(); //?????? ???????????? ?????? ???????????? ?????? ??????????????? ?????? ???????????? ?????? ??????????????? 
					} 
					
					multiUpdates ={}; // ?????? ????????? 

					//????????? ??? ?????? ????????? ?????? ????????? ?????? ?????? ?????? ?????? ??????..
					if(roomUserListLength>1){
						for(var i=0; i < roomUserListLength; i++){ 							
							multiUpdates['MessagesByUser/' +roomUserList[i]+'/' + roomId+'/' + messageRefKey] = {
									readOk : 'false'								
									};  							
					         } 					
					database.ref().update(multiUpdates); 
					
					}	
															
					multiUpdates ={}; // ?????? ????????? 

					//????????? ?????? 
					multiUpdates['Messages/' + roomId + '/' + messageRefKey] = { 
							uid: curUserKey, 
							userName: curName, 
							message: convertMsg, // ?????? ?????? ??????
							profileImg: curProfilePic ? curProfilePic : 'noprofile.png', 
							timestamp: firebase.database.ServerValue.TIMESTAMP //???????????? ???????????? 
					} 

					//????????? ???????????? ?????? 
					var roomUserListLength = roomUserList.length;
					 
					if(roomUserList && roomUserListLength > 0){ 
						for(var i = 0; i < roomUserListLength ; i++){ 
							multiUpdates['RoomsByUser/'+ roomUserList[i] +'/'+ roomId] = { 
								roomId : roomId,
								roomTitle : roomTitle, 
								roomUserName : roomUserName.join('@spl@'), 
								roomUserList : roomUserList.join('@spl@'), 
								roomType : roomUserListLength > 2 ? 'MULTI' : 'ONE_VS_ONE', 
								roomOneVSOneTarget : roomUserListLength == 2 && i == 0 ? roomUserList[1] : // 1??? 1 ???????????? i ?????? 0 ?????? 
									roomUserListLength == 2 && i == 1 ? roomUserList[0] // 1??? 1 ?????? ?????? i?????? 1?????? 
									: '', // ????????? 
								lastMessage : convertMsg, 
								profileImg : curProfilePic ? curProfilePic : 'noprofile.png', 
								timestamp: firebase.database.ServerValue.TIMESTAMP 
							}; 
						} 
					} 
					database.ref().update(multiUpdates);

					//RoomsByUser ?????? ???????????? ??? ?????? ?????? ????????? ?????? ??????										
					loadRoomList(curUserKey);			
				} 
		   }



          
          /** * ???????????? yyyyMMddHHmmsss????????? ?????? */ 
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

          
              /** * timestamp??? ?????? ?????? ?????? ?????? */ 
              var timestampToTime = function(timestamp){ 
                  var date = new Date(timestamp), 
                  	  year = date.getFullYear(), 
                  	  month = date.getMonth()+1, 
                  	  day = date.getDate(), 
                  	  hour = date.getHours(), 
                  	  minute = date.getMinutes(), 
                  	  week = new Array('???', '???', '???', '???', '???', '???', '???'); 
              	  var convertDate = year + "??? "+month+"??? "+ day +"??? ("+ week[date.getDay()] +") "; 
              	  var convertHour=""; 
              	  if(hour < 12){ 
                  	  convertHour = "?????? " + pad(hour) +":" + pad(minute); 
                  	  }else if(hour === 12){ 
                      	  convertHour = "?????? " + pad(hour) +":" + pad(minute); 
                      	  }else{ convertHour = "?????? " + pad(hour - 12) +":" + pad(minute); 
                      	  } 
              	  return convertDate + convertHour; 

              }

              
          

          var rootRef = database.ref();

		  //????????? ????????? ?????? ????????? ??? ?????? ?????? ?????? ?????? ??????....	
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
              //??????????????? ??????
			  if(message.lastIndexOf("?????? ?????????????????????.")>0){
				  messageTemplate = '<li  class="text-center chat-item mt-2 mb-3" data-key="' + key + '">'
				  								+ '<b>'+ message+'</b>'
				  								+ '</li>';
				  $('#ulMessageList').append(messageTemplate);
				  return;
			  }	
			  //?????? ????????? ??????
			  if(message.lastIndexOf("?????? ??????????????????.")>0){
				  
				 				  messageTemplate = '<li  class="text-center chat-item mt-2 mb-3" data-key="' + key + '">'
				  			  								+ '<b>'+ message+'</b>'
				  			  								+ '</li>';
				  
				  				  $('#ulMessageList').append(messageTemplate);
				  				  return;
				   			  }	
   			  //??????????????? ???????????? ?????? ?????? ???????????? ?????? ?????????.				  
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
        	  				saveMessages(curName + "?????? ??????????????????.");//????????? ???????????? ????????? ??????
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
              console.log("??? ?????? ????????? ??? ????????? ?????? ??" + roomFlag);
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
            	  var inviteUserName = arrInviteUserList[i].getAttribute('data-username') + '???'; 
            	  updates['UsersInRoom/'+ roomId +'/'+ inviteUserUid] = true; 
            	  //arrInviteUserList[i].outerHTML = ''; 
            	  roomUserList.push(inviteUserUid); 
            	  roomUserName.push(inviteUserName); 
            	  arrInviteUserName.push(inviteUserName); 
            	  } 

        	  roomUserList.sort(); 			 
			  var arrRoomList = Array.prototype.slice.call($('#ulRoomList > li'));       	          	     
				//?????? ?????? ????????? ???????????? ???????????? ????????? ???????????? ????????? ?????? ????????? ???????????? ??????        	 
      	      arrRoomList.forEach(function(item, index){
				var aroomUserList = item.getAttribute('data-roomUserList').split('@spl@');
      	        if(JSON.stringify(roomUserList)==JSON.stringify(aroomUserList)){     	    	      	    	 
      	    	 isRoom(item);//???????????? ?????? ?????? ?????? ??? ?????????.. ????????? ?????? ?????? ????????? ???????????? ??????....
          	           }     		
      	         });
      	      database.ref().update(updates); //UsersInRoom DB ??????
      	      //?????? ????????? 
      	      arrInviteUserName.forEach(function(item, index){
      	     	  saveMessages(item + '??? ?????????????????????.');     	    	
          	    });           
      	      //??????????????? ????????? ???????????? ??????
      	      var justCreatedRoom = document.getElementById('liRoom' + roomId);     	    
      	          onRoomListClick(justCreatedRoom);
      	                

           }

          function isRoom(item) {
        	  var txt;
        	  var r = confirm("?????? ?????? ?????? ?????????. ?????? ????????? ?????? ????????????");
        	  if (r == true) {
        	    console.log("??? ???????????? ?????? ????????????... ?????? ??????????????? ?????????.. ???????????????..");
        	    onRoomListClick(item);
        	  } 
        	}	


			
          console.log("????????????" + curName + " / " + curEmail);


          function checkOnline(){ 
              var userUid = curUserKey; 
              var myConnectionsRef = database.ref('UsersConnection/'+userUid+'/connection'); 
              var lastOnlineRef = database.ref('UsersConnection/'+userUid+'/lastOnline'); 
              var connectedRef = database.ref('.info/connected'); 
              connectedRef.on('value', function(snap) { 
                  if (snap.val() === true) { 
                      myConnectionsRef.set(true); // ?????? ?????? ????????? 
                      myConnectionsRef.onDisconnect().set(false); 
                      lastOnlineRef.onDisconnect().set(firebase.database.ServerValue.TIMESTAMP); 
                      } 
                  }); 
              }

			//?????? ??? ?????? ?????? ?????? ?????????
			function owlInit(curUserKey){
				//????????? ??? ?????? ??????
				loadRoomList(curUserKey);
                //?????? ?????? ?????? ?????? ??????...
                checkOnline();	
                //fcm ????????? ?????? ?????? ?????? ?????????... ?????? ????????? uid ??? fb db ?????? ?????? ?????? ??????.. ?????????..??????..??? ????????? fb db ??? fcm token wjwkd gksms gkatn
    			saveFCMToken();
    			//????????? ?????? ?????? ???
    			loadPushNotice(curUserKey);
    			//?????? ?????? ????????? ?????? ?????? ??????
    			numOfNotreadNotices(curUserKey);
    			 //????????? ?????? ??? ?????? ????????? ??????
        		$('#aBackBtn').click(onBackBtnClick);
        		 //?????? ????????? ?????? ?????????
    		    $('#dnModal').modal(); 				 
    			//????????? ?????? modal ?????? 
    			$('#dvAddUser').modal();  
    		    //?????? ??????????????? ?????? ?????? ?????????  ????????? ????????? ?????? ????????? ???????????? ?????? ?????????
    			$('#onCreateClick').click(onCreateClick);       			
    			//???????????? ???????????? ????????? ????????? ?????????....
    			$('#collapseOne4, #collapseTwo5, #collapseThree6, #collapseThree7').on('shown.bs.collapse', saveReadNotice);
    			//????????? ????????? ????????? ????????? ?????? ?????? ????????? ?????? ?????? ????????? ??????
    			$("#chattingRoomIn .emoji-wysiwyg-editor:first").keydown(pressEnter);
				}

		  // ????????? ??? ?????? ????????? ??????... ?????? ??????????????? ?????? ??????????????? ???????????? ???????????? ????????? ?????? ????????? ???????????? ????????????.	
          $(function(){           
			var curUserKey;
			//?????? ????????? ????????? ?????????????????? ????????? ?????? ????????? ????????? ???????????? ??????..					
            writeUserData(curName, curEmail, curProfilePic).then(function(resolvedData){
				console.log("?????? ???????????? user ????????????>>" + resolvedData + "<<<<<");
                $('#curUserKey').val(resolvedData);//html ????????? 
                curUserKey = $('#curUserKey').val();//??? ?????? ????????? ???????????? ?????? ?????? ??????
                window.curUserKey = resolvedData;//????????? ????????? ?????? ?????? ???????????? ??????
                owlInit(resolvedData);
                  
              }); 

            //?????? ??????????????? ?????? ?????? ????????? ???????????? ?????????...????????? ?????? ????????? ????????? ????????? ?????? ?????? ??????.
      		$.ajax({
      			url: "MyProjectsMates.do",
      			type: "POST",
      			dataType: 'json',
      			data : { email : curEmail,
      				     name : curName }, 
      			success: function (data) {
      				console.log("???????????? ????????? ?????? ??????????? >" + data);   				
      				$.each(data, function(index, value) {          				    				  
      				  console.log(value.name + " / " + value.email + " / " + value.profilePic);    				
      				writeUserData(value.name, value.email, value.profilePic).then(function(resolvedData){          				    					
    				//????????? ??????????????? ?????? ???????????? ?????? ?????? ?????? ???
    				userListUp(resolvedData, value.name, value.profilePic, value.email);						
      					});
      				});	
      			},
      			error: function(xhr, status, error){
          			console.log("????????? ?????? ?????? ??????");
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