<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
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
	<!-- DataTable -->
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.css"/>
	<script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.js"></script>
	<!-- Toast Ui -->
    <link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.css" />
    <script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.js"></script>
	<script src="https://uicdn.toast.com/tui.dom/v3.0.0/tui-dom.js"></script>
	<script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.min.js"></script>
	<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.min.js"></script>
	<script src="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.js"></script>
	
	<!-- Chart.js -->
	 <script src="https://www.chartjs.org/dist/2.9.3/Chart.min.js"></script>    
	 <script src="https://www.chartjs.org/samples/latest/utils.js"></script>
 
	<!--  dashboard css -->
	<link href="resources/css/dashBoard.css" rel="stylesheet">
	<script src="resources/js/dashBoard.js"></script>

	<style>
	#dashCalendar > .tui-full-calendar-layout.tui-view-8.tui-view-13{
	display: none !important;
	}
</style>	 	
<script type="text/javascript">
	$(function(){
		 setTheme("${setting.themeColor}", "${setting.font}");
		 initDashBoard(0);
	})
</script>
</head>

<body class="mainBody">
	<!-- LOADER -->
    <div class="preloader">
        <div class="lds-ripple">
            <div class="lds-pos"></div>
            <div class="lds-pos"></div>
        </div>
    </div>
   
    <div id="main-wrapper">
        
		<!-- TOP -->
        <jsp:include page="../include/top.jsp"/>
       
        <!-- SIDE BAR -->
        <jsp:include page="../include/sideBar.jsp"/>

		<!-- CONTENT BOX -->
        <div class="page-wrapper">
        
		<!-- DASHBOARD  -->
		<jsp:include page="../dashBoard/mainDashboard.jsp"/>
		
		<!-- BOTTOM -->
        <jsp:include page="../include/bottom.jsp"/>
    </div>
 </div>
</body>