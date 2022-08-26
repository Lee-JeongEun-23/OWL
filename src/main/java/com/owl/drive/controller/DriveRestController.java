package com.owl.drive.controller;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.owl.drive.dto.DriveFile;
import com.owl.drive.dto.DriveFolder;
import com.owl.drive.service.DriveService;
import com.owl.helper.MemberHelper;
import com.owl.helper.UploadHelper;

@RestController
public class DriveRestController {

	@Autowired
	private DriveService service;

	/**
	 * 드라이브로 페이지 이동
	 * @author 이정은
	 * @since 2020/01/29
	 * @param modelAndView
	 * @return modelAndView
	 */
	@RequestMapping("GetDrive.do")
	public ModelAndView getDriveView(ModelAndView modelAndView) {
		modelAndView.setViewName("drive/drive");

		return modelAndView;
	}

	/**
	 * 드라이브 새 폴더 Insert
	 * @author 윤다정
	 * @since 2020/01/28
	 * @param drivefolder
	 * @param refs
	 * @param request
	 * @return drivefolder.getDriveIdx()
	 */
	@RequestMapping(value = "insertFolder.do")
	public int insertFolder(DriveFolder drivefolder, String[] refs, HttpServletRequest request) {
		try {
			drivefolder.setFolderName(drivefolder.getFolderName());
			drivefolder.setProjectIdx(drivefolder.getProjectIdx());
			drivefolder.setRef(drivefolder.getRef());
			drivefolder.setDepth(drivefolder.getDepth());
			service.insertDriveFolder(drivefolder);

			String uploadPath = request.getServletContext().getRealPath("upload");

			UploadHelper.makeDriveDirectory(uploadPath, drivefolder.getProjectIdx(), refs, drivefolder.getDriveIdx());
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return drivefolder.getDriveIdx();
	}

	/**
	 * 드라이브 폴더 Cut & Paste
	 * @author 이정은
	 * @since 2020/01/28
	 * @param drivefolder
	 * @param refs
	 * @param oldRef
	 * @param request
	 * @return boolean result
	 */
	@RequestMapping(value="cutFolder.do")
	public int cutFolder(DriveFolder drivefolder, String[] refs, int oldRef, HttpServletRequest request) {
		String oldPath = "";
		List<Integer> driveRefs = new ArrayList<Integer>();
		if (refs.length == 2) { // default 하위
			driveRefs.add(Integer.parseInt(refs[0])); //default
			oldPath = request.getServletContext().getRealPath("upload") + "\\project\\" 
									+ drivefolder.getProjectIdx() + "\\drive\\" +Integer.parseInt(refs[0])+"\\"+ oldRef +"\\"+ drivefolder.getDriveIdx();
		} else {
			driveRefs.add(Integer.parseInt(refs[1])); //default
			driveRefs.add(Integer.parseInt(refs[0])); 
			oldPath = request.getServletContext().getRealPath("upload") + "\\project\\" 
									+ drivefolder.getProjectIdx()+ "\\drive\\" +Integer.parseInt(refs[1]) +"\\" + drivefolder.getDriveIdx();
		}
		try {
			drivefolder.setFolderName(drivefolder.getFolderName());
			drivefolder.setProjectIdx(drivefolder.getProjectIdx());
			drivefolder.setRef(drivefolder.getRef());
			drivefolder.setDepth(drivefolder.getDepth());
			service.updateFolder(drivefolder);

			String uploadPath = request.getServletContext().getRealPath("upload");
			UploadHelper.moveDriveDirectory(oldPath, uploadPath, drivefolder.getProjectIdx(), driveRefs.stream().mapToInt(i -> i).toArray(), drivefolder.getDriveIdx());
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}		
		return drivefolder.getDriveIdx();
	}
	/**
	 * 드라이브 폴더 Copy & Paste
	 * @author 이정은
	 * @since 2020/01/29 
	 * @param drivefolder
	 * @param refs
	 * @param oldId
	 * @param parent
	 * @param request
	 * @return drivefolder.getDriveIdx()
	 */
	@RequestMapping(value="copyFolder.do")
	public int copyFolder(DriveFolder drivefolder, String[] refs, int oldId, int parent, HttpServletRequest request) {	
		String oldPath = "";
		List<Integer> driveRefs = new ArrayList<Integer>();
		if (refs.length == 2) { // default 하위
			oldPath = request.getServletContext().getRealPath("upload") + "\\project\\" 
					+ drivefolder.getProjectIdx() + "\\drive\\" +Integer.parseInt(refs[0])+ "\\"+ oldId;		
				if(parent ==Integer.parseInt(refs[0])) {
					driveRefs.add(Integer.parseInt(refs[0]));	 //default
				}else {	
					driveRefs.add(Integer.parseInt(refs[0]));
					driveRefs.add(parent);
				}					
		} else { //refs.length ==3
			oldPath = request.getServletContext().getRealPath("upload") + "\\project\\" 
					+ drivefolder.getProjectIdx() + "\\drive\\" +Integer.parseInt(refs[1])+ "\\"+Integer.parseInt(refs[0])+ "\\"+oldId;					
				driveRefs.add(Integer.parseInt(refs[1])); //default	
				driveRefs.add(parent);
		}        

		try {
			drivefolder.setFolderName(drivefolder.getFolderName());
			drivefolder.setProjectIdx(drivefolder.getProjectIdx());
			drivefolder.setRef(parent);
			drivefolder.setDepth(drivefolder.getDepth());
			service.insertDriveFolder(drivefolder);

			String uploadPath = request.getServletContext().getRealPath("upload");
			UploadHelper.copyDriveDirectory(oldPath, uploadPath, drivefolder.getProjectIdx(),
						driveRefs.stream().mapToInt(i -> i).toArray(), drivefolder.getDriveIdx());
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}		
		return drivefolder.getDriveIdx();
	}

	/**
	 * 드라이브 폴더 이름 수정
	 * @author 이정은
	 * @since 2020/01/28
	 * @param folderName
	 * @param driveIdx
	 * @param request
	 * @return boolean result
	 */
	@RequestMapping(value="updateNewName.do")
	public int updateNewNameFolder(String folderName , int driveIdx ,HttpServletRequest request) {
		service.updateNewNameFolder(folderName, driveIdx);	
		return driveIdx;
	}
	
	/**
	 * 드라이브 폴더 삭제 시 isDelete 1로 변경
	 * @author 이정은
	 * @since 2020/01/29
	 * @param driveIdx
	 * @return boolean result
	 */
	@RequestMapping(value="DeleteFolder.do", method = RequestMethod.POST)
	public boolean deleteFolder(int driveIdx) {
		return service.deleteFolderFromDrive(driveIdx);
	}
	
	@RequestMapping(value="DeleteAllFile.do", method = RequestMethod.POST)
	public boolean deleteAllFileFromDrive(String driveFileIdxList) {
		boolean result = false;
		/* System.out.println(driveIdxList); */
		System.out.println(driveFileIdxList);
		
		 service.deleteAllFileFromDrive(driveFileIdxList);	
		return result;
	}
	
	
	/**
	 * 드라이브 폴더 전체 List 출력
	 * @author 이정은
	 * @since 2020/01/29
	 * @param projectIdx
	 * @return List<DriveFolder>
	 */
	@RequestMapping(value = "DriveList.do")
	public List<DriveFolder> getDriveList(int projectIdx) {
		List<DriveFolder> folders = null;
		folders = service.getDriveList(projectIdx);
		return folders;
	}

	/**
	 * 드라이브 해당 폴더에 다중 파일 업로드
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param driveUploadFiles
	 * @param projectIdx
	 * @param folderIdx
	 */
	@RequestMapping("DriveFileUpload.do")
	public void driveFileUpload(@RequestParam("driveUploadFiles") List<MultipartFile> driveUploadFiles, int projectIdx, int folderIdx, String[] refs, HttpServletRequest request, Principal principal) {
		driveUploadFiles.forEach(file -> {
			String fileName = file.getOriginalFilename();
			String uploadPath = request.getServletContext().getRealPath("upload");

			DriveFile driveFile = new DriveFile();
			driveFile.setCreator(MemberHelper.getMemberEmail(principal, request.getSession()));
			driveFile.setDriveIdx(folderIdx);
			driveFile.setFileName(fileName);
			driveFile.setFileSize((int) (file.getSize() / 1024));
			
			String filePath = "";
			try {
				filePath = UploadHelper.uploadFileByProjectDrive(uploadPath, "drive", projectIdx, refs, folderIdx, fileName, file.getBytes());
				service.insertFile(driveFile);
			} catch (IOException e) {
				if (!filePath.isEmpty())
					UploadHelper.deleteFile(filePath);
				e.printStackTrace();
			}
		});
	}

	/**
	 * 드라이브에 해당하는 폴더의 파일들과 하위 폴더를 가져온다.
	 * @author 윤다정
	 * @since 2020/01/30
	 * @param folderIdx
	 * @return Map<String, Object>
	 */
	@RequestMapping(value = "GetFolderData.do")
	public Map<String, Object> getFolderData(int folderIdx) {
		return service.getFolderData(folderIdx);
	}
	
	
	/**
	 * @author 배인영
	 * @since 2020/01/29
	 * @param projectIdx
	 * @return Map<String, Object>
	 */
	@RequestMapping(value = "GetTrashList.do")
	public Map<String, Object> getTrashList(int projectIdx) {
		return service.getTrashList(projectIdx);
	}

	/**
	 * 드라이브 파일 삭제
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param driveFileIdx
	 * @return boolean 
	 */
	@RequestMapping(value = "DeleteDriveFile.do")
	public boolean deleteDriveFile(int driveFileIdx) {
		return service.deleteFileFromDrive(driveFileIdx);
	}
	
	/**
	 * 드라이브 파일 이름 변경
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param projectIdx
	 * @param refs
	 * @param driveIdx
	 * @param driveFileIdx
	 * @param newFileName
	 * @return boolean
	 */
	@RequestMapping(value = "RenameDriveFile.do")
	public boolean renameDriveFile(int projectIdx, String[] refs, int driveIdx, int driveFileIdx, String newFileName,
			HttpServletRequest request) {
		System.out.println("in renameDriveFile");
		System.out.println(driveFileIdx);
		
		String uploadPath = request.getServletContext().getRealPath("upload");
		return service.renameFile( uploadPath,  projectIdx, refs,  driveIdx,  driveFileIdx,  newFileName);
	}
	
	/**
	 * @author 배인영
	 * @since 2020/01/29
	 * @param driveFileIdx
	 * @return
	 */
	@RequestMapping(value = "DeleteFileFromTrash.do")
	public boolean deleteFilefromTrash(int driveFileIdx) {
		System.out.println("in DeleteFileFromTrash");
		
		
		return service.deleteFilefromTrash(driveFileIdx);
	}

	/**
	 * @author 배인영
	 * @since 2020/01/29
	 * @param driveFileIdx
	 * @return boolean
	 */
	@RequestMapping(value = "DeleteFolderfromTrash.do")
	public boolean DeleteFolderfromTrash(int driveFileIdx) {
		System.out.println("in DeleteFolderfromTrash");
		System.out.println(driveFileIdx);
		
		return service.deleteFolderfromTrash(driveFileIdx);
	}
		
		
	/**
	 * @author 배인영
	 * @since 2020/01/29
	 * @param driveFileIdx
	 * @return
	 */
	@RequestMapping(value = "RestoreFile.do")
	public boolean restoreFilefromTrash(int driveFileIdx) {
		System.out.println("in restoreFilefromTrash");
		System.out.println(driveFileIdx);

		return service.restoreFilefromTrash(driveFileIdx);
	}

	/**
	 * @author 배인영
	 * @since 2020/01/29
	 * @param driveFileIdx
	 * @return
	 */
	@RequestMapping(value = "RestoreFolder.do")
	public boolean restoreFolderfromTrash(int driveFileIdx) {
		System.out.println("in restoreFilefromTrash");
		System.out.println(driveFileIdx);

		return service.restoreFolderfromTrash(driveFileIdx);
}

	/**
	 *  드라이브 파일 다운로드 경로 구하기
	 * @author 윤다정
	 * @since 2020/01/29
	 * @param projectIdx
	 * @param folderIdx
	 * @param refs
	 * @param request
	 * @return downloadPath
	 */
	@RequestMapping(value = "GetDriveDownloadPath.do", method = RequestMethod.POST)
	public String getDriveDownloadPath(int projectIdx, int folderIdx, String[] refs, String fileName, HttpServletRequest request) {
		String path = UploadHelper.getDriveDownloadPath(projectIdx, folderIdx, fileName, refs);
		
		File temp = new File(path.replace("upload", request.getServletContext().getRealPath("upload")));

		return temp.exists() ? path : "";
	}
}
