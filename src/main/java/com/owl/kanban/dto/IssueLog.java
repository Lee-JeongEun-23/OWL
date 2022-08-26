package com.owl.kanban.dto;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class IssueLog {
	private int logIdx;
	private String log;
	private Date logTime;
	private String creator;
	
	// UI용
	private String creatorName;
	
	public String getLogTime() {
		if (logTime == null)
			return null;
		else
			return new SimpleDateFormat("yyyy-MM-dd   HH:mm:ss").format(logTime);
	}
}
