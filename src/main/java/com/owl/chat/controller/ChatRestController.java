package com.owl.chat.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.owl.chat.dto.MyProjectsMates;
import com.owl.chat.service.ChatService;


@RestController
public class ChatRestController {
	
	@Autowired
	private ChatService service;
	
	
	
	@RequestMapping("MyProjectsMates.do")
	public List<MyProjectsMates> getMyProjectsMates(String email, String name) {
		System.out.println("나와 같은 프로젝트에 있는 사람들 뽑아내는 함수 타나요??");
		System.out.println("뷰단에서 데이타 들어 오나요??" + email+ " / " + name);
		List<MyProjectsMates> result = new ArrayList<MyProjectsMates>();
		
		try {
			result = service.getMyProjectsMates(email, name);
			System.out.println("디비에서 데이타 뽑히나요??? : " + result);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		
		return result;
	}
	
	@RequestMapping("MyProjectsMatesFull.do")
	public List<MyProjectsMates> getMyProjectsMatesFull(String email) {
		System.out.println("나와 같은 프로젝트에 있는 사람들 뽑아내는 함수 타나요??");
		System.out.println("뷰단에서 데이타 들어 오나요??" + email);
		List<MyProjectsMates> result = new ArrayList<MyProjectsMates>();
		
		try {
			result = service.getMyProjectsMatesFull(email);
			System.out.println("디비에서 데이타 뽑히나요??? : " + result);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		
		return result;
	}
	
}
