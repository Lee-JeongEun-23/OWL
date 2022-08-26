package com.owl.member.dto;

import java.util.HashMap;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.owl.calendar.dto.SmartCalendar;
import com.owl.project.dto.Project;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Member {
	private String email;
	private String password;
	private int enabled;
	private String name;
	private String profilePic;
	private String signFrom;
	private HashMap<Integer, Project> projects;
	private Setting setting;
	private HashMap<Integer, SmartCalendar> calendars;
	private boolean authOk;
	private String authority;
	private String role;	
	private CommonsMultipartFile multipartFile;
}
