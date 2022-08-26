package com.owl.dashBoard.dto;

import com.owl.kanban.dto.Issue.IssueProgressType;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ProjectProgress {
	private int projectIdx;
	private int issueIdx;
	private int labelIdx;
	private String projectName;
	private String projectColor;
	private String assigned;
	private String labelName;
	private String labelColor;
	private IssueProgressType issueProgress;
}
