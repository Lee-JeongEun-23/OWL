package com.owl.drive.dto;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Getter;
import lombok.ToString;
import lombok.Setter;

@Getter
@Setter
@ToString
public class DriveFile {
	private int driveFileIdx;
	private int driveIdx;
	private String creator;
	private String fileName;
	private int fileSize;
	private Date createDate;
	private Date deleteDate;
	private boolean isDelete;
	
	public String getCreateDate() {
		String result = "";
		if (createDate != null)
			result = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(createDate);

		return result;
	}
	
	public String getDeleteDate() {
		String result = "";
		if (deleteDate != null)
			result = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(deleteDate);
		
		return result;
	}
	private  String creatorName;
}
