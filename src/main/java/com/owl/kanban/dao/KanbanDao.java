package com.owl.kanban.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.owl.kanban.dto.Column;
import com.owl.kanban.dto.Issue;
import com.owl.kanban.dto.IssueLog;
import com.owl.kanban.dto.Reply;
import com.owl.member.dto.Member;
import com.owl.notice.dto.File;
import com.owl.project.dto.Label;

public interface KanbanDao {
	public Member selectProjectMember(int projectIdx) throws ClassNotFoundException, SQLException;

	public int insertIssue(Issue issue) throws ClassNotFoundException, SQLException;

	public int insertIssueFile(File file) throws ClassNotFoundException, SQLException;

	public int updateAllIncrease(int issueIdx, int projectIdx) throws ClassNotFoundException, SQLException;
	
	public int insertColumn(Column column) throws ClassNotFoundException, SQLException;

	public int insertLabel(Label label) throws ClassNotFoundException, SQLException;

	public int insertIssueLog(Issue issue) throws ClassNotFoundException, SQLException;

	public List<Label> getLabelList(int projectIdx) throws ClassNotFoundException, SQLException;

	public Label getLabelinfo(int labelIdx) throws ClassNotFoundException, SQLException;

	public List<Issue> getIssue(int projectIdx) throws ClassNotFoundException, SQLException;

	public List<Column> getColumn(int projectIdx) throws ClassNotFoundException, SQLException;
	
	public String getColumnName(int projectIdx,int colIdx)throws ClassNotFoundException, SQLException;

	public Issue getIssuebyIssueIdx(int issueIdx) throws ClassNotFoundException, SQLException;

	public int updateColumn(Column column) throws ClassNotFoundException, SQLException;

	public int updateIssueOrder(List<Issue> issues) throws ClassNotFoundException, SQLException;

	public int deleteColumn(int colIdx) throws ClassNotFoundException, SQLException;

	public int deleteIssue(int issueIdx) throws ClassNotFoundException, SQLException;

	public int deleteLabel(int labelIdx) throws ClassNotFoundException, SQLException;
	
	public int deleteReply(int issuerlyidx) throws ClassNotFoundException, SQLException;

	public List<File> getIssueFiles(int issueIdx) throws ClassNotFoundException, SQLException;

	public List<IssueLog> getIssueLogs(int issueIdx) throws ClassNotFoundException, SQLException;

	public List<Reply> getIssueReplies(int issueIdx) throws ClassNotFoundException, SQLException;

	public int updateMoveIssue(Map<String, Object> data) throws ClassNotFoundException, SQLException;

	public int updateLabel(Label label) throws ClassNotFoundException, SQLException;

	public int insertIssueLog(int issueIdx, String log, String email) throws ClassNotFoundException, SQLException;
	
	public int closeIssue(int issueIdx) throws ClassNotFoundException, SQLException;
	
	public int reopenIssue(int issueIdx, int colIdx) throws ClassNotFoundException, SQLException;
	
	public Map<String, Integer> getIssueProgress(int projectIdx) throws ClassNotFoundException, SQLException;
	
	public int insertReply(Reply reply) throws ClassNotFoundException, SQLException;

	public Reply getReply(int issueRlyIdx) throws ClassNotFoundException, SQLException;
	
	public int updateReply(Reply reply) throws ClassNotFoundException, SQLException;
	
	public List<Issue> searchAssignee(int projectIdx, String email) throws ClassNotFoundException, SQLException;

	public List<Issue> searchLabel(int labelIdx) throws ClassNotFoundException, SQLException;

	public List<Issue> searchPriority(String priorityidx) throws ClassNotFoundException, SQLException;

	public int updateIssueTitle(Issue issue) throws ClassNotFoundException, SQLException;
	
	public int updateIssueContent(Issue issue) throws ClassNotFoundException, SQLException;
	
	public int updateIssuePriority(Issue issue) throws ClassNotFoundException, SQLException;
	
	public int updateIssueDueDate(Issue issue) throws ClassNotFoundException, SQLException;
	
	public int updateIssueAssigned(Issue issue) throws ClassNotFoundException, SQLException;

	public int updateIssueLabel(Issue issue) throws ClassNotFoundException, SQLException;
	
	public int deleteIssueFile(int fileIdx) throws ClassNotFoundException, SQLException;
	
	public String getPMemail(int projectIdx) throws ClassNotFoundException, SQLException;

	public int IssueComfirmfromPM(int issueIdx) throws ClassNotFoundException, SQLException;

	public int IssueRejectfromPM(Issue issue) throws ClassNotFoundException, SQLException;
	
	public String GetcomfirmReason(int issueIdx) throws ClassNotFoundException, SQLException;

}
