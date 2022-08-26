package com.owl.drive.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.owl.drive.dao.DriveDao;
import com.owl.drive.dto.DriveFile;
import com.owl.drive.dto.DriveFolder;
import com.owl.helper.UploadHelper;

@Service
public class DriveService {
	@Autowired
	private SqlSession sqlSession;
	public void insertDriveFolder(DriveFolder drivefolder) {
		DriveDao dao = getDriveDao();
		try {
			dao.insertFolder(drivefolder);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public List<DriveFolder> getDriveList(int projectIdx) {
		DriveDao dao = getDriveDao();
		List<DriveFolder> folders = new ArrayList<DriveFolder>();

		try {
			folders = dao.getDriveList(projectIdx);
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return folders;
	}
	
	public boolean insertFile(DriveFile file) {
		DriveDao dao = getDriveDao();
		boolean result = false;
		
		try {
			result = dao.insertFile(file) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public Map<String, Object> getFolderData(int folderIdx) {
		DriveDao dao = getDriveDao();

		Map<String, Object> results = new HashMap<String, Object>();
		try {
			results.put("files", dao.getFileByFolderIdx(folderIdx));
			results.put("folders", dao.getFolderByFolderIdx(folderIdx));
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return results;
	}
	
	public void updateNewNameFolder(String folderName, int driveIdx) {
		DriveDao dao = getDriveDao();
		try {
			dao.updateNewNameFolder(folderName, driveIdx);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void updateFolder(DriveFolder drivefolder) {
		DriveDao dao = getDriveDao();
		try {
			dao.updateFolder(drivefolder);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	
	public Map<String, Object> getTrashList(int projectIdx) {
		DriveDao dao = getDriveDao();
		Map<String, Object> trashlist = new HashMap<String, Object>();

		try {
			trashlist.put("files", dao.getFileListinTrash(projectIdx));
			trashlist.put("folders", dao.getFolderListinTrash(projectIdx));
			
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return trashlist;
		}

	public boolean deleteFolderFromDrive(int driveIdx) {
		boolean reseult = false;
		DriveDao dao = getDriveDao();
		try {
			reseult = dao.deleteFolderFromDrive(driveIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return reseult;
	}
	
	public void deleteAllFileFromDrive(String driveFileIdxList) {
		DriveDao dao = getDriveDao();
		try {
			/* dao.deleteFoldersFromDrive(driveIdxList); */
			dao.deleteFilesFromDrive(driveFileIdxList);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
	
	
	public boolean deleteFileFromDrive(int driveFileIdx) {
		boolean reseult = false;
		DriveDao dao = getDriveDao();
		try {
			reseult = dao.deleteFileFromDrive(driveFileIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return reseult;
	}
	
	
	public boolean deleteFilefromTrash(int driveFileIdx) {
		boolean result = false;
		DriveDao dao = getDriveDao();
		try {
			result = dao.deleteFileFromTrash(driveFileIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	public boolean deleteFolderfromTrash(int driveFileIdx) {
		boolean result = false;
		DriveDao dao = getDriveDao();
		try {
			result = dao.deleteFolderFromTrash(driveFileIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		System.out.println("deleteFolderfromTrash result :" +result);
		return result;
	}
	
	
	public boolean renameFile(String uploadPath, int projectIdx, String[] refs, int driveIdx, int driveFileIdx, String newFileName) {
		boolean result =false;
		DriveDao dao = getDriveDao();

		try {
			result = UploadHelper.renameDriveFile(uploadPath, projectIdx, refs, driveIdx, dao.getFileName(driveFileIdx), newFileName);
			
			if(result)
				result = dao.renameFile(driveFileIdx, newFileName) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public boolean restoreFilefromTrash(int driveFileIdx) {
		System.out.println("in restoreFilefromTrash");
		System.out.println(driveFileIdx);
		boolean result = false;
		DriveDao dao = getDriveDao();

		try {
			result = dao.restoreFilefromTrash(driveFileIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
	}
	
	public boolean restoreFolderfromTrash(int driveFileIdx) {
		System.out.println("in restoreFolderfromTrash");
		System.out.println(driveFileIdx);
		boolean result = false;
		DriveDao dao = getDriveDao();

		try {
			result = dao.restoreFolderfromTrash(driveFileIdx) > 0 ? true : false;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * DriveDao 구하기
	 * @author 윤다정
	 * @since 2020/01/29 
	 * @return DriveDao
	 */
	private DriveDao getDriveDao() {
		return sqlSession.getMapper(DriveDao.class);
	}
}
