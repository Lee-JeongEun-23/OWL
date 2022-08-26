package com.owl.member.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.owl.member.dao.MemberDao;
import com.owl.member.dto.Member;
import com.owl.member.dto.Setting;

@Service
public class MemberService {
	@Autowired
	private SqlSession sqlSession;

	/**
	 * 이메일 인증 거치기 전 회원 가입
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param member
	 * @return
	 */
	public boolean insertMember(Member member) {
		MemberDao userDao = getMemberDao();

		boolean result = false;
		try {
			result = userDao.insertMember(member) > 0 ? true : false;
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} 
		return result;
	}

	/**
	 * 이메일 인증 
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param email
	 * @return
	 */
	public boolean joinMemberOk(String email) {
		MemberDao userDao = getMemberDao();
		boolean result = false;

		try {
			userDao.joinMemberOk(email);
			userDao.grantDefaultRole(email);
			userDao.grantDefaultSetting(email);
			result = true;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 멤버 수정
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param member
	 * @return
	 */
	public boolean updateMember(Member member) {
		MemberDao userDao = getMemberDao();
		boolean result = false;

		try {
			result = userDao.updateMember(member) > 0 ? true : false;
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} 

		return result;
	}

	/** 
	 * 멤버 삭제
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param email
	 * @return boolean
	 */
	public boolean deleteMember(String email) {
		MemberDao userDao = getMemberDao();
		boolean result = false;

		try {
			result = userDao.deleteMember(email) > 0 ? true : false;
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	public Member getMember(String email) {
		MemberDao userDao = getMemberDao();
		Member member = null;

		try {
			member = userDao.getMember(email);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} 

		return member;
	}

	/** 
	 * 전체 멤버 가져오기
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @return List<Member>
	 */
	public List<Member> getMembers() {
		MemberDao userDao = getMemberDao();
		List<Member> members = new ArrayList<Member>();

		try {
			members = userDao.getMembers();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return members;
	}

	/**
	 * 회원 가입된 이메일인지 확인
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param email
	 * @return boolean
	 */
	public boolean emailCheck(String email) {		
		MemberDao dao = getMemberDao();       
		boolean result = false;
		try {
			result = dao.emailCheck(email) != null ? true : false;
			
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public boolean changePassword(String email, String password) {
		MemberDao dao = getMemberDao();
		boolean result = false;

		try {
			result = dao.changePassword(email, password) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 회원 테마 설정 가져오기
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param email
	 * @return Setting
	 */
	public Setting getSetting(String email) {
		MemberDao dao = getMemberDao();
		Setting setting = new Setting();
		try {
			setting = dao.getSetting(email);
			// dark theme 일때
			if(setting.getThemeColor().equals("rgb(128, 128, 128)")) 
				setting.setSubColor("white");
			else
				setting.setSubColor("black");
				
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		System.out.println(setting);
		return setting;
	}

	/**
	 * 회원 테마 변경
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param email
	 * @param column
	 * @param value
	 * @return boolean
	 */
	public boolean updateSetting(String email, String column, String value) {
		System.out.println(email);
		System.out.println(column);
		System.out.println(value);
		MemberDao dao = getMemberDao();
		boolean result = false;
		try {
			result = dao.updateSetting(email, column, value) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * MemberDao 구하기
	 * @author 윤다정
	 * @since 2020/01/29 
	 * @return MemberDao
	 */
	private MemberDao getMemberDao() {
		return sqlSession.getMapper(MemberDao.class);
	}
}
