package com.owl.kanban.dto;


import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Reply {
	private int issueIdx;
	private int issueRlyIdx;
	private String content;
	private Date createDate;
	private String creator;
	private String profilepic;
	private String creatorName; //UI용
	
	public String getCreateDate() {
		String result = "";
		if (createDate != null)
			result = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(createDate);

		return result;
	}
	
}
