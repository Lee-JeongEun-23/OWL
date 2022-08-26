function initResetPasswordController(){
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
}

function initLoginController(error){
	checkError(error);
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
}

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

function checkError(error) {
	if (!error)
		return;
	else {
		Swal.fire( '로그인 실패'
						, error
						, 'error')
	}
}

function initMyProfileSettingController(font){
	let agreeChk = false;
	let pwdChk = false;
	

	$('#setFont option[value=\"'+font+'\"]').attr("selected", "selected");
	$("#settingTabs li a").on("click", function(){
		if(($(this).attr("href").replace("#","").trim()=="deleteAccount" || $(this).attr("href").replace("#","").trim()=="themeSetting") && !$("#twopage").hasClass("hidden")){
			 $("#firstpage").removeClass("hidden");
			 $("#twopage").addClass("hidden");
		}
	})

	$('#myProfileSetModal').on('hidden.bs.modal', function(event){
		$('#myPassword').val("");
		$("#twopage").addClass("hidden");
		$("#firstpage").removeClass("hidden");
	});
	
    $("#deleteMemberBtn").click(function () {
        if ($("#delPwdOut").val() == "" || $("#delPwdOut").val() == null) {
            $("#delPwdOut").focus();
            return;
        } else {
            $.ajax({
                url: "chkDelPwd.do",
                data: {
                    email: $("#email").val(),
                    password: $("#delPwdOut").val()
                },
                type: "post",
                dataType: "html",
                success: function (responsedata) {
                    if (responsedata == "true") {
                        pwdChk = true; 
                        if(pwdChk && agreeChk)
                        location.href="DeleteAccount.do";
                    } else {
                    	 warningAlert("약관에 동의하고 비밀번호를 알맞게 입력해주십시오");
                    }
                },
                error: function () {
                    console.log("에러");
                }
            });
        }
    });

    $("#editButton").click(function () {
            $("#firstpage").addClass("hidden");
            $("#twopage").removeClass("hidden");	            
    });   


    $("#deleteChk").change(function () {
        if ($("input:checkbox[id='deleteChk']").is(":checked") == true) {
            $("#deleteChk").siblings(".text-danger").css("display", "none");
            agreeChk = true;

        } else {
            $("#deleteChk").siblings(".text-danger").css("display", "block");
            agreeChk = false;
        }
    });

    $("#multipartFile").change(function () {
        var reader = new FileReader();
        reader.onload = function (e) {
            // get loaded data and render thumbnail.
            document.getElementById("profileImage").src = e.target.result;
        };
        // read the image file as a data URL.
        reader.readAsDataURL(this.files[0]);
    });

    $("#profileImage").click(function () {
        $("#multipartFile").click();
    });

    $("#cancelButton").click(function () {
        $("#firstpage").removeClass("hidden");
        $("#twopage").addClass("hidden");
    });

	$("#setBackgroundColor span").click(function(data){
		console.log("in span");
		let color = $(data.target).css("background-color");
		chageSetting("themecolor", color);
	})

	$("#setFont").change(function() {
		chageSetting("font", $("#setFont").val());
  	});
}

function updateMyProfile(){
	 if(!$("#myPassword").val()){
			warningAlert("비밀번호를 입력해주세요.");
			 return false;
		} 
	let formData = new FormData();
	
   formData.append("password", $("#myPassword").val());
   formData.append("name", $("#myName").val());
   formData.append('profilePic', $("#multipartFile")[0].files[0]);

   $.ajax({
       type: "POST",
       enctype: 'multipart/form-data',
       url: "UpdateMember.do",
       data: formData,
       processData: false,
       contentType: false,
       cache: false,
       success: function (data) {
       	$('#myPicture').attr("src","upload/member/"+data.profilePic+"");
     		$("#name").val(data.name);
     		$('#userImgTop').attr("src","upload/member/"+data.profilePic+"");
     		$('#userImgToggle').attr("src","upload/member/"+data.profilePic+"");
     		$("#userNameToggle").text(data.name);
     		$("#userEmailToggle").text(data.email);
	        $("#twopage").addClass("hidden");
	        $("#firstpage").removeClass("hidden");
       }
   });
}

function chageSetting(cmd, value){
	$.ajax({
		url: "SettingChange.do",
		type: "POST",
		dataType: 'json',
		data : { cmd : cmd , value :value}, 
		success: function (data) {
			console.log(data);
			if(data){
				setTheme(data.themeColor, data.font);
			}
		}
	});
}