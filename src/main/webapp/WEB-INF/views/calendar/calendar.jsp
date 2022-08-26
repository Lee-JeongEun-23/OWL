<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>OWL</title>
    <jsp:include page="../include/headTag.jsp"/>
    
    <!-- Toast Ui -->
	<link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.css" />
	<!-- If you use the default popups, use this. -->
	<link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
	<link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
<style type="text/css">
#menu{
	padding: 16px;
	font-size: 12px;
}
.calendarBtn{
background-color: #fff;
border-radius: 25px;
color: #333;
display: inline-block;
margin-bottom: 0;
text-align: center;
cursor: pointer;
border: 1px solid #ddd;
padding: 0 16px;
line-height: 30px;
}
#renderRange {
    padding-left: 12px;
    font-size: 19px;
    vertical-align: middle;
}  

.move-today{
padding: 0 16px;
line-height: 30px;
}  

.dropdown-menu > li {
    padding: 9px 12px;
    cursor: pointer;
    height: 38px; 
    width: 205px;   
}    

.open>.dropdown-menu {
    display: block;
}    
.dropdown-menu {
    top: 25px;
    padding: 3px 0;
    border-radius: 2px;
    border: 1px solid #bbb;
}

.dropdown-menu >li:hover .fa-hand-point-right{
visibility: visible !important;
}

.tui-full-calendar-section-calendar.tui-full-calendar-hide{
	visibility: visible !important;
}
.tui-full-calendar-confirm{
	background-color: #326295;
	font-size: 14px;
}
.tui-full-calendar-confirm:hover{
	color: #326295;
	border: 1px double #326295;
	background-color: #fff;
}
.lnb-calendars-item{
	margin-bottom: 10px;
}

.tui-full-calendar-popup-section-item.tui-full-calendar-section-title{
	width: 461px !important;
}

.tui-full-calendar-popup-section-item.tui-full-calendar-section-location{
		height: 42px !important;
		margin-bottom: 10px !important;
}

.tui-full-calendar-popup-section.tui-full-calendar-dropdown.tui-full-calendar-close.tui-full-calendar-section-state{
	display: none !important;
}

#tui-full-calendar-schedule-private{
	display: none !important;
}

.tui-full-calendar-popup-container{
    padding-top: 25px !important;
}

.tui-full-calendar-icon.tui-full-calendar-ic-location{
background:url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAA9UlEQVQokX3STSuFQRjG8d/xUk72SNnQiZ3TWVpJITtbu7O0UHwAtmx8DyzsFSmilCg+gEgkLJTyFofFmSfT0zznqmlm7nv+c1/NPTS1hBf8FowGTjEUziuhgnNM40pabVhGP2az4BQuCoBYk7jMNh1RogsbYc5rG9dxIAY/sYlyAjxDbxHYjpGCivd4w0cKLAUoBXbiCOMp8BsnOav7eAzrYdRxgJ3848znKj4EcBR7OMQCajH4jpmEzSp2cYeB4Kyb1n2s4gmLweoX1rJkK/AYKxjETQzR/HKvGEOf/3714AfruMVq6ub4kzdQwwSesYW5PPAHNCg4N4Y0WccAAAAASUVORK5CYII=') no-repeat !important;
}
.tui-full-calendar-ic-location-b{
background:url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAA80lEQVQokW3RvS4EURQH8N/szhIf2YiEUCloiFAoJRrVdmoPINF6F4nOE0hU20joJApB5QFUssKGYFiZUczZZDLc5Oaee+75f9xzEizhABto+bsynOIYvRTrGME+XmrFCVbQweIQMIUevrCKZgXwHiQZxiGNhwIz/9h6wn1VMq3EA3zUAJ/B/orvKiCJwok4i7AIzzgJa42qpSySrWC+xAPmsIkc3brCaKj+xJ7HHtaUnXwcAnJc4yruTWUbdzEWfxugX1XII1lgGjuhdosGLnDTQB+zWMYC2mFlC5PK2Zwpp/2W4g7bOAr2wyBph0IX59Favyp2O6MuUf5JAAAAAElFTkSuQmCC') no-repeat !important;
}
.tui-full-calendar-ic-state-b+span{
display: none !important;
}
.tui-full-calendar-ic-state-b{
display: none !important;
}
</style>
<script type="text/javascript">
//왼쪽에 위치한 프로젝트 리스트 목록 출력 및 팝업창에서의 프로젝트 리스트 출력
$(function(){
	setTheme("${setting.themeColor}", "${setting.font}");
		$.ajax({
    		url:"ProjectList.do",
    		success:function(data){
        		console.log(data);        		
    		    let calendar;
    			$.each(data, function(index, element){
					calendar = new CalendarInfo();
					calendar.id = String(element.projectIdx);
				    calendar.name = element.projectName;
				    calendar.color = '#ffffff';
				    calendar.bgColor = element.projectColor;
				    calendar.dragBgColor = element.projectColor;
				    calendar.borderColor = element.projectColor;
				    addCalendar(calendar);		    						
    			})
    			var calendarList = document.getElementById('calendarList');
    		    var html = [];
    		    CalendarList.forEach(function(calendar) {
    		        html.push('<div class="lnb-calendars-item"><label>' +
    		            '<input type="checkbox" class="tui-full-calendar-checkbox-round" value="' + calendar.id + '" checked>' +
    		            '<span style="border-color: ' + calendar.borderColor + '; background-color: ' + calendar.borderColor + ';"></span>' +
    		            '<span>' + calendar.name + '</span>' +
    		            '</label></div>'
    		        );
    		    });
    		    calendarList.innerHTML = html.join('\n\n');
    		    setSchedules();
    		}
    	});
});

function setSchedules() {
    cal.clear();
    generateSchedule(cal.getViewName());
    cal.createSchedules(ScheduleList);
    refreshScheduleVisibility();
}

function generateSchedule(viewName) {         

	$.ajax({
		url:"GetMyAllCalendars.do",
		dataType:"json",
		async: false,
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
	            bgColor: calendar.bgColor,
	            dragBgColor: calendar.bgColor,
	            borderColor: calendar.borderColor,
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
            <div class="page-breadcrumb themeChange">
                <div class="row">
                    <div class="col-12 d-flex no-block align-items-center" style="border-bottom: 1px solid #326295; padding-bottom: 15px;">
                        <h4 class="page-title themeChangeLetter" style="color:#326295;">&nbsp;My Calendar</h4>
                    </div>
                </div>
            </div>

            <!-- CONTENT MAIN -->
            <div class="container-fluid themeChange themeChangeLetter" style="height: 800px;">
            <div class="row">
            <div class="col-md-2">
			    <div id="lnb">
			        <div id="lnb-calendars" class="lnb-calendars">
			            <div>
			            <br>
			                <div class="lnb-calendars-item">
			                    <label>
			                        <input class="tui-full-calendar-checkbox-square" type="checkbox" value="all" checked>
			                        <span></span>
			                        <strong>View all</strong>
			                    </label>
			                </div>
			            <hr style="margin-top: 14px !important;">
			            <div id="calendarList" class="lnb-calendars-d1">
			            </div>
			            </div>
			        </div>
			    </div>
		    </div>
		    <div class="col-md-10">
			    <div id="right">
			        <div id="menu">
			            <span class="dropdown">
			                <button id="dropdownMenu-calendarType" class="calendarBtn btn-sm dropdown-toggle" type="button" data-toggle="dropdown"
			                    aria-haspopup="true" aria-expanded="true">
			                    <i id="calendarTypeIcon" class="far fa-hand-point-right" style="margin-right: 4px;"></i>
			                    <span id="calendarTypeName">Dropdown</span>&nbsp;
			                </button>
			                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu-calendarType">
			                    <li role="presentation">
			                        <a class="dropdown-menu-title" role="menuitem" data-action="toggle-daily">
			                            <i class="far fa-hand-point-right" style="margin-right: 5px; visibility: hidden;"></i>Daily
			                        </a>
			                    </li>
			                    <li role="presentation">
			                        <a class="dropdown-menu-title" role="menuitem" data-action="toggle-weekly">
			                            <i class="far fa-hand-point-right" style="margin-right: 5px; visibility: hidden;"></i>Weekly
			                        </a>
			                    </li>
			                    <li role="presentation">
			                        <a class="dropdown-menu-title" role="menuitem" data-action="toggle-monthly">
			                            <i class="far fa-hand-point-right" style="margin-right: 5px; visibility: hidden;"></i>Month
			                        </a>
			                    </li>
			                    <li role="presentation">
			                        <a class="dropdown-menu-title" role="menuitem" data-action="toggle-weeks2">
			                            <i class="far fa-hand-point-right" style="margin-right: 5px; visibility: hidden;"></i>2 weeks
			                        </a>
			                    </li>
			                    <li role="presentation">
			                        <a class="dropdown-menu-title" role="menuitem" data-action="toggle-weeks3">
			                            <i class="far fa-hand-point-right" style="margin-right: 5px; visibility: hidden;"></i>3 weeks
			                        </a>
			                    </li>
			                    <li role="presentation">
			                        <a role="menuitem" data-action="toggle-workweek">
			                            <input type="checkbox" class="tui-full-calendar-checkbox-square" value="toggle-workweek" checked>
			                            <span class="checkbox-title"></span>Show weekends
			                        </a>
			                    </li>
			                    <li role="presentation">
			                        <a role="menuitem" data-action="toggle-start-day-1">
			                            <input type="checkbox" class="tui-full-calendar-checkbox-square" value="toggle-start-day-1">
			                            <span class="checkbox-title"></span>Start Week on Monday
			                        </a>
			                    </li>
			                    <li role="presentation">
			                        <a role="menuitem" data-action="toggle-narrow-weekend">
			                            <input type="checkbox" class="tui-full-calendar-checkbox-square" value="toggle-narrow-weekend">
			                            <span class="checkbox-title"></span>Narrower than weekdays
			                        </a>
			                    </li>
			                </ul>
			            </span>
			            <span id="menu-navi">
			                <button type="button" class="calendarBtn btn-sm move-today" data-action="move-today">Today</button>
			                <button type="button" class="calendarBtn btn-sm move-day" data-action="move-prev">
			                    	<i class="fas fa-angle-left" data-action="move-prev"></i>
			                </button>
			                <button type="button" class="calendarBtn btn-sm move-day" data-action="move-next">
			                    <i class="fas fa-angle-right" data-action="move-next"></i>
			                </button>
			            </span>
			            <span id="renderRange" class="render-range"></span>
			        </div>
			        <div id="calendar"></div>
			    </div>
			    </div>
            </div>
            </div>
    <script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.min.js"></script>
	<script src="https://uicdn.toast.com/tui.dom/v3.0.0/tui-dom.js"></script>
	<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.min.js"></script>
	<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.min.js"></script>
	<script src="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.js"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chance/1.0.13/chance.min.js"></script>
    <script src="resources/plugin/calendar/calendars.js"></script>
    <script src="resources/plugin/calendar/schedules.js"></script>
    <script src="resources/plugin/calendar/app.js"></script>
            <!-- BOTTOM -->
            <jsp:include page="../include/bottom.jsp" />
        </div>
    </div>
</body>