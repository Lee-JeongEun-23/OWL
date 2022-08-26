package com.owl.calendar.dto;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SmartCalendar {
	private int projectIdx;
	private int calIdx;
	private CalendarType type;
	private String title;
	private String content;
	private Date startDate;
	private Date endDate;
	private int allDay;
	private String email;
 
	public enum CalendarType {
		MY, PROJECT
	}
	

	/*
	 * public Date getstartDate() { SimpleDateFormat simpleDateFormat = new
	 * SimpleDateFormat("yyyy-MM-dd HH:mm"); Date stDate =
	 * simpleDateFormat.parse(startDate); return stDate; }
	 * 
	 * public Date getendDate() { return new
	 * SimpleDateFormat("yyyy-MM-dd HH:mm").format(endDate); }
	 */
}
