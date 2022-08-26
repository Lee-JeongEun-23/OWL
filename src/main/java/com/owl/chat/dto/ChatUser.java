package com.owl.chat.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatUser {
	private int chatUserIdx;
	private String email;
	private String name;
}
