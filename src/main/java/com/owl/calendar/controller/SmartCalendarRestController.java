package com.owl.calendar.controller;

import java.security.Principal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.owl.calendar.dto.SmartCalendar;
import com.owl.calendar.dto.SmartCalendar.CalendarType;
import com.owl.calendar.service.SmartCalendarService;
import com.owl.helper.MemberHelper;

@RestController
public class SmartCalendarRestController {

	@Autowired
	SmartCalendarService service;
	
	/**
	 * 캘린더 스케줄 Insert
	 * @author 이정은
	 * @since 2020/02/03
	 * @param calendarId
	 * @param title
	 * @param content
	 * @param startDate
	 * @param endDate
	 * @param allDay
	 * @param principal
	 * @return boolean result
	 */
	@RequestMapping(value="InsertCalendar.do", method = RequestMethod.POST)
	public boolean insertCalendar(@RequestParam(value = "calendarId") int calendarId, 
												@RequestParam(value = "title") String title,
												@RequestParam(value = "location",required = false) String content,
												@RequestParam(value = "start",required = false) String startDate,
												@RequestParam(value = "end",required = false) String endDate,
												@RequestParam(value = "allDay") boolean allDay,
												Principal principal, HttpServletRequest request) {
		boolean result = false;
		SmartCalendar calendar = new SmartCalendar();
		try {
		
		if(calendarId == 0) {
			calendar.setType(CalendarType.MY);
		}else {
			calendar.setType(CalendarType.PROJECT);
			calendar.setProjectIdx(calendarId);
		}
		calendar.setTitle(title);
		calendar.setContent(content);	
		

		if(allDay) {			
			if(!startDate.isEmpty()) {
				calendar.setStartDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(startDate));
			}
			if(!endDate.isEmpty()) {
				calendar.setEndDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(endDate));		
			}	
			calendar.setAllDay(1);
	
		}else {
			calendar.setStartDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(startDate));
			calendar.setEndDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(endDate));	
			calendar.setAllDay(0);
		}		
		calendar.setEmail(MemberHelper.getMemberEmail(principal, request.getSession()));
		result = service.insertCalendar(calendar);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 캘린더 스케줄 Delete
	 * @author 이정은
	 * @since 2020/02/03
	 * @param calIdx
	 * @return boolean result
	 */
	@RequestMapping(value="DeleteCalendar.do", method = RequestMethod.POST)
	public boolean deleteMyCalendar(@RequestParam(value = "scheduleId") int calIdx) {
		boolean result = false;
		result = service.deleteCalendar(calIdx);	
		return result;
	}
	
	/**
	 * 내 캘린더 조회(나의 일정과 내가 속한 프로젝트의 일정 전부 조회)
	 * @author 이정은
	 * @since 2020/02/03
	 * @param principal
	 * @return List<SmartCalendar>
	 */
	@RequestMapping(value="GetMyAllCalendars.do")
	public List<SmartCalendar> getMyAllCalendars(Principal principal, HttpServletRequest request){
		List<SmartCalendar> calendar = null;
		calendar = service.getMyAllCalendars(MemberHelper.getMemberEmail(principal, request.getSession()));		
		return calendar;
	}
	
	/**
	 * 프로젝트 내의 캘린더 조회(해당 프로젝트의 일정만 조회)
	 * @author 이정은
	 * @since 2020/02/03
	 * @param projectIdx
	 * @return List<SmartCalendar>
	 */
	@RequestMapping(value="GetProjectCalendar.do")
	public List<SmartCalendar> getProjectCalendar(int projectIdx){
		List<SmartCalendar> calendar = null;
		calendar = service.getProjectCalendar(projectIdx);
		return calendar;
	}
	
	/**
	 * 캘린더 수정 (모든 조건)
	 * @author 이정은
	 * @since 2020/02/03 
	 * @param calIdx
	 * @param projectIdx
	 * @param title
	 * @param content
	 * @param startDate
	 * @param endDate
	 * @param allDay
	 * @param principal
	 * @return boolean result
	 */
	@RequestMapping(value="UpdateCalendar.do", method = RequestMethod.POST)
	public boolean updateCalendar(@RequestParam(value = "scheduleId") int calIdx, 
												  @RequestParam(value = "calendarId" ,required = false) String projectIdx, 												  
												  @RequestParam(value = "title" ,required = false) String title,
												  @RequestParam(value = "location",required = false) String content,
												  @RequestParam(value = "start" ,required = false) String startDate,
												  @RequestParam(value = "end" ,required = false) String endDate,
												  @RequestParam(value = "allDay" ,required = false) boolean allDay,
												Principal principal, HttpServletRequest request) {
		boolean result = false;
		SmartCalendar calendar = new SmartCalendar();
		try {
		if(projectIdx !=null) { // 프로젝트 변경했을 때
			int chageIdx = Integer.parseInt(projectIdx);
			calendar.setProjectIdx(chageIdx);
			if(chageIdx == 0)
				calendar.setType(CalendarType.MY);
			else 
				calendar.setType(CalendarType.PROJECT);
		}else { // 프로젝트 변경 없을 때
			calendar.setProjectIdx(-1);
		}
			
		calendar.setTitle(title);
		calendar.setContent(content);	
		calendar.setCalIdx(calIdx);
			if(allDay) {
				if(!startDate.isEmpty()) {
					calendar.setStartDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(startDate));
				}
				if(!endDate.isEmpty()) {
					calendar.setEndDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(endDate));		
				}	
					calendar.setAllDay(1);
			}else{
				if(!startDate.isEmpty()) {
					calendar.setStartDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(startDate));
				}
				if(!endDate.isEmpty()) {
					calendar.setEndDate(new SimpleDateFormat("E MMM dd yyyy HH:mm:ss 'GMT'z",Locale.ENGLISH).parse(endDate));		
				}
				calendar.setAllDay(0);
			}
		calendar.setEmail(MemberHelper.getMemberEmail(principal, request.getSession()));
		result = service.updateCalendar(calendar);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
		
}

