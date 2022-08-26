package com.owl.notice.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.owl.helper.UploadHelper;
import com.owl.notice.dao.NoticeDao;
import com.owl.notice.dto.File;
import com.owl.notice.dto.Notice;


@Service
public class NoticeService {
	@Autowired
	private SqlSession sqlSession;
	
	@Transactional
	public boolean insertNotice(Notice notice, List<MultipartFile> multipartFiles, String uploadPath) throws Exception{
		NoticeDao dao = getNoticeDao();
		boolean result = false;
		
		try {
			result = dao.insertNotice(notice) > 0 ? true : false;

			if (multipartFiles.size() > 0) 
				notice.setFiles(insertNoticeFiles(dao, notice.getEmail(),notice.getProjectIdx(),notice.getBoardIdx(), multipartFiles, uploadPath));

		} catch (Exception e) {
			throw e; 
		}

		return result;
	}
	
	private List<File> insertNoticeFiles(NoticeDao dao, String email, int pojectIdx, int boardIdx, List<MultipartFile> multipartFiles, String uploadPath) {
		List<File> files = new ArrayList<File>();

		multipartFiles.forEach(multipartFile -> {
			String fileName = multipartFile.getOriginalFilename();
			System.out.println(fileName);
			try {
				UploadHelper.uploadFileByProject(uploadPath, "file", pojectIdx, fileName, multipartFile.getBytes());
			} catch (IOException e) {
				e.printStackTrace();
			}

			File file = new File();
			file.setBoardIdx(boardIdx);
			file.setFileName(fileName);
			file.setWriter(email);
			file.setFileSize(String.valueOf(multipartFile.getSize()/1024));
			
			try {
				dao.insertNoticeFile(file);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			files.add(file);
		});

		return files;
	}

	public List<Notice> getNoticesByProjectIdx(int projectIdx) {
		NoticeDao dao = getNoticeDao();
		List<Notice> notices = null;
		try {
			notices = dao.getNoticesByProjectIdx(projectIdx);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
			System.out.println("날짜는?" + notices);
		return notices;
	}

	public Notice getNotice(int boardIdx) {
		NoticeDao dao = getNoticeDao();
		Notice notice = new Notice();
		try {
			notice = dao.getNotice(boardIdx);
			notice.setFiles(dao.getNoticeFiles(boardIdx));
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return notice;
	}
	
	public boolean deleteNotice(int noticeIdx) {
		NoticeDao dao = getNoticeDao();
		boolean result = false;
		try {
			result = dao.deleteNotice(noticeIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	public boolean deleteFile(int fileIdx) {
		NoticeDao dao = getNoticeDao();
		boolean result = false;
		try {
			result = dao.deleteFile(fileIdx)> 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	@Transactional
	public boolean updateNotice(Notice notice, List<MultipartFile> multipartFiles, String uploadPath) throws Exception{
		NoticeDao dao = getNoticeDao();
		boolean result = false;
		System.out.println(notice.getEmail());
		try {
			result = dao.updateNotice(notice) > 0 ? true : false;

			System.out.println(multipartFiles.size());
			if (multipartFiles.size() > 0) 
				notice.setFiles(insertNoticeFiles(dao, notice.getEmail(),notice.getProjectIdx(),notice.getBoardIdx(), multipartFiles, uploadPath));

		} catch (Exception e) {
			System.out.println("Trans 예외 발생 : " + e.getMessage());
			throw e; 
		}

		return result;
	}
	
	public void setReadNum(int noticeIdx) {
		System.out.println("in setReadNum" + noticeIdx);
		NoticeDao dao = getNoticeDao();
		try {
			dao.setReadNum(noticeIdx);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
	}
	
	private NoticeDao getNoticeDao() {
		return sqlSession.getMapper(NoticeDao.class);
	}
}
