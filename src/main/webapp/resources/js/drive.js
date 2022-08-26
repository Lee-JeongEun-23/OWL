let driveViewType ;
let isTrash = false;  //false : drive , true : trash

function initDrive(){	
	setFileUpload();
	setDriveTable();
	
	$('#jstree').on( "select_node.jstree", function(event, data){
		isTrash = false;
		
		$("#searchFile").addClass("hidden");
		$("#driveSearchViewBox").addClass("hidden");
		$("#driveSearchViewBox").empty();
		$("#default").removeClass("hidden");
		$("#allCheck").addClass("hidden");
		$(".jstree-node > a").removeClass("jstree-search");
		$("#searchText").val("");
		let path = data.instance.get_path(data.node, '<i class="fas fa-angle-right ml-2 mr-2"></i><i class="far fa-folder mr-2"></i>');
	    $("#driveName").html('<i class="far fa-folder mr-2"></i>'+path);
		callDirectoryData();
		
    });
	
	$(".driveViewBtn").click(function(){
		$(this).attr("disabled", true);
		$(this).addClass("active");
		driveViewType= $(this).attr("id");
		if(driveViewType == "tableView"){
			$("#iconView").removeClass("active");
			$("#iconView").attr("disabled", false);
		}
		// icon View
		else{
			$("#tableView").removeClass("active");
			$("#tableView").attr("disabled", false);
		}
			callDirectoryData();
	})
	
	//휴지통 버튼 click
	$('#trashBtn').click(function() {
		isTrash = true;
		callDirectoryData();
	})
}

//프로젝트 내 휴지통 리스트 보여주는 function 
function setTrashData() {
	isTrash = true;
	$.ajax({
		url : "GetTrashList.do",
		data : {'projectIdx' : currentProjectIdx},
		success : function (data) {
			$('#driveSearchBtn').hide();
			$('#driveUploadBtn').hide();
			$('#trashName').removeClass("hidden");
			
			if (data.folders.length == 0 && data.files.length == 0) {
				$("#emptyDriveBox").removeClass("hidden");
				$('#emptyDriveBox').find('h4').hide();
				$("#driveIconViewBox").addClass("hidden");
				$("#driveTableViewBox").addClass("hidden");
				return;
			}
			
			$("#emptyDriveBox").addClass("hidden");
			$('#driveTable').DataTable().clear();
			$("#driveIconViewBox").empty();

			if(driveViewType =="tableView")
				setTableView(data);
			else
				setIconView(data);
		},
			error : function() {
					console.log('GetTrashList error');
			}
	})
}


var rowCount=0;
function createStatusbar(obj){
     rowCount++;
     var row="odd";
     if(rowCount %2 ==0) row ="even";
     this.statusbar = $("<div class='statusbar "+row+"'></div>");
     this.filename = $("<div class='filename'></div>").appendTo(this.statusbar);
     this.size = $("<div class='filesize'></div>").appendTo(this.statusbar);
     this.progressBar = $("<div class='progressBar'><div></div></div>").appendTo(this.statusbar);
     this.abort = $("<div class='abort'>Abort</div>").appendTo(this.statusbar);
     obj.after(this.statusbar);
 
    this.setFileNameSize = function(name,size){
        var sizeStr="";
        var sizeKB = size/1024;
        if(parseInt(sizeKB) > 1024){
            var sizeMB = sizeKB/1024;
            sizeStr = sizeMB.toFixed(2)+" MB";
        }
        else{
            sizeStr = sizeKB.toFixed(2)+" KB";
        }
 
        this.filename.html(name);
        this.size.html(sizeStr);
    }
    this.setProgress = function(progress)
    {       
        var progressBarWidth =progress*this.progressBar.width()/ 100;  
        this.progressBar.find('div').animate({ width: progressBarWidth }, 10).html(progress + "% ");
        if(parseInt(progress) >= 100)
        {
            this.abort.hide();
        }
    }
    this.setAbort = function(jqxhr)
    {
        var sb = this.statusbar;
        this.abort.click(function()
        {
            jqxhr.abort();
            sb.hide();
        });
    }
}


function Search() {
	$("#default").addClass("hidden");
	$("#searchFile").removeClass("hidden");
}

function Allcheck() { //전체선택 onclick
	//If 폴더면 전체 이동 안됨
	$('div.more').parent('div.card').css('background', 'rgba(161, 163, 166, 0.3)');
	$("input[type=checkbox]").prop("checked", true);
	$("#default").addClass("hidden");
	$("#allCheck").removeClass("hidden");
}

function ReturnCheck() { //선택 해제
	$('div.more').parent('div.card').css('background', '');
	$("input[type=checkbox]").prop("checked", false);
	$("#allCheck").addClass("hidden");
	$("#theCheck").addClass("hidden");
	$("#searchFile").addClass("hidden");
	$("#default").removeClass("hidden");
	$('#searchText').empty();
}

function checkBox(obj) {
	if (obj.checked == true) {
		$(obj).parent().parent().css('background', 'rgba(161, 163, 166, 0.3)');
		$("#default").addClass("hidden");
		$("#theCheck").removeClass("hidden");		
	} else {
		$('div.more').parent('div#css').css('background', '');
		ReturnCheck();
	}
}

function getSelectedFolderId(){
	return $('#jstree').jstree('get_selected')[$('#jstree').jstree('get_selected').length-1];
}
function callDirectoryData(){
	let folderIdx = getSelectedFolderId();
	let folderName = $("#jstree").jstree(true).get_node(folderIdx).text;

	if(isTrash){
		$("#driveName").hide();
		setTrashData();
	} else{
		$('#driveSearchBtn').show();
		$('#driveUploadBtn').show();
		$('#trashName').addClass("hidden");
		$("#driveName").show();
		if(folderIdx != null && folderName!= null)
			setDirectoryData(folderIdx, folderName);
	}	
}

function setDirectoryData(folderIdx, folderName) {
	isTrash = false;

	$.ajax({
		url : "GetFolderData.do",
		data : { folderIdx : folderIdx },
		success : function(data){

			if(data.folders.length == 0 && data.files.length == 0){
				$("#directoryName").text("[ "+folderName+" ] directory.");
				$("#emptyDriveBox").removeClass("hidden");
				$('#emptyDriveBox').find('h4').show();
				$("#driveIconViewBox").addClass("hidden");
				$("#driveTableViewBox").addClass("hidden");
				return;
			}
			
			$("#emptyDriveBox").addClass("hidden");
			$('#driveTable').DataTable().clear();
			$("#driveIconViewBox").empty();
			
			if(driveViewType =="tableView")
				setTableView(data);
			else
				setIconView(data);
		},
		error : function(){
			console.log("in GetFolderData error");
		}
	})
}

/*var nameList = [];*/
function setSearchView(obj){
	$("#driveSearchViewBox").removeClass("hidden");
	$("#driveTableViewBox").addClass("hidden");		
	$("#driveIconViewBox").addClass("hidden");		
	let line = 4;
	let controls =[];
	
	$.each(obj,function(index, element){
		$(element).attr("style","");
		controls.push(element);
		
		
		if (index % line == line - 1 || index == obj.length - 1) {
			let row = $("<div class='row'></div>");
			$.each(controls, function(index2, element2){
				row.append(element2);
			})
			$("#driveSearchViewBox").append(row);
			controls=[];
		}	
		
	});
}


function setIconView(data){
	$("#driveIconViewBox").removeClass("hidden");
	$("#driveTableViewBox").addClass("hidden");	
	$("#driveSearchViewBox").addClass("hidden");

	let control ="";
	let line = 4;
	$.each(data.folders, function(index, element) {
		control += '<div class="col-sm-3">'
					+ 	'<div class="card driveCard dropdown folder" id="'+element.driveIdx+'" style="cursor:pointer;" ondblclick="changeSelectedFolder('+element.driveIdx+',\''+element.folderName+'\')">'
					+ 		'<div class="more"  style="margin-top: 15px; padding-right:10px;">&nbsp;&nbsp;&nbsp;&nbsp;'
					+			'<input type="checkbox" id="checkfolder"  onclick="checkBox(this)" style="width:18px; height:18px;">'
					+				'<a href="javascript:void(0)" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="float: right; padding-left :10px; padding-right :10px;">'	
					+					'<i class="fas fa-ellipsis-v fa-lg"></i>'
					+				'</a>'
					+			'<div class="dropdown-menu" aria-labelledby="dropdownIssueButton">'
					+				'<ul class="list-style-none">';
		if(isTrash) {
			control += '<li class="pl-2"><a href="#" onclick="restoreFolderfromTrash('+element.driveIdx+')"><i class="fas fa-undo"></i>&nbsp; 복원</a></li>'
						+  '<li class="pl-2"><a href="#" onclick="deleteFolderfromTrash('+element.driveIdx+')"><i class="fas fa-trash-alt"></i>&nbsp; 영구삭제</a></li>';
		}else {downloadFile
			control += '<li class="pl-2"><a href="#"  onclick="setRenameIconView(this,'+element.driveIdx+')"><i class="fas fa-undo"></i>&nbsp; 이름 변경</a></li>'
						+	'<li class="pl-2"><a href="#"  onclick="driveDetail(true,'+element.driveIdx+')"><i class="fas fa-info-circle"></i>&nbsp; 상세 정보</a></li>'
						+	'<li class="pl-2"><a href="#" onclick="deleteDriveFolder('+element.driveIdx+')"><i class="fas fa-trash-alt"></i>&nbsp; 삭제</a></li>'
		}
					
		control +=				'</ul>'                                                                                                                                                         
					+			'</div>'                                                                                                                                                        
					+		'</div>'                                                                                                                                                            
					+		'<div class="card-body text-center">'                                                                                                                               
					+			'<span style="color:#326295;"><i class="fas fa-folder fa-5x mb-4"></i></span>'
					+			'<div class="driveCardContent"><h5>' +element.folderName+ '</h5>'
					+				'<input class="fileName" type="hidden" value="'+element.folderName+'">'
					+			'</div>'                                                                                                                                         
					+		'</div>'                                                                                                                                                            
					+	 '</div>'                                                                                                                                                               
					+  '</div>';     
		
		if (index % line == line - 1 || index == data.folders.length - 1) {
			let row = $("<div class='row'></div>");
			row.append(control);
			$("#driveIconViewBox").append(row);
			control ="";
		}
	});

	control ="";
	$.each(data.files, function(index, element) {
		let extension = element.fileName.substr(element.fileName.lastIndexOf(".")+1).toLowerCase();
		let fileName = element.fileName.length > 12 ? element.fileName.substr(0, 12)+ "..." : element.fileName;				

		control += '<div class="col-sm-3">'
					+ 	'<div class="card driveCard dropdown file" id="'+element.driveFileIdx+'">'
					+ 		'<div class="more" style="margin-top: 15px; padding-right:10px;">&nbsp;&nbsp;&nbsp;&nbsp;'
					+			'<input type="checkbox" id="checkfile" value="css" onclick="checkBox(this)" style="width:18px; height:18px;">'
					+				'<a href="javascript:void(0)" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="float: right; padding-left :10px; padding-right :10px;">'	
					+					'<i class="fas fa-ellipsis-v fa-lg"></i>'
					+				'</a>'
					+			'<div class="dropdown-menu" aria-labelledby="dropdownIssueButton">'
					+				'<ul class="list-style-none">';
		
		if(isTrash) {
			control += '<li class="pl-2"><a href="#" onclick="restoreFileTrash('+element.driveFileIdx+')"><i class="fas fa-undo"></i>&nbsp; 복원</a></li>'
						+  '<li class="pl-2"><a href="#" onclick="deleteFilefromTrash('+element.driveFileIdx+')"><i class="fas fa-trash-alt"></i>&nbsp; 영구삭제</a></li>';
		}else {downloadFile
			control += '<li class="pl-2"><a href="#" onclick="downloadFile(\''+element.fileName+'\')" ><i class="fas fa-download"></i>&nbsp; 다운로드</a></li>'
						+ '<li class="pl-2"><a href="#"  onclick="setRenameIconView(this,'+element.driveFileIdx+')"><i class="fas fa-undo"></i>&nbsp; 이름 변경</a></li>'
						+ '<li class="pl-2"><a href="#"  onclick="driveDetail(false,'+element.driveFileIdx+')"><i class="fas fa-info-circle"></i>&nbsp; 상세 정보</a></li>'
						+	'<li class="pl-2"><a href="#"  onclick="deleteDriveFile('+element.driveFileIdx+')"><i class="fas fa-trash-alt"></i>&nbsp; 삭제</a></li>';
		}

		control	+=				'</ul>'
					+			'</div>'
					+		'</div>'
					+		'<div class="card-body text-center">'
					+			'<img class="fileDefaultImage mb-4" onerror="this.onerror=null; this.src=\'resources/images/drive/file.png\';" src="resources/images/drive/'+extension+'.png" >'
					+			'<div class="driveCardContent"><h5>' + fileName + '</h5>'
					+				'<input class="fileName" type="hidden" value="'+element.fileName+'">'
					+				'<input class="fileSize" type="hidden" value="'+element.fileSize+'">'
					+				'<input class="fileCreator" type="hidden" value="'+element.creator+'">'
					+				'<input class="fileCreateDate" type="hidden" value="'+element.createDate+'">'
					+				'<input class="fileCreatorName" type="hidden" value="'+element.creatorName+'">'
					+			'</div>'    
					+		'</div>'
					+	 '</div>'
					+  '</div>';
		
		if (index % line == line - 1 || index == data.files.length - 1) {
			let row = $("<div class='row'></div>");
			row.append(control);
			$("#driveIconViewBox").append(row);
			control="";
		}
		
		/*nameList.push(element.fileName);*/
	});
}


function setTableView(data){
	$("#driveTableViewBox").removeClass("hidden");
	$("#driveIconViewBox").addClass("hidden");
	$("#driveSearchViewBox").addClass("hidden");

	$.each(data.files, function(index, element) {
		$('#driveTable').DataTable().row.add( [
			"<i class='fas fa-file-alt mr-3'></i><span>"+element.fileName+"</span>",
			element.createDate,
			element.creatorName,
			element.fileSize+" KB"
        ]).node().id = element.driveFileIdx;
		
		$('#driveTable').DataTable().draw();
	})
	
		//if(!isTrash){		
		$.each(data.folders, function(index, element) {
			let row =$('#driveTable').DataTable().row.add( [
							"<i class='fas fa-folder mr-3'></i><span>"+element.folderName+"</span>",
							"-",
							"-",
							"-"
							]);
			row.node().id = element.driveIdx;
			$(row.node()).addClass("folder");
			
			$('#driveTable').DataTable().draw();
		})
	//}
}


function allRemove(){

	return;
	
/*	Swal.fire({
	    title: '선택하신 을 삭제하시겠습니까?',
	    text: '해당 파일은 휴지통으로 이동합니다.',
	    imageUrl: 'https://i.imgur.com/vxFBTRJ.png',
	    imageWidth: 150,
	    showCancelButton: true,
	    confirmButtonColor: '#3085d6',
	    cancelButtonColor: '#d33',
	    confirmButtonText: '삭제',
	    cancelButtonText: '취소'
	  }).then((result) => {
	    if (result.value) {
	    	return;
	    	$.ajax({
	   		 url : "DeleteFolderAndFile.do",
	   		 data : {driveFileIdx : driveFileIdx},
	   		 success : function(data){
	   			 if(data){
	   				 callDirectoryData();
	   			 }else{
	   				 errorAlert("파일 삭제 실패");
	   			 }
	   		 },
	   		 error : function(){
	   			 errorAlert("파일 삭제 실패");
	   		 }
	   	 })  
	   }         
	});*/
}


function deleteDriveFile(driveFileIdx){
	Swal.fire({
	    title: '파일을 삭제하시겠습니까?',
	    text: '해당 파일은 휴지통으로 이동합니다.',
	    imageUrl: 'https://i.imgur.com/vxFBTRJ.png',
	    imageWidth: 150,
	    showCancelButton: true,
	    confirmButtonColor: '#3085d6',
	    cancelButtonColor: '#d33',
	    confirmButtonText: '삭제',
	    cancelButtonText: '취소'
	  }).then((result) => {
	    if (result.value) {
	    	$.ajax({
	   		 url : "DeleteDriveFile.do",
	   		 data : {driveFileIdx : driveFileIdx},
	   		 success : function(data){
	   			 if(data){
	   				driveRefresh();
	   			 }else{
	   				 errorAlert("파일 삭제 실패");
	   			 }
	   		 },
	   		 error : function(){
	   			 errorAlert("파일 삭제 실패");
	   		 }
	   	 })  
	   }         
	});
}


function deleteDriveFolder(driveIdx, parentIdx){
	Swal.fire({
	    title: '폴더를 삭제하시겠습니까?',
	    text: '해당 폴더는 휴지통으로 이동합니다.',
	    imageUrl: 'https://i.imgur.com/vxFBTRJ.png',
	    imageWidth: 150,
	    showCancelButton: true,
	    confirmButtonColor: '#3085d6',
	    cancelButtonColor: '#d33',
	    confirmButtonText: '삭제',
	    cancelButtonText: '취소'
	  }).then((result) => {
	    if (result.value) {
	    	$.ajax({
	    		url : "DeleteFolder.do",
	    		type : "POST",
	    		data : {driveIdx : driveIdx},
	    		success : function(data){
	    			if(data){
	    				driveRefresh();
	    			}else{
	    				errorAlert("폴더 삭제 실패");
	    			}
	    		},
	    		error : function(){
	    			errorAlert("폴더 삭제 실패");
	    		}
	    	})
	   }         
	});
}


//휴지통에서 영구 삭제 함수 
function deleteFilefromTrash(driveFileIdx) {
	Swal.fire({
	    title: '완전히 삭제 하시겠습니까?',
	    text: '완전히 삭제하면 복구 하실 수 없습니다.',
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonColor: '#3085d6',
	    cancelButtonColor: '#d33',
	    confirmButtonText: '삭제',
	    cancelButtonText: '취소'
	  }).then((result) => {
	    if (result.value) {
	    	$.ajax({
	    		url : "DeleteFileFromTrash.do",
	    		data : {'driveFileIdx' : driveFileIdx},
	    		success : function(data) {
	    			//console.log('deleteFileFromTrash in');
	    			setTrashData(currentProjectIdx);
	    			
	    		},
	    		error : function() {
	    			console.log('deleteFilefromTrash error');
	    		}
	    	})  
	   }         
	});
}


//휴지통에서 폴더 영구 삭제 함수 
function deleteFolderfromTrash(driveFileIdx) {
	Swal.fire({
	    title: '완전히 삭제 하시겠습니까?',
	    text: '삭제시 해당 폴더 및 폴더내 파일을 복구 하실 수 없습니다.',
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonColor: '#3085d6',
	    cancelButtonColor: '#d33',
	    confirmButtonText: '삭제',
	    cancelButtonText: '취소'
	  }).then((result) => {
	    if (result.value) {
	    	$.ajax({
	    		url : "DeleteFolderfromTrash.do",
	    		data : {'driveFileIdx' : driveFileIdx},
	    		success : function(data) {
	    			console.log('deleteFolderfromTrash in');
	    			setTrashData(currentProjectIdx);
	    			
	    		},
	    		error : function() {
	    			console.log('deleteFilefromTrash error');
	    		}
	    	})  
	   }         
	});
}

//휴지통에서 파일  복원 함수 
function restoreFileTrash(driveFileIdx) {
	$.ajax({
		url : "RestoreFile.do",
		data : {'driveFileIdx' : driveFileIdx},
		success : function(data) {
			 successAlert("파일 복원 완료");
			 driveRefresh();
		},
		error : function() {
			console.log('restorefromTrash ERROR');
		}
	}) 
}

//휴지통에서 폴더 복원 
function restoreFolderfromTrash(driveFileIdx) {
	$.ajax({
		url : "RestoreFolder.do",
		data : {'driveFileIdx' : driveFileIdx},
		success : function(data) {
			driveRefresh();
		},
		error : function() {
			console.log('restoreFolderfromTrash ERROR');
		}
	}) 
}

function setRenameIconView(obj, idx){
	let element = $(".driveCard").filter("#"+idx).first();
	let renameElement = element.find(".driveCardContent").first();
	let oldText ="";
	let isFolder = element.hasClass("folder");
	if(isFolder)
		oldText = renameElement.find("h5:first").text();
	else
		oldText = renameElement.find("input:first").val();
	
	renameElement.html(getRenameElementContent(isFolder, idx, oldText));
	$("#driveFileRename").selectRange(0, oldText.lastIndexOf('.'));
}	

function getRenameElementContent(isFolder, idx, oldText){
	let fun = isFolder ? "renameFolder("+idx+")" : "renameFile("+idx+")";
	return "<input id='driveFileRename' type='text' style='width : 60%; height : 32px;' value='"+oldText+"' onKeypress='javascript:if(event.keyCode==13) {"+fun+"}'>"
				+ "<button class='btn btn-default btn-sm ml-2 mr-1' style='height : 32px; width : 30px;' onclick='"+fun+"'><i class='fas fa-check'></i></button>"
				+ "<button class='btn  btn-danger btn-sm' style='height : 32px; width : 30px;' onclick='renameCancel(this,\""+oldText+"\","+isFolder+")'><i class='fas fa-times'></i></button>";
}

function renameCancel(obj, oldText, isFolder){
	if(driveViewType == "tableView"){
		if(isFolder)
			$(obj).parent().html("<i class='fas fa-folder mr-3'></i><span>"+oldText+"</span>");
		else
			$(obj).parent().html("<i class='fas fa-file-alt mr-3'></i><span>"+oldText+"</span>");
	}else
		$(obj).parent().html("<h4>"+oldText+"</h4>");
}

function renameFile(driveFileIdx){
	let folderIdx = $('#jstree').jstree('get_selected')[$('#jstree').jstree('get_selected').length-1];
	let refs = $('#jstree').jstree().get_node(folderIdx).parents;
	
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
		 url : "RenameDriveFile.do",
		 data : { projectIdx : currentProjectIdx
			 		, refs : refs
			 		, driveIdx : folderIdx
			 		, driveFileIdx : driveFileIdx
			 		, newFileName :  $("#driveFileRename").val()},
		 success : function(data){
			 if(data){ 
				 successAlert("파일 이름 변경 완료");
				 callDirectoryData();
			 }else{
				 errorAlert("파일 이름 변경 실패");
			 }
		 },
		 error : function(){
			 errorAlert("파일 이름 변경 실패");
		 }
	 })
}

function renameFolder(driveIdx){
	$.ajax({
		url:"updateNewName.do",
		method:"POST",
		data:{driveIdx: driveIdx,
			     folderName: $("#driveFileRename").val() },
			success : function(data){
				if(data > 0){ 
					$("#driveTable #"+driveIdx).find("td").first().html("<i class='fas fa-file-alt mr-3'></i><span>"+$("#driveFileRename").val()+"</span>");
					successAlert("폴더 이름 변경 완료");
					driveRefresh();
				}else{
					errorAlert("폴더 이름 변경 실패");
				}
			},
			error : function(){
				errorAlert("폴더 이름 변경 실패");
			}
	})
}

function driveDetail(isFolder, idx) {
	let extension = "folder";
	let creator = "-";
	let size = "-";
	let name = "";
	let createDate = "-";
	
	if(driveViewType == "tableView"){
		let row = $("#driveTable #"+idx).first();
		name = row.find("td:eq(0)").text();

		if(!isFolder){
			extension = name.substr(name.lastIndexOf(".")+1);
			createDate = row.find("td:eq(1)").text();
			creator = row.find("td:eq(2)").text();
			size = row.find("td:eq(3)").text() + " KB";
		}
	}else{
		let element =  $(".driveCard").filter("#"+idx).first();
		name = element.find(".driveCardContent>input.fileName").first().val();

		if(!isFolder){	
			extension = name.substr(name.lastIndexOf(".")+1);
			createDate = element.find(".driveCardContent>input.fileCreateDate").first().val();
			creator = element.find(".driveCardContent>input.fileCreatorName").first().val();
			size = element.find(".driveCardContent>input.fileSize").first().val() + " KB";
		}
	}
	
	let html =	"<h4 class='mt-3 mb-4'>"
					+'<img class=" mr-3" style="height : 40px;" onerror="this.onerror=null; this.src=\'resources/images/drive/file.png\';" src="resources/images/drive/'+extension+'.png" >'
					+ name +"  </h4>" 
					+ "<div class='row mb-3' style='font-size: medium;'>"
					+ "	<div class='col-sm-6'>유형</div>"
					+ "	<div class='col-sm-6 text-left'>"+extension+"</div>"
					+ "</div>"
					+ "<div class='row mb-3' style='font-size: medium;'>"
					+ "	<div class='col-sm-6'>용량</div>"
					+ "	<div class='col-sm-6 text-left'>"+size+"</div>"
					+ "</div>"
					+ "<div class='row mb-3' style='font-size: medium;'>"
					+ "	<div class='col-sm-6'>위치</div>"
					+ "	<div class='col-sm-6 text-left' style='font-size : small;'>"+$("#driveName").html()+"<i class='fas fa-angle-right ml-2'></i></div>"
					+ "</div>"
					+ "<div class='row mb-3' style='font-size: medium;'>"
					+ "	<div class='col-sm-6'>소유자</div>"
					+ "	<div class='col-sm-6 text-left'>"+creator+"</div>"
					+ "</div>"
					+ "<div class='row mb-3' style='font-size: medium;'>"
					+ "	<div class='col-sm-6'>생성일</div>"
					+ "	<div class='col-sm-6 text-left'>"+createDate+"</div>"
					+ "</div>"
	
	Swal.fire({
		  title : '<i class="fas fa-info-circle mr-4"></i> 상세 보기',
		  html : html,
	})
}

function downloadFile(fileName){
	let folderIdx = $('#jstree').jstree('get_selected')[$('#jstree').jstree('get_selected').length-1];
	let ref = $('#jstree').jstree().get_node(folderIdx).parent;
	let refs = $('#jstree').jstree().get_node(folderIdx).parents;

	let path ="/upload/project/"+currentProjectIdx+"/drive/";
	
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
		url : "GetDriveDownloadPath.do",
		type : "POST",
		data : { projectIdx : currentProjectIdx
					, folderIdx :folderIdx
					, refs : refs 
					, fileName : fileName
					},
		success : function(downloadPath){
			if(downloadPath){
				$(".defaultDriveMenu").append("<a href='"+downloadPath+"' id='tempLink' download ></a>")
				$("#tempLink").get(0).click();
				$("#tempLink").remove();
			}else{
				errorAlert("파일 다운로드에 실패하였습니다.");
			}
		},
		error : function(){
			errorAlert("파일 다운로드에 실패하였습니다.");
		}
	})
}

$.fn.selectRange = function(start, end) {
	return this.each(function() {
		if(this.setSelectionRange) {
			this.focus();
			this.setSelectionRange(start, end);
		}
		else if(this.createTextRange) {
			let range = this.createTextRange();
			range.collapse(true);
			range.moveEnd('character', end);
			range.moveStart('character', start);
			range.select();
		}
	});
}

function changeSelectedFolder(id, name){
	let folderIdx = $('#jstree').jstree('get_selected')[$('#jstree').jstree('get_selected').length-1];
	let folderName = $("#jstree").jstree(true).get_node(id).text;

	$('#jstree').jstree("deselect_all");
	$("#jstree").jstree("select_node", "#"+id);
	
	setDirectoryData(id, name);
}

function driveRefresh(){
	folderList = [];
	$.ajax({
		url:"DriveList.do",
		dataType:"json",
		data:{projectIdx: currentProjectIdx},
		success:function(data){
			let folder;		
			$.each(data, function(index, element){				
				folder = new folderInfo();
				
			    if(element.ref == 0){
					element.ref = "#";
					folder.state= {"opened" : true, "selected" : true};
			    }			    
			    folder.id = element.driveIdx;
			    folder.parent = element.ref;
			    folder.text = element.folderName;
			    
			    addFolder(folder);
			});
			
			$('#jstree').jstree(true).settings.core.data = folderList;
			$('#jstree').jstree(true).refresh();

			callDirectoryData();
		}
	});
}

function handleFileUpload(files, obj){
   for (var i = 0; i < files.length; i++){
        var fd = new FormData();
        fd.append('file', files[i]);

        var status = new createStatusbar(obj); //Using this we can set progress.
        status.setFileNameSize(files[i].name,files[i].size);

        sendFileToServer(fd,status);
   }
}

function setFileUpload(){
	let counter = 0;
	$("#dragandrophandler").on('dragenter', function (e){ // 파일 dropZone에 들어옴
		counter++;
		
	    $(this).addClass('dragBorder');
    	$(".driveUploadBox").removeClass("hidden");
	    return false;
	}).on('dragleave', function (e) { // 파일 dropZone에서 나감
		counter--;
		 if (counter === 0) { 
			 $(this).removeClass('dragBorder');
				$(".driveUploadBox").addClass("hidden");
		 }
		 
		return false; 
	}).on('drop', function (e)  {	 // 파일 dropZone에  drop
	    $(this).removeClass('dragBorder');
	    $(".driveUploadBox").addClass("hidden");
	    
	     return false;
	});
	
	$("#driveUploadFiles").fileupload({
		singleFileUploads: false,
		url : "DriveFileUpload.do",
		formData : {projectIdx : currentProjectIdx},
		add: function(e, data){
			let folderIdx = $('#jstree').jstree('get_selected')[$('#jstree').jstree('get_selected').length-1];
			$("#driveUploadFiles").fileupload( 'option', 'formData').folderIdx = folderIdx;
			$("#driveUploadFiles").fileupload( 'option', 'formData').refs = $('#jstree').jstree().get_node(folderIdx).parents;
			data.submit();
		},
		dropZone: $('#dragandrophandler'),
		done : function(e, data){
			let files = [];
			$.each(data.files, function(index, element){
				files.push(element.name);
			})
			callDirectoryData();
			
			files.forEach(function(item, index){
				//푸쉬 알람 보내기. 이 함수의 위치는 top.jsp  아래쪽 스크립트에 있음...
				sendNoticePushAll(currentProjectName, item +"파일이 업로드 되었습니다.", currentProjectIdx);
				pushNoticeToAll(currentProjectIdx,currentProjectName, item +"파일이 업로드 되었습니다." , "drive");
				
			});
			
    		
		},
		fail : function(){
			console.log("driveUploadFiles fail");
		}
	});
}

function setDriveTable(){
	$("#driveTable").DataTable({
	 	stateSave: true, // 페이지 상태 저장
	 	"lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	 	"searching": false,
         fixedColumns: true,
         autoWidth: false,
         columnDefs: [ { targets: 0, className: 'dt-body-left' }]
	}).on('click', 'tbody tr', function () {
		if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
        } else {
        	$("#driveTable").DataTable().$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
	}).on('dblclick', 'tbody tr.folder', function () {
		changeSelectedFolder($(this).attr("id"), $(this).find("td span").first().text());
	});

	
	 $.contextMenu({
         selector: '#driveTable tbody tr',
         build : function(trigger, e){
        	 let isFolder = $(trigger[0]).hasClass("folder");
        	 return {
                 callback: function(key, options) {
                     let driveFileIdx = trigger[0].id;
                     if(key == "download"){
                    	 downloadFile($(trigger[0]).find("td span").first().text());
                     }else if(key == "rename"){
                       	 let renameElement = $(trigger[0]).find("td").first();
                    	 let oldText = $(trigger[0]).find("td span").first().text();
                    	 
                    	 renameElement.html(getRenameElementContent(isFolder, driveFileIdx, oldText));
                    	 $("#driveFileRename").selectRange(0, oldText.lastIndexOf('.'));
                     }else if(key == "detail"){
                    	 driveDetail(isFolder, driveFileIdx);
                     }else if(key == "delete"){
                    	 if(isFolder)
                    		 deleteDriveFolder(driveFileIdx);
                    	 else 
                    		 deleteDriveFile(driveFileIdx);
                     }else if(key == "restore"){
                    	 if(isFolder)
                    		 restoreFolderfromTrash(driveFileIdx);
                    	 else 
                    		 restoreFileTrash(driveFileIdx);
                     }else if(key == "deleteFromTrash"){
                    	 if(isFolder)
                        	 deleteFolderfromTrash(driveFileIdx);
                    	 else
                        	 deleteFilefromTrash(driveFileIdx);
                     }
                 },
                 items:{
                     "download": {name: "다운로드", icon: "fas fa-download", visible : !isFolder && !isTrash},
                     "rename": {name: "이름 변경", icon: "edit", visible : !isTrash},
                     "detail": {name: "상세 보기", icon: "fas fa-info-circle", visible : !isTrash},
                     "delete": {name: "삭제", icon: "delete", visible : !isTrash},
                     "restore": {name: "복원", icon: "fas fa-undo", visible : isTrash},
                     "deleteFromTrash": {name: "영구삭제", icon: "delete", visible : isTrash},
            	 	}
             };
         },
     });
}