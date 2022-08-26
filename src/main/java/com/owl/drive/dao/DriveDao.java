package com.owl.drive.dao;

import java.sql.SQLException;
import java.util.List;

import com.owl.drive.dto.DriveFile;
import com.owl.drive.dto.DriveFolder;

public interface DriveDao {
	public int insertMainFolder(DriveFolder drivefolder) throws ClassNotFoundException, SQLException;

	public int insertFolder(DriveFolder drivefolder) throws ClassNotFoundException, SQLException;

	public int insertFile(DriveFile file) throws ClassNotFoundException, SQLException;

	public int updateNewNameFolder(String folderName, int driveIdx) throws ClassNotFoundException, SQLException;

	public int updateFolder(DriveFolder drivefolder) throws ClassNotFoundException, SQLException;

	public List<DriveFolder> getDriveList(int projectIdx) throws ClassNotFoundException, SQLException;

	public List<DriveFile> getFileByFolderIdx(int folderIdx) throws ClassNotFoundException, SQLException;

	public List<DriveFolder> getFolderByFolderIdx(int folderIdx) throws ClassNotFoundException, SQLException;

	public List<DriveFile> getFileListinTrash(int projectIdx) throws ClassNotFoundException, SQLException;

	public List<DriveFolder> getFolderListinTrash(int projectIdx) throws ClassNotFoundException, SQLException;

	public String getFileName(int driveFileIdx) throws ClassNotFoundException, SQLException;

	public int deleteFolderFromDrive(int driveIdx) throws ClassNotFoundException, SQLException;

	public int deleteFileFromDrive(int driveFileIdx) throws ClassNotFoundException, SQLException;

	public int deleteFileFromTrash(int driveFileIdx) throws ClassNotFoundException, SQLException;

	public int deleteFoldersFromDrive(String driveIdxList) throws ClassNotFoundException, SQLException;
	
	public int deleteFilesFromDrive(String driveFileIdxList) throws ClassNotFoundException, SQLException;
	
	public int deleteFolderFromTrash(int driveFileIdx) throws ClassNotFoundException, SQLException;

	public int renameFile(int driveFileIdx, String fileName) throws ClassNotFoundException, SQLException;

	public int restoreFilefromTrash(int driveFileIdx) throws ClassNotFoundException, SQLException;

	public int restoreFolderfromTrash(int driveFileIdx) throws ClassNotFoundException, SQLException;
}
