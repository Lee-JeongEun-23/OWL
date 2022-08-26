package com.owl.notice.dto;

import lombok.Getter;
import lombok.ToString;
import lombok.Setter;

@Getter
@Setter
@ToString
public class File {
	private int fileIdx;
	private String writer;
	private String fileName;
	private String fileSize;
	private int boardIdx;
	private int issueIdx;
}
