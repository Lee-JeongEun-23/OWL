package com.owl.drive.dto;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DriveFolder {
	private int driveIdx; //폴더식별번호
	private int projectIdx;
	private String folderName;
	private int ref;
	private int depth;
	private boolean isDelete;	
	private Date deleteDate;
	
	public String getDeleteDate() {
		String result = "";
		if (deleteDate != null)
			result = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(deleteDate);
		
		return result;
	}
}
