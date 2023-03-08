<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

 <link rel="stylesheet" href="${path}/resources/css/board.css">
      
        <!-- 헤더 네비 아래 가운데 큰 배경들-->
        <section>
            <div class="jarallax bg-dark min-vh-40 py-4" data-jarallax data-type="scroll-opacity" data-speed="0.7">
              <div class="jarallax-img"><img src="${path}/resources/img/board.jpg" style="height: 100%; width: 100%;"></div>
              <div class="container position-relative zindex-5 py-sm-4 py-lg-5 mt-4">

                    <h1 class="display-4 text-light text-lowercase pb-sm-2 pb-md-3" style="margin: 10% 10%; text-align: center;">자유게시판</h1>
                  
                  </div>
                </div>
                <!--배경-->
        <div class="my_div my_bg"> 
                <div class="index-mid" >
                    
                    <c:set var="searchType" value="${param.searchType}"/>
					<c:if test="${empty searchType}">
						<c:set var="searchType" value="${'title'}"/>
					</c:if>
                    <!-- 검색창-->
                 <form action="${path}/Board" method="get">
                     <div class="search-group" style="padding-top: 10px;">
                        <div class="input-group rounded-pill" style="background-color: white;">
                            <span class="input-group-text" >
                              <i class="ai-search"></i>
                            </span>
                            <input type="search" class="form-control" id="searchValue" name="searchValue" placeholder="검색..." value="${param.searchValue}">
                            <button type="submit" class="btn btn-primary rounded-pill">검색</button>
                          </div>
                          <div class=" radioCheck align-items-center pt-sm-2 pt-md-3" style="margin-left:380px;">
                            <div class="form-check form-check-inline mb-0" style="width:200px;">
                              <input class="form-check-input" type="radio" name="searchType" value="title" ${searchType=='title' ? 'checked':''} id="title">
                              <label class="form-check-label" for="writer">제목</label>
                            </div>
                            <div class="form-check form-check-inline mb-0"  style="width:200px;">
                              <input class="form-check-input" type="radio" name="searchType" value="writer" ${searchType=='writer' ? 'checked':''} id="writer">
                              <label class="form-check-label" for="title">작성자</label>
                            </div>
                            <div class="form-check form-check-inline mb-0"  style="width:200px;">
                              <input class="form-check-input" type="radio" name="searchType" value="content" ${searchType=='content' ? 'checked':''} id="content">
                              <label class="form-check-label" for="content">내용</label>
                            </div>
                      	</div>
                      </div>
                  </form>
                    <!----------게시판-------------->
                    <!--글쓰기 내글보기 버튼-->
                                  
                    
                      <div class="writeBtn">
                      <c:choose>
                    <c:when test="${loginMember != null}">
                    <button type="button" class="btn btn-primary btn-sm" id="btn-add" onclick="location.href='${path}/Board/write'"> 
                      <i class="ai-edit-alt"></i>
                      &nbsp;글쓰기
                    </button>
                    </c:when>
                    <c:otherwise>
                    <button type="button" class="btn btn-primary btn-sm" id="btn-add" style="margin-left:100px;" onclick="alert('로그인이 필요합니다.')"> 
                      <i class="ai-edit-alt"></i>
                      &nbsp;글쓰기
                    </button>
                    </c:otherwise>
                    </c:choose>
                    
					<c:if test="${loginMember != null}">
                    <button type="button" class="btn btn-primary btn-sm" style="margin-left: 10px;" id="btn-add" onclick="location.href='${path}/myArticle'">
                      <i class="ai-note"></i>
                      &nbsp;내글보기        
                    </button>
                    </c:if>
                  </div>
            
            
                    <!----------------->
                    <div class="table-responsive">
                        <table class="tableBoard" id="type" style="margin-bottom: 0px">
                        <thead>
                            <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                            <th>조회수</th>
                            <th>좋아요</th>
                            </tr>
                        </thead>
                        <c:if test="${empty list}">
						<tr>
						<td colspan="6" style="text-align: center;">조회된 글이 없습니다.</td>
						</tr>
						</c:if>
						<c:if test="${not empty list}">
						<c:forEach var="board" items="${list}">
						<c:if test="${board.type eq '자유게시판' }">
                        <tbody>
                            <tr>
                            <th scope="boardNo" id="boardNo">${board.no}</th>
                            <td class="title" id="title"><a href="${path}/Board/boardDetail?no=${board.boardNo}" >${board.title}</a></td>
                            <td class="id" id="id">${board.id}</td>
                            <td class="createDate" id="createDate"><fmt:formatDate type="both" value="${board.createDate}"/></td>
                            <td class="readcount" id="readcount">${board.readcount}</td>
                            <td class="good" id="good">${board.good}</td>
                            </tr>
                    </tbody>
                    </c:if>
                    	</c:forEach>
						</c:if>
                        </table>
                    </div>
                      
                    <!--게시글 페이지 번호-->
                    <!-- Pagination with prev / next icons + text -->

<nav aria-label="Page navigation example">
  <ul class="pagination">
    <li class="page-item">
      <a href="javascript:void(0);" onclick="movePage('${path}/Board?page=1');" class="page-link">
        <i class="ai-chevron-left"></i>
        &nbsp;&nbsp; Prev
      </a>
    </li>
	
				
	<c:forEach begin="${pageInfo.startPage}" end="${pageInfo.endPage}" step="1" varStatus="status">
	<c:if test="${status.current == pageInfo.currentPage}">			
  		<li class="page-item d-none d-sm-block" >
      		<a class="page-link" >${status.current}</a>
   		</li>
    </c:if>
    <c:if test="${status.current != pageInfo.currentPage}">
			 <a href="javascript:void(0);" onclick="movePage('${path}/Board?page=${status.current}');" class="page-link">${status.current}</a>
		</c:if>
	</c:forEach>
   <!-- <li class="page-item d-none d-sm-block" >
        <a href="#" class="page-link">2</a>
    </li>
    <li class="page-item d-none d-sm-block">
      <a href="#" class="page-link">3</a>
    </li>
    <li class="page-item d-none d-sm-block">
      <a href="#" class="page-link">4</a>
    </li>
    <li class="page-item d-none d-sm-block">
      <a href="#" class="page-link">5</a>
    </li> -->
    
    <li class="page-item">
      <a href="javascript:void(0);" onclick="movePage('${path}/Board?page=${pageInfo.maxPage}');" class="page-link">
        Next&nbsp;&nbsp;
        <i class="ai-chevron-right"></i>
      </a>
    </li>
  </ul>
</nav>







</div>
 </div>            
<!---mid 끝-->
        


            </section>



<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>


<script type="text/javascript">
	function movePage(pageUrl){
		var searchValue = document.getElementById("searchValue"); 
		var searchTypes = document.getElementsByName("searchType"); 
		var searchType = 'title';
		if(searchValue.value.length > 0){
			for(var i = 0; i <searchTypes.length; i++){
				if(searchTypes[i].checked == true){
					searchType = searchTypes[i].value;
				}
			}
			pageUrl = pageUrl + '&searchType=' + searchType + '&searchValue=' + searchValue.value; 
		}
		console.log(pageUrl);
		location.href = encodeURI(pageUrl);	
	}
</script>
