package com.owl.kanban.dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Column {
	private int colIdx;
	private int projectIdx;
	private String colname;
}
