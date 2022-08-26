package com.owl.dashBoard.dto;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.springframework.aop.aspectj.annotation.LazySingletonAspectInstanceFactoryDecorator;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class TimeLine {
	private String projectName;
	private String projectColor;
	private String subject;
	private Date dueDate;
	
	public String getDueDate() {
		String[] week = new String[] { "일", "월", "화", "수", "목", "금", "토" };
		String result = "";
		if (dueDate != null) {
			result = new SimpleDateFormat("yyyy-MM-dd").format(dueDate);
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(dueDate);
			result += " (" + week[calendar.get(Calendar.DAY_OF_WEEK)-1] + ")";
		}
		
		return result;
	}
}
