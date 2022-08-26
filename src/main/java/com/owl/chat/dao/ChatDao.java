package com.owl.chat.dao;

import java.sql.SQLException;
import java.util.List;

import com.owl.chat.dto.ChatRoom;
import com.owl.chat.dto.ChatUser;
import com.owl.chat.dto.MyProjectsMates;


public interface ChatDao {
	// ChatRoom
	public int insertChatRoom(ChatRoom room) throws ClassNotFoundException, SQLException;

	public int deleteChatRoom(ChatRoom room) throws ClassNotFoundException, SQLException;

	// ChatUser
	public int insertChatUser(ChatUser user) throws ClassNotFoundException, SQLException;

	public int deleteChatUser(ChatUser user) throws ClassNotFoundException, SQLException;
	
	public List<MyProjectsMates> getMyProjectsMates(String email, String name) throws ClassNotFoundException, SQLException;
	
	public List<MyProjectsMates> getMyProjectsMatesFull(String email) throws ClassNotFoundException, SQLException;
}
