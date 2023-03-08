package com.multi.mvc.board.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.multi.mvc.board.model.service.BoardService;
import com.multi.mvc.board.model.vo.Board;
import com.multi.mvc.board.model.vo.Good;
import com.multi.mvc.board.model.vo.B_REPLY;
import com.multi.mvc.common.util.PageInfo;
import com.multi.mvc.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/Board") // 요청 url의 상위 url을 모두 처리할때 사용
@Controller
public class BoardController {
	
	@Autowired
	private BoardService service;
	
	@Autowired
	private ResourceLoader resourceLoader; // 파일 다운로드 기능시 활용하는 loader
	
//	@GetMapping("/board/list") // class 상단의 @RequestMapping로 인하여 /board 생략해야함
	@GetMapping("")
	public String list(Model model, @RequestParam Map<String, String> param) {
		log.info("리스트 요청, param : " + param);
		int page = 1;
		Map<String, String> searchMap = new HashMap<String, String>();
		try {
			String searchValue = param.get("searchValue");
			if(searchValue != null && searchValue.length() > 0) {
				String searchType = param.get("searchType");
				searchMap.put(searchType, searchValue);
			}
			page = Integer.parseInt(param.get("page"));
		} catch (Exception e) {}
		
		int boardCount = service.getBoardCount(searchMap);
		PageInfo pageInfo = new PageInfo(page, 5, boardCount, 15);
		List<Board> list = service.getBoardList(pageInfo, searchMap);
		
		model.addAttribute("list", list);
		model.addAttribute("param", param);
		model.addAttribute("pageInfo", pageInfo);
		return "/board";
	}
	
	
	@GetMapping("/notice")
	public String noticelist(Model model, @RequestParam Map<String, String> param) {
		log.info("리스트 요청, param : " + param);
		int page = 1;
		Map<String, String> searchMap = new HashMap<String, String>();
		try {
			String searchValue = param.get("searchValue");
			if(searchValue != null && searchValue.length() > 0) {
				String searchType = param.get("searchType");
				searchMap.put(searchType, searchValue);
			}
			page = Integer.parseInt(param.get("page"));
		} catch (Exception e) {}
		
		int boardCount = service.getBoardCount2(searchMap);
		PageInfo pageInfo = new PageInfo(page, 5, boardCount, 15);
		List<Board> list = service.getBoardList2(pageInfo, searchMap);
		String notice = "notice";
		
		
		model.addAttribute("noticelist", list);
		model.addAttribute("param", param);
		model.addAttribute("pageInfo", pageInfo);
		return "/notice";
	}
	

	
	@RequestMapping("/boardDetail")
	public String view(Model model, @RequestParam("no") int no) {
		Board board = service.findByNo(no);
		if(board == null) {
			return "redirect:error";
		}
		Board next = service.nextText(board);
		int nextnum = 9999;
		if(next!=null) {
			nextnum = next.getBoardNo();
		}
		Board prev = service.prevText(board);
		int prevnum = 9999;
		
		if(prev!=null) {
			prevnum = prev.getBoardNo();
		}
		
		List<Good> goodList = service.selectGood(no);
		List<Integer> memberNo = new ArrayList<Integer>();
		for (Good good : goodList) {
			memberNo.add(good.getMemberNo());
		}
		model.addAttribute("goodList", memberNo);
		model.addAttribute("board", board);
		model.addAttribute("replyList", board.getReplies());
		model.addAttribute("nextnum", nextnum);
		model.addAttribute("prevnum", prevnum);

		return "/boardDetail";
	}
	

	@GetMapping("/write")
	public String writeView(Model model,String type) {
		model.addAttribute("type", type);
		return "/write";
	}
	
	@PostMapping("/write")
	public String writeBoard(Model model, HttpSession session,
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			@ModelAttribute Board board,
			@RequestParam("upfile") MultipartFile upfile
			) {
		log.info("게시글 작성 요청");
		
		// 보안상의 코드라 프로젝트때는 없어도 된다. 잘못된 접근 체킹하는 예시
		if(loginMember.getId().equals(board.getWriterId()) == false) {
			model.addAttribute("msg", "잘못된 접근입니다.");
			model.addAttribute("location", "/");
			return "common/msg";
		}
		
		board.setMemberNo(loginMember.getMemberno());
		// 파일 저장 로직
		if(upfile != null && upfile.isEmpty() == false) {
			String rootPath = session.getServletContext().getRealPath("resources");
			String savePath = rootPath +"/upload/board";
			System.out.println(savePath);
			String renameFileName = service.saveFile(upfile, savePath); // 실제 파일 저장하는 로직
			
			if(renameFileName != null) {
				board.setOriginalFileName(upfile.getOriginalFilename());
				board.setRenamedFileName(renameFileName);
			}
		}
		
		System.out.println(board.getType());
		
		log.debug("board : " + board);
		int result = service.saveBoard(board);

		if(result > 0) {
			model.addAttribute("msg", "게시글이 등록 되었습니다.");
			if(board.getType().equals("공지사항")) {
				model.addAttribute("location", "/Board/notice");
			}else {
				model.addAttribute("location", "/Board");
			}
			
			
		}else {
			model.addAttribute("msg", "게시글 작성에 실패하였습니다.");
			if(board.getType().equals("공지사항")) {
				model.addAttribute("location", "/Board/notice");
			}else {
			model.addAttribute("location", "/Board");
			}
		}
		
		
		return "common/msg";
	}
	
	
	
	@RequestMapping("/reply")
	public String writeReply(Model model, 
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			@ModelAttribute B_REPLY reply
			) {
		reply.setMemberNo(loginMember.getMemberno());
		log.info("리플 작성 요청 Reply : " + reply);
		
		int result = service.saveReply(reply);
		
		if(result > 0) {
			model.addAttribute("msg", "댓글이 등록되었습니다.");
		}else {
			model.addAttribute("msg", "댓글 등록에 실패하였습니다.");
		}
		model.addAttribute("location", "/Board/boardDetail?no="+reply.getBoardNo());
		return "/common/msg";
	}
	
	@GetMapping("/update")
	public String updateView(Model model,
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			@RequestParam("no") int no
			) {
		Board board = service.findByNo(no);
		model.addAttribute("board",board);
		return "/update";
	}
	
	@PostMapping("/update")
	public String updateBoard(Model model, HttpSession session,
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			@ModelAttribute Board board,
			@RequestParam("reloadFile") MultipartFile reloadFile
			) {
		log.info("게시글 수정 요청");
		
		
		if(loginMember.getId().equals(board.getWriterId()) == false) {
			model.addAttribute("msg", "잘못된 접근입니다.");
			model.addAttribute("location", "/");
			return "common/msg";
		}
		
		board.setMemberNo(loginMember.getMemberno());
		System.out.println("DASFAAAAAAASAFDDDDDDDDDDDDDDDDD"+board.getBoardNo());
		// 파일 저장 로직
		if(reloadFile != null && reloadFile.isEmpty() == false) {
			String rootPath = session.getServletContext().getRealPath("resources");
			String savePath = rootPath +"/upload/board";
			
			// 기존 파일이 있는 경우 삭제
			if(board.getRenamedFileName() != null) {
				service.deleteFile(savePath + "/" +board.getRenamedFileName());
			}
			
			String renameFileName = service.saveFile(reloadFile, savePath); // 실제 파일 저장하는 로직
			
			if(renameFileName != null) {
				board.setOriginalFileName(reloadFile.getOriginalFilename());
				board.setRenamedFileName(renameFileName);
			}
		}
		
		log.debug("board : " + board);
		int result = service.saveBoard(board);
		
		if(result > 0) {
			model.addAttribute("msg", "게시글이 수정 되었습니다.");
			if(board.getType().equals("공지사항")) {
				model.addAttribute("location", "/Board/notice");
			}else {
				model.addAttribute("location", "/Board");
			}
			
			
		}else {
			model.addAttribute("msg", "게시글 수정에 실패하였습니다.");
			if(board.getType().equals("공지사항")) {
				model.addAttribute("location", "/Board/notice");
			}else {
				model.addAttribute("location", "/Board");
			}
		}
		
		
		return "common/msg";
	}
	
	
	@RequestMapping("/replyDel")
	public String deleteReply(Model model, 
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			int bReplyNo, int boardNo
			){
		log.info("리플 삭제 요청");
		int result = service.deleteReply(bReplyNo);
		
		if(result > 0) {
			model.addAttribute("msg", "댓글 삭제가 정상적으로 완료되었습니다.");
		}else {
			model.addAttribute("msg", "댓글 삭제에 실패하였습니다.");
		}
		model.addAttribute("location", "/Board/boardDetail?no=" + boardNo);
		return "/common/msg";
	}
	
	

	@RequestMapping("/delete")
	public String deleteBoard(Model model,  HttpSession session,
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			int boardNo, String boardType
			) {
		log.info("게시글 삭제 요청 boardNo : " + boardNo);
		
		String rootPath = session.getServletContext().getRealPath("resources");
		String savePath = rootPath +"/upload/board";
		int result = service.deleteBoard(boardNo, savePath);
		
		if(result > 0) {
			model.addAttribute("msg", "게시글 삭제가 정상적으로 완료되었습니다.");
		}else {
			model.addAttribute("msg", "게시글 삭제에 실패하였습니다.");
		}
		if(boardType.equals("공지사항")) {
			model.addAttribute("location", "/Board/notice");
		}else {
			model.addAttribute("location", "/Board");
		}
		
		return "/common/msg";
	}
	
	@RequestMapping("/fileDown")
	public ResponseEntity<Resource> fileDown(
			@RequestParam("oriname") String oriname,
			@RequestParam("rename") String rename,
			@RequestHeader(name= "user-agent") String userAgent){
		try {
			Resource resource = resourceLoader.getResource("resources/upload/board/" + rename);
			String downName = null;
			downName = new String(oriname.getBytes("UTF-8"), "ISO-8859-1"); // 크롬
			return ResponseEntity.ok()
					.header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=\"" + downName + "\"")
					.header(HttpHeaders.CONTENT_LENGTH, String.valueOf(resource.contentLength()))
					.header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM.toString())
					.body(resource);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 실패했을 경우
	}
	
	@ResponseBody 
	@PostMapping("/goodInsert")
	public void goodInsert(Model model,
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			@RequestBody Good good
			){
		System.out.println("쌍공!!!!!!!!!!!!");
		service.insertGood(good);
	}
	
	@ResponseBody 
	@PostMapping("/goodDelete")
	public void goodDelete(Model model,
			@SessionAttribute(name = "loginMember", required = false) Member loginMember,
			@RequestBody Good good
			){
		System.out.println("쌍공!!!!!!!!!!!!");
		service.deleteGood(good);
	}
	
	
	
	
}

