package com.owl.dashBoard.dto;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.owl.kanban.dto.Issue.PriorityType;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class IssueTask {
	private int projectIdx;
	private int issueIdx;
	private String subject;
	private String assigned;
	private Date dueDate;
	private PriorityType priorityCode;
	
	// UI 용
	private String projectName;
	private String assignedName;
	
	public String getDueDate() {
		String result = "";
		if (dueDate != null)
			result = new SimpleDateFormat("yyyy-MM-dd").format(dueDate);

		return result;
	}
}
