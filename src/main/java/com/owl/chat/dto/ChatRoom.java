package com.owl.chat.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatRoom {
	private int chatIdx;
	private String name;
	// private List<>
	private List<ChatUser> chatUsers;
	private ChatType typeCode;

	enum ChatType {
		PROJECT, 
		ONEONONE
	}
}
