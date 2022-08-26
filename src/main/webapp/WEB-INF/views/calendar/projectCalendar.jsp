<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>   
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

.tui-full-calendar-layout{
margin-left: 30px;
margin-right: 30px;
}

#tui-full-calendar-schedule-location{
top: 4px !important;
}
#tui-full-calendar-schedule-title{
top: 1px !important;
height: 27px !important;
}
.tui-full-calendar-weekday-grid-line.tui-full-calendar-near-month-day{
border-bottom : 1px solid #e5e5e5 !important;
}
</style>
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

            <!-- CONTENT MAIN -->
    <div class="container-fluid">
            <div class="row">
		    <div class="col-md-12">
			    <br>
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
    <script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.min.js"></script>
	<script src="https://uicdn.toast.com/tui.dom/v3.0.0/tui-dom.js"></script>
	<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.min.js"></script>
	<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.min.js"></script>
	<script src="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.js"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/chance/1.0.13/chance.min.js"></script>
