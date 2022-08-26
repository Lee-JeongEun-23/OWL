package com.owl.kanban.service;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

import com.owl.helper.UploadHelper;
import com.owl.kanban.dao.KanbanDao;
import com.owl.kanban.dto.Column;
import com.owl.kanban.dto.Issue;
import com.owl.kanban.dto.Reply;
import com.owl.member.dto.Member;
import com.owl.notice.dao.NoticeDao;
import com.owl.notice.dto.File;
import com.owl.project.dao.ProjectDao;
import com.owl.project.dto.Label;

@Service
public class KanbanService {
	@Autowired
	private SqlSession sqlSession;

	/**
	 * issue, issue file insert
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param issue
	 * @param multipartFiles
	 * @param uploadPath
	 * @return Issue
	 */
	@Transactional
	public Issue insertIssue(Issue issue, List<MultipartFile> multipartFiles, String uploadPath) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		Issue colList = null;
		try {
			result = dao.insertIssue(issue) > 0 ? true : false;
			if (multipartFiles.size() > 0)
				issue.setFiles(insertIssueFiles(dao, issue.getCreator(), issue.getProjectIdx(), issue.getIssueIdx(), multipartFiles, uploadPath));

			dao.updateAllIncrease(issue.getIssueIdx(), issue.getProjectIdx());

			if (result)
				colList = dao.getIssuebyIssueIdx(issue.getIssueIdx());

			insertLog(issue.getIssueIdx(), "Opened this issue", issue.getCreator(), dao);
		} catch (Exception e) {
			System.out.println("Trans 예외 발생 : " + e.getMessage());
		}

		return colList;
	}

	/**
	 * issue file insert, 실 업로드
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param dao
	 * @param email
	 * @param projectIdx
	 * @param issueIdx
	 * @param multipartFiles
	 * @param uploadPath
	 * @return List<File>
	 */
	private List<File> insertIssueFiles(KanbanDao dao, String email, int projectIdx, int issueIdx, List<MultipartFile> multipartFiles, String uploadPath) {
		List<File> files = new ArrayList<File>();

		multipartFiles.forEach(multipartFile -> {
			String fileName = multipartFile.getOriginalFilename();
			try {
				UploadHelper.uploadFileByProject(uploadPath, "file", projectIdx, fileName, multipartFile.getBytes());
			} catch (IOException e) {
				e.printStackTrace();
			}

			File file = new File();
			file.setIssueIdx(issueIdx);
			file.setFileName(fileName);
			file.setWriter(email);
			file.setFileSize(String.valueOf(multipartFile.getSize()/1024));

			try {
				dao.insertIssueFile(file);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			files.add(file);
		});

		return files;
	}

	public boolean insertColumn(Column column) {
		System.out.println("insertColumn Service in");
		System.out.println(column.getProjectIdx() + "/" + column.getColname());
		
		KanbanDao dao = getKanbanDao();
		boolean result = false;

		try {
			
			result = dao.insertColumn(column) > 0 ? true : false;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("컬럼정보" + column.toString());
		System.out.println("insert service 결과 : " + result);
		System.out.println("insert service 컬럼 아이디엑스  : " + column.getColIdx());
		
		
		return result;
	}
	
	
	
	public boolean insertLabel(Label label) {
		System.out.println("insertLabel Service in");
		System.out.println(label.getProjectIdx() + "/" + label.getLabelColor() + label.getLabelName());
		
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			
			result = dao.insertLabel(label) > 0 ? true : false;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("insert service 결과 : " + result);
		System.out.println("insert service 컬럼 아이디엑스  : " + label.getLabelIdx());
		
		return result;
	}
	
	
	
	public List<Label> getLabelList(int projectIdx) {
		System.out.println("getLabelList : " + projectIdx);
		KanbanDao dao = getKanbanDao();
		List<Label> lblist = null;
		
		try {
			lblist = dao.getLabelList(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return lblist;
	}
	
	
	public List<Column> getColum(int projectIdx){
		KanbanDao dao = getKanbanDao();
		List<Column> colList = null;
		try {
			colList = dao.getColumn(projectIdx);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		return colList;
	}
	
	public List<Issue> getIssue(int projectIdx){
		//System.out.println("여기서 projectIdx 는??????" + projectIdx) ;
		KanbanDao dao = getKanbanDao();
		List<Issue> issue = null;
		
		try {
			issue = dao.getIssue(projectIdx);
			//System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			//System.out.println(issue);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		return issue;
	}
		
	public boolean updateColumn(Column column) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			System.out.println("칼럼 업데이트  :" + column);
			result = dao.updateColumn(column) > 0 ? true : false;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	
	public List<Member>getAssignees(int projectIdx) {
		KanbanDao dao = getKanbanDao();
		Member member = null;
		
		try {
			member = dao.selectProjectMember(projectIdx);
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return null;
	}
	
	public boolean deleteColumn(int colIdx) {
		boolean result = false;
		KanbanDao dao = getKanbanDao();
		try {
			result = dao.deleteColumn(colIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	};
	
	public boolean deleteIssue(int issueIdx) {
		boolean result = false;
		KanbanDao dao = getKanbanDao();
		try {
			result = dao.deleteIssue(issueIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	};
	
	public boolean deleteLabel(int labelIdx) {
		System.out.println("deleteLabel service in++++++++++++");
		System.out.println("labelIdx" +labelIdx);
		boolean result = false;
		KanbanDao dao = getKanbanDao();
		try {
			result = dao.deleteLabel(labelIdx) > 0 ? true : false;
			System.out.println("result" + result);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	};
	

	public Map<String, Object> getIssueform(int projectIdx) {
		System.out.println("getIssueform in");
		
		Map<String, Object> object = new HashMap<>();
		KanbanDao daok = getKanbanDao();
		ProjectDao daop = getProjectDao();
		
		try {
			List<Label> label = daok.getLabelList(projectIdx);
			List<Member> member = daop.getProjectMembers(projectIdx);
			
			object.put("label", label);
			object.put("member", member);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		//System.out.println("object" + object);
		
		return object;
	}
	

	public boolean updateIssueOrder() {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		
		return result;
	}

	
	public Issue getIssueDetail(int issueIdx) {
		KanbanDao dao = getKanbanDao();
		Issue issue = null;
		try {
			issue = dao.getIssuebyIssueIdx(issueIdx);
			issue.setFiles(dao.getIssueFiles(issueIdx));
			issue.setLogs(dao.getIssueLogs(issueIdx));
			issue.setReplies(dao.getIssueReplies(issueIdx));
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		System.out.println("in getIssueDetail service "+issueIdx);
		System.out.println(issue);
		return issue;
	}
	
	/**
	 * 칸반보드 내에서 이슈 이동할 때 orderNum,  move, reopen, close 구분 하여 업데이트
	 * @author 윤다정
	 * @since 2020/02/07
	 * @param projectIdx
	 * @param targetIssueIdx
	 * @param columnIdx
	 * @param issues
	 * @param email
	 * @return boolean
	 */
	public boolean updateMoveIssue(int projectIdx, int targetIssueIdx, int columnIdx, int[] issues, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			Issue issue = dao.getIssuebyIssueIdx(targetIssueIdx);
			int oldColIdx = issue.getColIdx();
			for (int i = 0; i < issues.length; i++) {
				Map<String, Object> parameters = new HashMap<>();
				parameters.put("colIdx", columnIdx);
				parameters.put("index", i);
				parameters.put("issueIdx", issues[i]);
				dao.updateMoveIssue(parameters);
			}
			
			if (oldColIdx != columnIdx) {
				String log = "";
				if (oldColIdx == -99) { // reopen
					dao.reopenIssue(issue.getIssueIdx(), columnIdx);
					log = "ReOpen to " + dao.getColumnName(projectIdx, columnIdx);
				} else if (columnIdx == -99) { // close
					dao.closeIssue(issue.getIssueIdx());
					log = "Close this ";
				} else { // move
					log = "Moved this from " + dao.getColumnName(projectIdx, oldColIdx) + " to " + dao.getColumnName(projectIdx, columnIdx);
				}
				insertLog(targetIssueIdx, log, email, dao);
			}

			result = true;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	
	public boolean UpdateLabel(Label label) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			System.out.println("label :" + label);
			result = dao.updateLabel(label) > 0 ? true : false;
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("result가 뭐니?" + result);
		return result;
	}
	
	public boolean closeIssue(int issueIdx, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		try {
			result = dao.closeIssue(issueIdx) > 0 ? true : false;

			insertLog(issueIdx, "Closed this", email, dao);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}

		return result;
	}
	
	public boolean reopenIssue(int issueIdx, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		try {
			result = dao.reopenIssue(issueIdx, -1) > 0 ? true : false;
			insertLog(issueIdx, "Reopen this", email, dao);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * IssueLog 테이블 insert
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param issueIdx
	 * @param log
	 * @param email
	 * @param dao
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	private void insertLog(int issueIdx, String log, String email, KanbanDao dao) throws ClassNotFoundException, SQLException {
		dao.insertIssueLog(issueIdx, log, email);
	}

	public Reply insertReply(Reply reply) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		Reply re = new Reply();

		try {
			result = dao.insertReply(reply) > 0 ? true : false;
			System.out.println(reply.getIssueRlyIdx());

			if (result) {
				re = dao.getReply(reply.getIssueRlyIdx());
				re.setIssueRlyIdx(reply.getIssueRlyIdx());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return re;
	}
	
	public boolean deleteReply(int issuerlyidx) {
		boolean result = false;
		KanbanDao dao = getKanbanDao();
		try {
			result = dao.deleteReply(issuerlyidx) > 0 ? true : false;
			System.out.println("result" + result);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	};
	

	public boolean editReply(Reply reply) {
		boolean result = false;
		KanbanDao dao = getKanbanDao();
		
		 try {
			result = dao.updateReply(reply) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	public boolean updateIssueTitile(Issue issue, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			result = dao.updateIssueTitle(issue) > 0 ? true : false;
			insertLog(issue.getIssueIdx(), "update issue title", email, dao);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public boolean updateIssueContent(Issue issue, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		System.out.println("업데이트 이슈 콘텐트 service ");
		try {
			result = dao.updateIssueContent(issue) > 0 ? true : false;
			insertLog(issue.getIssueIdx(), "update issue content", email, dao);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public boolean updateIssuePriority(Issue issue, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			result = dao.updateIssuePriority(issue) > 0 ? true : false;
			insertLog(issue.getIssueIdx(), "update issue priority", email, dao);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	public boolean updateIssueDuedate(Issue issue, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			result = dao.updateIssueDueDate(issue) > 0 ? true : false;
			insertLog(issue.getIssueIdx(), "update issue duedate", email, dao);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	public boolean updateIssueAssgined(Issue issue, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			result = dao.updateIssueAssigned(issue) > 0 ? true : false;
			insertLog(issue.getIssueIdx(), "update issue assigned", email, dao);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	public boolean updateIssueLabel(Issue issue, String email) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		
		try {
			result = dao.updateIssueLabel(issue) > 0 ? true : false;
			insertLog(issue.getIssueIdx(), "update issue label", email, dao);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	public boolean deleteIssueFile(int fileIdx) {
		KanbanDao dao = getKanbanDao();
		boolean result = false;
		try {
			result = dao.deleteIssueFile(fileIdx)> 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	public boolean addIssueFile(Issue issue, List<MultipartFile> multipartFiles, String uploadPath) {
		KanbanDao dao = getKanbanDao();
		System.out.println("addIssueFile service in ");
		boolean result = false;
		List<File> files = new ArrayList<File>();
		if (multipartFiles.size() > 0) 
			files = insertIssueFiles(dao, issue.getCreator(), issue.getProjectIdx(), issue.getIssueIdx(), multipartFiles, uploadPath);
			result = files.size() > 0 ? true : false;
			issue.setFiles(files);
		
		return result;
	}
	public List<Issue> searchAssignee(int projectIdx,String email){
		KanbanDao dao = getKanbanDao();
		List<Issue> issue = null;
		
		try {
			issue = dao.searchAssignee(projectIdx, email);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return issue;
	}
	
	
	
	public List<Issue> searchLabel(int labelIdx){
		KanbanDao dao = getKanbanDao();
		List<Issue> issue = null;
		
		try {
			issue = dao.searchLabel(labelIdx);
		} catch (Exception e) {
			e.printStackTrace();
		} 	
		return issue;
	}
	
	
	
	public List<Issue> searchPriority(String priorityidx){
		KanbanDao dao = getKanbanDao();
		List<Issue> issue = null;
		try {
			issue = dao.searchPriority(priorityidx);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return issue;
	}
	
	public List<Member> getProjectMemberList(int projectIdx){
		
		ProjectDao daop = getProjectDao();
		List<Member> member = null;
		try {
			member = daop.getProjectMembers(projectIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(member);
		return member;
	}
	
	
	public String getPMemail(int projectIdx){
		KanbanDao dao = getKanbanDao();
		
		String email = null;
		try {
			email = dao.getPMemail(projectIdx);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return email;
	}
	
	
	
	public boolean IssueComfirmfromPM(int issueIdx){
		KanbanDao dao = getKanbanDao();
		boolean check = false;
		
		try {
			check = dao.IssueComfirmfromPM(issueIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return check;
	}
	
	
	
	public boolean IssueRejectfromPM(Issue issue){
		KanbanDao dao = getKanbanDao();

		boolean check = false;
		try {
			check = dao.IssueRejectfromPM(issue)> 0 ? true : false;

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return check;
	}
	
	public String GetcomfirmReason(int issueIdx){
		KanbanDao dao = getKanbanDao();

		
		System.out.println("GetcomfirmReason in controller");
		String check = null;
		try {
			check = dao.GetcomfirmReason(issueIdx);

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return check;
	}
	
	
	/**
	 * KanbanDao 구하기
	 * @author 윤다정
	 * @since 2020/01/29
	 * @return KanbanDao
	 */
	private KanbanDao getKanbanDao() {
		return sqlSession.getMapper(KanbanDao.class);
	}
	
	/**
	 * ProjectDao 구하기
	 * @author 윤다정
	 * @since 2020/01/29
	 * @return ProjectDao
	 */
	private ProjectDao getProjectDao() {
		return sqlSession.getMapper(ProjectDao.class);
	}
}
