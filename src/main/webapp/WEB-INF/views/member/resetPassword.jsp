<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>OWL</title>
    <jsp:include page="../include/headTag.jsp" />
    <link href="resources/css/style.css" rel="stylesheet">
    <style type="text/css">
        #forgotPwdBody {
            background-color: #326295;
            overflow-y: hidden;
            height: 100vh !important;
        }

        .forgotBox {
            border-radius: 15px;
        }

        .forgotButton {
            padding: 10px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $("#resetBox  .pwd1").keyup(
                function (event) {
                    if ($("#resetBox  .pwd1").val().length < 8) {
                        $("#resetBox  .pwd1").siblings(".text-danger").css("display", "block");
                        $("#resetBox .successletter").css("display", "none");
                        $("#resetBox .failletter").css("display", "none");

                    } else if ($("#resetBox  .pwd1").val() == null && $("#resetBox  .pwd2").val() == null) {
                        $("#resetBox .successletter").css("display", "none");
                        $("#resetBox .failletter").css("display", "none");

                    } else {
                        $("#resetBox  .pwd1").siblings(".text-danger").css("display", "none");
                        $("#resetBox  .pwd2").keyup(
                            function (event) {
                                if ($("#resetBox  .pwd1").val() == $("#resetBox  .pwd2").val()) {
                                    $("#resetBox .successletter").css("display", "block");
                                    $("#resetBox .failletter").css("display", "none");
                                } else {
                                    $("#resetBox .failletter").css("display", "block");
                                    $("#resetBox .successletter").css("display", "none");
                                }
                            }
                         )
                    }
                })

            $("#changeButton").click(function () {
                if($("#resetBox  .pwd1").val().length < 8){
                	warningAlert("비밀번호는 8자리 이상입력해주세요.");
					return;
               } else if($("#resetBox  .pwd1").val() != $("#resetBox  .pwd2").val()){
            	   warningAlert("비밀번호가 일치하지 않습니다.");
					return;
                }
                
                $.ajax({
                    method: "POST",
                    url: "ResetPassword.do",
                    data: {
                        email: $("#email").val(),
                        password: $("#pwd").val()
                    },
                    success: function (result) {
                        Swal.fire({
                            title: '비밀번호 변경 완료\n로그인 화면으로 이동합니다.',
                            icon: "success",
                            showConfirmButton: false,
                            timer: 1500
                        }).then((result) => {
                            window.location.href = "Login.do";
                        })
                    },
                    error: function () {
                        errorAlert("비밀번호 변경에 실패했습니다.");
                    }
                })

            })
        })
    </script>
</head>

<body id="forgotPwdBody">
    <div class="login-form-bg h-100">
        <div class="container h-100">
            <div class="row justify-content-center h-100 align-items-center">
                <div class="col-xl-6">
                    <div class="form-input-content  text-center">
                        <img src="resources/images/owl_plz_beige.png" alt="" height="30">
                        <div class="card login-form mb-0 forgotBox mt-4">
                            <div class="card-body pt-5 text-left">
                                <div id="resetBox" class="form-group">
                                    <input type="hidden" id="email" value="${email}">
                                    <input type="password" name="pwd1" class="form-control pwd1"
                                        placeholder="New Password">
                                    <span class="text-danger pwd1letter" style="display: none;">Please enter your New
                                        Password.</span><br>
                                    <input type="password" id="pwd" class="form-control pwd2"
                                        placeholder="Confirmed New Password">
                                    <span class="text-success successletter" style="display: none;">You can change your
                                        Password</span>
                                    <span class="text-danger failletter" style="display: none;">Passwords do not
                                        match.</span>
                                </div>
                                <input type="button" id="changeButton"
                                    class="btn btn loginButton btn-block waves-effect waves-light"
                                    value="Change my password">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

</html>