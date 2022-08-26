package com.owl.member.controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.owl.helper.UploadHelper;
import com.owl.member.dto.Member;
import com.owl.member.service.MemberService;

@Controller
public class MemberController {

	@Autowired
	private MemberService service;

	@RequestMapping(value = "DeleteAccount.do")
	public String deleteMember(HttpServletRequest request, Principal principal, Model model) {
		// 테스트 데이터
		System.out.println(principal.getName() + "delete 멤버");
		boolean result = service.deleteMember(principal.getName());
		request.getSession().removeAttribute("member");
		request.getSession().removeAttribute("setting");
		System.out.println("멤버 delete");
		String view = "";
		if (result) {
			view = "member/deleteOk";
		} else {
			view = "member/myProfileSetting";
		}
		System.out.println(request.getSession());
		return view;
	}

	@RequestMapping(value = "ResetPassword.do", method = RequestMethod.GET)
	public String showResetPasswordView(String memberId, Model model) {
		System.out.println("ResetPassword");
		model.addAttribute("email", memberId);
		return "member/resetPassword";
	}
}
