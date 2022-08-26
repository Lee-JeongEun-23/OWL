package com.owl.helper;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Paths;

import org.apache.commons.io.FileUtils;

public class UploadHelper {
	/**
	 * upload 경로에 파일 업로드
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param uploadPath
	 * @param uploadType
	 * @param fileName
	 * @param content
	 * @return String
	 */
	public static String uploadFile(String uploadPath, String uploadType, String fileName, byte[] content) {
		uploadPath = Paths.get(uploadPath, uploadType).toString();
		makeDirectory(uploadPath);
		String path = Paths.get(uploadPath, fileName).toString();
		System.out.println(path);
		try (FileOutputStream fs = new FileOutputStream(path)) {
			fs.write(content);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return fileName;
	}

	/**
	 * 프로젝트에 해당하는 파일 업로드
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param uploadPath
	 * @param uploadType
	 * @param projectIdx
	 * @param fileName
	 * @param content
	 * @return String
	 */
	public static String uploadFileByProject(String uploadPath, String uploadType, int projectIdx, String fileName, byte[] content) {
		uploadPath = Paths.get(uploadPath, "project", Integer.toString(projectIdx), uploadType).toString();
		makeDirectory(uploadPath);

		String path = Paths.get(uploadPath, fileName).toString();
		try (FileOutputStream fs = new FileOutputStream(path)) {
			fs.write(content);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return path;
	}
	
	/**
	 * 프로젝트 드라이브 해당 디렉토리에 파일 업로드
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param uploadPath
	 * @param uploadType
	 * @param projectIdx
	 * @param refs
	 * @param folderIdx
	 * @param fileName
	 * @param content
	 * @return String
	 */
	public static String uploadFileByProjectDrive(String uploadPath, String uploadType, int projectIdx,String[] refs,int folderIdx, String fileName, byte[] content) {
		uploadPath = Paths.get(uploadPath
											, "project"
											, Integer.toString(projectIdx)
											, uploadType
											, getParentPath(refs)
											, Integer.toString(folderIdx)).toString();
		
		makeDirectory(uploadPath);
		
		String path = Paths.get(uploadPath, fileName).toString();
		try (FileOutputStream fs = new FileOutputStream(path)) {
			fs.write(content);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return path;
	}

	/**
	 * 프로젝트 드라이브에서 폴더 생성
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param uploadPath
	 * @param projectIdx
	 * @param refs
	 * @param driveIdx
	 */
	public static void makeDriveDirectory(String uploadPath, int projectIdx, String[] refs, int driveIdx) {
		String path = Paths.get(uploadPath
											, "project"
											, Integer.toString(projectIdx)
											, "drive"
											, getParentPath(refs)
											, Integer.toString(driveIdx)).toString();
		makeDirectory(path);
	}

	/**
	 * 프로젝트 드라이브 프로젝트 명으로 디폴트 디렉토리 생성
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param uploadPath
	 * @param projectIdx
	 * @param driveIdx
	 */
	public static void makeDefaultDirectory(String uploadPath, int projectIdx, int driveIdx) {
		String path = Paths.get(uploadPath
											, "project"
											, Integer.toString(projectIdx)
											, "drive"
											, Integer.toString(driveIdx)).toString();
		makeDirectory(path);
		System.out.println(path);
	}
	 
	 public static void copyDriveDirectory(String oldPath, String uploadPath, int projectIdx, int[] refs, int driveIdx) { 
		String refPath = "";
		 File oldDirectory = new File(oldPath);
				for (int i = 0; i < refs.length; i++) {
					if (i == refs.length - 1)
						refPath += refs[i];
					else
						refPath += refs[i] + File.separator;
				}
				String path = Paths.get(uploadPath, "project", Integer.toString(projectIdx), "drive", refPath, Integer.toString(driveIdx)).toString();
				makeDirectory(path);
		File newDirectory = new File(path);
		
			try {
			    FileUtils.copyDirectory(oldDirectory, newDirectory);
			} catch (Exception e) {
			    e.printStackTrace();
			}	   
	
	}

	 /**
	  * 파일 존재 확인 후 삭제
	  * @author 윤다정
	  * @since 2020/01/29
	  * @param path
	  */
	public static void deleteFile(String path) {
		File file = new File(path);
		if (file.exists())
			file.delete();
	}

	public static void moveDriveDirectory(String oldPath, String uploadPath, int projectIdx, int[] refs, int driveIdx) {
		String refPath = "";
		for (int i = 0; i < refs.length; i++) {
			if (i == refs.length - 1)
				refPath += refs[i];
			else
				refPath += refs[i] + File.separator;
		}
		String newPath = Paths.get(uploadPath
													, "project"
													, Integer.toString(projectIdx)
													, "drive"
													, refPath
													, Integer.toString(driveIdx)).toString();

		File oldDirectory = new File(oldPath);
		File newDirectory = new File(newPath);
		boolean isMove = oldDirectory.renameTo(newDirectory);
		System.out.println("파일 이동 성공 : " + isMove);
	}

	/**
	 * 드라이브 실 파일 이름 변경
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param uploadPath
	 * @param projectIdx
	 * @param refs
	 * @param driveIdx
	 * @param oldFileName
	 * @param newFileName
	 * @return boolean
	 */
	public static boolean renameDriveFile(String uploadPath, int projectIdx, String[] refs, int driveIdx, String oldFileName, String newFileName) {
		boolean result = false;
		String path = Paths.get(uploadPath
											, "project"
											, Integer.toString(projectIdx)
											, "drive"
											, getParentPath(refs)
											, Integer.toString(driveIdx)
											, oldFileName).toString();
		
		System.out.println(path);
		result = new File(path).renameTo(new File(path.replace(oldFileName, newFileName)));
		return result;
	}
	
	/**
	 * 드라이브 실 경로 구하기
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param projectIdx
	 * @param folderIdx
	 * @param fileName
	 * @param refs
	 * @return String
	 */
	public static String getDriveDownloadPath(int projectIdx, int folderIdx, String fileName, String[] refs) {
		return Paths.get("upload"
								, "project"
								, Integer.toString(projectIdx)
								, "drive"
								, getParentPath(refs)
								, Integer.toString(folderIdx)
								, fileName).toString();
	}
	
	/**
	 * 디렉토리 존재검사 후 없으면 생성
 	 * @author 윤다정
	 * @since 2020/01/29
	 * @param path
	 */
	private static void makeDirectory(String path) {
		File file = new File(path);
		if (!file.exists())
			file.mkdirs();
	}
	
	/**
	 * 드라이브 디폴트 디렉토리부터 경로 설정
	 * @author 윤다정
	 * @since 2019/01/29
	 * @param refs
	 * @return refPath
	 */
	private static String getParentPath(String[] refs) {
		String refPath = "";
		if (refs.length == 2)
			refPath = refs[0];
		else if (refs.length == 3)
			refPath = refs[1] + File.separator + refs[0];
		
		return refPath;
	}
}
