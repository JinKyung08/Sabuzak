<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>


 <link rel="stylesheet" href="${path}/resources/css/boardDetail.css">

    <!-- 게시글 상세보기 start!!!!!!!!!!!!-->
    <div class="my_div my_bg">  
      
      <!-- 게시판상세 메인 이미지-->
      <section class="boardMain">
        <img src="${path}/resources/img/boardMainImage.JPG" style="width: 100%; height: 500px;">
        <h1 class="main_image_text" style="font-size:50px">게시판</h1>
      </section>

      
      
      <div class="container">
        <div class="row pt-sm-2 pt-lg-0">

           <!--breadcrumb-->
          <section id="bc" class="container">
            <ol id="bc2" class="breadcrumb">
              <li class="breadcrumb-item doing">
                <a href="${path}">
                  <i class="ai-home fs-base me-2"></i>
                  Home
                </a>
              </li>
              <li class="breadcrumb-item"><a href="${path}/Board">게시판</a></li>
              <li class="breadcrumb-item active" aria-current="page" id="brMuName">게시글 상세보기</li>
            </ol>
          </section>

          <!-- 게시판 상세보기 -->
          <section class="container ">
            <h3 class="boardDetail_text">게시글 상세보기</h3>
                        
                      
          <div class="bd">
              <div class="ct">
              <!-- 게시글 카테고리  -->
                <div class="category" name="category" style="width:100px; margin-left:20px" >
                  <span id="type"><c:out value="${board.type}"/></span>
                </div>
              <!--제목-->
              <div id="tt" class="input-group input-group-sm">
                <input type="text" class="form-control" name="title" id="title" value="${board.title}"readonly>
              </div>

              <!--작성자 작성일 조회수 좋아요-->
            <div class="etcetc">
              <div class="etc">
                <div class="name" id="memberNo" style="margin-left: 20px;">
                <c:out value="${board.id}"/>
                </div>
                <div class="createDate" id="createDate" style="margin-left: 20px;"><fmt:formatDate type="both" value="${board.createDate}"/></div>
                <div class="readCount" id="readcount" style="margin-left: 20px;">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-fill" id="icon" viewBox="0 0 16 16">
                    <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                    <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                  </svg><c:out value="${board.readcount}"/></div>
                <div class="likecount" id="good" style="margin-left: 20px;">
                <i class="ai-like" id="icon"></i><c:out value="${board.good}"/></div>
              </div>
            </div>
            
            <!-- Textarea -->
            <div class="content mb-3">
              <textarea class="form-control my-4" id="content" rows="20" name="content" readonly><c:out value="${board.content}"/></textarea>
            </div>
            
            <!-- File  -->
            <div class="file mb-3" >
            <c:if test="${ !empty board.originalFileName }">
              <a href="javascript:fileDownload('${board.originalFileName}','${board.renamedFileName}')"id="renamedFileName">
              <button type="button" class="btn btn-outline-primary">첨부파일</button>
              <img src="${path}/resources/img/file.png" width="20" height="20"/>
              <c:out value="${board.originalFileName}"></c:out>	
              </a>
              <script>
				function fileDownload(oriname, rename) {
					const url = "${path}/Board/fileDown";
							
					var oName = encodeURIComponent(oriname);
					var rName = encodeURIComponent(rename);

					location.assign(url + "?oriname=" + oName + "&rename=" + rName);
				}
			</script>
			</c:if>
			<c:if test="${empty board.originalFileName}">
				<span> - </span>
			</c:if>
            </div> 

            <!--좋아요-->
            <c:choose>
            <c:when test="${ !empty loginMember }">
            <div class="like" >
            	<input type="hidden" value="0" id="dummy">
              <button type="button" class="btn btn-secondary active" id="boardLike" ><i class="ai-like"></i>좋아요</button>
            </div>
            </c:when>
            <c:otherwise>
            	<div class="like" >
	            	<input type="hidden" value="0" id="dummy">
	              	<button type="button" class="btn btn-secondary active" onclick="alert('로그인이 필요합니다.')" ><i class="ai-like"></i>좋아요</button>
	            </div>
            </c:otherwise>
            </c:choose>

            <!--수정 삭제 목록 글쓰기-->
            <div class="crud">
              <c:if test="${not empty loginMember && (loginMember.memberno == board.memberNo 
									|| loginMember.role == 'ROLE_ADMIN')}">
                <button type="button" class="btn btn-primary btn-sm" id="boardUp">수정</button>
                <button type="button" class="btn btn-primary btn-sm" id="boardDel">삭제</button>
			  </c:if>
			  
			<c:if test="${board.type == '자유게시판'}">
			  <c:choose>
            	<c:when test="${ !empty loginMember }">			 	
                	<button type="button" class="btn btn-primary btn-sm" id="wr" onclick="location.href='${path}/Board/write'">글쓰기</button>
  				</c:when>
  				<c:otherwise>
  					<button type="button" class="btn btn-primary btn-sm" id="wr" onclick="alert('로그인이 필요합니다.')">글쓰기</button>
            	</c:otherwise>
              </c:choose>
             	<button type="button" class="btn btn-primary btn-sm" onclick="location.href='${path}/Board'">목록</button>
            </c:if>
             <c:if test="${board.type == '공지사항'}">
             <c:if test="${not empty loginMember && loginMember.role == 'ROLE_ADMIN'}">
                <button type="button" class="btn btn-primary btn-sm" id="wr" onclick="location.href='${path}/Board/write'">글쓰기</button>
              </c:if>
            	<button type="button" class="btn btn-primary btn-sm" onclick="location.href='${path}/Board/notice'">목록</button>
            	</c:if>
            </div>
           
			

            </div>
          </div>
          </section>
                    
       <!-- 댓글!!!!!!!!!!!!!-->
      <section class="">
        <div class="container ">
          <div class="replyHead">
            <h5>댓글</h5>
          </div>
          
          <!--댓글-->
          <div class="replyWrite">
	<c:if test="${!empty replyList}">
		<c:forEach var="reply" items="${replyList}">
            <div class="reviewlist">
              <h6 class="replyName" id="bReplyNo">${reply.id}</h6> 
              
              <div class="replyDate" id="createDate"><fmt:formatDate type="both" value="${reply.createDate}"/></div>
           <c:choose>
            <c:when test="${ !empty loginMember && (loginMember.id == reply.id || loginMember.role == 'ROLE_ADMIN') }">
              <div class="trashbtn">
                <button class="btn btn-icon btn-sm btn-light bg-light border-0 rounded-circle zindex-5 " onclick="deleteReply('${reply.BReplyNo}','${board.boardNo}');" type="button"><i class="ai-trash fs-xl text-danger"></i></button>
              </div>
            </c:when>
            <c:otherwise>
            	<div class="trashbtn">
                <button class="btn btn-icon btn-sm btn-light bg-light border-0 rounded-circle zindex-5 " onclick="deleteReply('${reply.BReplyNo}','${board.boardNo}');" type="button" style="visibility: hidden;"><i class="ai-trash fs-xl text-danger"></i></button>
              </div>
            </c:otherwise>
           </c:choose> 
              <p class="replyContent" id="content"><c:out value="${reply.content}"/></p> 
            </div>
            
     	</c:forEach>
     	
	</c:if>      
           <c:if test="${empty replyList}">
			<tr>
				<td colspan="3" style="text-align: center;">등록된 댓글이 없습니다.</td>
			</tr>
		</c:if>

          </div>

          <button type="button" class="btn btn-primary rounded-pill" id="seeMore">리뷰더보기</button>

		 <c:if test="${ !empty loginMember}">
          <!-- 댓글달기-->
          <form action="${path}/Board/reply" method="post"> 
            <div class="input-group" style="background-color: #fff;" >
              <input type="hidden" name="memberNo" value="${loginMember.memberno}" />
              <input type="hidden" name="boardNo" value="${board.boardNo}" />
              <textarea name="content" class="form-control border" id="reWrtie"style="background-color: #fff;" placeholder="댓글을 작성해주세요~" rows="4" data-bind-characters-target="#charactersRemaining"  maxlength="1000" required></textarea>
              <button type="submit"  class="btn btn-primary" id="replybtn" >등록</button>
             
             <script>
             	$(function () {
             	    $('#reWrtie').keydown(function () {
             	        var inputTextLength = $(this).val().length;//글자수
             	        if (inputTextLength > 1000)
             	        {
             	            $(this).val($(this).val().substring(0, 1000));
             	        }
             	        var inputPossible = 1000 - ($(this).val().length);
             	        $('.textLength').html(inputPossible);
             	    });
             	}); 
             </script>
            </div> 
              <small class="font-weight-light mx-3">글자수
              <span class="textLength" id="charactersRemaining">1000</span>자 이내</small>
          </form>
		</c:if>      
        </div>
                  <!-- 이전글 다음글-->
                  <div class="pn">
                    <nav aria-label="Page navigation example">
                      <ul class="pagination">
                        <li class="page-item" id="pi">
                          <a href="javascript:void(0);" onclick="npPage('${nextnum}');" class="page-link" >
                            <i class="ai-arrow-left fs-xl mb-1"></i>
                            이전글
                          </a>
                        </li>
                        
                        <li class="page-item" id="pi">
                          <a href="javascript:void(0);" onclick="npPage('${prevnum}');" class="page-link">
                            다음글
                            <i class="ai-arrow-right fs-xl mb-1"></i>
                          </a>
                        </li>
                      </ul>
                    </nav>
                  </div>
      </section>
            
                    



        </div>
      </div>
    </div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>

<script>
		//게시글 삭제
	$(document).ready(() => {
		
		$("#boardUp").on("click", (e) => {
			location.href = "${path}/Board/update?no=${board.boardNo}";
		});
		
		$("#boardDel").on("click", (e) => {
			if(confirm("정말로 게시글을 삭제 하시겠습니까?")) {
				location.replace("${path}/Board/delete?boardNo=${board.boardNo}&boardType=${board.type}");
			}
		});
		
		
		
		// 좋아요
		
		var isboardlikeChecked = false;
		var goodList = ${goodList};
		
		var loginMemberNo = '<c:out value="${loginMember.memberno}"/>';
		for (var i = 0; i < goodList.length; i++) {
			if(goodList[i]==loginMemberNo){
				isboardlikeChecked = true;
			}
		}
		
		
		if (isboardlikeChecked == false)
		{
		    $('#boardLike').attr('class', 'btn btn-secondary active');
		} else if (isboardlikeChecked == true)
		{
		    $('#boardLike').attr('class', 'btn btn-primary active');
		}

		$('#boardLike').on('click', function () {
			var boardNo = ${board.boardNo};
			var memberNo = '<c:out value="${loginMember.memberno}"/>';
		    isboardlikeChecked = !isboardlikeChecked;
		    if (isboardlikeChecked == false)
		    {
		        $(this).attr('class', 'btn btn-secondary active');
		        $.ajax({
		    		type :'post',
		    		url : '<c:url value ="/Board/goodDelete"/>',
		    		contentType: 'application/json',
		    		data : JSON.stringify(
		    				{
		    					"boardNo":boardNo,
		    					"memberNo":memberNo
		    				}),
		    		success : function(result){
		    			location.reload();
		    		}
		    	});
		        
		    } else if (isboardlikeChecked == true)
		    {
		        $(this).attr('class', 'btn btn-primary active');
		        $.ajax({
		    		type :'post',
		    		url : '<c:url value ="/Board/goodInsert"/>',
		    		contentType: 'application/json',
		    		data : JSON.stringify(
		    				{
		    					"boardNo":boardNo,
		    					"memberNo":memberNo
		    				}),
		    		success : function(result){
		    			location.reload();
		    		}
		    	});
		    }
		});
	});
	
	
	function deleteReply(bReplyNo, boardNo){
		var url = "${path}/Board/replyDel?bReplyNo=";
		var requestURL = url + bReplyNo +"&boardNo=" + boardNo;
		location.replace(requestURL);
	}
	//이전글 다음글
	function npPage(pageNum){
		if(pageNum==9999){
			alert('게시글이 없습니다.');
		}else{
			var url = "${path}/Board/boardDetail?no="+pageNum;
			location.replace(url);
		}
		
	}

</script>
