package com.owl.member.dao;

import java.sql.SQLException;
import java.util.List;

import com.owl.member.dto.Member;
import com.owl.member.dto.Setting;

public interface MemberDao {
	public int insertMember(Member member) throws ClassNotFoundException, SQLException;

	public int joinMemberOk(String email) throws ClassNotFoundException, SQLException;

	public int grantDefaultRole(String email) throws ClassNotFoundException, SQLException;
	
	public int grantDefaultSetting(String email) throws ClassNotFoundException, SQLException;

	public int updateMember(Member member) throws ClassNotFoundException, SQLException;

	public int deleteMember(String email) throws ClassNotFoundException, SQLException;

	public Member getMember(String email) throws ClassNotFoundException, SQLException;

	public List<Member> getMembers() throws ClassNotFoundException, SQLException;

	public Member emailCheck(String email) throws ClassNotFoundException, SQLException;

	public int changePassword(String email, String password) throws ClassNotFoundException, SQLException;
	
	public Setting getSetting(String email)throws ClassNotFoundException, SQLException;
	
	public int updateSetting(String email, String column, String value)throws ClassNotFoundException, SQLException;
}
