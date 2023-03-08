package com.multi.mvc.board.model.vo;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Good {
	private int goodNo;
	private int boardNo;
	private int MemberNo;
	
	public Good(int boardNo, int memberNo) {
		super();
		this.boardNo = boardNo;
		MemberNo = memberNo;
	}
	
	
}