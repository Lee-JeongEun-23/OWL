<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<meta name="google-signin-client_id"
		content="266293759218-1i2o19cvv8p80i4q4a9q94d1dner0ksg.apps.googleusercontent.com.apps.googleusercontent.com">
	<title>OWL</title>
	<jsp:include page="../include/headTag.jsp" />
	<!-- Favicon icon -->
	<link rel="icon" type="image/png" sizes="16x16" href="resources/images/favicon.png">

	<!-- Kakao -->
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script type="text/javascript" src="resources/js/commonSweetAlert.js"></script>
	<style type="text/css">
		.snsLoginButton {
			background-color: transparent;
			border: none;
			width: 50px;
			height: 50px;
			cursor: pointer;
		}

		.vertical-center {
			min-height: 100%;
			min-height: 100vh;
			display: flex;
			align-items: center;
		}

		body {
			background-color: #326295;
			overflow-y: hidden;
		}

		.roundBox {
			background-color: white;
			border-radius: 15px;
		}

		.loginButton {
			padding: 15px 40px;
			background: #326295;
			font-weight: 700;
			color: white;
		}

		#loginBox input[type=text],
		#loginBox input[type=email],
		#loginBox input[type=password],
		#joinBox input[type=text],
		#joinBox input[type=email],
		#joinBox input[type=password] {
			border-top-width: 0px;
			border-left-width: 0px;
			border-right-width: 0px;
		}
	</style>
	<script type="text/javascript">
		Kakao.init("5d151c02cc241d9ba7a8373a8051d79d");
		//https://kauth.kakao.com/oauth/authorize?client_id=5d151c02cc241d9ba7a8373a8051d79d&redirect_uri=http://localhost:8090/OWL/kakaoLogin
		function loginWithKakao() {
			// 로그인 창을 띄웁니다.
			Kakao.Auth.login({
				success: function (authObj) {
					alert("success" + JSON.stringify(authObj));
				},
				fail: function (err) {
					alert("error" + JSON.stringify(err));
				}
			});
		};

		$(function () {
			checkError();
			//flag 
			let nameCheck = false;
			let emailCheck = false;
			let pwdCheck = false;

			$("#sendPwd").click(function () {
				if(!$("#findPwdModal .email").val()){
					warningAlert("이메일을 입력해주세요.");
					return;
				}
				
				$("#sendPwd").val("Sending...");
				
				$.ajax({
					url: "ForgotPassword.do",
					data: {
						email: $("#findPwdModal .email").val()
					},
					success: function (data) {
						if (data.result) {
							successAlert(data.message);
							$("#findPwdModal").modal("hide");
							$("#sendPwd").val("SEND");
						} else {
							warningAlert(data.message);
						}
					},
					error: function () {
						errorAlert("메일발송에 실패했습니다.");
					}
				})
			})

			$("#profileImage").click(function () {
				$("#multipartFile").click();
			})

			$("#multipartFile").change(function () {
				let file = document.querySelector('input[type=file]').files[0];
				let reader = new FileReader();

				reader.onloadend = function () {
					$("#profileImage").attr("src", reader.result)
				}

				if (file) {
					reader.readAsDataURL(file);
				} else {
					preview.src = "resources/images/login/profile.png";
				}
			})

			$("#joinBox .name").keyup(
				function (event) {
					if ($("#joinBox .name").val().length < 1) {
						$("#joinBox .name").siblings(".text-danger").css("display", "block");
						nameCheck = false;
					} else {
						$("#joinBox .name").siblings(".text-danger").css("display", "none");
						nameCheck = true;
					}
				})

			$("#joinBox .email").keyup(
				function (event) {
					let regExp =
						/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
					if ($("#joinBox .email").val().match(regExp) != null) {
						$("#joinBox .email").siblings(".text-danger").css("display", "none");
						$('#duplicateBtn').attr("disabled", false);
						emailCheck = true;
					} else {
						$("#joinBox .email").siblings(".text-danger").css("display", "block");
						$('#duplicateBtn').attr("disabled", true);
						emailCheck = false;
					}
				})

			$("#joinBox .pwd").keyup(
				function (event) {
					if ($("#joinBox .pwd").val().length < 8) {
						$("#joinBox .pwd").siblings(".text-danger").css("display", "block");
						pwdCheck = false;
					} else {
						$("#joinBox .pwd").siblings(".text-danger").css("display", "none");
						pwdCheck = true;
					}
				})


			//이메일 중복체크 
			$('#duplicateBtn').click(function () {
				if ($("#email").val() == "") {
					errorAlert("이메일 주소를 입력하세요.");
				} else {
					$.ajax({
						url: "Emailcheck.do",
						data: {
							email: $("#email").val()
						},
						success: function (data) {
							console.log("success in");
							console.log(data);
							if (data == "true") {
								successAlert("사용가능한 메일주소입니다");
								$("#email").removeAttr("style ");

							} else {
								warningAlert("이미 존재하는 메일주소입니다");
								$("#email").val("");
								emailCheck = false;
							}
						},
						error: function () {
							console.log("error error");
						}
					})
				}
			});

			openDialog();


			$('#joinBtn').click(function () {
				if (nameCheck && emailCheck && pwdCheck) {} else {
					warningAlert("필수 항목을 모두 입력해주세요.");
					return false;
				}
			})

		})

		function openDialog() {
			let type = "${show}";
			if (!type)
				return;
			else if (type === "joinEmail")
				$("#opneJoinEmailModal").click();
			else if (type === "joinOk") {
				$('#joinOkModal').modal({
					backdrop: 'static',
					keyboard: false
				})
				$("#opneJoinOkModal").click();
			} else if (type === "join") {
				changeView(false)
			}
		}

		function changeView(isLogin) {
			// 로그인 화면 요청
			if (isLogin) {
				$("#loginBox").removeClass("hidden");
				$("#joinBox").addClass("hidden");
			}
			// 회원가입 화면 요청
			else {
				$("#joinBox").removeClass("hidden");
				$("#loginBox").addClass("hidden");
			}

		}

		function checkError() {
			console.log("check error");

			let error = "${errorMessage}";
			
			if (!error)
				return;
			else {
				Swal.fire( '로그인 실패'
								, error
								, 'error')
			}
		}
	</script>
</head>

<body>



	<div id="main-wrapper">
		<div class="text-center mt-5">
			<a href="Index.do"><img src="resources/images/owl_plz_beige.png" alt=""></a>
		</div>

		<!-- Content -->
		<div class="content-main mt-5">
			<div class="container-fluid ">
				<div class="login-form-bg">
					<div class="container h-100">
						<div class="row justify-content-center h-100">
							<div class="col-xl-6">
								<!-- Start 로그인 화면 -->
								<div id="loginBox" class="roundBox p-4">
									<div class="text-center mt-4">
										<h4>LOGIN</h4>
									</div>
									<c:url value="/login" var="loginurl" />
									<form action="${loginurl }" method="post" class="mt-5 mb-5 login-input">
										<div class="form-group">
											<input type="email" name="email" class="form-control email" placeholder="Email" value="${email }">
										</div>
										<div class="form-group">
											<input type="password" name="password" class="form-control pwd" placeholder="Password" value="${password }">
										</div>
										<div class="form-check mb-3" style="padding-left: 0px;">
											<div class="custom-control custom-checkbox mr-sm-2">
												<input type="checkbox" class="custom-control-input" id = "remember_me" name ="remember-me">
												<label class="custom-control-label" for="remember_me">Remember me</label>
											</div>
										</div>
										<input type="submit" class="btn loginButton btn-block waves-effect waves-light" value="LOGIN">
									</form>
									<hr />

									<div class="text-center">
										<h5>SNS LOGIN</h5>
										<button id="naverLoginButton" class="snsLoginButton mt-2 mr-3" onclick="location.href='${naverUrl}'">
											<img src='resources/images/login/naver.png' style="width: 50px;">
										</button>
										<button id="kakaoLoginButton" class="snsLoginButton mr-3" onclick="location.href='${kakaoUrl}'">
											<img src='resources/images/login/kakao.png' style="width: 50px;">
										</button>
										<button id="googleLoginButton" class="snsLoginButton mr-3" onclick="location.href='${googleUrl}'">
											<img src='resources/images/login/google.png' style="width: 50px;">
										</button>
									</div>

									<div class="mt-5 login-form__footer text-center">
										<b class="login-form__footer">
											<a href="#" data-toggle="modal" data-target="#findPwdModal" class="text-secondary">Forgot password?</a>
										</b>
										<p>
											Don't have account? <a href="javascript:void(0);" onclick="changeView(false);" class="text-primary">Sign
												Up</a> now
										</p>
									</div>
								</div>
								<!-- End 로그인 화면 -->

								<!-- Start 회원가입 화면 -->
								<div id="joinBox" class="roundBox p-4 hidden">
									<div class="text-center mt-4">
										<h4>JOIN </h4>
									</div>
									<c:choose>
										<c:when test="${joinProjectIdx == null}">
											<form action="EmailConfirm.do" method="post" class="mt-4 mb-3 login-input" enctype="multipart/form-data">
										</c:when>
										<c:otherwise>
											<form action="EmailConfirmPass.do" method="post" class="mt-4 mb-3 login-input" enctype="multipart/form-data">
										</c:otherwise>
									</c:choose>
										<div class="text-center mb-3">
											<img id="profileImage" src="resources/images/login/profile.png"
													onerror="this.src='resources/images/login/profile.png'"
													style="width: 150px; height: 150px; cursor: pointer;"
													data-toggle="tooltip" data-placement="top" title="Please upload image."
													class="rounded-circle">
											<input type="file" name="multipartFile" id="multipartFile" accept="image/*" style="display: none;" onchange="previewProfile()" />

										</div>
										<div class="form-group">
											<input id="name" type="text" name="name" class="form-control name" placeholder="* Name">
											<span class="text-danger" style="display: none;">Please enter your name.</span>
										</div>
										<div class="form-group">
											<div class="row">
												<div class="col-8">
													<input type="email" name="email" id="email" class="form-control email" placeholder="* Email">
													<span class="text-danger" style="display: none;">Please enter your email.</span>
												</div>
												<div class="col-4">
													<button id="duplicateBtn" type="button" class="btn mb-1 btn-outline-primary" disabled>Duplicate Check</button>
												</div>

											</div>
										</div>
										<div class="form-group">
											<input type="password" name="password" id="password" class="form-control pwd" placeholder="* Password">
											<span class="text-danger" style="display: none;">Please enter your password at least 8.</span>
										</div>
										<input id="joinBtn" type="submit" class="btn loginButton btn-block waves-effect waves-light" value="JOIN IN">

									</form>
									<p class="mt-3 login-form__footer">
										Do you have account? <a href="javascript:void(0);" onclick="changeView(true);" class="text-primary">Login</a>
										now
									</p>
								</div>
								<!-- End 회원가입 화면 -->

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

	<!--  Modal  -->
	<jsp:include page="modal/forgotPassword.jsp" />
	<jsp:include page="modal/joinConfirm.jsp" />
	<jsp:include page="modal/joinOk.jsp" />

	<!--Scripts-->
	<script src="resources/plugins/common/common.min.js"></script>
	<script src="resources/js/custom.min.js"></script>
	<script src="resources/js/settings.js"></script>
	<script src="resources/js/gleek.js"></script>
	<script src="resources/js/styleSwitcher.js"></script>
</body>

</html>