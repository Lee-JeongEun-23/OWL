package com.owl.notice.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.owl.helper.MemberHelper;
import com.owl.notice.dto.Notice;
import com.owl.notice.service.NoticeService;

@RestController
public class NoticeRestController {
	@Autowired
	private NoticeService service;

	@RequestMapping(value = "GetNotices.do", method = {RequestMethod.GET, RequestMethod.POST})
	public List<Notice> getNotices(int projectIdx) {
		System.out.println("getNotices : "+projectIdx);
		List<Notice> notices = service.getNoticesByProjectIdx(projectIdx);

		return notices;
	}

	@RequestMapping(value = "WriteNotice.do", method = RequestMethod.POST, consumes = { "multipart/form-data" })
	public int insertNotice(@RequestParam(value = "projectIdx") int projectIdx
									, @RequestParam(value = "content") String content
									, @RequestParam(value = "title") String title
									, @RequestParam(value = "multipartFiles", required = false) List<MultipartFile> multipartFiles
									, Principal principal, HttpServletRequest request) {		
		Notice notice = new Notice();
		notice.setProjectIdx(projectIdx);
		notice.setContent(content);
		notice.setTitle(title);
		notice.setEmail(MemberHelper.getMemberEmail(principal, request.getSession()));
		System.out.println(multipartFiles.size());
		
		boolean result= false;
		try {
			result = service.insertNotice(notice, multipartFiles, request.getServletContext().getRealPath("upload"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result ? notice.getBoardIdx() : -1;
	}
	
	@RequestMapping(value = "GetNotice.do", method = RequestMethod.POST)
	public Notice getNotice(int boardIdx) {
		
		return service.getNotice(boardIdx);
	}
	
	@RequestMapping(value = "DeleteNotice.do", method = RequestMethod.POST)
	public boolean deleteNotice(int noticeIdx) {
		return service.deleteNotice(noticeIdx);
	}
	@RequestMapping(value = "DeleteFile.do", method = RequestMethod.POST)
	public boolean deleteFile(int fileIdx) {
		return service.deleteFile(fileIdx);
	}
	@RequestMapping(value = "UpdateNotice.do", method = RequestMethod.POST, consumes = { "multipart/form-data" })
	public int updateNotice(@RequestParam(value = "boardIdx") int boardIdx
			, @RequestParam(value = "content") String content
			, @RequestParam(value = "title") String title
			, @RequestParam(value = "multipartFiles", required = false) List<MultipartFile> multipartFiles
			, Principal principal, HttpServletRequest request) {		
		Notice notice = new Notice();
		//notice.setProjectIdx(projectIdx);
		notice.setBoardIdx(boardIdx);
		notice.setContent(content);
		notice.setTitle(title);
		notice.setEmail(MemberHelper.getMemberEmail(principal, request.getSession()));
		System.out.println(multipartFiles.size());
		
		boolean result= false;
		try {
			result = service.updateNotice(notice, multipartFiles, request.getServletContext().getRealPath("upload"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result ? notice.getBoardIdx() : -1;
	}
	
	@RequestMapping("SetReadNum.do")
	public void setReadNum(int noticeIdx) {
		service.setReadNum(noticeIdx);
	}
}
