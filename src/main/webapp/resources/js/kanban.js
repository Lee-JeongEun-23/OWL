let projectIdx;

let editIdx = 0;

let pmemail; 

let words = new Array(); // project memberlist (name)
let wordsemail = new Array(); // project memberlist (email)

let selectoption = '<option value="">Select</option>';
let ordernum = 1; 

let kanbanViewType = "";

function initKanban(projectIdx){
	this.projectIdx= projectIdx;
	
	
	$.ajax({
		url : "GetPMemail.do",
		data : {projectIdx : projectIdx},
		success : function(data) {
			pmemail = data;
			
		}, error : function() {
			console.log('error');
		}
		
	})
	
	
	// addIssueModal 모달이 오픈되면 !
	$('#addIssueModal').on('show.bs.modal', function() {  
		// 칸반으로 옮김
		getissueinfo("issueModalOpen");

	}).on('hidden.bs.modal', function(e){
		 $('#isContent').summernote("reset");
		$(this).find('.addContent')[0].reset();
 	});
	

	
	$('#editLabelBtn').click(function() {
		
		if(editIdx == 0)
			return;
		
		$('#labelColor').val("");
		$('#labelName').val("");
			
		$.ajax({
			url : "UpdateLabel.do",
			data : {'labelIdx' : editIdx, 'labelColor' : $('#labelcolor').val(), 'labelName' : $('#labelname').val()},
			success : function(data) {
				$('#'+editIdx+'Label').next().remove();
				$('#'+editIdx+'Label').remove();
				
				addLabel(editIdx, $('#labelcolor').val(), $('#labelname').val());
				
				$('#labelColor').val("");
				$('#labelName').val("");
				editIdx = 0;
				
				$('#'+editIdx+'Label').attr('style', "background-color:#fff");
			}, error : function () {
				console.log('EditLabel error');
			}
		});
	});
	
	
	$('#backBtn').click(function() {
		editIdx = 0;
		$('#labelcolor').val("");
		$('#labelname').val("");
		
		$('#addLabelBtn').removeClass("hidden");
		$('#editLabelBtn').addClass("hidden");
		$('#backBtn').addClass("hidden");

		$('#colorform').find('.asColorPicker-trigger').find('span').css('background-color', '#000000');
		$('.labelList').find('.edit').removeClass("hidden");

	});


	// 검색 후 원래 칸반으로 되돌아가는 버튼
	$('#searchReturnBtn').click(function() {
		changeKanbanView("returnlist");
	})
	
	
	
	$('#searchSelectBox').change(function () {
		
		var selectMenu = $('#searchSelectBox option:selected').val();

		if(selectMenu == "Label") {
			$('#searchContent').attr('list', 'LabelMenu');
			getLabelList("SearchLabelList");
		}else if(selectMenu == "Assignee") {
			$('#searchContent').attr('list', 'MemberMenu');
			getProjectMemberList("searchMember");
		}else if(selectMenu == "Priority") {
			$('#searchContent').attr('list', 'PriorityMenu');

			var prioritylist = '<datalist id="PriorityMenu">'
						     + '<option value="LOW" data-id="LOW"></option>'
						     + '<option value="MEDIUM" data-id="MEDIUM"></option>'
						     + '<option value="HIGH" data-id="HIGH"></option>'
						     + '<option value="URGENT" data-id="URGENT"></option>'
						     + '</datalist>'; 
			
			$('#searchContent').append(prioritylist);
		}	
	})

	
	// 검색
	$('#kanbanSearchBtn').click(function(){
		
		$('#searchBox').find('tbody').empty();
		
		if($('#searchContent').val() == "" || $('#searchContent').val() == null) {
			return;
		}
		
		let selectMN = $('#searchSelectBox option:selected').val();
		let contentVal = $('#searchContent').val();
		
		if(selectMN == "Assignee") {
			
			var memberemail = $('#MemberMenu option[value='+contentVal+']').attr('data-id');

			$.ajax ({
				url : "SearchAssignee.do",
				data : {"projectIdx" :projectIdx, "email" : memberemail},
				method : "POST",
				success : function(data) {
					searchAppend(data)

				},error : function() {
					console.log('SearchAssignee error');
				} 
			})
			
		}else if(selectMN == "Label") {
			
			var labelidx = $('#LabelMenu option[value='+contentVal+']').attr('data-id');
		
			$.ajax ({
				url : "SearchLabel.do",
				data : {"labelIdx" : labelidx},
				method : "POST",
				success : function(data) {
					searchAppend(data)
				},error : function() {
					console.log('SearchLabel error');
				} 
			})
		}else if(selectMN == "Priority") {
			
			var priorityidx = $('#PriorityMenu option[value='+contentVal+']').attr('data-id');

			$.ajax ({
				url : "SearchPriority.do",
				data : {"priorityidx" : priorityidx},
				method : "POST",
				success : function(data) {
					searchAppend(data)

				},error : function() {
					console.log('SearchLabel error');
				} 
			})
			
		}
	});


	 $('#isContentEdit').summernote({
	        height: 300,
	        toolbar: [
	            ['style', ['bold', 'italic', 'underline', 'clear']],
	            ['font', ['strikethrough', 'superscript']],
	            ['fontsize'],
	            ['color'],
	            ['para', ['ul', 'ol', 'paragraph']],
	        ]
	      });
	 


		$('.editViewBtn').on('click', function(e){
			    if( $(this).parent().siblings().find(".row").hasClass("hidden")){
				    $(this).parent().siblings().find(".row").removeClass("hidden");
				    $(this).parent().siblings().find("span").addClass("hidden");
			    } else {
			    	$(this).parent().siblings().find("span").removeClass("hidden");
				    $(this).parent().siblings().find(".row").addClass("hidden");
			    }
			});

	

		 /* datwpicker */
		 		 $('#datepicker-autoclose, #datepicker-editIssue').datepicker({
		 			 dateFormat: 'yy-mm-dd' ,
		 	   		  autoclose: true,
		 	    	  todayHighlight: true,
		 	    	  minDate : currentProjectStartDate,
		 	    	  maxDate : currentProjectEndDate
		 		 }); 

		 		/* Summer Note */
		 		 $('#isContent').summernote({
		 		        placeholder: 'Write Issue content',
		 		        height: 120,
		 		        toolbar: [
		 		            ['style', ['bold', 'italic', 'underline', 'clear']],
		 		            ['font', ['strikethrough', 'superscript']],
		 		            ['fontsize'],
		 		            ['color'],
		 		            ['para', ['ul', 'ol', 'paragraph']],
		 		        ]
		 		      });


		 		 
		 			$(".InsertIssueBtn").on("click", function (event) {
 			        	var projectAuth = $('#getAuthority').val();
		 				
 			        	if($('#issueTitle').val() == ""){
		 					warningAlert("제목을 작성해주십시오");
		 					return; 
		 				}
 			        	
		 				if($('#isContent').val() == ""){
		 					warningAlert("내용을 작성해주십시오");
		 					return; 
		 				}	
		 				
		 			    let formData = new FormData();
		 			    formData.append("projectIdx",projectIdx);

		 			    formData.append('issueTitle',$('#issueTitle').val());
		 			    formData.append('content', $('#isContent').summernote('code'));
		 			    formData.append('orderNum', ordernum++);
		 			    formData.append('priorityCode', $('#priorityCode').val());			    
		 			    formData.append('assigned', $('#assigned').val());
		 			    formData.append('labelIdx', $('#labelIdx').val());
		 			    formData.append('dueDate', $('#datepicker-autoclose').val());
		 			    formData.append('colIdx', '-1');
		 			    formData.append('authority', projectAuth);

		 			    $.each($("#multipartFiles")[0].files, function(i, file) {
		 			    	formData.append('multipartFiles', file);
		 			    }); 

		 				let istitle = $('#issueTitle').val();
		 				let isassignee = $('#assigned').val();
		 				
		 				$.ajax({
		 					url : 'InsertIssue.do',
		 			        type: "POST",
		 					enctype :'multipart/form-data',
		 					data : formData,
		 			        processData: false,
		 			        contentType: false,
		 			        cache: false,
		 			        timeout: 600000,
		 			        success: function (data) {

		 			        if(projectAuth == 'ROLE_PROJECTMEMBER'){ // 이슈, 컨펌, pm에게 보내는 경우
		 			        	sendNoticePushToOne(pmemail, loginUserName+"님이 이슈 생성", istitle);
		 			        	pushNoticeToOne(currentProjectIdx,currentProjectName, "["+ loginUserName+"]님이 이슈 생성:" + istitle , "kanbanIssueToPm", pmemail, data.issueIdx, "topm");
		 			        }else{ // 이슈 생성 알림
		 			        	sendNoticePushAll(loginUserName + "님이 이슈 생성", istitle, currentProjectIdx);
		 			        	pushNoticeToAll(currentProjectIdx, currentProjectName, "["+ loginUserName+"]님이 이슈 생성:" + istitle, "kanbanIssue", data.issueIdx);
		 			        }
		 			        	
		 	 		        if(data != null){
		 			        	successAlert("PM에게 issue전달 완료");
		 			 			setKanbanData();
		 			 			//setChageView("kanban");

		 			        	$('#addIssueModal').modal("hide");

		 			        }else{
		 			        	errorAlert("Issue 추가 실패");
		 			        }

		 	 		       	$( ".sortableCol").sortable({
		 				        connectWith: ".connectedSortable",
		 				        dropOnEmpty: true       
		 				     }).disableSelection(); 
		 			        },
		 			        error: function (e) {
		 			        	errorAlert("Issue 추가 실패");
		 			        }
		 			    });
		 		 	});
		 			

		 			
		 			$('#addLabelModal').on('show.bs.modal', function() { 
		 				getLabelList("ShowLabelList");

		 			}).on('hidden.bs.modal', function() {  
		 				$('#labelcolor').val("");
		 				$('#labelname').val("");
		 				
		 				$('#addLabelBtn').removeClass("hidden");
		 				$('#editLabelBtn').addClass("hidden");
		 				$('#backBtn').addClass("hidden");
		 			});

		 		
		 	         $("#openIssueBtn").click(function() {
		 	            $("#-1Column").removeClass("d-none");
		 	     		$("#-99Column").hide();
		 	     		$("#-1Column").show();
		 	          });
		 	         
		 	         
		 	         $("#closeIssueBtn").click(function() {
		 	         	$("#-99Column").removeClass("d-none");
		 	     		$("#-1Column").hide();
		 	     		$("#-99Column").show();
		 	          });

		 	    $("#InsertColumnBtn").on("click", function () {	
		 	    	if(!$('#colname').val()) {
		 	    		warningAlert("칼럼 이름을 입력해주세요.");
		 	    		return;
		 	    	}

		 	    	$.ajax({
		 	   				url : 'InsertColumn.do',
			   				type: "POST",
		 	   				data : {'projectIdx' : projectIdx, 'colname' : $('#colname').val()},
		 	   				success : function(data) {
		 	   					if(data != null) {
		 	   						
		 	   		        		addColumn(data);

		 	       					$( ".sortableCol").sortable({
		 	       				        connectWith: ".connectedSortable",
		 	       				        dropOnEmpty: true,
		 	       				        update: function(event, ui) {
		 	   								let target = $(ui.item).attr("id").replace("Issue","");
		 	   								let columnIdx = $(this).parent().attr("id").replace("Column","");
		 	   								let issues = [];
		 	   								$.each($(this)[0].children, function(){
		 	   									issues.push($(this).attr("id").replace("Issue","").trim())
		 	   								})
		 	   								
		 	   								if(issues.length == 0)
		 	   									return;
		 	   								
		 	   								$.ajaxSettings.traditional = true; 
		 	   								$.ajax({
		 	   									type : "POST",
		 	   									url : "MoveIssue.do",
		 	   									data : { 	projectIdx :  projectIdx
		 	   												, targetIssueIdx : target
		 	   												, columnIdx : columnIdx
		 	   												, issues : issues },
		 	   									success : function(data) {
		 	   									},
		 	   									error: function() {
		 	   										console.log("error move issue");
		 	   									}
		 	   								})
		 	          				        }       
		 	       				     }).disableSelection();

		 	   		        		$('#addColumnModal').modal("hide");
		 	   					}else {
		   						errorAlert("Column 추가 실패");
		 	   					}
		 	   				},
		 	   				error : function(e) {
		 	   		        	errorAlert("Column 추가 error");
		 	   					}
		 	   				});
		 	   	});
		 	    	

		 	   	
		 		$('#addColumnModal').on('hidden.bs.modal', function() {  
		 			$('#colname').val("");
		 		});
		 		
		 		
		 		$("#addLabelBtn").on("click", function () {	

		 			let lcolor = false;
		 			let lname = false;

		 			let lbcolor = $('#labelcolor').val();
		 			let lbname = $('#labelname').val();

		 			if($('#labelcolor').val().trim() != "" && $('#labelcolor').val().trim() != null) lcolor = true;
		 			if($('#labelname').val().trim() != "" && $('#labelname').val().trim() != null) lname = true;

		 			if(lcolor == true && lname == true) {
		 				$.ajax({
		 					url : 'InsertLabel.do',
		 					data : {'projectIdx' : projectIdx, 'labelColor' : $('#labelcolor').val(), 'labelName' : $('#labelname').val()},
		 					success : function(labelIdx) {
		 						
		 					addLabel(labelIdx, lbcolor, lbname);

		 					$('#labelcolor').val("");
		 				    $('#labelname').val("");
		 					},
		 					error : function(e) {
		 			        	errorAlert("label 추가 error");
		 					}
		 				});
		 				
		 			}else {return false;}

		 			});

		 	    $("#editColumnBtn").click(function() {
		 	        $.ajax({
		 	        	url : 'UpdateColumn.do',
		 	        	data : { 'colname' : $("#editcolName").val(),'projectIdx' : projectIdx,'colIdx' :  $("#editcolIdx").val()}, 
		 	        	success : function(data) {
		 	            $("#" + data + "Column span").text($("#editcolName").val());
		 	        		$("#editcolName").val("");
		 	            	$('#editColumnModal').modal('hide');
		 		
		 	            },
		 	            error : function() {
		 	            	errorAlert("칼럼 수정 error");
		 	            }
		 	        });
		 	    });
		 	   setKanbanTable();
		 	   changeKanbanViewType();

			$('#editColumnModal').on('show.bs.modal', function(event) {     
				let editColIdx="";
				let editColname="";
				editColIdx = $(event.relatedTarget).data('updatecol-id');
				editColname = $(event.relatedTarget).data('upcolname-id');
			  	
			  $("#editcolName").val(editColname);
			  $("#editcolIdx").val(editColIdx);
			});
			
} // initKanban 끝




function editColname() {
	 $.ajax({
      	url : 'UpdateColumn.do',
      	data : { 'colname' : $("#editcolName").val(),'projectIdx' : currentProjectIdx, 'colIdx' :  $("#editcolIdx").val()}, 
      	success : function(data) {
      		setChageView("kanban");
      		$("#editcolName").val("");
          	$('#editColumnModal').modal('hide');
          },
          error : function() {
          	errorAlert("칼럼 수정 error");
          }
      });	
	
}

function addReply(creator) {

	let replyct = $('#replycontent').val();
	if(replyct == "" || replyct == null) {
		return false;
	}else {
		  $.ajax ({
		 		type :"POST",
				url : "InsertReply.do",
				data : { 'issueIdx' : $('#issueIdxNum').val()
							, 'content': $('#replycontent').val()},
				success : function(data) {
					
					arrSelectedUserEmail.forEach(function(item, index){
						sendNoticePushToOne(item, "<" + curName + "님의 멘션>", $('#replycontent').val());
			        	pushNoticeToOne(currentProjectIdx,currentProjectName, curName + "언급하였습니다.", "mention", item, $('#issueIdxNum').val(), "");
					})

					$(".emoji-wysiwyg-editor").empty();
					$('#replycontent').val("");
		    		setKanbanDetail(data.issueIdx);

				},error : function() {
		        	errorAlert("InsertReply error");
					}
				})   
		}
	};	


function searchAppend(data) {
	
	$('#searchContent').val("");
	changeKanbanView("search");
      $.each(data, function(index, element) {
    	  	
			let labelnm = element.labelName == null ? "" : element.labelName;
			let dueDt = element.dueDate == null ? "-" : element.dueDate;
			
			
	    	  var control = "";
    	  	  control = '<tr><td class="text-center"><label><span class="badgeIcon" style="background-color:'+ element.labelColor+'">' + labelnm + '</span></td>'
			 	      + '<td class="text-center"><a href="#" onclick="setKanbanDetail('+element.issueIdx+');">'+element.issueTitle+'</a></td>'
			          + '<td class="text-center">'+element.assigned+'</td>'
			          + '<td class="text-center"><span class="searchpriority"></span></td>'
			          + '<td class="text-center">'+dueDt+'</td></tr>';
    	  	  $('#searchBox').find('tbody').append(control);
			
			
			if(element.priorityCode != null){
				$(".searchpriority").addClass("priorityBadge "+element.priorityCode.toLowerCase());
			} 

      });
}



function addLabel(lbidx, lbcolor, lbnm) {
   let lablist =  '<div class="row labelList" id="'+lbidx+'Label">'
            +  '<div class="col-lg-8">'
            +  '<span class="badgeIcon" style="background-color: '+lbcolor+';color:'+getTextColorFromBg(lbcolor)+'">'+lbnm+'</span>'
            +  '</div>'
            +  '<div class="col-lg-2">'
            + '<button class="btn-link link-gray edit" onclick="editLabel(' + lbidx +','+"'"+lbcolor+"'"+','+"'"+lbnm+"'"+')";>Edit</button>'
            +  '</div>'
            +  '<div class="col-lg-2">'
            +  '<button class="btn-link link-gray delete" onclick="deleteLabel(' + lbidx +')";>Delete</button>'
            +  '</div></div><hr>';

   $('#labelList').append(lablist);
}

   
function addColumn(obj){
	
	let authority = $('#getAuthority').val();

   let column = '<div class="columnSection" id="'+ obj.colIdx +'Column">'
              + '<div class="columnTitle text-center mt-2 dropdown">'
              + '<h4><span>' + obj.colname + '</span>';
            
	if(authority == 'ROLE_PM') {
		
	    column  += '<a href="javascript:void(0)" data-toggle="dropdown" id = "dropdownColBtn" aria-haspopup="true" aria-expanded="false" style="float: right">' 
                + '<i class="fas fa-ellipsis-v fa-sm"></i></a>'
                + '<div class="dropdown-menu" aria-labelledby="dropdownColBtn">'
                +            '<ul class="list-style-none">'
                +   '<li class="pl-3"><a href="#editColumnModal" data-toggle="modal" data-updatecol-id="' + obj.colIdx +'" data-upcolname-id ="'+ obj.colname + '">'  
                +   'Edit Column</a></li>'
                +               '<li class="pl-3"><a href="#" onclick="deleteColumn(' + obj.colIdx +');">Remove Column</a></li>'
                +            '</ul>'
                +         '</div>';
		
	}
 
	 column  +=  '</h4>'
             +   '</div>'
             +   '<ul class="connectedSortable sortableCol columnBody cursor ui-sortable" style="margin-top: 35px">'
             +   '</ul>'
             + '</div>';
   
   $('#kanbanIn').append(column);
}

function deleteColumn(obj){
   var colIndex = obj;
   Swal.fire({
          title: '정말 삭제하시겠습니까?',
          text: '컬럼 내에 있는 이슈와 파일들이 함께 삭제됩니다.',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#3085d6',
          cancelButtonColor: '#d33',
          confirmButtonText: 'Yes'
        }).then((result) => {
          if (result.value) {
           $.ajax({
                 url:"DeleteColumn.do",
                 method:"POST",
                 data:{colIdx: colIndex},
                 success:function(data){
                    $("#"+colIndex+"Column").remove();
                 }
              });   
         }         
     });
}


function addKanbanIssue(colIdx,obj){
	
	let issueTitle = obj.issueTitle.length > 12 ? obj.issueTitle.substr(0, 12)+ ".." : obj.issueTitle;   
	//let letterLength = obj.issueTitle.length + obj.labelName.length;
	//let issueTitle = letterLength > 15 ? obj.issueTitle.substr(0, 15 - obj.labelName.length)+ ".." : obj.issueTitle;

	if(obj.labelName == null) {
		obj.labelName = "";
		obj.labelColor = "";
	}
	
	if(obj.name == null) 
		obj.name  = "none";
	 let issue = '<li class="issuePiece" id="'+obj.issueIdx+'Issue">'
			+		'<div class="dropdown">'
			+			'<label> <span class="badgeIcon float-left" style="background-color: '+ obj.labelColor+'; color: ' + getTextColorFromBg(obj.labelColor) + '">' + obj.labelName + '</span>'
			+			'<span class="issueTitle">' + issueTitle + '</span>'
			+			'</label>'
			+			'<a href="javascript:void(0)" data-toggle="dropdown" id="dropdownIssueButton" aria-haspopup="true" aria-expanded="false" style="float: right">' 
			+			'<i class="fas fa-ellipsis-v fa-sm" style="padding:5px;"></i></a>'
			+			'<div class="dropdown-menu" aria-labelledby="dropdownIssueButton">'
			+				'<ul class="list-style-none">'
			+					'<li class="pl-3"><a href="#" onclick="setKanbanDetail('+obj.issueIdx+');" data-toggle="modal">Detail</a></li>'
			+					'<li class="pl-3"><a href="#" onclick="deleteIssue(' + obj.issueIdx +');">Remove Issue</a></li>'
			+				'</ul>'
			+			'</div>'
			+		'</div>'
			+		'<div>'
			+			'<label>'
			+			'<span class="assigneetitle">'
			+			'<i class="fas fa-user-check"></i>&nbsp; Assignee</span> <span class="assignee">' + obj.name + '</span>'
			+			'</label>'
			+		'</div>'
			+	'</li>';
	
		$("#"+colIdx+"Column > .columnBody").append(issue);
	}


function deleteIssue(obj){
   var issueIndex = obj;

   Swal.fire({
       title: '정말 삭제하시겠습니까?',
       text: '해당 이슈는 복구되지 않습니다.',
       icon: 'warning',
       showCancelButton: true,
       confirmButtonColor: '#3085d6',
       cancelButtonColor: '#d33',
       confirmButtonText: 'Yes'
     }).then((result) => {
       if (result.value) {
    	   $.ajax({
               url:"DeleteIssue.do",
               method:"POST",
               data:{issueIdx: issueIndex},
               success:function(data){
                  $("#"+issueIndex+"Issue").remove();
               }
            });    
      }         
  });
   
   
  
}


function deleteLabel(labelidx) {
   $.ajax ({
      url : "DeleteLabel.do",
      method : "POST",
      data : {'labelIdx' : labelidx},
      success: function(data) {
         
         $("#"+labelidx+"Label").next().remove();
           $("#"+labelidx+"Label").remove();

      }, error : function() {
			warningAlert("현재 사용중인 라벨입니다.");

         }
      })
   }
      

function setKanbanDetail(issueIdx){
	$.ajax({
			type: "POST",
		    url: "GetIssueDetail.do",
			data : { issueIdx : issueIdx},
			success : function (data) {

				$("#multipartFilesIssueEdit").empty();
				$("#issueIdxNum").val(issueIdx);
				$("#issueDetailLabel").removeAttr("style");
				
				if(data.issueProgress == 'OPEN')
						$("#closeIssueDetailBtn").attr("onclick","closeIssue("+issueIdx+",'inDetail')");
					else if (data.issueProgress == 'CLOSED')
						$("#closeIssueDetailBtn").attr("onclick","reOpenIssue("+issueIdx+",'inDetail')");
					
					$("#issueDetailTitle").text(data.issueTitle);
					$("#issueDetailContent").html(data.content);
					
					$("#issueDetailFiles").empty();
					$("#issueDetailFileCount").text("첨부파일 ("+data.files.length+") ");
					
					$.each(data.files, function(index,file){
						let path = "/upload/"+ projectIdx +"/file/"+file.fileName;
						let control = "<li class='mb-2' style='font-size: 16px'>"
										+ "<i class='far fa-save'></i><a href='"+path+"' download class='d-inline-block'>&nbsp;&nbsp;<span> "+file.fileName+" ("+file.fileSize+" KB)</span></a>"
										+ "<i class='far fa-times-circle font-weight-bold ml-3 hidden editIssueFileBtn' style='cursor: pointer;' onclick= 'deleteIssueFile("+file.fileIdx +")'></i>"
										+" </li>";
						$("#issueDetailFiles").append(control);
					});
					
					$("#issueDetailActivity").empty();
					$("#issueDetailActivityCount").text("Activity ("+data.logs.length+") ");
					$.each(data.logs, function(index, log){
						let control = "<li> "		
										+ "	<p style='padding-top: 3px;'>"
										+ "		<b> "+log.creatorName+"</b>"
										+ "		<span> "+log.log+"</span>"
										+ "		<span class='text-muted ml-4'> "+log.logTime+"</span>"
										+ "	</p>"
										+ "</li>";
						
						$("#issueDetailActivity").append(control);
					});
					
					$("#issueDetailComment").empty();
					$("#issueDetailCommentCount").text(data.replies.length);
					$.each(data.replies, function(index, element){

                        let error = "onerror='this.src=\"resources/images/login/profile.png\"'";
                     
						let control = '<div class="d-flex flex-row comment-row m-0 mb-1" id="'+element.issueRlyIdx+'Reply">'
										+ '	<div class="p-2">'
										+ '<img class="rounded-circle" width="40" src="upload/member/'+element.profilepic+'" alt="user" onerror="this.src=\'resources/images/login/profile.png\'">'
										+ '	</div>'
										+ '	 <div class="comment-text w-100">'
										+ '		<h6 class="font-medium mb-2 mt-2">'+element.creatorName
										+ '		<span class="text-muted float-right">'+element.createDate+'</span></h6>'
										+ '		<div class="mb-1" id="'+element.issueRlyIdx+'recontent">'+element.content+'</div>'
										+ '		<textarea class="hidden inputBox editable" id="'+element.issueRlyIdx+'editContent" onKeypress="javascript:if(event.keyCode==64 || event.keyCode==50) {mentionSearch()}"></textarea>';
						if(element.creator == loginUser){
							control += '		<div class="comment-footer float-right">'
										+ '		<button type="button" class="btn btn-info btn-sm" id="'+element.issueRlyIdx+'reEditBtn" onclick="editReply('+element.issueRlyIdx+', '+element.issueIdx+')">Edit</button>'
										+ '		<button type="button" class="btn btn-secondary btn-sm" id="'+element.issueRlyIdx+'reDeleteBtn" onclick="deleteReply('+element.issueRlyIdx+')">Delete</button>'
										+ '		<button type="button" class="btn btn-info btn-sm hidden" id="'+element.issueRlyIdx+'editChangeBtn">SaveChange</button>'
										+ '		<button type="button" class="btn btn-secondary btn-sm hidden replyCcBtn" id="'+element.issueRlyIdx+'editCancelBtn">Cancel</button>'
										+ '		</div>';
						}
						
						control += '	</div></div>';
						
						$("#issueDetailComment").prepend(control);
					});

					if(data.assigned == "" || data.assigned == null){
						data.assigned = "none";
					}
					
					$("#issueDetailAssignees").text(data.name);
					
					if(data.labelIdx > 0){
						$("#issueDetailLabel").text(data.labelName);
						$("#issueDetailLabel").css("background-color", data.labelColor);
						$("#issueDetailLabel").css("color", getTextColorFromBg(data.labelColor));
					}
					else
						$("#issueDetailLabel").text("none");
					
					$("#issueDetailPriority").removeClass();
					$("#issueDetailPriority").text("");
					if(data.priorityCode != null){
						$("#issueDetailPriority").addClass("priorityBadge "+data.priorityCode.toLowerCase());
					} else{
						$("#issueDetailPriority").text("none");
					}
					if(data.dueDate != null)
						$("#issueDetailDueDate").text(data.dueDate);
					else
						$("#issueDetailDueDate").text("none");
					if(data.issueProgress == 'CLOSED')
						$("#issueClosedChk").text('Reopen issue');
					else 
						$("#issueClosedChk").text('Close issue');
		},
		error : function(){
			console.log("GetIssueDetail error");
		}
	})

	changeKanbanView("detail");
}


function closeIssue(issueIdx,flag) {
	 console.log("in closeIssue");
	   $.ajax({
           url:"CloseIssue.do",
           method:"POST",
           data:{issueIdx : issueIdx},
           success:function(data){
        	if(flag == "inDetail"){
        	setKanbanDetail(issueIdx);
        	setChageView("kanban");
        	} 
           }, error : function(){
        	   console.log("close issue error");
           }
        });  		
}


function reOpenIssue(issueIdx,target) {
	$.ajax({
		url:"ReopenIssue.do",
		method:"POST",
		data : {issueIdx : issueIdx},
		success:function(data) {
			if(target == 'inDetail'){
        	setKanbanDetail(issueIdx);
        	setChageView("kanban");
			} 
		},error :function() {
			
			console.log("ReopenIssue error");
		}
		
	})

}


function changeKanbanView(view){

	if(view == "list"){
	  $("#kanbanDetailBox").addClass("hidden");
	  $("#kanbanMainBox").removeClass("hidden");
	  /* 추가 서치박스 히든 */
	   $('#searchBox').addClass('hidden');
	   $('#searchReturnBtn').addClass('hidden');
	   $('#kanbanIn').removeClass('hidden');
	   $('#-1Column').removeClass('hidden');
	   $('#-99Column').removeClass('hidden');
	   $('#openIssueBtn').removeClass('hidden');
	   $('#closeIssueBtn').removeClass('hidden');	
	   $('#addIssuebtn').removeClass('hidden'); 
	   $('#addLabelBtn').removeClass('hidden'); 
	   $('#addColumnBtn').removeClass('hidden');
	   $('#confirmIssueBtn').removeClass('hidden'); 
	   $('#kanbanTableView').removeClass('hidden'); 
	   $('#kanbanIconView').removeClass('hidden'); 
	   /* 추가 데이터 테이블 히든 */
	   $('#kanbanTableViewBox').addClass('hidden');
	   $("#kanbanTableView").removeClass("active");
	   $("#kanbanTableView").attr("disabled", false);
	   $("#kanbanIconView").addClass("active");
	}else if(view == "detail"){
	   $("#kanbanMainBox").addClass("hidden");
	   $("#kanbanDetailBox").removeClass("hidden");
	}else if (view == "edit"){
	   $("#kanbanMainBox").addClass("hidden");
	   $("#kanbanDetailBox").addClass("hidden");	
	 }else if (view == "search") {
	   $('#searchBox').removeClass('hidden');
	   $('#searchReturnBtn').removeClass('hidden');		
	   $('#kanbanIn').addClass('hidden');
	   $('#openIssueBtn').addClass('hidden');
	   $('#closeIssueBtn').addClass('hidden');
	   $('#-1Column').addClass('hidden');
	   $('#-99Column').addClass('hidden');
	   $('#addIssuebtn').addClass('hidden'); 
	   $('#addLabelBtn').addClass('hidden'); 
	   $('#addColumnBtn').addClass('hidden'); 
	   $('#confirmIssueBtn').addClass('hidden'); 
	   $('#kanbanTableView').addClass('hidden'); 
	   $('#kanbanIconView').addClass('hidden');
	   $('#kanbanTableViewBox').addClass('hidden'); 
	 }else if (view == "returnlist") {
	   $('#searchBox').addClass('hidden');
	   $('#searchReturnBtn').addClass('hidden');
	   $('#kanbanIn').removeClass('hidden');
	   $('#-1Column').removeClass('hidden');
	   $('#-99Column').removeClass('hidden');
	   $('#openIssueBtn').removeClass('hidden');
	   $('#closeIssueBtn').removeClass('hidden');	
	   $('#addIssuebtn').removeClass('hidden'); 
	   $('#addLabelBtn').removeClass('hidden'); 
	   $('#addColumnBtn').removeClass('hidden');
	   $('#confirmIssueBtn').removeClass('hidden'); 
	   $('#kanbanTableView').removeClass('hidden'); 
	   $('#kanbanIconView').removeClass('hidden'); 
	 } else if(view == "changeView"){
			 if(kanbanViewType == "kanbanTableView"){
				 $('#kanbanTableViewBox').removeClass('hidden');
				   $('#kanbanIn').addClass('hidden');
				   $('#-1Column').addClass('hidden');
				   $('#-99Column').addClass('hidden');
				   $('#openIssueBtn').addClass('hidden');
				   $('#closeIssueBtn').addClass('hidden');	
				   $('#addColumnBtn').addClass('hidden');
				   $('#confirmIssueBtn').addClass('hidden'); 
			 }else{
			 	   $('#kanbanTableViewBox').addClass('hidden');
				   $('#kanbanIn').removeClass('hidden');
				   $('#-1Column').removeClass('hidden');
				   $('#-99Column').removeClass('hidden');
				   $('#openIssueBtn').removeClass('hidden');
				   $('#closeIssueBtn').removeClass('hidden');	
				   $('#addIssuebtn').removeClass('hidden'); 
				   $('#addLabelBtn').removeClass('hidden'); 
				   $('#addColumnBtn').removeClass('hidden');
				   $('#confirmIssueBtn').removeClass('hidden'); 
			 }
	 }
}


function editLabel(idx, color, name) {
	
	$('.labelList').find('.edit').removeClass("hidden");

	editIdx = idx;
	$('#addLabelBtn').addClass("hidden");
	$('#editLabelBtn').removeClass("hidden");
	$('#backBtn').removeClass("hidden");
	
	$('#labelcolor').val(color);
	$('#labelname').val(name);
	$('#colorform').find('.asColorPicker-trigger').find('span').css('background-color', color);

	$('#'+idx+'Label').find('.edit').addClass("hidden");
	};
	
	
	function deleteReply(replyIdx) {
		   $.ajax ({
		      url : "DeleteReply.do",
		      method : "POST",
		      data : {'issuerlyidx' : replyIdx},
		      success: function(data) {
		    	  let count = Number($("#issueDetailCommentCount").text());
		    	  $("#issueDetailCommentCount").text(--count);
		          $("#"+replyIdx+"Reply").remove();
		      }, 
		      error : function() {
		         console.log("deleteReply error"); 
		         }
		      })
		   }	
	
	
	function editReply(issueRlyIdx, issueIdx){
		
		$('#'+issueRlyIdx+'recontent').hide(); // 본 댓글
		$('#'+issueRlyIdx+'editContent').removeClass('hidden');// 변경댓글
		$('#'+issueRlyIdx+'reEditBtn').addClass("hidden"); // EDIT 버튼
		$('#'+issueRlyIdx+'reDeleteBtn').addClass("hidden"); // Delete 버튼
		$('#'+issueRlyIdx+'editChangeBtn').removeClass('hidden'); // saveChange
																	// 버튼
		$('#'+issueRlyIdx+'editCancelBtn').removeClass('hidden'); // cancel 버튼
		
		let recontent= $('#'+issueRlyIdx+'recontent').text();
		
		$('#'+issueRlyIdx+'editContent').val(recontent);
		
		$('#'+issueRlyIdx+'editChangeBtn').click ( function() {
			
			let changecontent = $('#'+issueRlyIdx+'editContent').val();

			$.ajax({
				url : "EditReply.do",
			    method : "POST",
			    data : {'issueRlyIdx' : issueRlyIdx, 'content' : changecontent},
			    success : function(data) {
			    	setKanbanDetail(issueIdx);
			    	
			    }, error : function() {
			    	console.log('editReply in');
			    }
			})
		})
		
			$('.replyCcBtn').click(function() {
					setKanbanDetail(issueIdx);
			});

	}



	function getLabelList(flagelement) {
			
		  $.ajax({
				url : 'GetLabelList.do',
				data : {'projectIdx' : currentProjectIdx},
				success : function(data) {
					$('#labelList').empty();
					$('#labelIdx').empty();
					$('#labelIdxEdit').empty();
					if(flagelement == "ShowLabelList") {
						let lablist = ""; // Make 라벨 부분에서 라벨 목록 보여줄 것
				
						$.each(data,function(index, obj) {
					
							lablist +=  '<div class="row labelList" id="'+obj.labelIdx+'Label">';
							lablist +=  '<div class="col-lg-8">';
							lablist +=  '<span class="badgeIcon" style="background-color: '+obj.labelColor+';color:'+ getTextColorFromBg(obj.labelColor) +'">'+obj.labelName+'</span>';
							lablist +=  '</div>';
							lablist +=  '<div class="col-lg-2">';
							lablist +=  '<button class="btn-link link-gray edit" onclick="editLabel(' + obj.labelIdx +','+"'"+obj.labelColor+"'"+','+"'"+obj.labelName+"'"+')";>Edit</button>';
							lablist +=  '</div>';
							lablist +=  '<div class="col-lg-2">';
							lablist +=  '<button class="btn-link link-gray delete" onclick="deleteLabel(' + obj.labelIdx +')";>Delete</button>';
							lablist +=  '</div></div><hr>';
					});

							$('#labelList').append(lablist);
						
					}else if(flagelement == "SearchLabelList") {  
				
						var labellist = '<datalist id="LabelMenu">';
				
						$.each(data,function(index, obj) {
							labellist += '<option value="'+obj.labelName+'" data-id="'+obj.labelIdx+'"></option>';	
						});		 	
						
						labellist += '</datalist>';
						
						$('#searchContent').append(labellist);
						
					}else if(flagelement == "editDetail"){
						let llist = '<option value="">select</option>'; 
		                $.each(data, function(index, element) {
		                 	 llist += '<option value="'+element.labelIdx+'"style="background-color:'+element.labelColor+';color:'+ getTextColorFromBg(element.labelColor) +'">'+element.labelName+'</option>'
		                 });
							$('#labelIdxEdit').append(llist);
					}
			},error : function() {
					console.log("Showlabel error");
					
			}
		  });
		}
	
	function editTitleViewBtn(){
		$("#issueDetailTitleEdit").val($("#issueDetailTitle").text());
		if($("#editTitleBox").hasClass("hidden")){
			$("#issueDetailTitle").addClass("hidden");
			$("#editTitleBox").removeClass("hidden");
		} else {
			$("#editTitleBox").addClass("hidden");
			$("#issueDetailTitle").removeClass("hidden");
		}
	}
	
	function editContentViewBtn(){
		$("#isContentEdit").summernote('code', $("#issueDetailContent").html());
		if($("#editContentBox").hasClass("hidden")){
			$("#issueDetailContent").addClass("hidden");
			$("#editContentBox").removeClass("hidden");
		} else {
			$("#editContentBox").addClass("hidden");
			$("#issueDetailContent").removeClass("hidden");
		}
	}

	function editIssueTitleOk() {
		$.ajax({
			url : "UpdateIssueTitle.do",
		    method : "POST",
		    data : {issueIdx : $("#issueIdxNum").val(), issueTitle : $("#issueDetailTitleEdit").val()},
		    success : function(data){
		    	setKanbanDetail($("#issueIdxNum").val());
		    	setChageView("kanban");
		    	$("#editTitleBox").addClass("hidden");
				$("#issueDetailTitle").removeClass("hidden");
		    }, error : function() {
		    	console.log('edit issue title in');
		    }
		});
	}
	
	function editIssueContentOk() {
		
		$.ajax({
			url : "UpdateIssueContent.do",
			method : "POST",
		    data : {issueIdx : $("#issueIdxNum").val(), content :$('#isContentEdit').summernote('code')},
		    success : function(data){
		    	setKanbanDetail($("#issueIdxNum").val());
		    	setChageView("kanban");
		    	$("#editContentBox").addClass("hidden");
				$("#issueDetailContent").removeClass("hidden");
		    }, error : function() {
		    	console.log('edit issue contnet in');
		    }
		});
	}


	function getProjectMemberList(flagelement) {
		
		$.ajax({
			url : "GetProjectMemberList.do",
			data : {'projectIdx' : currentProjectIdx},
			success : function(data) {
				
				$('#assignedEdit').empty();
				
				if(flagelement == 'searchMember'){
					
					var memberlist = '<datalist id="MemberMenu">';

					$.each(data, function(index, obj) {
						memberlist += '<option value="'+obj.name+'" data-id="'+obj.email+'">('+obj.email+')</option>';	
					});		 	
					
					memberlist += '</datalist>';
						
				$('#searchContent').append(memberlist);
				
				} else if(flagelement == 'editDetail') { 

					let optmember;
					$('#assignedEdit').append(selectoption);
		             $.each(data, function(index, element) {
					  optmember += '<option value="'+element.email+'">'+element.name+'('+element.email+')</option>';
		               });
		               
		          $('#assignedEdit').append(optmember);

				
				}else if(flagelement == 'mentionSearch'){
					
					$.each(data, function(index, obj){
						
						words.push(obj.name);
						wordsemail.push(obj.email);
					});
				}
			}, error : function() {

			}
			
		})
	}
	
	function editIssuePriorityOk() {
		$.ajax({
			url : "UpdateIssuePriority.do",
		    method : "POST",
		    data : {issueIdx : $("#issueIdxNum").val(), priorityCode : $('#priorityCodeEdit').val()},
		    success : function(data){
		    	setKanbanDetail($("#issueIdxNum").val());
		    	setChageView("kanban");
		    	$("#editPriorityBox").addClass("hidden");
				$("#issueDetailPriority").removeClass("hidden");
		    }, error : function() {
		    	console.log('edit issue contnet in');
		    }
		});
	}
	
	function editIssueDueDateOk() {
		$.ajax({
			url : "UpdateIssueDuedate.do",
		    method : "POST",
		    data : {issueIdx : $("#issueIdxNum").val(), 'dueDate' :$('#datepicker-editIssue').val()},
		    success : function(data){
		    	setKanbanDetail($("#issueIdxNum").val());
		    	setChageView("kanban");
		    	$("#editDuedateBox").addClass("hidden");
				$("#issueDetailDueDate").removeClass("hidden");
		    }, error : function() {
		    	console.log('edit issue duedate in');
		    	console.error();
		    }
		});
	}
	
	function editIssueAssignedOk() {
		$.ajax({
			url : "UpdateIssueAssgined.do",
		    method : "POST",
		    data : {issueIdx : $("#issueIdxNum").val(), 'assigned' : $('#assignedEdit').val()},
		    success : function(data){
		    	setKanbanDetail($("#issueIdxNum").val());
		    	setChageView("kanban");
		    	$("#editAssignedBox").addClass("hidden");
				$("#issueDetailAssignees").removeClass("hidden");
		    }, error : function() {
		    	console.log('edit issue duedate in');
		    }
		});
		
	}
	
	function editIssueLabelOk() {
		$.ajax({
			url : "UpdateIssueLabel.do",
		    method : "POST",
		    data : {issueIdx : $("#issueIdxNum").val(), 'labelIdx' : $('#labelIdxEdit').val()},
		    success : function(data){
		    	setKanbanDetail($("#issueIdxNum").val());
		    	setChageView("kanban");
		    	$("#editLabelBox").addClass("hidden");
				$("#issueDetailLabel").removeClass("hidden");
		    }, error : function() {
		    	console.log('edit issue label in');
		    }
		});
		
	}
	
function assignListEditview(){
	getProjectMemberList("editDetail");	
}
	
function labelListview(){
	getLabelList("editDetail");
}
	
function deleteIssueFile(fileIdx){
	
	$.ajax({
			url : "DeleteIssueFile.do",
			type : "POST",
			data : {fileIdx : fileIdx},
			success : function(data){
				if(data){
					setKanbanDetail($("#issueIdxNum").val());
					$(".editIssueFileBtn").removeClass("hidden");
				} else
					warningAlert("삭제 실패!");
			},
			error : function(){
				warningAlert("삭제 실패!");
			}
		})
		
	}

function editIssueFileView() {
	if($(".editIssueFileBtn").hasClass("hidden"))
		$(".editIssueFileBtn").removeClass("hidden");
	else 
	 $(".editIssueFileBtn").addClass("hidden");
}
	
function issueDetailFileEdit() {
		
	let formData = new FormData();
		
	formData.append("projectIdx",currentProjectIdx);
	formData.append("issueIdx",$("#issueIdxNum").val());
	   $("#multipartFilesIssueEdit").empty();
	    
	    $.each($("#multipartFilesIssueEdit")[0].files, function(i, file) {
	    	formData.append('multipartFiles', file);
	    });
	    $.ajax({
			url : 'IssueFileEdit.do',
	        type: "POST",
			enctype :'multipart/form-data',
			data : formData,
	        processData: false,
	        contentType: false,
	        cache: false,
	        success: function (data) {
		        	if(data){
		        		setKanbanDetail($("#issueIdxNum").val());
		        		 $(".editIssueFileBtn").removeClass("hidden");
	        	}else{
	        		errorAlert("사진 추가 실패");
	        	}
	        },
	        error: function (e) {
	        	errorAlert("Issue 추가 실패");
	        }
	    });
}

function getissueinfo(flagelement) {

	if(flagelement == "issueModalOpen") {
			
		 $.ajax({
		 	type: "POST",
	        url: "GetAddIssueForm.do",
	        data: { projectIdx: currentProjectIdx },
	        success: function (data) {
	           $('#assigned').empty();
	           $('#labelIdx').empty();

				let member = data.member;
				let label = data.label;
					
				let optlabel;
				let optmember;

				$('#assigned').append(selectoption);
	            $('#labelIdx').append(selectoption);

	             $.each(member, function(index, element) {
	            	   
	            	 if(element.authority == 'ROLE_PM') {
	            		
	            		 let appendCtn = '<input type="hidden" id="pmemail" value="'+element.email+'">';
	            		   $('#addIssueModal').append(appendCtn);
	            	   }
	            	  
						optmember += '<option value="'+element.email+'">'+element.name+'('+element.email+')</option>';
	               });
	               
	               $('#assigned').append(optmember);

	               $.each(label, function(index, element) {
	                 	 optlabel += '<option value="'+element.labelIdx+'"style="background-color:'+element.labelColor+'">'+element.labelName+'</option>'
	                 });
	                
	                $('#labelIdx').append(optlabel);	
	            },
	            error: function () {
	                console.log("GetProjectMember error");
	            }
			})
		
		}
	}
	
var arrSelectedUserEmail =[];

function mentionSearch() {
		 getProjectMemberList("mentionSearch");
		 
    	// 멘션
	  $('.editable').textcomplete([{
		  
		    match:  /\B@(\w*)$/,
		    search: function (term, callback) {
		      callback($.map(words, function (word) {
		        return word.indexOf(term) === 0 ? word : null;
		      }));
		    },
		    index: 1,
		    replace: function (word) {
		      return '@' + word + ' ';
		    }
		  }]).on({
			  'textComplete:select': function (e, value) {	
				  arrSelectedUserEmail.push(wordsemail[words.indexOf(value)]);  
			  }
		  }) ;
	}
	

	function kanbanDetailBackBtn() {
	      if($("#issueDetailTitle").hasClass("hidden")){
	      $("#editTitleBox").addClass("hidden");
	      $("#issueDetailTitle").removeClass("hidden");
	      }
	      
	      if($("#issueDetailContent").hasClass("hidden")){
	      $("#editContentBox").addClass("hidden");
	      $("#issueDetailContent").removeClass("hidden");
	      }
	      
	      if($("#issueDetailAssignees").hasClass("hidden")){
	      $("#editAssignedBox").addClass("hidden");
	      $("#issueDetailAssignees").removeClass("hidden");
	      }
	      
	      if($("#issueDetailLabel").hasClass("hidden")){
	      $("#editLabelBox").addClass("hidden");
	      $("#issueDetailLabel").removeClass("hidden");
	      }
	      
	      if($("#issueDetailDueDate").hasClass("hidden")){
	      $("#editDuedateBox").addClass("hidden");
	      $("#issueDetailDueDate").removeClass("hidden");
	      }
	      
	      if($("#issueDetailPriority").hasClass("hidden")) {
	      $("#editPriorityBox").addClass("hidden");
	      $("#issueDetailPriority").removeClass("hidden");
	      }
	      
	      if(!$(".editIssueFileBtn").hasClass("hidden")) {
	      $(".editIssueFileBtn").addClass("hidden");
	      }
	      changeKanbanView('list');
	   }
	
	function changeKanbanViewType(){
		$(".kanbanViewBtn").click(function(){
 			$(this).attr("disabled", true);
 			$(this).addClass("active");

 			kanbanViewType= $(this).attr("id");
 			if(kanbanViewType == "kanbanTableView"){
 				$("#kanbanIconView").removeClass("active");
 				$("#kanbanIconView").attr("disabled", false);
 				setKanbanTableView();
 			}
 			// icon View
 			else{
 				$("#kanbanTableView").removeClass("active");
 				$("#kanbanTableView").attr("disabled", false);
 				setKanbanData();
 			}
 			
 			changeKanbanView("changeView");
 		})
	}
	
	function setKanbanTable(){
		let table = $("#kanbanTable").DataTable({
			"pageLength": 10,
	         fixedColumns: true,
	         autoWidth: false,
	         "searching": false,
	         "lengthChange": false,
	         columnDefs: [ { targets: 4, render: function (data, type, row) {
	        	if(type === 'export'){
	        		let priority = $(data).attr("class");
	        		return priority==null?"":priority.replace("priorityBadge","").trim();
	        	}else
	        		return data;
        	}}]
		});

        new $.fn.dataTable.Buttons( table , {
            buttons: [
                { extend :'excel',
                	autoFilter : true,
                    sheetName : 'OWL',
	                className : 'btn hidden kanbanExportButton',
	                title: 'OWL - '+currentProjectName,
	                exportOptions : {
	                	orthogonal : 'export',
	                    columns : ':visible'
	                }
                },  
            ]
        });
        
        table.buttons().container().appendTo('#kanbanTableViewBox');

		 $.contextMenu({
	         selector: '#kanbanTable tbody tr',
	         build : function(trigger, e){
	        	 return {
	                 callback: function(key, options) {
	                     let issueIdx = trigger[0].id;
	                     if(key == "detail")
	                    	 setKanbanDetail(issueIdx);
	                     else if(key == "remove")
	                    	 deleteIssue(issueIdx);
	                     else if(key == "export")
	                    	 $(".kanbanExportButton:first").click();
	                 },
	                 items:{
	                     "detail": {name: "Detail", icon: "fas fa-info-circle"},
	                     "remove": {name: "Remove Issue", icon: "delete"},
	                     "sep1": "---------",
	                     "export": {name: "Export Excel", icon: "fas fa-file-excel"},
	            	 	}
	             };
	         },
	     });
	}
	
	function setKanbanTableView(){
		$('#kanbanTable').DataTable().clear();
		$.ajax({
			 url : 'GetColumn.do',
			 data : { projectIdx :  currentProjectIdx },
			 success : function(data) {
					$.ajax({
						url : "GetIssue.do",
						data : {'projectIdx' :  currentProjectIdx },
						success : function(data) {
							let colInfos = data;
							 $.each(data,function(index, element) {
								 $('#kanbanTable').DataTable().row.add( [
										++index,
										'<span class="badgeIcon" style="background-color: '+ element.labelColor+'; color: ' + getTextColorFromBg(element.labelColor) + '">' + element.labelName + '</span>',
										element.issueTitle,
										element.name,
										element.priorityCode == null? "-":'<span class="priorityBadge '+element.priorityCode.toLowerCase()+'"></span>',
										element.dueDate== null? "-":element.dueDate,
							        ]).node().id = element.issueIdx;
									
									$('#kanbanTable').DataTable().draw();
							});	
						},
						error: function() {
							console.log("setKanbanTableView error");
						}
					})
			 },
			 error : function(){
				 console.log("setKanbanTableView error")
			 }
		});
	}
	
    function setKanbanData() {
	    $("#-1Column > .columnBody").empty();
        $("#-99Column > .columnBody").empty();
    	$("#kanbanIn").empty();
    	
        $.ajax({
			 url : 'GetColumn.do',
			 data : {'projectIdx' :  currentProjectIdx },
			 success : function(data) {
				$.each(data,function(index,obj) {
					if(obj.colIdx != -1 && obj.colIdx != -99){
						addColumn(obj);
					}
				});
				$( ".sortableCol").sortable({
			        connectWith: ".connectedSortable",
			        dropOnEmpty: true,
			        update: function(event, ui) {
						let target = $(ui.item).attr("id").replace("Issue","");
						let columnIdx = $(this).parent().attr("id").replace("Column","");
						
						let issues = [];
						$.each($(this)[0].children, function(){
							issues.push($(this).attr("id").replace("Issue","").trim())
						})

						if(issues.length == 0)
							return;

						$.ajaxSettings.traditional = true; 
						$.ajax({
							type : "POST",
							url : "MoveIssue.do",
							data : { projectIdx :  currentProjectIdx
										, targetIssueIdx : target
										, columnIdx : columnIdx
										, issues : issues },
							success : function(data) {
								console.log("success move issue");
							},
							error: function() {
								console.log("error move issue");
							}
						})
				       }        
			     }).disableSelection();
				setIssueData();
			},
			 error : function() {
				console.log("getColum.do error");
			}
		}); 
    }
    
    function setIssueData(){
		$.ajax({
			url : "GetIssue.do",
			data : {'projectIdx' :  currentProjectIdx },
			success : function(data) {
				 $.each(data,function(index, obj) {
					 addKanbanIssue(obj.colIdx, obj); 
					 // 차트용
					 wholeProjectChart(currentProjectIdx); 
				});
			},
			error: function() {
				console.log("getIssue.do error");
			}
		})
	}