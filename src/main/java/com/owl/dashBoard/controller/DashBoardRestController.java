package com.owl.dashBoard.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.owl.dashBoard.dto.IssueTask;
import com.owl.dashBoard.dto.LineChart;
import com.owl.dashBoard.dto.ProjectMemberProgress;
import com.owl.dashBoard.dto.ProjectProgress;
import com.owl.dashBoard.dto.TimeLine;
import com.owl.dashBoard.service.DashBoardService;
import com.owl.helper.MemberHelper;

@RestController
public class DashBoardRestController {
	
	@Autowired
	private DashBoardService service;
	
	/**
	 * MyDashBoard - 해당 멤버가 참여중인 프로젝트가 존재하는지 체크 요청
	 * @author 윤다정
	 * @since 2020/01/31
	 * @param principal
	 * @return int
	 */
	@RequestMapping("CheckJoinProject.do")
	public int checkJoinProject(Principal principal, HttpServletRequest request) {
		return service.checkJoinProject(MemberHelper.getMemberEmail(principal, request.getSession()));
	}
	
	/**
	 * Issue Task 테이블 데이터 요청
	 * @author 윤다정
	 * @since 2020/01/31
	 * @param principal
	 * @return List<IssueTask>
	 */
	@RequestMapping("GetMyIssueTask.do")
	public List<IssueTask> getMyIssueTasks(Principal principal, HttpServletRequest request) {
		return service.getMyIssueTasks(MemberHelper.getMemberEmail(principal, request.getSession()));
	}
	
	/**
	 * Issue Task 테이블 데이터 요청 (프로젝트  본인)
	 * @author 윤다정
	 * @since 2020/02/01
	 * @param projectIdx
	 * @param principal
	 * @return List<IssueTask>
	 */
	@RequestMapping("getMyIssueTaskByProject.do")
	public List<IssueTask> getMyIssueTasksByProject(int projectIdx, Principal principal, HttpServletRequest request) {
		return service.getMyIssueTasksByProject(projectIdx, MemberHelper.getMemberEmail(principal, request.getSession()));
	}
	
	/**
	 * Issue Task 테이블 데이터 요청 (프로젝트 전체)
	 * @author 윤다정
	 * @since 2020/02/01
	 * @param projectIdx
	 * @param principal
	 * @return List<IssueTask>
	 */
	@RequestMapping("getProjectIssueTask.do")
	public List<IssueTask> getProjectIssueTasks(int projectIdx ) {
		return service.getProjectIssueTasks(projectIdx);
	}
	
	/**
	 * 본인에게 할당된 이슈 진행률(프로젝트 별 in project)
	 * @author 이정은
	 * @since 2020/01/31 
	 * @param projectIdx
	 * @param principal
	 * @return List<ProjectProgress>
	 */
	@RequestMapping("MyProgress.do")
	public List<ProjectProgress> getProgressChart(int projectIdx, Principal principal, HttpServletRequest request) {
		return service.getProgressChart(MemberHelper.getMemberEmail(principal, request.getSession()), projectIdx);
	}
	
	@RequestMapping("Progress.do")
	public List<ProjectProgress> getProjectChart(int projectIdx) {
		return service.getProjectChart(projectIdx);
	}

	/**
	 * 본인에게 할달된 이슈 진행률(프로젝트 별)
	 * @author 이정은
	 * @since 2020/01/31
	 * @param principal
	 * @return Map<Integer ,List<ProjectProgress>>
	 */
	@RequestMapping("MyProjectProgress.do")
	public Map<Integer ,List<ProjectProgress>> getMyProjectChart(Principal principal, HttpServletRequest request) {	
		return service.getMyProjectChart(MemberHelper.getMemberEmail(principal, request.getSession()));
	}
	
	/**
	 * Horizon Chart
	 * @author 이정은
	 * @since 2020/02/01 
	 * @param principal
	 * @return Map<Integer ,List<ProjectProgress>>
	 */
	@RequestMapping("HorizonChart.do")
	public Map<Integer ,List<ProjectProgress>> getHorizonChart(Principal principal, HttpServletRequest request) {	
		return service.getHorizonChart(MemberHelper.getMemberEmail(principal, request.getSession()));
	}
	
	/**
	 * 프로젝트 내의 라벨별 진행률
	 * @author 이정은
	 * @since 2020/02/01 
	 * @param projectIdx
	 * @return Map<String ,List<ProjectProgress>>
	 */
	@RequestMapping("LabelChart.do")
	public Map<String ,List<ProjectProgress>> getLabelChart(int projectIdx) {	
		return service.getLabelChart(projectIdx);
	}
	
	/**
	 * LineChart
	 * @author 이정은
	 * @since 2020/02/01 
	 * @param principal
	 * @return
	 */
	@RequestMapping("LineChart.do")
	public Map<Integer, List<LineChart>> getLineChart(Principal principal, HttpServletRequest request) {
		return service.getLineChart(MemberHelper.getMemberEmail(principal, request.getSession()));
	}
	
	/**
	 * TimeLine 데이터 요청
	 * @author 윤다정
	 * @since 2020/01/31
	 * @param principal
	 * @return Map<String, List<TimeLine>>
	 */
	@RequestMapping("GetMyTimeLine.do")
	public Map<String, List<TimeLine>> getMyTimeLines(Principal principal, HttpServletRequest request) {
		return service.getMyTimeLines(MemberHelper.getMemberEmail(principal, request.getSession()));
	}
	
	/**
	 * TimeLine 데이터 요청 (프로젝트 개별)
	 * @author 윤다정
	 * @since 2020/01/31
	 * @param principal
	 * @return Map<String, List<TimeLine>>
	 */
	@RequestMapping("GetMyTimeLineByProject.do")
	public Map<String, List<TimeLine>> getMyTimeLineByProject(int projectIdx) {
		return service.getMyTimeLinesByProject(projectIdx);
	}
	
	/**
	 * 프로젝트 멤버별 진행률 요청
	 * @author 윤다정
	 * @since 2020/02/01
	 * @param projectIdx
	 * @return
	 */
	@RequestMapping("GetProjectMemberProgress.do")
	public Map<String, Object> getProjectMemberProgress(int projectIdx) {
		return service.getProjectMemberProgress(projectIdx);
	}
}
