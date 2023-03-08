<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>


 <link rel="stylesheet" href="${path}/resources/css/write.css">
 
      <div>
        <section class="boardMain">
          <img src="${path}/resources/img/write_mainimg.jpg" style="width: 100%; height: 500px;">
          <h1 class="main_image_text" style="font-size:50px">게시판</h1>
        </section>
      </div >

      
      <!-- 본문 전체 배경-->
      <div class="section" style="background-image: url('${path}/resources/img/back.JPG');">

        <!--breadcrumb-->
        <section id="bc" class="container">
         <ol id="bc2" class="breadcrumb">
           <li class="breadcrumb-item doing">
             <a href="${path}/index">
               <i class="ai-home fs-base me-2"></i>
               Home
             </a>
           </li>
           <li class="breadcrumb-item"><a href="${path}/Board">게시판</a></li>
           <li class="breadcrumb-item active" aria-current="page" id="bWrite">글쓰기</li>
         </ol>
       </section>

    <div class="outer">
         <h2>글쓰기</h2>
      <form action="${path}/Board/write" method="post" enctype="multipart/form-data">  
         <div class="inner">
           <!-- 카테고리 -->
           <div class="category_container">
             <select name="type" class="form-select bg-white" id="category"  style="width:140px;">
               <c:if test="${ !empty loginMember && (loginMember.role == 'ROLE_ADMIN') }">
               <option>공지사항</option>
               </c:if>
               <option>자유게시판</option>
             </select>
           </div>
           <!-- 제목 -->
           <div class="title_container" style="margin-left:70px;"> 
             <input class="form-control" type="text" id="title" name="title" placeholder="제목" required>
            </div>
            <!-- 첨부파일 -->
            <div class="attachFile_container">
              <label for="file-input" class="form-label" id="attachFileLabel"><h5>첨부파일</h5></label>
              <input class="form-control" type="file" id="originalFileName" name="upfile" style="margin-left:215px;">
            </div>
            <input type="hidden" name="writerId" value="${loginMember.id}" readonly>
          <!-- 글자 입력 박스 -->
          <div class="textarea_container">
            <textarea class="form-control" id="content" name="content"  rows="5" placeholder="내용을 입력해주세요." data-bind-characters-target="#charactersRemaining" maxlength="10000" required></textarea>
          </div>
          <small class="font-weight-light" style="float: right; padding-right: 90px;">글자수
          <span class="textLength" id="charactersRemaining">10000</span>자 이내</small>
          <script>
          $(function () {
            $('#content').keydown(function () {
                var inputTextLength = $(this).val().length;//글자수
                if (inputTextLength > 10000)
                {
                    $(this).val($(this).val().substring(0, 10000));
                }
                var inputPossible = 10000 - ($(this).val().length);
                $('.textLength').html(inputPossible);
            });
        });
        </script>
          <h5 style="margin-top: 50px;">주의사항</h5>
          <p>※음란물, 차별, 비하, 혐오 및 초상권, 저작권 침해 게시물은 민, 형사상의 책임을 질 수 있습니다.</p>
        </div>
        <!-- 버튼 -->
        <div class="button_container">
          <button type="submit" class="btn btn-primary" id="enrollButton">등 록</button>
          <button type="reset" class="btn btn-outline-primary" id="cancelButton">초기화</button>
          <c:choose>
          <c:when test="${type !='notice'}">
          <button type="button" style="margin-left:270px" class="btn btn-primary" id="listbtn" onclick="location.href='${path}/Board'">목록</button>
          </c:when>
          <c:otherwise>
          <button type="button" style="margin-left:270px" class="btn btn-primary" id="listbtn" onclick="location.href='${path}/Board/notice'">목록</button>
          </c:otherwise>
          </c:choose>
        </div>
      </div>
    </form>
  </div>


<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>