package com.owl.helper;

import java.security.Principal;

import javax.servlet.http.HttpSession;

public class MemberHelper {
	public static String getMemberEmail(Principal principal, HttpSession session) {
		return principal != null ? principal.getName() : (String) session.getAttribute("memberEmail");
	}
}
