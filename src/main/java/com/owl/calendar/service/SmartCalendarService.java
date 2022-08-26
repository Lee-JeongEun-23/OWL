package com.owl.calendar.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.owl.calendar.dao.SmartCalendarDao;
import com.owl.calendar.dto.SmartCalendar;

@Service
public class SmartCalendarService {
	@Autowired
	private SqlSession sqlSession;

	/**
	 * 캘린더에 스케줄 INSERT
	 * @author 이정은
	 * @since 2020/02/03 
	 * @param calendar
	 * @return boolean result
	 */
	public boolean insertCalendar(SmartCalendar calendar) {
		boolean result = false;
		SmartCalendarDao dao = getSmartCalendarDao();

		try {
			result = dao.insertCalendar(calendar) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	};

	/**
	 * 캘린더에 스케줄 UPDATE
	 * @author 이정은
	 * @since 2020/02/03  
	 * @param calendar
	 * @return boolean result 
	 */
	public boolean updateCalendar(SmartCalendar calendar) {
		boolean result = false;
		SmartCalendarDao dao = getSmartCalendarDao();

		try {
			result = dao.updateCalendar(calendar) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	};

	/**
	 * 캘린더에 스케줄 DELETE
	 * @author 이정은
	 * @since 2020/02/03  
	 * @param calIdx
	 * @return boolean result 
	 */
	public boolean deleteCalendar(int calIdx) {
		boolean result = false;
		SmartCalendarDao dao = getSmartCalendarDao();

		try {
			result = dao.deleteCalendar(calIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	};
	
	/**
	 * 나의 스케줄 전체 SELECT
	 * @author 이정은
	 * @since 2020/02/03  
	 * @param email
	 * @return List<SmartCalendar>
	 */
	public List<SmartCalendar> getMyAllCalendars(String email) {
		SmartCalendarDao dao = getSmartCalendarDao();
		
		List<SmartCalendar> calendars = new ArrayList<SmartCalendar>();
		try {
			calendars = dao.getMyAllCalendars(email);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return calendars;
	}
	
	/**
	 * 프로젝트 내의 스케줄 전체 SELECT
	 * @author 이정은
	 * @since 2020/02/03 
	 * @param projectIdx
	 * @return List<SmartCalendar>
	 */
	public List<SmartCalendar> getProjectCalendar(int projectIdx) {
		SmartCalendarDao dao = getSmartCalendarDao();

		List<SmartCalendar> calendars = new ArrayList<SmartCalendar>();
		try {
			calendars = dao.getProjectCalendar(projectIdx);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return calendars;
	}

	/**
	 * SmartCalendarDao 구하기
	 * @author 윤다정
	 * @since 2020/01/29
	 * @return SmartCalendarDao
	 */
	private SmartCalendarDao getSmartCalendarDao() {
		return sqlSession.getMapper(SmartCalendarDao.class);
	}
}
