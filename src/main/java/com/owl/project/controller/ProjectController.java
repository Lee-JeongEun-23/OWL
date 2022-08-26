package com.owl.project.controller;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.owl.helper.MemberHelper;
import com.owl.project.dto.ProjectList;
import com.owl.project.service.ProjectService;

@Controller
public class ProjectController {
	
	@Autowired
	private ProjectService service;

	@RequestMapping("Project.do")
	public String showProject(int projectIdx, Principal	principal, Model model, HttpServletRequest request) {
		if(request.getParameter("isAlarm") != null) {
			model.addAttribute("isAlarm", true);
			model.addAttribute("view", request.getParameter("view"));
			model.addAttribute("targetIdx", Integer.parseInt(request.getParameter("targetIdx")));
		}else 
			model.addAttribute("isAlarm", false);

		List<ProjectList> projectList  = service.getProjectLists(MemberHelper.getMemberEmail(principal, request.getSession()));
		model.addAttribute("projectList", projectList);
		
		ProjectList project = projectList.stream().filter(x -> x.getProjectIdx() == projectIdx).findFirst().get();
		model.addAttribute("project", project);
		
		return "project/main";
	}

	/**
	 * 프로젝트 초대 메일 클릭
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param joinProjectIdx
	 * @param projectName
	 * @param joinProjectPm
	 * @param request
	 * @param model
	 * @return String
	 */
	@RequestMapping(value = "AddProjectMemberOk.do", method = RequestMethod.POST)
	public String addProjectMemberOk(int joinProjectIdx, String projectName, String joinProjectPm, HttpServletRequest request, Model model) {
		model.addAttribute("projectName", projectName);
		request.getSession().setAttribute("joinProjectIdx", joinProjectIdx);
		request.getSession().setAttribute("joinProjectPm", joinProjectPm);

		return "member/joinProject";
	}
	
	@RequestMapping("ProjectFromAlarm.do")
	public void projectFromAlarm(String view, int projectIdx, int targetIdx) {
		
	}
}
