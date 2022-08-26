function initDashBoard(projectIdx){
	 $("#dashCalendar").tuiCalendar({
		  defaultView: 'month',
		  taskView: true
	}); 
	 
	 MyProjectProgress();
	 HorizonChart();
	 LineChart();
	 
	if(projectIdx > 0){
		initProjectDashBoard();		
		setProjectDashBoard();
	}
	else
		setMainDashBoard();
}

function setMainDashBoard(){
	$("#dashboardTable").DataTable({
		"pageLength": 5,
         fixedColumns: true,
         autoWidth: false,
         "ordering" : false,
         "searching": false,
         "lengthChange": false,
	});
	
	$.ajax({
		 url : "CheckJoinProject.do",
		 success : function(data){
			 console.log("in CheckJoinProject success");
			 if(data < 1){ // 참여중인 프로젝트가 없음
				 $("#myDashBoardBox").addClass("hidden");
				 $("#myDashBoardEmptyBox").removeClass("hidden");
				 return;
			 }
			 
			 $("#myDashBoardBox").removeClass("hidden");
			 $("#myDashBoardEmptyBox").addClass("hidden");
			 
			 // 데이터 셋팅
			 setMyIssueTask();
			 setTimeLine();
		 },
		 error : function(){
			 console.log("in CheckJoinProject error");
		 }
	 })
}


function initProjectDashBoard(){
	$("#dashboardPTable").DataTable({
		"pageLength": 5,
         fixedColumns: true,
         autoWidth: false,
         "ordering" : false,
         "searching": false,
         "lengthChange": false,
         "columnDefs": [ {
             "searchable": false,
             "orderable": false,
             "targets": 0
         } ],
	});
}

function setProjectDashBoard(){	
	wholeProjectChart(currentProjectIdx);
	setMyIssueTaskByProject(currentProjectIdx);
	setTimeLineByProject(currentProjectIdx, currentProjectColor);
	setProjectMemberProgress(currentProjectIdx);
}

function setMyIssueTask(){
	$.ajax({
		url : "GetMyIssueTask.do",
		success : function(data){
			if(data.length > 0){
				$("#dashBoardTableEmptyBox").addClass("hidden");
				$("#dashBoardTableBox").removeClass("hidden");
				
				$.each(data, function(index, element){
					$('#dashboardTable').DataTable().row.add([
						element.projectName,
						element.subject,
						element.dueDate!=null? getDueDateElement(element.dueDate):"-",
						element.priorityCode!=null? "<span class='priorityBadge "+element.priorityCode.toLowerCase()+"'></span>":"-"
					]).draw();
					// .node().id = element.driveFileIdx;
					// $('#dashboardTable').DataTable().draw();
				})
			}else{ // 할당된 이슈 없음
				$("#dashBoardTableEmptyBox").removeClass("hidden");
				$("#dashBoardTableBox").addClass("hidden");
			}
		},
		error : function(){
			console.log("in setMyIssueTask error");
		}
	})
}

function getDueDateElement(date){
	let result = "";
	let now = new Date();
	let dates = date.split("-"); 
	let target = new Date(dates[0], Number(dates[1])-1, dates[2]);  
	
	let betweenDay = Math.round((target-now)/(1000*60*60*24))+1;
	if(betweenDay < 0)
		result = "<span style='color:red; font-weight: bold;'>Past by "+Math.abs(betweenDay)+" days</span>";
	else if(betweenDay === 0)
		result = "<span style='background-color:yellow;font-weight: bold; padding-left: 20px;padding-right: 20px;'>Today</span>";
	else if(betweenDay === 1)
		result = "<span style='color:green; font-weight: bold;'>Tomorrow</span>";
	else
		result = date;
	
	return result;
}

function setTimeLine(){
	let today = getTimeLineDateFormat(new Date());
	$.ajax({
		url : "GetMyTimeLine.do",
		success : function(data){
			$("#timeLineDate").text("Today : "+today);
			$("#dashboardTimeLine ul:first").empty();

			$.each(data, function(key, value){
					let control = "<li><p class='float-right' style='margin-right: 15px;'>"+((key==today)?"Today":key)+"</p>";
					let group = value.reduce((r, a) => {
																 r[a.projectName] = [...r[a.projectName] || [], a];
																 return r;
															}, {});

					$.each(group, function(key2, value2){
						control += "<span style='background-color: "+value2[0].projectColor+"; color : "+getTextColorFromBg(value2[0].projectColor)+"'>"+key2+"</span>";

						$.each(value2, function(index, element){
							control += "<p>"+element.subject+"</p>";
						})
					})
					$("#dashboardTimeLine ul:first").append(control+"</li>");
			});
			
			if($("#dashboardTimeLine ul:first li").length == 0){ // 데이터 없음
				let lastWeek = new Date(); 
				lastWeek.setDate(lastWeek.getDate() + 7);
				getTimeLineDateFormat(lastWeek);
				$("#dashboardTimeLineEmptyBox h4:first").text("( "+today+" ~ "+getTimeLineDateFormat(lastWeek)+" )");
				$("#dashboardTimeLineEmptyBox").removeClass("hidden");
				$("#dashboardTimeLine").addClass("hidden");
			}else{
				$("#dashboardTimeLineEmptyBox").addClass("hidden");
				$("#dashboardTimeLine").removeClass("hidden");
			}
		},
		error : function(){
			console.log("in setTimeLine error");
		}
	})
}

function setTimeLineByProject(projectIdx, projectColor){
	let today = getTimeLineDateFormat(new Date());
	$.ajax({
		url : "GetMyTimeLineByProject.do",
		data : {projectIdx : projectIdx },
		success : function(data){
			$("#timeLinePDate").text("Today : "+today);
			$("#dashboardPTimeLine ul:first").empty();
			$.each(data, function(key, value){
					let control = "<li><p class='float-right' style='margin-right: 15px;'>"+((key==today)?"Today":key)+"</p>"
									+ "<span style='background-color: "+projectColor+"; color : "+getTextColorFromBg(projectColor)+"'>"+value[0].projectName+"</span>";

					$.each(value, function(index, element){
						control += "<p>"+element.subject+"</p>";
					})
				
					$("#dashboardPTimeLine ul:first").append(control+"</li>");
			});
			
			if($("#dashboardPTimeLine ul:first li").length == 0){ // 데이터 없음
				let lastWeek = new Date(); 
				lastWeek.setDate(lastWeek.getDate() + 7);
				getTimeLineDateFormat(lastWeek);
				$("#dashboardPTimeLineEmptyBox h4:first").text("( "+today+" ~ "+getTimeLineDateFormat(lastWeek)+" )");
				$("#dashboardPTimeLineEmptyBox").removeClass("hidden");
				$("#dashboardPTimeLine").addClass("hidden");
			}else{
				$("#dashboardPTimeLineEmptyBox").addClass("hidden");
				$("#dashboardPTimeLine").removeClass("hidden");
			}
		},
		error : function(){
			console.log("in setTimeLineByProject error");
		}
	})
}

function wholeProjectChart(projectIdx){
	$.ajax({
        url:"MyProgress.do",
        data: {projectIdx: projectIdx},
        success:function(data){
        	if(data.length > 0){
	    	  let idx = data[0].projectIdx;
		      let color = data[0].projectColor;
	    	  let totalCount=data.length;
	    	  let closeCount=0;
	    	  $("#chartMyProgress").empty();
	    	  $.each(data, function(index, element){
	    			if(element.issueProgress == "CLOSED") 
						closeCount++;
	    	  })
	    	 let makeChart = '<div id="canvas-holder"><canvas id="myProgress'+idx+'"></canvas></div>';
			$("#chartMyProgress").append(makeChart);
				MyChart(idx, totalCount, closeCount, color);	
        	}else{
				$("#MyProgressNone").removeClass("hidden");
				$("#chartMyProgress").addClass("hidden");
        	}	
       }
   }); 

	$.ajax({
        url:"Progress.do",
        data: {projectIdx: projectIdx},
        success:function(data){
        	if(data.length > 0){
	    	  let idx = data[0].projectIdx;
	    	  let totalCount=data.length;
	    	  let closeCount=0;
	    	  $("#chartProjectProgress").empty();
	    	  $.each(data, function(index, element){
	    			if(element.issueProgress == "CLOSED") 
						closeCount++;
	    	  })
	    	 let makeChart = '<div id="canvas-holder"><canvas id="projectProgress'+idx+'"></canvas></div>';
			$("#chartProjectProgress").append(makeChart);
				OurChart(idx, totalCount, closeCount);		
        	}else{
				$("#OurProgressNone").removeClass("hidden");
				$("#chartProjectProgress").addClass("hidden");	
        	}	
       }
   });

	$.ajax({
        url:"LabelChart.do",
        dataType: "json",
        data: {projectIdx: projectIdx},
        success:function(data){
		        let idx = projectIdx;
		        let label;
		        let totalCount = [];
		    	let closeCount = [];
	    	    let name = [];
	    	    let color = [];
	    	    $("#labelProgress").empty(); 
		     $.each(data, function(key, value){
		    	  label = key;
		    	  totalCount.push(value.length);
		    	  name.push(value[0].labelName);
		    	  color.push(value[0].labelColor);
		    	  let closed = 0;
		    	  $.each(value, function(index, element){
		    			if(element.issueProgress == "CLOSED") 
							closed++;
		    	  });
		    	  closeCount.push(closed);	    	
		     });
	    	 let makeChart = '<canvas id="label'+idx+'"></canvas>';
					$("#labelProgress").append(makeChart);
					ProjectLabelChart(idx, totalCount, closeCount, name, color);		
       }
   });	
}	

function MyChart(idx, totalSum, closeSum, color){  
	window.myDoughnut = new Chart(document.getElementById('myProgress'+idx).getContext('2d'), {
	        type: 'doughnut',
	        data: {
	            datasets: [{
	                data: [
	                	Math.round((totalSum - closeSum)/totalSum*100),
	                	Math.round((closeSum)/totalSum*100)               	
	                ],
	                backgroundColor: [
	                	"#d9d9d9",
	                	color                	
	                ],
	                label: 'Data'
	            }],
	            labels: [
	            	'Total',
					'Complete'    
	            ]
	        },
	        options: {
	            responsive: true,
	            legend: {
	                position: 'top',
	            },
	            title: {
	                display: true,
	                text: '나의 진행률'
	            },
	            animation: {
	                animateScale: true,
	                animateRotate: true
	            }
	        }
	    });	
	}	

function OurChart(idx, totalSum, closeSum){  
	window.myDoughnut = new Chart(document.getElementById('projectProgress'+idx).getContext('2d'), {
	        type: 'doughnut',
	        data: {
	            datasets: [{
	                data: [
	                	Math.round((totalSum - closeSum)/totalSum*100),
	                	Math.round((closeSum)/totalSum*100)               	
	                ],
	                backgroundColor: [
	                	"#d9d9d9",
	                	"#326295"                	
	                ],
	                label: 'Data'
	            }],
	            labels: [
	            	'Total',
					'Complete'    
	            ]
	        },
	        options: {
	            responsive: true,
	            legend: {
	                position: 'top',
	            },
	            title: {
	                display: true,
	                text: '프로젝트 진행률'
	            },
	            animation: {
	                animateScale: true,
	                animateRotate: true
	            }
	        }
	    });	
	}

function ProjectLabelChart(idx, totalCount, closeCount, name, color){
	window.myBar = new Chart(document.getElementById('label'+idx).getContext('2d'), {
		type: 'bar',
		data: {
			labels: name,
			datasets: [{
				label: 'Complete',
				backgroundColor: color,
				minBarLength: 2,
				yAxisID: 'y-axis-2',
				data: closeCount
			}, {
				label: 'Total',
				backgroundColor: window.chartColors.grey,
				minBarLength: 2,
				yAxisID: 'y-axis-2',
				data: totalCount
			}]

		},
		options: {
			responsive: true,
			scaleBeginAtZero : true,
			title: {
				display: true,
				text: '라벨 별 업무 진행도'
			},
			tooltips: {
				mode: 'index',
				intersect: true
			},
			scales: {
				yAxes: [{
					type: 'linear', // only linear but allow scale type
									// registration. This allows extensions to
									// exist solely for log scale for instance
					display: true,
					position: 'right',
					id: 'y-axis-2',
					gridLines: {
						drawOnChartArea: false
					},
				ticks: {
                    beginAtZero:true,  // Y축의 값이 0부터 시작,
                    callback: function (value) {
                        if (0 === value % 1) {
                            return value;
                        }
                    }
                }
				}],
			}
		}
	});	
}	

function getTimeLineDateFormat(date){
	let week = new Array('일', '월', '화', '수', '목', '금', '토'); 
	let year = date.getFullYear(); 
	let month = (date.getMonth() + 1) < 10? "0"+(date.getMonth() + 1):(date.getMonth() + 1); 
	let day = (date.getDate()) < 10? "0"+(date.getDate() ):(date.getDate()); 
	let dayName = week[date.getDay()];
	
	return year+"-"+month+"-"+day+" ("+dayName+")";
}

function setMyIssueTaskByProject(projectIdx){
	$('#dashboardPTable').DataTable().clear();
	$.ajax({
		url : "getMyIssueTaskByProject.do",
		data : {projectIdx : projectIdx},
		success : function(data){
			if(data.length > 0){
				$("#dashBoardPTableEmptyBox").addClass("hidden");
				$("#dashBoardPTableBox").removeClass("hidden");
				
				$.each(data, function(index, element){
					$('#dashboardPTable').DataTable().row.add([
						++index,
						element.subject,
						element.dueDate!=null? getDueDateElement(element.dueDate):"-",
						element.priorityCode!=null? "<span class='priorityBadge "+element.priorityCode.toLowerCase()+"'></span>":"-"
					]).draw();
					// .node().id = element.driveFileIdx;
					// $('#dashboardTable').DataTable().draw();
				})
			}else{ // 할당된 이슈 없음
				$("#dashBoardPTableEmptyBox").removeClass("hidden");
				$("#dashBoardPTableBox").addClass("hidden");
			}
		},
		error : function(){
			console.log("in setMyIssueTaskByProject error");
		}
	})
}

function setProjectMemberProgress(projectIdx){
	$.ajax({
		url : "GetProjectMemberProgress.do",
		data : {projectIdx : projectIdx },
		success : function(data){
			let labels = [];
			let totals = [];
			let closes = [];
			$.each(data.member, function(index, element){
				labels.push(element.memberName);
				totals.push(0);
				closes.push(0);
			})

			$.each(data.progress, function(index, element){
				let labelIndex = labels.indexOf(element.assignedName);
				closes[labelIndex] = element.closedCount;
				totals[labelIndex] = element.openCount + element.closedCount;
			})

			window.myMixedChart = new Chart(document.getElementById('dashBoardMemberProgress').getContext('2d'), {
				type: 'bar',
				data: {
					labels: labels,
					datasets: [{
						type: 'line',
						label: 'Complate',
						borderColor: "#326295",
						borderWidth: 2,
						fill: false,
						data: closes
					}, {
						type: 'bar',
						label: 'Total',
						backgroundColor: "rgb(165,197,232,.3)",
						data: totals,
						borderColor: '#a5c5e8',
						borderWidth: 2
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					scaleBeginAtZero : true,
					tooltips: {
						mode: 'index',
						intersect: true
					},scales: {
				        yAxes: [{
				            ticks: {
				                beginAtZero: true
				            }
				        }]
				    }
				}
			});
		},
		error : function(){
			console.log("in setProjectMemberProgress error");
		}
	})
}

function MyHorizonChart(theData, name, color){  
	var chart = new Chart(document.getElementById('myHorizon').getContext('2d'), {
	    // The type of chart we want to create
	    type: 'horizontalBar',
	    // The data for our dataset
	    data: {
	        labels: name,
	        datasets: [{
	            label: '내가 속한 프로젝트 전체 진행률(%)',
	            data: theData,
	            backgroundColor: color,
	            borderColor: color,
	            borderWidth: 1
	        }]
	    },	
	    // Configuration options go here
	    options: {
	        scales: {
	            xAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    max: 100,
	                }
	            }]
	        }
	    }
	});
}

function ProjectMyChart(idx, totalSum, closeSum, projectName, color){  
    window.myDoughnut = new Chart(document.getElementById('chartProject'+idx).getContext('2d'), {
        type: 'doughnut',
        data: {
            datasets: [{
                data: [
                	Math.round((totalSum - closeSum)/totalSum*100),
                	Math.round((closeSum)/totalSum*100)               	
                ],
                backgroundColor: [
                	"#d9d9d9",
                	color                	
                ],
                label: projectName
            }],
            labels: [
            	'Open : ' + totalSum,
                'Close : ' + closeSum                
            ]
        },
        options: {
            responsive: true,
            legend: {
                position: 'top',
            },
            title: {
                display: true,
                text: projectName
            },
            animation: {
                animateScale: true,
                animateRotate: true
            },
            tooltips: {
				mode: 'index',
				intersect: false,
				callbacks: {
					label: function(tooltipItem, data) {
				          return data['datasets'][0]['data'][tooltipItem['index']] + '%';
				        },
				}
			}
        }
    });	
}

var LineData = [];

function MakeDataSet() {
    this.label = null;
    this.borderColor = null;
    this.backgroundColor = null;
    this.fill = false;
    this.data = [];
    this.yAxisID = 'y-axis-1';
}
function MyProjectProgress(){
	$.ajax({
        url:"MyProjectProgress.do",
        dataType: "json",
        success:function(data){	   
        $("#myProgressChart").empty();   
	     $.each(data, function(key, value){
	    	  let idx = key;
		      let name = value[0].projectName;
		      let color = value[0].projectColor;
	    	  let totalCount=value.length;
	    	  let closeCount=0;
	    	  $.each(value, function(index, element){
	    			if(element.issueProgress == "CLOSED") 
						closeCount++;
	    	  }) 
	    	 let makeChart = '<div class="col-md-4"><div id="canvas-holder">'
				  +'<canvas id="chartProject'+idx+'"></canvas></div></div>';
			$("#myProgressChart").append(makeChart);
			ProjectMyChart(idx, totalCount, closeCount, name, color);		    	
	     });
	     
       }
   }); 
}

function HorizonChart(){
	$.ajax({
        url:"HorizonChart.do",
        dataType: "json",
        success:function(data){		     
			let name = [];
			let theData = [];
			let color = [];	        
	     $.each(data, function(key, value){
		      name.push(value[0].projectName);
		      color.push(value[0].projectColor);
	    	  let totalCount=value.length;
	    	  let closeCount=0;
	    	  $.each(value, function(index, element){
	    			if(element.issueProgress == "CLOSED") 
						closeCount++;
	    	  });
	    	  theData.push(Math.round((closeCount/totalCount)*100));				    	
	     });
	    	 MyHorizonChart(theData, name, color);	
       }
   });
}

function LineChart(){
	let week = new Array('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'); 
	let dayCount = [0, 0, 0, 0, 0, 0, 0];
	let dayName = week[new Date().getDay()];
	$.ajax({
		url : "LineChart.do",
		success : function(data){ 			
			let group;
			$.each(data, function(key, value) {
					group = value.reduce((r, a) => {
																 r[a.logTime] = [...r[a.logTime] || [], a];
																 return r;
															}, {});

					let theData;			
				    theData = new MakeDataSet();
					theData.label = value[0].projectName;
					theData.borderColor = value[0].projectColor;
					theData.backgroundColor = value[0].projectColor;
					theData.fill = false;   							
					theData.yAxisID = 'y-axis-1';
					
					dayCount = [0, 0, 0, 0, 0, 0, 0];		
					$.each(group, function(key2, value2){   
    					console.log(value2.length);
    					dayCount[new Date(key2).getDay()] = value2.length;			  					
					}) 
					theData.data=dayCount;	
					LineData.push(theData);
			});
			
			MyLineChart();
		},
		error : function(){
			console.log("in setTimeLine error");
		}
	});
}
function MyLineChart(){
    window.myLine = Chart.Line(document.getElementById('myLine').getContext('2d'), {
        data: {
            labels: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
            datasets: LineData,
        },
        options: {
            responsive: true,
            hoverMode: 'index',
            stacked: false,
            title: {
                display: true,
                text: '나의 프로젝트 활동 빈도(일주일 단위)'
            },
            scales: {
                yAxes: [{
                    type: 'linear', // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
                    display: true,
                    position: 'left',
                    id: 'y-axis-1',
                    // grid line settings
                    gridLines: {
                        drawOnChartArea: false, // only want the grid lines for one axis to show up
                    },	
                    ticks: {
	                    beginAtZero: true,
	                },
                }],
            }
        }
    });        
}