<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>OWL</title>
<jsp:include page="../include/headTag.jsp" />
<!-- Favicon icon -->
<link rel="icon" type="image/png" sizes="16x16"
	href="resources/images/favicon.png">
<!-- Pignose Calender -->
<link href="resources/plugins/pg-calendar/css/pignose.calendar.min.css"
	rel="stylesheet">
<!-- Chartist -->
<link rel="stylesheet"
	href="resources/plugins/chartist/css/chartist.min.css">
<link rel="stylesheet"
	href="resources/plugins/chartist-plugin-tooltips/css/chartist-plugin-tooltip.css">
<!-- Custom Stylesheet -->
<link href="resources/css/style.css" rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
<link rel="stylesheet"
	href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
<!-- fontawesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
<!-- Kakao -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" src="resources/js/commonSweetAlert.js"></script>
<style type="text/css">
.snsLoginButton {
	background-color: transparent;
	border: none;
	width: 50px;
	height: 50px;
	cursor: pointer;
}

.graycolor {
color: gray;
}

.verticalcenter {

  display: block;
  margin-left: auto;
  margin-right: auto;

}

body {
	background-color: #326295;
	overflow-y: hidden;
}
.text-primary_owl {
  color: #326295; }
</style>
</head>
<body>
	<div id="main-wrapper">

		<div class="text-center mt-5">
			<a href="Index.do"><img src="resources/images/owl_plz_beige.png"
				alt=""></a>
		</div>

		<!-- Content -->
		<div class="content-main " >
		<div class="login-form-bg " >
        <div class="container h-100" >
            <div class="row justify-content-center ">
                <div class="col-xl-6">
                    <div class="error-content">
                        <div class="card  mt-5">
                            <div class="card-body text-center">
                             <div class="text-primary_owl mt-5"><i class="fas fa-check-circle fa-9x"></i></div>
                                <h3 class="text-primary_owl mt-5"><b>회원탈퇴가 완료되었습니다.</b></h3>
                            
                                <h3 class="text-primary_owl"><b>이용해 주셔서 감사합니다.</b></h3> <br>
                                <h4 class="graycolor">Thank you for using &nbsp;<img class="" src="resources/images/owl_logo_fit.png" style="width: 45px"></h4>
                                <form class="mt-5 mb-5">                                   
                                    <div class="text-center mb-2 mt-4"><a href="Logout.do" class="btn btn-primary">Go to Main</a>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
			
			
		</div>


	</div>


	<!--Scripts-->
	<script src="resources/plugins/common/common.min.js"></script>
	<script src="resources/js/custom.min.js"></script>
	<script src="resources/js/settings.js"></script>
	<script src="resources/js/gleek.js"></script>
	<script src="resources/js/styleSwitcher.js"></script>

	<!-- Chartjs -->
	<script src="resources/plugins/chart.js/Chart.bundle.min.js"></script>
	<!-- Circle progress -->
	<script src="resources/plugins/circle-progress/circle-progress.min.js"></script>
	<!-- Datamap -->
	<script src="resources/plugins/d3v3/index.js"></script>
	<script src="resources/plugins/topojson/topojson.min.js"></script>
	<script src="resources/plugins/datamaps/datamaps.world.min.js"></script>
	<!-- Morrisjs -->
	<script src="resources/plugins/raphael/raphael.min.js"></script>
	<script src="resources/plugins/morris/morris.min.js"></script>
	<!-- Pignose Calender -->
	<script src="resources/plugins/moment/moment.min.js"></script>
	<script src="resources/plugins/pg-calendar/js/pignose.calendar.min.js"></script>
	<!-- ChartistJS -->
	<script src="resources/plugins/chartist/js/chartist.min.js"></script>
	<script
		src="resources/plugins/chartist-plugin-tooltips/js/chartist-plugin-tooltip.min.js"></script>
	<script src="resources/js/dashboard/dashboard-1.js"></script>

</body>

</html>