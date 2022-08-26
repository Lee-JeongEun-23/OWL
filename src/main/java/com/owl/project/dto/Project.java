package com.owl.project.dto;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import com.owl.chat.dto.ChatRoom;
import com.owl.drive.dto.DriveFolder;
import com.owl.kanban.dto.Issue;
import com.owl.member.dto.Member;
import com.owl.notice.dto.Notice;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Project {
	
	private int projectIdx;
	private String projectName;
	private Date startDate;
	private Date endDate;
	private HashMap<String, Member> members;
	private HashMap<Integer, Issue> issues;
	private HashMap<Integer, Label> lavels;
	private HashMap<Integer, DriveFolder> drives;
	private HashMap<Integer, ChatRoom> chatRooms;
	private HashMap<Integer, Notice> boards;

	public String getStartDate() {
		if (startDate == null)
			return null;
		else
			return new SimpleDateFormat("yyyy-MM-dd").format(startDate);
	}
	
	public String getEndDate() {
		if (endDate == null)
			return null;
		else
			return new SimpleDateFormat("yyyy-MM-dd").format(endDate);
	}
}
