package com.multi.mvc.board.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class B_REPLY {
	private int bReplyNo;
	private int boardNo;
	private int memberNo;
	private String content;
	private int good;	
	private int bad;	
	private String STATUS;	
	private Date createDate;
	private Date modifyDate;
	private String id;
}