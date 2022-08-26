package com.owl.calendar.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.owl.calendar.service.SmartCalendarService;
import com.owl.project.dto.ProjectList;
import com.owl.project.service.ProjectService;

@Controller
public class SmartCalendarController {

	@Autowired
	private ProjectService projectService;

	/**
	 * my calendar 화면 이동
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param principal
	 * @param model
	 * @return
	 */
	@RequestMapping("Calendar.do")
	public String showView(Principal principal, Model model) {
		List<ProjectList> projects = projectService.getProjectLists(principal.getName());
		model.addAttribute("projectList", projects);
		return "calendar/calendar";
	}
}
