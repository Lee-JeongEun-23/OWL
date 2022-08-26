package com.owl.notice.dao;

import java.sql.SQLException;
import java.util.List;

import com.owl.notice.dto.File;
import com.owl.notice.dto.Notice;

public interface NoticeDao {
	public int insertNotice(Notice notice) throws ClassNotFoundException, SQLException;

	public int insertNoticeFile(File file) throws ClassNotFoundException, SQLException;

	public int deleteNotice(int noticeIdx) throws ClassNotFoundException, SQLException;

	public List<Notice> getNoticesByProjectIdx(int projectIdx) throws ClassNotFoundException, SQLException;

	public Notice getNotice(int boardIdx) throws ClassNotFoundException, SQLException;

	public List<File> getNoticeFiles(int boardIdx) throws ClassNotFoundException, SQLException;
	
	public int updateNotice(Notice notice) throws ClassNotFoundException, SQLException;
		
	public int deleteFile(int fileIdx) throws ClassNotFoundException, SQLException;
	
	public int setReadNum(int noticeIdx) throws ClassNotFoundException, SQLException;
}
