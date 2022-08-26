package com.owl.notice.dto;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Notice {
	private int projectIdx;
	private int boardIdx;
	private String email;
	private String title;
	private String content;
	private Date writeDate;
	private int readNum;
	private List<File> files;

	// UI 용
	private String name;
	
	public String getWriteDate() {
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(writeDate);
	}
}
