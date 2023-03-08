package com.multi.mvc.board.model.service;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.multi.mvc.board.model.mapper.BoardMapper;
import com.multi.mvc.board.model.vo.Board;
import com.multi.mvc.board.model.vo.Good;
import com.multi.mvc.board.model.vo.B_REPLY;
import com.multi.mvc.common.util.PageInfo;

@Service
public class BoardService {

	@Autowired
	private BoardMapper mapper;
	
	
//	// Mysql 페이지 기반 코드
//	public List<Board> getBoardList(PageInfo pageInfo, Map<String, String> param){
//		param.put("limit", "" + pageInfo.getListLimit());
//		param.put("offset", "" + (pageInfo.getStartList() - 1));
//		return mapper.selectBoardList1(param);
//	}
	
	
	public int getBoardCount(Map<String, String> param) {
		return mapper.selectBoardCount(param);
	}
	
	public int getBoardCount2(Map<String, String> param) {
		return mapper.selectBoardCount2(param);
	}
	
	public int getBoardCount4(Map<String, String> param) {
		return mapper.selectBoardCount4(param);
	}

	
	public List<Board> getBoardList(PageInfo pageInfo, Map<String, String> param){
		param.put("limit", "" + pageInfo.getListLimit());
		param.put("offset", "" + (pageInfo.getStartList() - 1));
		return mapper.selectBoardList(param);
	}

	public List<Board> getBoardList2(PageInfo pageInfo, Map<String, String> param){
		param.put("limit", "" + pageInfo.getListLimit());
		param.put("offset", "" + (pageInfo.getStartList() - 1));
		return mapper.selectBoardList2(param);
	}

	public List<Board> getBoardList3(){
		return mapper.selectBoardList3();
	}
	
	public List<Board> getBoardList4(PageInfo pageInfo, Map<String, String> param){
		param.put("limit", "" + pageInfo.getListLimit());
		param.put("offset", "" + (pageInfo.getStartList() - 1));
		return mapper.selectBoardList4(param);
	}

	@Transactional(rollbackFor = Exception.class)
	public Board findByNo(int boardNo) {
		Board board = mapper.selectBoardByNo(boardNo); 
		board.setReadcount(board.getReadcount() + 1);  
		mapper.updateReadCount(board); 
		return board; 
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int saveBoard(Board board) {
		int result = 0;
		if(board.getBoardNo() == 0) {
			result = mapper.insertBoard(board);
		}else {
			result = mapper.updateBoard(board);
		}
		return result;
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int saveReply(B_REPLY reply) {
		return mapper.insertReply(reply);
	}
	
	public String saveFile(MultipartFile upFile, String savePath) {
		File folder = new File(savePath);
		
		// 폴더 없으면 만드는 코드
		if(folder.exists() == false) {
			folder.mkdir();
		}
		System.out.println("savePath : " + savePath);
		
		// 파일이름을 랜덤하게 바꾸는 코드, test.txt -> 20221213_1728291212.txt
		String originalFileName = upFile.getOriginalFilename();
		String reNameFileName = 
					LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmssSSS"));
		reNameFileName += originalFileName.substring(originalFileName.lastIndexOf("."));
		String reNamePath = savePath + "/" + reNameFileName;
		
		try {
			// 실제 파일이 저장되는 코드
			upFile.transferTo(new File(reNamePath));
		} catch (Exception e) {
			return null;
		}
		return reNameFileName;
	}
	
	public void deleteFile(String filePath) {
		File file = new File(filePath);
		if(file.exists()) {
			file.delete();
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int deleteBoard(int no, String rootPath) {
		Board board = mapper.selectBoardByNo(no);
		deleteFile(rootPath + "\\" + board.getRenamedFileName());
		return mapper.deleteBoard(no);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public int deleteReply(int no) {
		return mapper.deleteBoardReply(no);
	}
	public Board nextText(Board board) {
		return mapper.nextText(board);
	}
	public Board prevText(Board board) {
		return mapper.prevText(board);
	}
	public void insertGood(Good Good) {
		Board board = mapper.selectBoardByNo(Good.getBoardNo());
		board.setGood(board.getGood()+1);
		mapper.updateBoard(board);
		mapper.insertGood(Good);
	}
	public void deleteGood(Good Good) {
		Board board = mapper.selectBoardByNo(Good.getBoardNo());
		board.setGood(board.getGood()-1);
		mapper.updateBoard(board);
		mapper.deleteGood(Good.getMemberNo());
	}
	public List<Good> selectGood(int boardNo) {
		return mapper.selectGood(boardNo);
	}
}




