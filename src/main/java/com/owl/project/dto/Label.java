package com.owl.project.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Label {
	private int labelIdx;
	private int projectIdx;
	private String labelName;
	private String labelColor;
}
