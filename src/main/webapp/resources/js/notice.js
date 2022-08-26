
function initNotice(){
	$('#noticeTable').DataTable({
	 	stateSave: true, // 페이지 상태 저장
	 	"lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        fixedColumns: true,
        autoWidth: false,
        "order": [[ 3, "desc" ]]
	});
	
	$('#noticeTable_length select').attr("class","select2 form-control custom-select");
	$('#noticeTable tbody').on('click', 'tr', function () {
        setDetailData($(this).attr("id"));
    });
	
	$("#noticeNote").summernote({
		height: 310,
        placeholder: "내용을 입력하세요.",
        popover: {
            image: [],
            link: [],
            air: []
          }
	});
	$("#noticeEditNote").summernote({
		height: 310,
        placeholder: "내용을 입력하세요.",
        popover: {
            image: [],
            link: [],
            air: []
          }
	});
}

let detailNoticeIdx = 0;
function setDetailData(boardIdx){
	$.ajax({
		type: "POST",
		url: "GetNotice.do",
		data: {boardIdx: boardIdx},
		success: function (notice) {
			detailNoticeIdx = boardIdx;
			setReadNum(boardIdx);
			$("#noticeTitle").text(notice.title);
			$("#noticeContent").html(notice.content);
			
			$("#noticeFiles").empty();
			$("#noticeFileCount").text("첨부파일 ("+notice.files.length+")");
			$.each(notice.files, function(){
				let path = "/upload/"+ currentProjectIdx +"/file/"+this.fileName;
				console.log(path);
				let control = "<li class='mb-2' style='font-size: 16px' id=" + this.fileIdx +">"
								+ "	<a href='"+path+"' download><i class='far fa-save'></i>&nbsp;&nbsp;<span> "+this.fileName+" ("+this.fileSize+" KB)</span></a>"
								+" </li>";
				$("#noticeFiles").append(control);
			})
			$("#noticeBoardIdx").text(boardIdx);
			changeNoticeView("detailBox");
		}
	}); 
}

function setNoticeData() {
	 $.ajax({
		type: "POST",
		url: "GetNotices.do",
		data: {projectIdx: currentProjectIdx},
		success: function (data) {
			console.log("setNoticeData");
			console.log(data);
			if(data.length > 0){
				$('#noticeTable').DataTable().clear();
				$.each(data, function (index, element) {
				$('#noticeTable').DataTable().row.add( [
					  	++index,
						element.title,
						element.name,
						element.writeDate,
						element.readNum
			        ]).node().id = element.boardIdx;
					$('#noticeTable').DataTable().draw();
				})

				$("#emptyNoticeBox").addClass("hidden");
				$("#noticeTableBox").removeClass("hidden");
			}else{
				$("#emptyNoticeBox").removeClass("hidden");
				$("#noticeTableBox").addClass("hidden");
			}
			changeNoticeView("noticeBox");
		}
	}); 
}

function writeNotice() {
	changeNoticeView("writeBox");
}

function cancelNotice(){
	$("#noticeForm")[0].reset();
	$("#noticeNote").summernote('reset');
	changeNoticeView("noticeBox");
}

function writeNoticeOk(){
	if($("#title").val() == "" || $('#noticeNote').val()==""){
		warningAlert("내용을 모두 작성해주세요.");
		return;
	}
    let formData = new FormData();
	
    formData.append("projectIdx", currentProjectIdx);
    formData.append("content",$('#noticeNote').summernote('code'));
    formData.append("title",$("#title").val());
    $.each($("#noticeMultipartFiles")[0].files, function(i, file) {
    	formData.append('multipartFiles', file);
    });

    
    let notice;
    $.ajax({
        type: "POST",
        enctype: 'multipart/form-data',
        url: "WriteNotice.do",
        data: formData,
        processData: false,
        contentType: false,
        cache: false,
        success: function (data) {
        	if(data >  0){
        		successAlert("공지사항 작성 완료");
        		
        		//푸쉬 알람 보내기. 이 함수의 위치는 top.jsp  아래쪽 스크립트에 있음...
        	    sendNoticePushAll($("#title").val(), $('#noticeNote').summernote('code'), currentProjectIdx); 
        	    pushNoticeToAll(currentProjectIdx,currentProjectName, $("#title").val(), "notice", data);
        		
        		cancelNotice();
        		setDetailData(data);
        	} else
        		writeNoticeError();
        },
        error: function (e) {
        	writeNoticeError()
        }
    });
}




function writeNoticeError(){
	errorAlert("공지사항 작성 실패 ");
	cancelNotice();
	setNoticeData(currentProjectIdx);
}

function deleteNotice(){
	$.ajax({
		url : "DeleteNotice.do",
		type : "POST",
		data : {noticeIdx : detailNoticeIdx},
		success : function(data){
			if(data){
				successAlert("삭제 완료!");
				setNoticeData();
			} else
				warningAlert("삭제 실패!");
		},
		error : function(){
			warningAlert("삭제 실패!");
		}
	})
}

function editNoticeSetView(){
	$("#editTitle").val($("#noticeTitle").text());
	$('#noticeEditNote').summernote('code',$("#noticeContent").html());
	
	$("#noticeEditFiles").empty();
	$("#noticeEditMultipartFiles").val("");
	  $.each($("#noticeFiles li"), function(i, item) {
		  console.log(item);
		  	let fileIndex = $(this).attr("id");
		  	let deleteIcon = "<div id= '" + fileIndex +"file'>" + $(this).text() + "<i class='far fa-times-circle font-weight-bold font-18 ml-1' style=' cursor: pointer;' onclick= 'deleteFIle("+ fileIndex +")'></i><div>";
		    $("#noticeEditFiles").append( deleteIcon );
	   });
	changeNoticeView("editBox");
}

function noticeEditOk() {
    let formData = new FormData();
    formData.append("boardIdx", $("#noticeBoardIdx").text());
    formData.append("content",$('#noticeEditNote').summernote('code'));
    formData.append("title",$("#editTitle").val());
    $("#noticeEditMultipartFiles").empty();
    
    $.each($("#noticeEditMultipartFiles")[0].files, function(i, file) {
    	formData.append('multipartFiles', file);
    });
   
	  let notice;
	    $.ajax({
	        type: "POST",
	        enctype: 'multipart/form-data',
	        url: "UpdateNotice.do",
	        data: formData,
	        processData: false,
	        contentType: false,
	        cache: false,
	        success: function (data) {
	        	console.log(data);
	        	if(data> 0){
	        		successAlert("공지사항 수정 완료");
	        		cancelNotice();
	        		setDetailData(data);
	        	}
	        	else
	        		writeNoticeError();
	        },
	        error: function (e) {
	        	writeNoticeError()
	        }
	    });
}

function deleteFIle(fileIdx){
	$.ajax({
		url : "DeleteFile.do",
		type : "POST",
		data : {fileIdx : fileIdx},
		success : function(data){
			if(data){
				$("#"+ fileIdx  +"file").remove();
			} else
				warningAlert("삭제 실패!");
		},
		error : function(){
			warningAlert("삭제 실패!");
		}
	})
}

function changeNoticeView(view){
	if(view == "noticeBox"){
		detailNoticeIdx = 0;
		$("#noticeDetailBox").addClass("hidden");
		$("#writeBox").addClass("hidden");
		$("#editBox").addClass("hidden");
		$("#noticeBox").removeClass("hidden");
	}else if(view == "writeBox"){
		detailNoticeIdx = 0;
		$("#noticeBox").addClass("hidden");
		$("#noticeDetailBox").addClass("hidden");
		$("#editBox").addClass("hidden");
		$("#writeBox").removeClass("hidden");
	}else if(view == "detailBox"){
		$("#noticeBox").addClass("hidden");
		$("#writeBox").addClass("hidden");
		$("#editBox").addClass("hidden");
		$("#noticeDetailBox").removeClass("hidden");
	}else if(view == "editBox"){
		$("#noticeDetailBox").addClass("hidden");
		$("#editBox").removeClass("hidden");
	}
}

function setReadNum(boardIdx){
	$.ajax({
		url : "SetReadNum.do",
		type : "POST",
		data : {noticeIdx : boardIdx},
		error : function(){
			console.log("setReadNum error");
		}
	})
}

