package com.multi.mvc.board.model.vo;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Board {
	private int no;
	private int boardNo;
	private int memberNo;
	private String writerId;
	private String id;
	private String title;
	private String content;
	private int good;
	private String type;
	private String originalFileName;
	private String renamedFileName;
	private int readcount;
	private String STATUS;
	private List<B_REPLY> replies;
	private Date createDate;
	private Date modifyDate;
	
	
}