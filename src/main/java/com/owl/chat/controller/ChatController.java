package com.owl.chat.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.owl.chat.service.ChatService;


@Controller
public class ChatController {
	@Autowired
	private ChatService service;
	
	@RequestMapping(value = "chatTest.do")
	public String emailConfirmOK(HttpServletRequest request,Model model) {
		System.out.println("in chatTest");
		//model.addAttribute("member",request.getSession().getAttribute("member"));
		//request.getSession().setAttribute("test", "어쩌구");
		return "chat/newChat2";
	}
	
	
	
}
