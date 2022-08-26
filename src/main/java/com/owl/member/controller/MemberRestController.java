package com.owl.member.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.ui.Model;
import org.springframework.ui.velocity.VelocityEngineFactoryBean;
import org.springframework.ui.velocity.VelocityEngineUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.owl.helper.MemberHelper;
import com.owl.helper.UploadHelper;
import com.owl.member.dto.Member;
import com.owl.member.dto.Setting;
import com.owl.member.service.MemberService;

@RestController
public class MemberRestController {
	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private VelocityEngineFactoryBean velocityEngineFactoryBean;

	@Autowired
	private MemberService service;

	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	/**
	 * 비밀번호 찾기 요청
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param email
	 * @return Map<String, Object>
	 */
	@RequestMapping(value = "ForgotPassword.do")
	public Map<String, Object> findPassword(String email) {
		Map<String, Object> map = new HashMap<String, Object>();
		boolean isMember = false;
		String message = "";
		isMember = true;

		// 회원 경우
		if (isMember) {
			isMember = true;
			try {
				MimeMessage content = mailSender.createMimeMessage();
				MimeMessageHelper messageHelper = new MimeMessageHelper(content, true, "UTF-8");
				Map<String, Object> models = new HashMap<String, Object>();
				models.put("memberId", email);

				String mailBody = VelocityEngineUtils.mergeTemplateIntoString(
						velocityEngineFactoryBean.createVelocityEngine(), "forgotPasswordTemplate.vm", "UTF-8", models);
				messageHelper.setSubject("[OWL] 비밀번호 재설정");
				messageHelper.setFrom("bit4owl@gmail.com");
				messageHelper.setTo(email);
				messageHelper.setText(mailBody, true);
				mailSender.send(content);
				message = "이메일을 전송했습니다." + "\n이메일을 확인해주세요.";
			} catch (Exception e) {
				System.out.println("이거 에러..>" + e.getMessage());
			}
		}
		// 비회원 경우
		else {
			message = "존재하지 않는 이메일입니다.";
		}

		map.put("result", isMember);
		map.put("message", message);

		return map;
	}


	// 비밀번호 확인
	@RequestMapping("chkDelPwd.do")
	public boolean chkDelPWd(String email, String password) throws Exception {
		System.out.println("email : " + email + " / password :" + password);
		Member member = service.getMember(email);
		String encodedPassword = member.getPassword();
		boolean result = bCryptPasswordEncoder.matches(password, encodedPassword);

		return result;
	}

	@RequestMapping("Emailcheck.do")
	public String emailCheck(String email, Model model) throws Exception {
		System.out.println("EmailCheck controller in");		
		boolean result = service.emailCheck(email);
		System.out.println(result);
		String data = "";
		if (result) {
			System.out.println("we have already this email");
			data = "false";

		} else {
			System.out.println("you can use this email");
			data = "true";
		}

		model.addAttribute("data", data);
		return data;
	}

	@RequestMapping(value = "ResetPassword.do", method = RequestMethod.POST)
	public boolean resetPassword(String email, String password) {
		password = bCryptPasswordEncoder.encode(password);
		boolean result = service.changePassword(email, password);
		System.out.println("ResetPassword post");
		System.out.println(result);
		return result;
	}

	/**
	 * 테마 변경
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param cmd
	 * @param value
	 * @param request
	 * @param principal
	 * @return
	 */
	@RequestMapping("SettingChange.do")
	public Setting settingChange(String cmd, String value, HttpServletRequest request, Principal principal) {
		if(value.equals("rgb(128, 128, 128)"))
			value = "black";
		boolean result = service.updateSetting(MemberHelper.getMemberEmail(principal, request.getSession()), cmd.toUpperCase(), value);
		Setting setting = null;
		if (result) {
			setting = service.getSetting(MemberHelper.getMemberEmail(principal, request.getSession()));
			request.getSession().setAttribute("setting", service.getSetting(MemberHelper.getMemberEmail(principal, request.getSession())));
		}

		return setting;
	}
	
	@RequestMapping("GetMyProfile.do")
	public Member getMember(Principal principal, Model model, HttpServletRequest request) {
		Member member = service.getMember(MemberHelper.getMemberEmail(principal, request.getSession()));
		model.addAttribute("member", member);
		return member;
	}
	
	@RequestMapping(value="UpdateMember.do", method = RequestMethod.POST, consumes = { "multipart/form-data" })
	public Member UpdateMember(@RequestParam(value = "password") String password,
												@RequestParam(value = "name") String name,
												@RequestParam(value = "profilePic" , required = false) MultipartFile profilePic,
												Principal principal, HttpServletRequest request, Model model) {
		Member member = new Member();

		try {
			String imagefilename = profilePic.getOriginalFilename();
			System.out.println(imagefilename);
			if (!imagefilename.equals("")) { // 실 파일 업로드
				String uploadpath = request.getServletContext().getRealPath("upload");
				String filePath = UploadHelper.uploadFile(uploadpath,"member", imagefilename, profilePic.getBytes());
				System.out.println(filePath);
				member.setProfilePic(imagefilename);
			}				
			member.setName(name);
			member.setPassword(bCryptPasswordEncoder.encode(password));
			member.setEmail(MemberHelper.getMemberEmail(principal, request.getSession()));
			service.updateMember(member);
			request.getSession().setAttribute("member", member);
			System.out.println(model);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return member;
	}
}
