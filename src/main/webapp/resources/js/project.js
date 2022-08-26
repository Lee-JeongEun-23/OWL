let currentProjectIdx;
let currentProjectName;
let currentProjectColor;
let currentProjectStartDate;
let currentProjectEndDate;
let loginUser;
let loginUserName;

function initProjcet(email,name, projectIdx, projectName, projectColor,projectStartDate, projectEndDate){
	loginUser = email;
	loginUserName = name;
	currentProjectIdx  = projectIdx;
	currentProjectName = projectName;
	currentProjectColor = projectColor;
	currentProjectStartDate = projectStartDate;
	currentProjectEndDate = projectEndDate;
	
	initNotice();
	initKanban(projectIdx);
    initDashBoard(currentProjectIdx);
    initDrive();
    initCalendar(projectIdx, projectColor, projectStartDate, projectEndDate);
}