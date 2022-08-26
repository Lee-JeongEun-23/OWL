package com.owl.project.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.owl.drive.dao.DriveDao;
import com.owl.drive.dto.DriveFolder;
import com.owl.helper.UploadHelper;
import com.owl.member.dto.Member;
import com.owl.project.dao.ProjectDao;
import com.owl.project.dto.Project;
import com.owl.project.dto.ProjectList;

@Service
public class ProjectService {

	@Autowired
	private SqlSession sqlSession;

	// Sidebar의 프로젝트 목록 출력
	public List<ProjectList> getProjectLists(String email) {
		ProjectDao projectDao = getProjectDao();
		List<ProjectList> projectlist = new ArrayList<ProjectList>();

		try {
			projectlist = projectDao.getProjectLists(email);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return projectlist;
	}

	// Sidebar의 프로젝트 목록 수정
	public void updateProjectList(ProjectList projectlist) {
		ProjectDao projectDao = getProjectDao();

		try {
			projectDao.updateProjectList(projectlist);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	
	//Sidebar의 프로젝트 목록 추가
	
	@Transactional
	public void insertNewProject(Project project, ProjectList projectlist, DriveFolder drivefolder, HttpServletRequest request) throws Exception{
		ProjectDao projectDao = getProjectDao();
		DriveDao driveDao = getDriveDao();
		try {
			projectDao.insertProject(project);
			
			int projectIdx = project.getProjectIdx();
			projectlist.setProjectIdx(projectIdx);
			projectlist.setAuthority("ROLE_PM");
			projectDao.insertProjectList(projectlist);	
			
			drivefolder.setFolderName(project.getProjectName());
			drivefolder.setProjectIdx(projectIdx);			
			driveDao.insertMainFolder(drivefolder);
			
			String uploadPath = request.getServletContext().getRealPath("upload");
			UploadHelper.makeDefaultDirectory(uploadPath, projectIdx, drivefolder.getDriveIdx());
		} catch (Exception e) {
			System.out.println("Trans 예외 발생 : " + e.getMessage());
			throw e; //이 시점에 매니저가 예외 인지 한 후 rollback 처리
		}
	}
	
	public ProjectList getProjectList(int projectIdx, String email) {
		ProjectDao dao = getProjectDao();
		ProjectList projectList = null;
		try {
			projectList = dao.getProjectList(projectIdx, email);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return projectList;
	}

	public boolean insertProjectMember(int projectIdx, String pm, String email) {
		ProjectDao dao = getProjectDao();
		boolean result = false;
		ProjectList projectList = new ProjectList();
		projectList.setAuthority("ROLE_PROJECTMEMBER");
		projectList.setEmail(email);
		projectList.setProjectIdx(projectIdx);
		System.out.println(projectIdx);
		System.out.println(pm);
		System.out.println(email);
		try {
			projectList.setProjectColor(dao.getProjectList(projectIdx, pm).getProjectColor());
			result = dao.insertProjectMember(projectList) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public List<Member> getProjectMembers(int projectIdx) {
		ProjectDao dao = getProjectDao();
		List<Member> projectMembers = new ArrayList<>();
		try {
			projectMembers = dao.getProjectMembers(projectIdx);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return projectMembers;
	}
	
	public boolean outProject(int projectIdx, String email) {
		ProjectDao dao = getProjectDao();
		System.out.println("in outProject service");
		boolean result =false;
		try {
			result = dao.outProject(projectIdx, email) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		System.out.println("result : "+result);
		return result;
	}
	public boolean transferAuthority(int projectIdx, String PMemail,String memberEmail) {
		ProjectDao dao = getProjectDao();
		System.out.println("in transferAuthority service");
		boolean result =false;
		try {
			result = dao.grantPM(projectIdx, memberEmail) > 0 && dao.grantProjectMember(projectIdx, PMemail) > 0 ? true : false;
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		System.out.println("result : "+result);
		return result;
	}
	private ProjectDao getProjectDao() {
		return sqlSession.getMapper(ProjectDao.class);
	}
	
	private DriveDao getDriveDao() {
		return sqlSession.getMapper(DriveDao.class);
	}	
}
