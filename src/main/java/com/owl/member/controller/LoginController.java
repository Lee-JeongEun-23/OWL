package com.owl.member.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.social.google.connect.GoogleOAuth2Template;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.velocity.VelocityEngineFactoryBean;
import org.springframework.ui.velocity.VelocityEngineUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.owl.helper.MemberHelper;
import com.owl.helper.UploadHelper;
import com.owl.member.dto.Member;
import com.owl.member.service.GoogleService;
import com.owl.member.service.KaKaoService;
import com.owl.member.service.MemberService;
import com.owl.member.service.NaverService;
import com.owl.project.dto.ProjectList;
import com.owl.project.service.ProjectService;

@Controller
public class LoginController {

	@Autowired
	private MemberService service;
	
	@Autowired
	private ProjectService projectSerivce;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Autowired
	private VelocityEngineFactoryBean velocityEngineFactoryBean;
	
	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	private KaKaoService kaKaoService;

	@Autowired
	private NaverService naverService;
	
	@Autowired
	private GoogleService googleService;
	
    @Autowired
    private GoogleOAuth2Template googleOAuth2Template;
    
    @Autowired
    private OAuth2Parameters googleOAuth2Parameters;

    /**
     * 로그인 페이지 이동
     * @author 윤다정
     * @since 2020/01/29
     * @param session
     * @param model
     * @return String
     */
	@RequestMapping(value = "Login.do", method = RequestMethod.GET)
	public String showView(HttpSession session,Model model) {
		String naverUrl = naverService.getAuthorizationUrl(session);
		String kakaoUrl = kaKaoService.getAuthorizationUrl();
		String googleUrl = googleOAuth2Template.buildAuthenticateUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);
		
		model.addAttribute("naverUrl", naverUrl);
		model.addAttribute("kakaoUrl", kakaoUrl);
        model.addAttribute("googleUrl", googleUrl);
        
		return "member/login";
	}
	
	/**
	 * 로그인 완료후 메인화면 이동
     * @author 윤다정
     * @since 2020/01/29
	 * @param request
	 * @param principal
	 * @param model
	 * @return String
	 */
	@RequestMapping(value = "Main.do")
	public String showMainView(HttpServletRequest request, Principal principal, Model model) {
		Member member = service.getMember(MemberHelper.getMemberEmail(principal, request.getSession()));
		request.getSession().setAttribute("member", member);
		request.getSession().setAttribute("setting", service.getSetting(MemberHelper.getMemberEmail(principal, request.getSession())));

		checkJoinProjectMember(request, member.getEmail());
		List<ProjectList> projectList = null;
		projectList = projectSerivce.getProjectLists(member.getEmail());
		model.addAttribute("projectList", projectList);

		return "member/main";
	}
	
	/** 
	 * 로그인 화면 이동
     * @author 윤다정
     * @since 2020/01/29
	 * @return String
	 */
	@RequestMapping(value = "ReturnLogin.do")
	public String returnLogin() {
		return "member/login";
	}

	/**
	 * kakao로 로그인 시 회원가입 여부 확인 후 메인 이동
	 * @author 윤다정
     * @since 2020/01/29
	 * @param code
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "KakaoLogin.do", produces = "application/json")
	public String kakaoLogin(@RequestParam("code") String code, HttpSession session) throws Exception {
		Member member = kaKaoService.getMemberInfo(code);

		if (member != null && !member.getEmail().isEmpty()) 
			snsJoinCheck(member);
			
		session.setAttribute("memberEmail", member.getEmail());
		return "redirect:Main.do";
	}

	/**
	 * naver로 로그인 시 회원가입 여부 확인 후 메인 이동
	 * @author 윤다정
     * @since 2020/01/29
	 * @param code
	 * @param state
	 * @param session
	 * @param model
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("NaverLogin.do")
	public String naverLogin(@RequestParam String code, @RequestParam String state, HttpSession session, Model model)
			throws IOException {
		Member member = naverService.getMemberInfo(session, code, state);
		
		if (member != null && !member.getEmail().isEmpty()) 
			snsJoinCheck(member);

		session.setAttribute("memberEmail", member.getEmail());
		return "redirect:Main.do";
	}

	/**
	 * google로 로그인 시 회원가입 여부 확인 후 메인 이동
	 * @author 윤다정
     * @since 2020/01/29
	 * @param code
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "GoogleLogin.do")
    public String doSessionAssignActionPage(String code, HttpSession session, Model model) throws Exception {
		Member member= googleService.getMemberInfo(code);
	
		if (member != null && !member.getEmail().isEmpty()) 
			snsJoinCheck(member);

		session.setAttribute("memberEmail", member.getEmail());
		return "redirect:Main.do";
    }

	/**
	 * 회원가입 화면 요청
	 * @author 윤다정
     * @since 2020/01/29
	 * @param model
	 * @return String
	 */
	@RequestMapping(value = "Register.do", method = RequestMethod.POST)
	public String showRegister( Model model) {
		model.addAttribute("show", "join");

		return "member/login";
	}
	
	/**
	 * 회원가입 완료 멤버에게 이메일 발송
	 * @author 윤다정
     * @since 2020/01/29
	 * @param member
	 * @param model
	 * @param request
	 * @return String
	 */
	@RequestMapping(value = "EmailConfirm.do", method = RequestMethod.POST)
	public String emailConfirm(Member member, Model model, HttpServletRequest request) {
		String imagefilename = member.getMultipartFile().getOriginalFilename();
		boolean result = false;
		try {
			if (!imagefilename.equals("")) { // 실 파일 업로드
				String uploadpath = request.getServletContext().getRealPath("upload");
				String filePath = UploadHelper.uploadFile(uploadpath,"member", imagefilename, member.getMultipartFile().getBytes());
				member.setProfilePic(filePath);
			}

			member.setPassword(bCryptPasswordEncoder.encode(member.getPassword())); // 비밀번호 암호화
			result = service.insertMember(member);

			if (result) {
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
				Map<String, Object> models = new HashMap<String, Object>();
				models.put("memberId", member.getEmail());
				models.put("name", member.getName());

				String mailBody = VelocityEngineUtils.mergeTemplateIntoString(
						velocityEngineFactoryBean.createVelocityEngine(), "joinTemplate.vm", "UTF-8", models);
				messageHelper.setSubject("[OWL] 가입을 환영합니다.");
				messageHelper.setFrom("bit4owl@gmail.com");
				messageHelper.setTo(member.getEmail());
				messageHelper.setText(mailBody, true);
				mailSender.send(message);

				model.addAttribute("mail", member.getEmail());
				model.addAttribute("show", "joinEmail");
			} else {
				model.addAttribute("show", "join");
			}
		} catch (Exception e) {
			System.out.println("이거 에러..>" + e.getMessage());
			model.addAttribute("show", "join");
		}

		return "member/login";
	}
	
	/**
	 * 초대 회원으로 이메일 인증 없이 바로 로그인 화면 요청
	 * @author 윤다정
     * @since 2020/01/29
	 * @param member
	 * @param model
	 * @param request
	 * @return String
	 */
	@RequestMapping(value = "EmailConfirmPass.do")
	public String emailConfirmPass(Member member, Model model, HttpServletRequest request) {
		String imagefilename = member.getMultipartFile().getOriginalFilename();
		try {
			if (!imagefilename.equals("")) { // 실 파일 업로드
				String uploadpath = request.getServletContext().getRealPath("upload");
				String filePath = UploadHelper.uploadFile(uploadpath,"member", imagefilename, member.getMultipartFile().getBytes());
				member.setProfilePic(filePath);
			}

			member.setPassword(bCryptPasswordEncoder.encode(member.getPassword())); // 비밀번호 암호화
			service.insertMember(member);
			service.joinMemberOk(member.getEmail());
		} catch (Exception e) {
			System.out.println("이거 에러..>" + e.getMessage());
			model.addAttribute("show", "join");
		}
		
		model.addAttribute("email", member.getEmail());
		return "member/login";
	}

	/**
	 * 회원가입 이메일인증 완료 
	 * @author 윤다정
     * @since 2020/01/29
	 * @param memberId
	 * @param model
	 * @return String
	 */
	@RequestMapping(value = "EmailConfirmOk.do")
	public String emailConfirmOK(String memberId, Model model) {
		service.joinMemberOk(memberId);

		model.addAttribute("show", "joinOk");
		model.addAttribute("memberId", memberId);
		return "index";
	}
	
	/**
	 * 프로젝트에 초대된 멤버인지 확인
	 * @author 윤다정
     * @since 2020/01/29
	 * @param request
	 * @param email
	 */
	private void checkJoinProjectMember(HttpServletRequest request, String email) {
		if (request.getSession().getAttribute("joinProjectIdx") != null) {
			int projectIdx = Integer.parseInt(request.getSession().getAttribute("joinProjectIdx").toString());
			projectSerivce.insertProjectMember(projectIdx, request.getSession().getAttribute("joinProjectPm").toString(), email);
			request.getSession().removeAttribute("joinProjectIdx");
			request.getSession().removeAttribute("joinProjectPm");
		}
	}
	
	/**
	 * sns 로그인시 회원가입 이력없으면 가입
	 * @author 윤다정
     * @since 2020/01/29
	 * @param member
	 */
	private void snsJoinCheck(Member member) {
		if (service.getMember(member.getEmail()) == null)
			service.insertMember(member);
	}
}
