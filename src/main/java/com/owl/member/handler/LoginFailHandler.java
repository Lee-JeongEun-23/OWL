package com.owl.member.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class LoginFailHandler implements AuthenticationFailureHandler {

	private String email;
	private String password;
	private String errorMessage;
	private String defaultFailureUrl;

	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		String inputEmail = request.getParameter("email");
		String inputPassword = request.getParameter("password");
		String message = "로그인 실패!";

		// https://docs.spring.io/spring-security/site/docs/3.1.x/apidocs/org/springframework/security/core/AuthenticationException.html참조
		if (exception instanceof BadCredentialsException) 
			message = "이메일 및 비밀번호를 확인해주세요.";
		else if (exception instanceof DisabledException) 
			message = "이메일 인증을 진행해주세요.";

		request.setAttribute(email, inputEmail);
		request.setAttribute(password, inputPassword);
		request.setAttribute(errorMessage, message);
		request.getRequestDispatcher(defaultFailureUrl).forward(request, response);
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public String getDefaultFailureUrl() {
		return defaultFailureUrl;
	}

	public void setDefaultFailureUrl(String defaultFailureUrl) {
		this.defaultFailureUrl = defaultFailureUrl;
	}
}
