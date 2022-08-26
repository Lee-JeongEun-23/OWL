<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<link href="resources/css/include.css" rel="stylesheet">
<link rel="stylesheet" href="https://kendo.cdn.telerik.com/2020.1.114/styles/kendo.default-v2.min.css"/>
<script src="https://kendo.cdn.telerik.com/2020.1.114/js/kendo.all.min.js"></script>

<style>
.asColorPicker-wrap {
    position: relative !important;
    display: inline-flex;
    width : 100%;
}

.asColorPicker-trigger{
    left: 0px;
    height: 45px !important;
}

.asColorPicker-dropdown{
max-width: 270px;
}
.k-textbox{
width: 100% !important;
height: 41.979166px;
}
.k-widget.k-dateinput.k-state-default{
width: 230px;
}
.endDatePicker{
left: 60px;
}
.k-calendar.k-calendar-range.k-range-end.k-link, .k-calendar.k-calendar-range.k-range-start.k-link {
    background-color: #326295!important;
}
.k-calendar .k-state-selected .k-link {
    border-color: #326295 !important;
    color: #fff;
    background-color: #326295 !important;
}
.k-nav-today{
color:#326295 !important;
}   
.k-today {
    color:#326295 !important;
} 
.k-calendar.k-calendar-range .k-range-end, .k-calendar.k-calendar-range .k-range-mid, .k-calendar.k-calendar-range .k-range-start {
    background-image: linear-gradient(transparent 1px,rgba(50, 98, 149,.25) 1px,rgba(50, 98, 149,.25) calc(100% - 1px),transparent calc(100% - 1px))!important;
}
.k-input::selection, .k-textarea::selection, .k-textbox::selection {
    color: black !important;
    background-color: white !important;
}

.sidebar-nav ul .sidebar-item .sidebar-link>span{
	font-weight: bold !important;
}
</style>
<script>
var theName;

 $(function(){
	 $(".complex-colorpicker").asColorPicker({
	        mode: 'complex'
    }); 
	 $("#daterangepicker").kendoDateRangePicker({
		 format: "yyyy/MM/dd",
		 parseFormats: ["yyyy-MM-dd"]
	});
	 $(".k-textbox-container").eq(1).addClass("endDatePicker");
	 $(".k-textbox").eq(0).attr("id", "setStart");
	 $(".k-textbox").eq(1).attr("id", "setEnd");
	 if($("#wholeFavorite > li").length >0){
			$(".sidebar-link.has-arrow.waves-effect.favoriteArrow").addClass("active");
			$("#wholeFavorite").addClass("in");			
			$(".sidebar-link.has-arrow.waves-effect.projectArrow").removeClass("active");
			$("#projectlist").removeClass("in");
					
	}else{
			$(".sidebar-link.has-arrow.waves-effect.favoriteArrow").removeClass("active");
			$("#wholeFavorite").removeClass("in");
			$(".sidebar-link.has-arrow.waves-effect.projectArrow").addClass("active");
			$("#projectlist").addClass("in");
	}	
	 

 $("#insertBtn").click(function(){
	 if(!$("#projectTitle").val() || !$("#myColor").val() || $("#myColor").val().startsWith("year")|| $("#setEnd").val().startsWith("year") ){
		warningAlert("모든 내용을 입력해주세요.");
		 return false;
	} 

	 let thisLi ="";
	 let theStartDate = new Date($("#setStart").val()).toString();
	 let theEndDate = new Date($("#setEnd").val()).toString();
 $.ajax({
	        url:"InsertNewProject.do",
	        type: "POST",
	        data: {projectName: 	$("#projectTitle").val(),
		        	  projectColor: $("#myColor").val(),
		        	  startDate: $("#setStart").val(),
		        	  endDate: $("#setEnd").val()},
	        success:function(idx){
	         	thisLi = "<li class='sidebar-item' id='"+idx+"' style='position:relative;'>"
            			+ "<input id='projectFavorite' type='hidden' value='0'>"
        				+ "<a href='Project.do?projectIdx="+idx+"' class='sidebar-link'>"
        				+ "<i class='mdi mdi-checkbox-blank-circle' style='color: "+$("#myColor").val()+";'></i>"
        				+ "<span class='hide-menu'>"+$("#projectTitle").val()+"</span></a>"
        				+ "<a type='button' id='sidebarTools' data-projectidx='"+idx+"' data-toggle='modal' data-target='#editProject'>"
        				+ "<i class='far fa-sun'></i></a></li>"; 	         	      
	         	$("#projectlist").append(thisLi);	 
	         	makeStart(idx, theStartDate);
	         	makeEnd(idx, theEndDate);	         	
	       }
	   }); 
	 });    
 $("#newProject").on('hidden.bs.modal', function (event) {
	  $(this).find('.modal-content.insertContent')[0].reset();
	  $(".asColorPicker-trigger").children('span').css("background", "#326295");
	}); 
		 
 $("#editProject").on('show.bs.modal', function (event) {
		let proIdx = $(event.relatedTarget).data('projectidx');
		$("#editBtn").attr("data-editidx", proIdx);
		$.ajax({
	        url:"GetProjectList.do",
	        dataType: 'json',
	        data: {projectIdx: proIdx},
	        success:function(data){
	         $("#myProjectTitle").empty();
	         $("#myProjectTitle").append('<i class="far fa-sun"></i> '+data.projectName+' 환경설정');
	         $("#nowColor").val(data.projectColor);
	         $(".modal-footer.edit > input").attr("value",data.projectName);
	         $(".asColorPicker-trigger").children('span').css("background", data.projectColor); 	         
	         	if(data.favorite == 0){
	         		$(".favoriteCheckbox").attr("checked",false);
		       }else if(data.favorite == 1){
		    	   $(".favoriteCheckbox").attr("checked",true);
			   } 
	       }
	   }); 			        
	}).on('hidden.bs.modal', function (e) {
	  $(this).find('.modal-content.editContent')[0].reset();
	}); 
 
 $("#editBtn").click(function(evt){
	 let thisLi ="";
	 let thisProIdx = $(this).attr('data-editidx');
	 let theName = $(this).siblings().eq(0).val();
	 let myFavorite =$(".favoriteCheckbox:checked").val() == "on" ? 1 : 0;
		$.ajax({
	        url:"EditMyProject.do",
	        type: "POST",
	        data: {projectIdx: thisProIdx,
		        	  projectColor: $("#nowColor").val(),
		        	  favorite: myFavorite},
	        success:function(newSet){
	         $('#projectlist > #'+thisProIdx+'> #projectFavorite').val(newSet.favorite);
	         $('#projectlist > #'+thisProIdx+'>.sidebar-link > i').attr('style', "color:"+newSet.projectColor+";");
	         $('#wholeFavorite > #'+thisProIdx+'>.sidebar-link > i').attr('style', "color:"+newSet.projectColor+";");
	         if(newSet.favorite == 1){
		 	 thisLi = "<li class='sidebar-item' id='"+newSet.projectIdx+"' style='position:relative;'>"
		 			+ "<input id='projectFavorite' type='hidden' value='"+newSet.favorite+"'>"
		 			+ "<a href='Project.do?projectIdx="+newSet.projectIdx+"' class='sidebar-link'>"
        		 	+ "<i class='mdi mdi-checkbox-blank-circle' style='color:"+newSet.projectColor+";'></i>" 
        		 	+ "<span class='hide-menu' id='projectName'>"+theName+"</span></a></li>";
	       	 	$("#wholeFavorite").append(thisLi);
		     }else if(newSet.favorite == 0){
		    	 $('#wholeFavorite > #'+thisProIdx+'').remove();
		    	 
			 }
	       }
	   });
	 });	
 });	
 function makeStart(idx, theStartDate){
	 $.ajax({
 		url:"InsertCalendar.do",
 		method:"POST",
 		data:{calendarId: idx,
 			       title: '🚩 프로젝트 시작',
     			   location: null,
 			       start: theStartDate,
 			       end: theStartDate,
 			       allDay: true
 			      },
 		success:function(data){	
 		}
	});
}
function makeEnd(idx, theEndDate){
	$.ajax({
		url:"InsertCalendar.do",
		method:"POST",
		data:{calendarId: idx,
			       title: '프로젝트 종료 🚩',
    			   location: null,
			       start: theEndDate,
			       end: theEndDate,
			       allDay: true
			      },
		success:function(data){	
		}
	});
}
</script>
<aside class="left-sidebar mySetting" data-sidebarbg="skin5">
    <div class="scroll-sidebar mySetting">
        <nav class="sidebar-nav" id="sidemenu">
        <c:set var="projectList" value="${projectList}"/> 
            <ul id="sidebarnav" class="p-t-30 mySetting">
            <li id="sidebarLable" class="sidebar-item hide-menu">MY</li>
                <li class="sidebar-item"> <a class="sidebar-link has-arrow waves-effect" href="javascript:void(0)" aria-expanded="true"><i class="mdi mdi-account-outline"></i><span class="hide-menu">MY TASK</span></a>
                    <ul aria-expanded="false" class="mySetting collapse first-level" style="padding-bottom: 0px;">
                        <li class="sidebar-item"><a href="Main.do" class="sidebar-link"><i class="mdi mdi-view-dashboard"></i><span class="hide-menu">DASHBOARD</span></a></li>
                        <li class="sidebar-item"><a href="Calendar.do" class="sidebar-link"><i class="mdi mdi-calendar"></i><span class="hide-menu">CALENDAR</span></a></li>
                    </ul>
                </li>
                <li class="sidebar-item"> <a class="sidebar-link has-arrow waves-effect favoriteArrow" href="javascript:void(0)" aria-expanded="true"><i class="mdi mdi-star-outline"></i> <span class="hide-menu">FAVORITES</span></a>
                    <ul aria-expanded="true" class="mySetting collapse first-level favorite" id="wholeFavorite">
                       <c:forEach var="list" items="${projectList}">
                       	<c:if test="${list.favorite == 1}">
	                    	<li class="sidebar-item" id="${list.projectIdx}" style="position:relative;">
	                    		<input id="projectFavorite" type="hidden" value="${list.favorite}">
	                    		<a href="Project.do?projectIdx=${list.projectIdx}" class="sidebar-link">
	                    			<i class="mdi mdi-checkbox-blank-circle" style="color: ${list.projectColor};"></i>
	                    			<span class="hide-menu" id="projectName">${list.projectName}</span>
	                    		</a>
	                    	</li> 
	                    	</c:if>                    
	                    </c:forEach>
                    </ul>
                </li>
                <li id="sidebarLable" class="hide-menu">PROJECT</li>    
                <li class="sidebar-item"> <a class="sidebar-link waves-effect waves-dark" type= "button" data-toggle="modal" data-target="#newProject"><i class="mdi mdi-plus"></i><span class="hide-menu">NEW PROJECT</span></a></li>           
                <li class="sidebar-item"> <a class="sidebar-link has-arrow waves-effect projectArrow" href="javascript:void(0)" aria-expanded="true"><i class="mdi mdi-laptop-windows"></i><span class="hide-menu">PROJECT LIST</span></a>
                    <ul aria-expanded="true" class="mySetting collapse first-level" id="projectlist">
	  					<c:forEach var="list" items="${projectList}">
	                    	<li class="sidebar-item" id="${list.projectIdx}" style="position:relative;">
	                    		<input id="projectFavorite" type="hidden" value="${list.favorite}">
	                    		<a href="Project.do?projectIdx=${list.projectIdx}" class="sidebar-link">
	                    			<i class="mdi mdi-checkbox-blank-circle" style="color: ${list.projectColor};"></i>
	                    			<span class="hide-menu">${list.projectName}</span>
	                    		</a>
	                    		<a type="button" id="sidebarTools" data-projectidx="${list.projectIdx}" data-toggle="modal" data-target="#editProject">
	                    			<i class="far fa-sun"></i>
	                    		</a>	
	                    	</li>                     
	                    </c:forEach>	           
                    </ul>
                </li>
            </ul>
        </nav>
    </div>
</aside>

<jsp:include page="../project/modal/newProject.jsp" />
	   <!-- 프로젝트 환경설정 Modal -->
<jsp:include page="../project/modal/editProject.jsp" />
