package com.owl.project.controller;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.ui.Model;
import org.springframework.ui.velocity.VelocityEngineFactoryBean;
import org.springframework.ui.velocity.VelocityEngineUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.owl.drive.dto.DriveFolder;
import com.owl.helper.MemberHelper;
import com.owl.member.dto.Member;
import com.owl.project.dto.Project;
import com.owl.project.dto.ProjectList;
import com.owl.project.service.ProjectService;

@RestController
public class ProjectRestController {

	@Autowired
	private ProjectService service;

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private VelocityEngineFactoryBean velocityEngineFactoryBean;

	/**
	 * Sidebar의 프로젝트 목록 수정
	 * 
	 * @author 이정은
	 * @since 2020/01/31
	 * @param projectIdx
	 * @param favorite
	 * @param projectColor
	 * @param principal
	 * @return projectlist
	 */
	@RequestMapping("EditMyProject.do")
	public ProjectList updateProjectList(int projectIdx, int favorite, String projectColor, Principal principal, HttpServletRequest request) {
		ProjectList projectlist = new ProjectList();
		try {
			projectlist.setEmail(MemberHelper.getMemberEmail(principal, request.getSession()));
			projectlist.setProjectIdx(projectIdx);
			projectlist.setFavorite(favorite);
			projectlist.setProjectColor(projectColor);

			service.updateProjectList(projectlist);

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return projectlist;
	}

	/**
	 * 새 프로젝트 추가
	 * 
	 * @author 이정은
	 * @since 2020/01/31
	 * @param projectName
	 * @param projectColor
	 * @param project
	 * @param projectlist
	 * @param principal
	 * @param drivefolder
	 * @param request
	 * @return boolean result
	 * @throws Exception
	 */
	@RequestMapping("InsertNewProject.do")
	public int insertNewProject(@RequestParam(value = "projectName") String projectName,
			@RequestParam(value = "projectColor") String projectColor,
			@RequestParam(value = "startDate") Date startDate, 
			@RequestParam(value = "endDate") Date endDate,
			Project project, ProjectList projectlist, Principal principal, DriveFolder drivefolder,
			HttpServletRequest request) throws Exception {
		try {
			projectlist.setEmail(MemberHelper.getMemberEmail(principal, request.getSession()));
			project.setProjectName(project.getProjectName());
			projectlist.setProjectColor(projectlist.getProjectColor());
			project.setStartDate(startDate);
			project.setEndDate(endDate);

			drivefolder.setDepth(0);
			drivefolder.setRef(0);
			service.insertNewProject(project, projectlist, drivefolder, request);

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return project.getProjectIdx();
	}

	/**
	 * projectIdx가 일치하는 프로젝트 정보 출력
	 * 
	 * @author 이정은
	 * @since 2020/01/31
	 * @param projectIdx
	 * @param principal
	 * @param model
	 * @return projectList
	 */
	@RequestMapping("GetProjectList.do")
	public ProjectList getProjectList(int projectIdx, Principal principal, Model model, HttpServletRequest request) {
		ProjectList projectList = null;
		projectList = service.getProjectList(projectIdx, MemberHelper.getMemberEmail(principal, request.getSession()));
		model.addAttribute("projectList", projectList);
		System.out.println(projectList);
		return projectList;
	}

	/**
	 * 전체 프로젝트 리스트 출력
	 * 
	 * @author 이정은
	 * @since 2020/01/31
	 * @param principal
	 * @param model
	 * @return projectList
	 */
	@RequestMapping("ProjectList.do")
	public List<ProjectList> getDriveList(Principal principal, Model model, HttpServletRequest request) {
		List<ProjectList> projectList = null;
		projectList = service.getProjectLists(MemberHelper.getMemberEmail(principal, request.getSession()));
		model.addAttribute("projectList", projectList);
		return projectList;
	}

	@RequestMapping(value = "AddProjectMember.do", method = RequestMethod.POST)
	public void AddProjectMember(int projectIdx, String projectName, String pm, String[] addProjectMembers,
			Principal principal, HttpServletRequest request) {

		try {
			MimeMessage content = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(content, true, "UTF-8");
			Map<String, Object> models = new HashMap<String, Object>();
			models.put("projectName", projectName);
			models.put("joinProjectIdx", projectIdx);
			models.put("pm", pm);
			models.put("pmEamil", MemberHelper.getMemberEmail(principal, request.getSession()));

			String mailBody = VelocityEngineUtils.mergeTemplateIntoString(
					velocityEngineFactoryBean.createVelocityEngine(), "joinProjectTemplate.vm", "UTF-8", models);
			messageHelper.setSubject("[OWL] 프로젝트 초대");
			messageHelper.setFrom("bit4owl@gmail.com");
			messageHelper.setTo(addProjectMembers);
			messageHelper.setText(mailBody, true);
			mailSender.send(content);

		} catch (Exception e) {
			System.out.println("이거 에러..>" + e.getMessage());
		}
	}

	@RequestMapping(value = "GetProjectMember.do", method = RequestMethod.POST)
	public List<Member> getProjectMembers(int projectIdx) {
		return service.getProjectMembers(projectIdx);
	}

	@RequestMapping(value = "OutProject.do", method = RequestMethod.POST)
	public boolean outProject(int projectIdx, Principal principal, HttpServletRequest request) {
		return service.outProject(projectIdx, MemberHelper.getMemberEmail(principal, request.getSession()));
	}

	@RequestMapping(value = "ExitMember.do", method = RequestMethod.POST)
	public boolean exitMember(int projectIdx, String email) {
		return service.outProject(projectIdx, email);
	}

	@RequestMapping(value = "TransferAuthority.do", method = RequestMethod.POST)
	public boolean transferAuthority(int projectIdx, String email, Principal principal, HttpServletRequest request) {
		return service.transferAuthority(projectIdx, MemberHelper.getMemberEmail(principal, request.getSession()), email);
	}
}
