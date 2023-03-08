package com.multi.mvc.board.model.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import com.multi.mvc.board.model.vo.Board;
import com.multi.mvc.board.model.vo.Good;
import com.multi.mvc.board.model.vo.B_REPLY;

@Mapper
public interface BoardMapper {

	List<Board> selectBoardList(Map<String, String> map);
	List<Board> selectBoardList2(Map<String, String> map);
	List<Board> selectBoardList3();
	List<Board> selectBoardList4(Map<String, String> map);
	int selectBoardCount(Map<String, String> map);
	int selectBoardCount2(Map<String, String> map);
	int selectBoardCount4(Map<String, String> map);
	Board selectBoardByNo(int no);
	int insertBoard(Board board);
	int insertReply(B_REPLY reply);
	int updateBoard(Board board);
	int updateReadCount(Board board);
	int deleteBoard(int no);
	int deleteBoardReply(int no);
	Board nextText(Board board);
	Board prevText(Board board);
	void insertGood(Good good);
	void deleteGood(int memberNo);
	List<Good> selectGood(int boardNo);
	
}
