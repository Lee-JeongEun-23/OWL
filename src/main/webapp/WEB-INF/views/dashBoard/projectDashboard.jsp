<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

 	<!-- Chart.js -->
 <script src="https://www.chartjs.org/dist/2.9.3/Chart.min.js"></script>    
 <script src="https://www.chartjs.org/samples/latest/utils.js"></script>   
 
 <script type="text/javascript"> 
//왼쪽에 위치한 프로젝트 리스트 목록 출력 및 팝업창에서의 프로젝트 리스트 출력
function setSchedules() {
    cal.clear();
    generateSchedule(cal.getViewName());
    cal.createSchedules(ScheduleList);
    refreshScheduleVisibility();
}

function generateSchedule(viewName) {         
	$.ajax({
		url:"GetProjectCalendar.do",
		dataType:"json",
		async: false,
		data: {projectIdx: ${project.projectIdx}},
		success:function(data){
	    	ScheduleList = [];
			$.each(data, function(index, element){
		    	let calendar;
		    	let schedule = new ScheduleInfo();
				$.each(CalendarList, function(index, obj){
		    		if(obj.id == element.projectIdx){
		    			calendar = obj;
		    			return false;
		    		}
		    	})		    	
		    	GetCalendar(calendar, element);				
			});
	    }

    });
}

function GetCalendar(calendar, element){
	 let data = {
	            id: String(element.calIdx),
	            title: element.title,
	            isAllDay: element.allDay >0 ? true : false,
	            start: element.startDate,
	            end: element.endDate,
	            category: element.allDay >0 ? 'allday' : 'time',
	            dueDateClass: '',
	            color: "#ffffff",
	            bgColor: $("#proColor").val(),
	            dragBgColor: $("#proColor").val(),
	            borderColor: $("#proColor").val(),
	            location: element.content,
	             raw: {
	                class: "public"
	            },
	            state: "Busy" 
	        };
        
	        if (calendar) {
	        	data.calendarId = calendar.id;
	        	data.color = calendar.color;
	        	data.bgColor = calendar.bgColor;
	        	data.borderColor = calendar.borderColor;
	        }

	        cal.createSchedules([data]);

	        refreshScheduleVisibility();
}

function refreshScheduleVisibility() {
    var calendarElements = Array.prototype.slice.call(document.querySelectorAll('#calendarList input'));

    CalendarList.forEach(function(calendar) {
        cal.toggleSchedules(calendar.id, !calendar.checked, false);
    });

    cal.render(false);

    calendarElements.forEach(function(input) {
        var span = input.nextElementSibling;
        span.style.backgroundColor = input.checked ? span.style.borderColor : 'transparent';
    });
}

</script>   
  <!-- CONTENT MAIN -->
<div class="container-fluid" style="padding:20px">
    <div class="row">
        <c:if test="${project.authority eq 'ROLE_PM'}">
            <div class="col-lg-12">
                <div class="card dash_shadow dash_radius" style="height: 450px">
                    <div class="card-body">
                        <h4 class="card-title">Member Progress</h4>
                        <div class="align-items-center " style="height: 370px">
                            <canvas id="dashBoardMemberProgress"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="col-lg-6">
            <div class="card dash_shadow dash_radius" style="height: 450px">
                <div class="card-body">
                    <h4 class="card-title">Issue Task</h4>
                    <div id="dashBoardPTableEmptyBox" class="emptyBox">
                        <div>
                            <h3 class="mb-4">프로젝트 내에 할당된 이슈가 없습니다.</h3>
                        </div>
                    </div>
                    <div id="dashBoardPTableBox" class="hidden">
                        <table class="table table-hover table-bordered text-center w-100"
                            id="dashboardPTable">
                            <thead>
                                <tr>
                                    <th width="5%">No</th>
                                    <th width="60%">Subject</th>
                                    <th width="25%">Due Date</th>
                                    <th width="10%">Priority</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="card dash_shadow dash_radius">
                <div class="card-body">
                    <h4 class="card-title">Calendar</h4>
                    <br>
                    <input type="hidden" value="${project.projectColor}" id="proColor">
                    <div class="d-md-flex align-items-center">
                        <div id="dashCalendar" class="w-100 h-100"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card dash_shadow dash_radius">
                <div class="card-body">
                    <h4 class="card-title" style="margin-bottom: 0px;">Progress Chart</h4>
                    <div class="align-items-center">
                        <div class="row">
                            <div class="col-md-6 hidden" id="OurProgressNone"
                                style="text-align: center; height: 150px;">
                                <h4 style="margin-top: 40px;">프로젝트 내에 할당된 </h4>
                                <h4>이슈가 없습니다.</h4>
                            </div>
                            <div class="col-md-6" id="chartProjectProgress"> </div>
                            <div class="col-md-6 hidden" id="MyProgressNone"
                                style="text-align: center; height: 150px;">
                                <h4 style="margin-top: 40px;">나에게 할당된</h4>
                                <h4> 이슈가 없습니다.</h4>
                            </div>
                            <div class="col-md-6" id="chartMyProgress"> </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card dash_shadow dash_radius" style="height: 450px">
                <div class="card-body">
                    <h4 class="card-title">Label Chart</h4>
                    <div class="align-items-center" id="labelProgress"> </div>
                </div>
            </div>

            <div class="card dash_shadow dash_radius">
                <div class="card-body" style="height: 470px;">
                    <h4 class="card-title">Timeline</h4>
                    <h6 id="timeLinePDate"></h6>
                    <div id="dashboardPTimeLineEmptyBox" class="emptyBox hidden">
                        <div>
                            <h3 class="mb-4">이번주 일정이 존재하지않습니다.</h3>
                            <h4 class="mt-1"></h4>
                        </div>
                    </div>
                    <div style="height: 350px; overflow: auto">
                        <div class="d-md-flex align-items-center" id="dashboardPTimeLine">
                            <ul class="timeline w-100">

                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
<script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.min.js"></script>
<script src="https://uicdn.toast.com/tui.dom/v3.0.0/tui-dom.js"></script>
<script src="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.1/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/chance/1.0.13/chance.min.js"></script>
<script src="resources/plugin/calendar/dashCalendar.js"></script>
