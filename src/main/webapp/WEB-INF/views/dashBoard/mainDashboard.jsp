<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Chart.js -->
<script src="https://www.chartjs.org/dist/2.9.2/Chart.min.js"></script>
<script src="https://www.chartjs.org/samples/latest/utils.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<style>
    .tui-full-calendar-month.tui-view-27.tui-view-28.tui-full-calendar-vlayout-container {
        display: none;
    }
</style>

<!-- CONTENT MAIN -->
<div class="container-fluid" style="padding:20px">
    <div class="row" class="h-100 w-100">
    	<div id="myDashBoardEmptyBox" class="emptyBox" class="row">
    		<div class="col-lg-12">
	            <div class="card dash_shadow dash_radius">
	                <div class="card-body" style="margin-bottom: 10px;">
	                    <div class="align-items-center" id="emptyProject">
									<img src="resources/images/monitor.png" style="width: 300px;">
									<br>
									<br>
									<h4>참여중인 프로젝트가 없습니다.</h4>
									<br>
									<h4>새로운 프로젝트를 시작해보세요.</h4>
	                    </div>
	                </div>
	            </div>
	        </div>
    	</div>
	    <div id="myDashBoardBox" class="row">
	         <!-- IssueTask -->
	        <div class="col-lg-6">
	            <div class="card dash_shadow dash_radius" style="height: 480px;">
	                <div class="card-body">
	                    <h4 class="card-title">Issue Task</h4>
	                    <div id="dashBoardTableEmptyBox" class="emptyBox">
		                    <div>
		                    	<h3 class="mb-4">나에게 할당된 이슈가 없습니다.</h3>
		                    </div>
	                    </div>
	                    <div id="dashBoardTableBox" class="hidden">
		                    <table class="table table-hover table-bordered text-center w-100" id="dashboardTable">
		                        <thead>
		                            <tr>
		                                <th width="25%">Project</th>
		                                <th width="40%">Subject</th>
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
	        </div>
	        <!--//  IssueTask -->
	        
	        <!-- TimeLine -->
	        <div class="col-lg-6">
	            <div class="card dash_shadow dash_radius"  style="height: 480px;">
	                <div class="card-body h-100">
	                    <h4 class="card-title">Timeline</h4>
	                    <h6 id="timeLineDate"></h6>
	                    <div id="dashboardTimeLineEmptyBox" class="emptyBox hidden">
		                    <div>
		                    	<h3 class="mb-4 mt-4">이번주 일정이 존재하지않습니다.</h3>
		                    	<h4 class="mt-1"> (2020-01-29 ~ 2020-02-07)</h4>
		                    </div>
	                    </div>
	                    <div style="height: 380px; overflow: auto">
	                    <div class="d-md-flex align-items-center" id="dashboardTimeLine"  >
	                        <ul class="timeline w-100" >
	                        </ul>
	                    </div>
	                   </div>
	                </div>
	            </div>
	        </div>
	        <!-- // TimeLine -->
	        
	        <div class="col-lg-12">
	            <div class="card dash_shadow dash_radius w-100">
	                <div class="card-body w-100">
	                    <h4 class="card-title" style="margin-bottom: 0px;">My Issue Progress Chart</h4>
	                    <div class="align-items-center">
	                        <div><div class="row" id="myProgressChart"></div> </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	        <div class="col-lg-6">
	            <div class="card dash_shadow dash_radius">
	                <div class="card-body">
	                    <h4 class="card-title">Project Contribution Chart</h4>
	                    <div class="align-items-center">
	                        <canvas id="myLine"></canvas>
	                    </div>
	                </div>
	            </div>
	        </div>
	
	        <div class="col-lg-6">
	            <div class="card dash_shadow dash_radius">
	                <div class="card-body">
	                    <h4 class="card-title">Project Progress Chart</h4>
	                    <div class="align-items-center" id="horizon">
	                    	<canvas id="myHorizon"></canvas>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
    </div>
</div>