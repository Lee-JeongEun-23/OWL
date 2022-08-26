<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- File Upload -->
<script src="resources/plugin/fileUpload/jquery.fileupload.js"></script>
<script src="resources/plugin/fileUpload/jquery.iframe-transport.js"></script>
<script src="resources/plugin/fileUpload/jquery.ui.widget.js"></script>
<!-- Contect Menu -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.7.1/jquery.contextMenu.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.7.1/jquery.contextMenu.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.7.1/jquery.ui.position.js"></script>

<style>
.btn-link1 {
	display: inline-block;
	padding: 0;
	font-size: inherit;
	color: #0366d6;
	text-decoration: none;
	white-space: nowrap;
	cursor: pointer;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
	background-color: initial;
	border: 0;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	
}
/* .more {
    visibility: hidden;
} */
</style>
<script>
var folderList = [];

function folderInfo() {
    this.id = null;
    this.parent = null;   
    this.text = null;
    this.state ={};
}

function addFolder(folder) {
	folderList.push(folder);
}

$(function(){
$("#driveSearchBtn").click(function(){
	$("#default").addClass("hidden");
	$("#searchFile").removeClass("hidden");
});
	
	$.ajax({
		url:"DriveList.do",
		dataType:"json",
		data:{projectIdx:${project.projectIdx}},
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

			$.jstree.defaults.core.themes.variant = "large";
			$('#jstree').jstree({
					"core" : {
						"animation" : 0,
						"check_callback" : true,
						'force_text' : true,
						"themes" : { "stripes" : true },
					    'data' : folderList
					  },
					  "types" : {
							"#" : { "max_children" : 1, "max_depth" : 3, "valid_children" : ["root"] },
							"root" : { "icon" : "fas fa-folder", "valid_children" : ["default"] },
							"default" : { "icon" : "fas fa-folder", "valid_children" : ["default","root"] }
						},
						"plugins" : [ "contextmenu", "dnd", "search", "state", "types", "wholerow"]
				});

			// default folder
			setDirectoryData(folderList[0].id,folderList[0].text);
		}
	});

	$('#jstree').bind('rename_node.jstree', function (e, data) {
			if(data.node.id.startsWith("j1_")){	
			jQuery.ajaxSettings.traditional = true;				
			  $.ajax({
	        		url:"insertFolder.do",
	        		method:"POST",
	        		data:{projectIdx: ${project.projectIdx},
	        			  folderName: data.text,
	        			  ref: data.node.parent,
	        			  refs : data.node.parents
	        			 },
	        		success:function(idx){
		        		data.node.id = idx; 
		        		driveRefresh();
	        		}
	    		});
			}else{
				let thisId = data.node.id;
				$.ajax({
	        		url:"updateNewName.do",
	        		method:"POST",
	        		data:{driveIdx: data.node.id,
	        			     folderName: data.text
	        			 },
	        		success:function(idx){
		        		data.node.id = idx;
		        		driveRefresh();
	        		}
	    		});
		       
			}
		}).bind('move_node.jstree', function (e, data) {
			//잘라내기 후 paste 할 때
			jQuery.ajaxSettings.traditional = true				
			  $.ajax({
	        		url:"cutFolder.do",
	        		method:"POST",
	        		data:{driveIdx: data.node.id,
		        		  projectIdx: ${project.projectIdx},
	        			  folderName: data.node.text,
	        			  ref: data.parent,
	        			  refs: data.node.parents,
	        			  oldRef: data.old_parent
	        			 },
	        		success:function(idx){
		        		data.node.id = idx;
		        		driveRefresh();
	        		}
	    		});
			}).bind('paste.jstree', function (e, data) {
 	 			//복사 후 paste 할 때
 	 			if(data.mode =="copy_node"){ 	 	 			
				jQuery.ajaxSettings.traditional = true				
				  $.ajax({
		        		url:"copyFolder.do",
		        		method:"POST",
		        		data:{oldId: data.node[0].id,
			        		  projectIdx: ${project.projectIdx},
		        			  folderName: data.node[0].text,
		        			  parent: data.parent, //새로운 ref
		        			  refs: data.node[0].parents
		        			 },
		        		success:function(idx){
			        		data.node[0].id =idx;
			        		driveRefresh();
		        		}
		    		});
 	 			}
 			}).bind('delete_node.jstree', function (e, data) {
				deleteDriveFolder(data.node.id, data.node.parent);
 			});

	$("#createFolder").click(function(){
		var ref = $('#jstree').jstree(true),
		sel = ref.get_selected();
		if(!sel.length) { return false; }
		sel = sel[0];
		sel = ref.create_node(sel, {"type":"default"});
		if(sel) {
			ref.edit(sel);					
		} 
	});
	
	//대소문자 구분 없이
	$.extend($.expr[":"], {
		"containsIN": function(elem, i, match, array) {
			return (elem.value || elem.innerText || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
		},
		"containsININ": function(elem, i, match, array) {
			return (elem.textContent || elem.innerText || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
		}
	});
		
	//검색 기능
	let to = false;
	$('#searchText').keyup(function () {
		if(to) { clearTimeout(to); }
		to = setTimeout(function () {
			var v = $('#searchText').val();

			if(driveViewType == "tableView"){
	                $("#driveTable > tbody > tr").hide();
	                let temp = $("#driveTable > tbody > tr > td:containsININ('" + v + "')");				
	                $(temp).parent().show();				
					$('#driveTable').DataTable().column().search(v).draw();
					
			}else{
				$(".driveCard").parent().hide();     
			     let temp = $(".driveCardContent>input.fileName:containsIN('" + v + "')");
				 let cloneTemp = $(temp).parent().parent().parent().parent();
				 setSearchView(cloneTemp);
			}	 
			$('#jstree').jstree(true).search(v);
		}, 100);
	});

	
});

function sendFileToServer(formData,status){
    var uploadURL ="http://hayageek.com/examples/jquery/drag-drop-file-upload/upload.php"; //Upload URL
    var extraData ={}; //Extra Data.
    var jqXHR=$.ajax({
            xhr: function() {
            var xhrobj = $.ajaxSettings.xhr();
            if (xhrobj.upload) {
                    xhrobj.upload.addEventListener('progress', function(event) {
                        var percent = 0;
                        var position = event.loaded || event.position;
                        var total = event.total;
                        if (event.lengthComputable) {
                            percent = Math.ceil(position / total * 100);
                        }
                        //Set progress
                        status.setProgress(percent);
                    }, false);
                }
            return xhrobj;
        },
    url: uploadURL,
    type: "POST",
    contentType:false,
    processData: false,
        cache: false,
        data: formData,
        success: function(data){
            status.setProgress(100); 
        }
    }); 
 
    status.setAbort(jqXHR);
}

function allRemovetoTrash(){
	let goTrashFolder = [];
	let goTrashFile = [];
/*  	$.each($('.driveCard.folder'), function(index, element){
		goTrashFolder.push($(element).attr("id"));		
		})  */
	$.each($('.driveCard.file'), function(index, element){
		goTrashFile.push($(element).attr("id"));		
		})		
/* let Stringfolder = goTrashFolder.join(','); */
let Stringfile = goTrashFile.join(',');
	$.ajax({
  		 url : "DeleteAllFile.do",
  		type: "POST",
  		data : {driveFileIdxList: Stringfile},
  		dataType: "json",
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
</script>


<div class="container-fluid mt-3 themeChangeLetter">
    <div class="row">
        <div class="col-md-3">
            <h2 style="padding-left: 25px;">
                <b>D r i v e</b>
            </h2>
            <hr>
            <span id="createFolder" style="cursor: pointer; float: right;"><i class="fas fa-plus"></i></span>
            <br>
            <div class="row">
                <div class="col-lg-12">
                    <div id="jstree" class="demo" style="margin-top:1em; min-height:300px;">

                    </div>
                    <div>
                        <button id="trashBtn" class="btn-link themeChangeLetter pl-2" style="color:#326295;"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;&nbsp;<span style="font-weight:bold; font-size:16px">휴지통</span></button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-9" style="padding-left: 0;">
            <div class="defaultDriveMenu themeChange pt-0">
	            <div class="h-100">
	            	<div style="height: 15%" class="mt-1 mb-3">
	            		<span style="font-size: medium;font-weight: 700;"  id="driveName"></span>
	            	</div>
	            	<div style="height: 70%; position: relative;">
		                <span style="font-size : large; font-weight:bold" class="hidden" id="trashName">
		                	<i class="fas fa-trash-alt"></i>&nbsp;&nbsp;휴지통
		               	</span>
		               	<div id="searchFile" class="hidden">
			                <input type='text' id='searchText' style='width: 40%; height: 30px; border-left-width: 0px;'>
			                <a href='#' onclick='ReturnCheck()'><i class='fas fa-times'></i></a>
		               	</div>		               	
		               	<div id="allCheck" class="hidden">
		               		<button type='button' class='driveBtn btn-primary' onclick='allRemovetoTrash()'>삭제</button>&nbsp;&nbsp;
		               		<button type='button' class='driveBtn btn-primary'>이동</button>&nbsp;&nbsp;		               		
							<button type='button' class='driveBtn btn-primary' onclick='ReturnCheck()'>선택해제</button>&nbsp;&nbsp;
		               	</div>
		               	<div id="theCheck" class="hidden">
		               		<button type='button' class='driveBtn btn-primary'>업로드</button>&nbsp;&nbsp;
		               		<button type='button' class='driveBtn btn-primary'>이동</button>&nbsp;&nbsp;
		               		<button type='button' class='driveBtn btn-primary'>삭제</button>&nbsp;&nbsp;		               		
							<button type='button' class='driveBtn btn-primary' onclick='ReturnCheck()'>선택해제</button>&nbsp;&nbsp;
		               	</div>
		               	<div id="default">
		                <button id="driveSearchBtn" type="button" class="driveBtn btn-primary"
		                    onclick="Search()">검색</button>&nbsp;&nbsp;
		                <div class="filebox" style="display:inline;">
		                    <input type="file" id="driveUploadFiles" name="driveUploadFiles" multiple>
		                    <label for="driveUploadFiles" style="cursor: pointer; margin-bottom: 0px;"
		                        class="driveBtn btn-primary" id="driveUploadBtn">업로드</label>&nbsp;&nbsp;
		                </div>
		                <button id="driveAllSelectBtn" type="button" class="driveBtn btn-primary"
		                    onclick="Allcheck()">전체선택</button>
		                </div>   
		                &nbsp;&nbsp;&nbsp;&nbsp;
		                <div class="drivegroup" style="position: absolute; right: 0px; top: 0px;">
		                    <button class="btn driveViewBtn " id="tableView">
		                        <i class="fas fa-list fa-2x"></i>
		                    </button>
		                    <button class="btn driveViewBtn active " id="iconView" disabled>
		                        <i class="fas fa-th-large fa-2x"></i>
		                    </button>
		                </div>
	            	</div>
	            </div>
            </div>

            <div class="row" style="margin : 10px 10px; margin-top: 0px;">
                <div class="col-lg-12">
                    <div id="dragandrophandler" style="height: 630px; overflow-y: auto; overflow-x:hidden;">
                        <div class="text-center mt-5 hidden" id="emptyDriveBox">
                            <img src="resources/images/drive/notFound.png" style="height: 250px">
                            <h1 class="text-muted mt-5">File Not Found.</h1>
                            <h4>Please upload a file in <span id="directoryName"></span></h4>
                        </div>
                        <div class="text-center ml-5 hidden driveUploadBox" >
                            <img src="resources/images/drive/upload.png" style="height: 250px" >
                            <h1 class="mt-4">Drag and Drop files here.</h1>
                        </div>
                        
                        <div id="driveIconViewBox"></div>
						
						<div id="driveSearchViewBox" class="hidden"></div>
							
                        <div id="driveTableViewBox" class="hidden">
                            <table id="driveTable" class="table table-hover table-bordered text-center">
                                <thead>
                                    <tr>
                                        <th width="45">파일 명</th>
                                        <th width="30%">생성일</th>
                                        <th width="15%">생성자</th>
                                        <th width="10%">파일 크기</th>
                                    </tr>
                                </thead>

                                <tbody> </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>