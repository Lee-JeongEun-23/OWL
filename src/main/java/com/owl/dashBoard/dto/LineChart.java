package com.owl.dashBoard.dto;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LineChart {
	private int projectIdx;
	private int issueIdx;
	private Date logTime;
	private String projectName;
	private String projectColor;
	private String creator;
	
	public String getLogTime() {
		if (logTime == null)
			return null;
		else
			return new SimpleDateFormat("yyyy-MM-dd   HH:mm:ss").format(logTime);
	}

}
