package com.owl.chat.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.owl.chat.dao.ChatDao;
import com.owl.chat.dto.ChatRoom;
import com.owl.chat.dto.MyProjectsMates;
import com.owl.project.dao.ProjectDao;


@Service
public class ChatService {
	@Autowired
	private SqlSession sqlSession;

	public boolean insertChatRoom(ChatRoom room) {
		ChatDao dao = getChatDao();
		boolean result = false;

		try {
			result = dao.insertChatRoom(room) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	private ChatDao getChatDao() {
		return sqlSession.getMapper(ChatDao.class);
	}
	
	// chat  같은 프로젝트에 있는 유저를 뽑아내는 함수
	public List<MyProjectsMates> getMyProjectsMates(String email, String name) {
			ChatDao dao = getChatDao();
			List<MyProjectsMates> myprojectsmates = new ArrayList<MyProjectsMates>();
			
			try {
				myprojectsmates = dao.getMyProjectsMates(email,name);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			System.out.println("디비에서 같은 프로젝트 멤버 나오나요 사이즈는??"+ myprojectsmates.size());
			System.out.println("디비에서 같은 프로젝트 멤버 나오나요 ??" + myprojectsmates);
			
			return myprojectsmates;
			
			
	}
	
	// chat  같은 프로젝트에 있는 유저를 뽑아내는 함수 겹치는 사람도 같이 뽑는다..
	public List<MyProjectsMates> getMyProjectsMatesFull(String email) {
				ChatDao dao = getChatDao();
				List<MyProjectsMates> myprojectsmates = new ArrayList<MyProjectsMates>();
				
				try {
					myprojectsmates = dao.getMyProjectsMatesFull(email);
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				System.out.println("디비에서 같은 프로젝트 멤버 나오나요 사이즈는??"+ myprojectsmates.size());
				System.out.println("디비에서 같은 프로젝트 멤버 나오나요 ??" + myprojectsmates);
				
				return myprojectsmates;
				
				
	}
}
