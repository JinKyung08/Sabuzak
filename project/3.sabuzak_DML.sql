USE MUSEtest;

#selectMemberCount - 총멤버 수
SELECT COUNT(id) FROM member;

#selectAll 			- 전체 멤버
SELECT 
memberNo, id, password, role, name, email, address, kakaoToken, originalImageName, renamedImageName, enrollDate, modifyDate
FROM member;

#selectMember 			- 아이디로 멤버 불러오기
SELECT
memberNo, id, password, role, name, email, address, kakaoToken, originalImageName, renamedImageName, enrollDate, modifyDate
FROM member
WHERE id = ?;

#selectMemberByKakaoToken 	- 카카오 토큰으로 멤버 불러오기
SELECT
memberNo, id, password, role, name, email, address, kakaoToken, originalImageName, renamedImageName, enrollDate, modifyDate
FROM member
WHERE kakaoToken = ?;

#insertMember 			- 멤버 넣기
INSERT 
member(id, password, name, email, address, kakaoToken)
VALUES(?, ?, ?, ?, ?, ?);

#updateMember 			- 멤버 수정
UPDATE member
SET name = ?, email = ?, address = ?, modifyDate = DEFAULT
WHERE memberNo = ?;

#updatePwd 			- 비번 수정
UPDATE member
SET password = ?
WHERE memberNo = ?;

#deleteMember 			- 멤버 삭제
#SET foreign_key_checks = 0;
DELETE 
FROM member 
WHERE memberNo = ?;
#SET foreign_key_checks = 1;

#selectBookmarkAntCount			- 총 찜한 유물 수
SELECT COUNT(*)
FROM bookmark_ant
WHERE memberNo = ?;

#selectBookmarkAntAll		- 찜한 유물 전체 불러오기, 페이징 기능
SELECT
b.antNo, a.antId, a.antName, a.antNameKr, a.antNameCn, a.antAuthor, a.antIndexWord, a.antMuseumName1, a.antMuseumName2, a.antMuseumName3,
a.antImgUri, a.antImgThumUriS, a.antImgThumUriM, a.antImgThumUriL, a.antNationalityName1, a.antNationalityName2, a.antMaterialName1,
a.antMaterialName2, a.antPurposeName1, a.antPurposeName2, a.antPurposeName3, a.antPurposeName4, a.antSizeRangeName, a.antPlaceLandName1,
a.antPlaceLandName2, a.antDesignationName1, a.antDesignationCode1, a.antSizeInfo, a.antDesc
FROM bookmark_ant b
JOIN ANTIQUITY a ON b.antNo = a.antNo
WHERE b.memberNo = ?;

#■ Museum - Museum, 박물관 댓글 --------------------------------------------------------------------------------------------------------------------

#selectMuseumCount		- 총 박물관 수
SELECT COUNT(museName) FROM MUSEUM;

#selectMuseumAll		- 전체 박물관, 페이징 기능
SELECT
mu.museNo, mu.museName, mu.museType, mu.museRdnmadr, mu.museLnmadr, mu.museLatitude, mu.museLongitude, mu.musePhone,
mu.museInsName, mu.museUrl, mu.fcltyInfo, mu.museWeekOpen, mu.museWeekClose, mu.museHolidayOpen, mu.museHolidayClose, mu.rstdeInfo,
mu.museCharge, mu.museIntro, mu.museTransport, b.bookmarkMuseNo
FROM MUSEUM mu
LEFT OUTER JOIN bookmark_muse b ON (b.museNo = mu.museNo)
WHERE mu.museName LIKE '%?%' AND mu.museRdnmadr LIKE '%?%';

#selectMuseum		- 박물관 디테일 정보, 넘버로 불러오기
SELECT
mu.museNo, mu.museName, mu.museType, mu.museRdnmadr, mu.museLnmadr, mu.museLatitude, mu.museLongitude, mu.musePhone,
mu.museInsName, mu.museUrl, mu.fcltyInfo, mu.museWeekOpen, mu.museWeekClose, mu.museHolidayOpen, mu.museHolidayClose, mu.rstdeInfo,
mu.museCharge, mu.museIntro, mu.museTransport, 
r.mReplyNo, r.memberNo, r.content, r.good, r.bad, r.STATUS, r.createDate, r.modifyDate, r.star,
b.bookmarkMuseNo
FROM MUSEUM mu
LEFT OUTER JOIN M_REPLY r ON (r.museNo = mu.museNo)
LEFT OUTER JOIN MEMBER me ON (me.memberNo = r.memberNo)
LEFT OUTER JOIN bookmark_muse b ON (b.museNo = mu.museNo)
WHERE mu.museNo = ? AND r.status = 'Y';

#selectStaravgBymuseNo		- 별점 평균, 넘버로 불러오기
SELECT AVG(star) 
FROM M_REPLY
WHERE museName = ?;

#insertMuseum		- 박물관 넣기
INSERT museum
(museName, museType, museRdnmadr, museLnmadr, museLatitude, museLongitude,
musePhone, museInsName, museUrl, fcltyInfo, museWeekOpen, museWeekClose,
museHolidayOpen, museHolidayClose, rstdeInfo, museCharge, museIntro, museTransport)
VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);

#insertMuseReply		- 박물관 댓글 추가
INSERT m_reply
(museNo, memberNo, content, good, bad, createDate, modifyDate, star)
VALUES(?,?,?,?,?,?,?,?);

#updateMuseum		- 박물관 정보 수정
UPDATE museum 
SET museName = ?, museType = ?,museRdnmadr = ?,museLnmadr = ?,museLatitude = ?,museLongitude = ?,musePhone = ?,
museInsName = ?,museUrl = ?,fcltyInfo = ?,museWeekOpen = ?,museWeekClose = ?,museHolidayOpen = ?,
museHolidayClose = ?,rstdeInfo = ?,museCharge = ?,museIntro = ?,museTransport = ?
WHERE museNo = ?;

#updateMuseReply		- 박물관 댓글 수정
UPDATE m_reply
SET content = ?,good = ?,bad = ?, modifyDate = current_date(),star = ?
WHERE mReplyNo = ?;

#deleteMuseum		- 박물관 삭제
DELETE FROM museum WHERE museNo = ?;

#deleteMuseReply		- 박물관 댓글 삭제
UPDATE m_reply SET STATUS = 'N', modifyDate = current_date() WHERE mReplyNo = ?;
    
#■ Exhibition -----------------------------------------------------------------------------------------------------------------------------
	
#selectExhibitionCount		- 총 전시회 수
SELECT COUNT(exName) FROM exhibition;

#selectExhibitionAll		- 전체 전시회, 페이징 기능
SELECT exNo, exName, exMuseName, exStartDate, exEndDate, exWeekOpen, exWeekClose, exHolidayOpen, 
exHolidayClose, exContactNum, exCharge, exDesc, exUrl
FROM exhibition
WHERE museName LIKE '%?%' AND exMuseName LIKE '%?%';

#select~		- 전시회 정보, 넘버로 불러오기
SELECT exNo, exName, exMuseName, exStartDate, exEndDate, exWeekOpen, exWeekClose, exHolidayOpen, 
exHolidayClose, exContactNum, exCharge, exDesc, exUrl
FROM exhibition
WHERE exNo = ?;

#insert~		- 전시회 넣기
INSERT exhibition
(exName, exMuseName, exStartDate, exEndDate, exWeekOpen, exWeekClose, exHolidayOpen, exHolidayClose, 
exContactNum, exCharge,exDesc, exUrl) 
VALUES(?,?,?,?,?,?,?,?,?,?,?,?);

#update~		- 전시회 정보 수정
UPDATE exhibition
SET exName = ?,exMuseName= ?,exStartDate= ?,exEndDate= ?,exWeekOpen= ?,exWeekClose= ?,
exHolidayOpen= ?,exHolidayClose= ?,exContactNum= ?,exCharge= ?,exDesc= ?,exUrl= ?
WHERE exNo = ?;

#delete~		- 전시회 삭제
DELETE FROM exhibition  WHERE exNo = ?;

#■ Antiquity - Antiquity, 유물 댓글 --------------------------------------------------------------------------------------------------------------------

#selectAntiquityCount	-- 총 유물 수
SELECT COUNT(*) FROM ANTIQUITY;

#selectAntiquityAll		-- 전체 유물, 페이징 기능
SELECT
			A.antName, A.antNameKr, b.bookmarkAntNo, -- 보여질 내용
            
			A.antNo, A.antNameCn, A.antNationalityName1, A.antNationalityName2, 
			A.antPlaceLandName1, A.antPlaceLandName2, A.antPurposeName1, A.antPurposeName2, 
            A.antPurposeName3, A.antPurposeName4, A.antMaterialName1, A.antMaterialName2, 
            A.antSizeRangeName, A.antDesignationName1, A.antId, A.antDesc, A.antImgUri, 
            A.antAuthor, A.antIndexWord, A.antMuseumName1, A.antMuseumName2, A.antMuseumName3, 
            A.antImgThumUriS, A.antImgThumUriM, A.antImgThumUriL, A.antDesignationCode1, A.antSizeInfo
FROM ANTIQUITY A
LEFT OUTER JOIN bookmark_ant b ON (b.antNo = A.antNo)
WHERE mu.museName LIKE '%?%' AND mu.museRdnmadr LIKE '%?%'; -- 수정예정

#selectAntiquity		-- 유물 디테일 정보, 넘버로 불러오기
SELECT  
			A.antNo, A.antName, A.antNameKr, A.antNameCn, A.antNationalityName1, A.antNationalityName2, 
			A.antPlaceLandName1, A.antPlaceLandName2, A.antPurposeName1, A.antPurposeName2, 
            A.antPurposeName3, A.antPurposeName4, A.antMaterialName1, A.antMaterialName2, 
            A.antSizeRangeName, A.antDesignationName1, A.antId, A.antDesc, A.antImgUri, -- 보여질 내용
            
            A.antAuthor, A.antIndexWord, A.antMuseumName1, A.antMuseumName2, A.antMuseumName3, 
            A.antImgThumUriS, A.antImgThumUriM, A.antImgThumUriL, A.antDesignationCode1, A.antSizeInfo, 
            
			r.aReplyNo, r.memberNo, r.content, r.good, r.bad, r.STATUS, r.createDate, r.modifyDate,
			b.bookmarkAntNo, M2.id
FROM ANTIQUITY A
LEFT OUTER JOIN A_REPLY R ON (A.antNo = R.antNo)
LEFT OUTER JOIN MEMBER M2 ON (R.memberNo = M2.memberNo)
LEFT OUTER JOIN bookmark_ant b ON (b.antNo = A.antNo)
WHERE A.antNo = ? AND r.status = 'Y';

#insertAntiquity		-- 유물 넣기
INSERT INTO ANTIQUITY(
			antNo, antName, antNameKr, antNameCn, antAuthor, antIndexWord,  
			antMuseumName1, antMuseumName2, antMuseumName3, antImgUri, 
			antImgThumUriS, antImgThumUriM, antImgThumUriL, antNationalityName1, 
			antNationalityName2, antMaterialName1, antMaterialName2, 
			antPurposeName1, antPurposeName2, antPurposeName3, 
			antPurposeName4, antSizeRangeName, antPlaceLandName1, 
			antPlaceLandName2, antDesignationName1, antDesignationCode1, 
			antSizeInfo, antDesc	
) VALUES (
			0, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
			?, ?, ?, ?, ?, ?, ?, ? 			
);

#insertAntReply			-- 유물 댓글 추가
INSERT INTO A_REPLY
(aReplyNo, antNo, memberNo, content, good, bad, STATUS, createDate, modifyDate)
VALUES(0,?,?,?,?,?,DEFAULT,DEFAULT,DEFAULT);

#updateAntiquity		-- 유물 정보 수정
UPDATE ANTIQUITY 
SET 
			antId = ?, antName = ?, antNameKr = ?, antNameCn = ?, antAuthor = ?, 
            antIndexWord = ?, antMuseumName1 = ?, antMuseumName2 = ?, antMuseumName3 = ?, 
            antImgUri = ?, antImgThumUriS = ?, antImgThumUriM = ?, antImgThumUriL = ?, 
			antNationalityName1 = ?, antNationalityName2 = ?, antMaterialName1 = ?, 
            antMaterialName2 = ?, antPurposeName1 = ?, antPurposeName2 = ?, 
            antPurposeName3 = ?, antPurposeName4 = ?, antSizeRangeName = ?, 
            antPlaceLandName1 = ?, antPlaceLandName2 = ?, antDesignationName1 = ?, 
            antDesignationCode1 = ?, antSizeInfo = ?, antDesc = ?  
WHERE antNo = ?;

#updateAntReply			-- 유물 댓글 수정
UPDATE A_REPLY
SET content = ?, modifyDate = CURRENT_TIMESTAMP
WHERE aReplyNo = ?;

#updateBoardReplyGood 	-- 댓글 좋아요 증가 
UPDATE A_REPLY SET good=? WHERE aReplyNo=?;

#updateBoardReplyBad	-- 댓글 싫어요 증가
UPDATE A_REPLY SET bad=? WHERE aReplyNo=?;

#deleteAntiquity		-- 유물 삭제
DELETE FROM ANTIQUITY WHERE antNo = ?;

#deleteAntReply			-- 유물 댓글 삭제 - update
UPDATE A_REPLY 
SET STATUS = 'N', modifyDate = CURRENT_TIMESTAMP 
WHERE aReplyNo = ?;

#deleteAntReply2		-- 유물 댓글 삭제 - delete
DELETE FROM A_REPLY 
WHERE aReplyNo = ?;

#selectAntReplyAll		-- 한 유물에 해당하는 댓글 리스트 조회용 쿼리문
SELECT R.aReplyNo, R.antNo, R.content, M.id, R.good, R.bad, R.createDate, R.modifyDate
FROM A_REPLY R
JOIN MEMBER M ON(R.memberNo = M.memberNo)
WHERE R.STATUS='Y' AND antNo= ? 
ORDER BY R.aReplyNo DESC;

#selectAntSearch 		-- 유물 검색
SELECT  A.antName, A.antImgUri
FROM ANTIQUITY A
WHERE 1 = 1
AND A.antNationalityName1 LIKE '%?%' 
AND A.antNationalityName2 LIKE '%?%' 
AND A.antPlaceLandName1 LIKE '%?%' 
AND A.antPlaceLandName2 LIKE '%?%'
AND A.antMaterialName1 LIKE '%?%'
AND A.antMaterialName2 LIKE '%?%'
ORDER BY A.antNo DESC LIMIT 10 OFFSET 0;

#selectAntSearchCnt 	-- 유물 검색 수
SELECT  COUNT(*)
FROM ANTIQUITY A
WHERE 1=1
AND A.antNationalityName1 LIKE '%?%' 
AND A.antNationalityName2 LIKE '%?%' 
AND A.antPlaceLandName1 LIKE '%?%' 
AND A.antPlaceLandName2 LIKE '%?%'
AND A.antMaterialName1 LIKE '%?%'
AND A.antMaterialName2 LIKE '%?%';

#■ Board - Board, 게시판 댓글 --------------------------------------------------------------------------------------------------------------------

#selectBoardCount		-- 총 게시글 수
SELECT COUNT(*) FROM BOARD;

#selectBoardAll			-- 전체 게시글, 페이징 기능
SELECT  B.boardNo, B.title, M.id, B.createDate, B.originalFileName, B.readcount, B.STATUS
FROM BOARD B JOIN MEMBER M ON(B.memberNo = M.memberNo) 
WHERE B.STATUS = 'Y' 
ORDER BY B.boardNo DESC LIMIT 10 OFFSET 0;

#selectBoard			-- 상세 조회
SELECT  B.boardNo, B.title, M.id, B.readcount, B.originalFileName, B.renamedFileName, B.content, B.createDate, B.modifyDate
FROM BOARD B
JOIN MEMBER M ON(B.memberNo = M.memberNo)
WHERE B.STATUS = 'Y' AND B.boardNo = 1;

#insertBoard			-- 게시글 넣기
INSERT INTO BOARD(
			boardNo, memberNo, title, content, good, type,  
			originalFileName, renamedFileName, readcount, STATUS, 
			createDate, modifyDate
) 
VALUES (0,?,?,?,?,?,?,?,DEFAULT,DEFAULT,DEFAULT,DEFAULT );

#insertBoard			-- 게시판 댓글 추가
INSERT INTO B_REPLY
(bReplyNo, boardNo, memberNo, content, good, bad, STATUS, createDate, modifyDate)
VALUES(0,?,?,?,?,?,DEFAULT,DEFAULT,DEFAULT);

#updateBoard			-- 게시글 정보 수정
UPDATE BOARD 
SET title = ?, content = ?, originalFileName = ?, renamedFileName = ?, modifyDate = CURRENT_TIMESTAMP
WHERE boardNo = ?;

#updateBoardReply		-- 게시판 댓글 수정
UPDATE B_REPLY 
SET content = ?, modifyDate = CURRENT_TIMESTAMP
WHERE bReplyNo = ?;

#updateBoardReplyGood 	-- 댓글 좋아요 증가 
UPDATE B_REPLY SET good=? WHERE bReplyNo=?;

#updateBoardReplyBad	-- 댓글 싫어요 증가
UPDATE B_REPLY SET bad=? WHERE bReplyNo=?;

#deleteBoard			-- 게시글 삭제
UPDATE BOARD SET STATUS = ? WHERE boardNo = ?;

#deleteBoardReply		-- 게시판 댓글 삭제 - update
UPDATE B_REPLY 
SET STATUS = 'N', modifyDate = CURRENT_TIMESTAMP 
WHERE bReplyNo = ?;

#deleteBoardReply2		-- 게시판 댓글 삭제 - delete
DELETE FROM B_REPLY WHERE bReplyNo = ?;

#selectBoardReplyAll	-- 한 게시판에 해당하는 댓글 리스트 조회용 쿼리문
SELECT R.bReplyNo, R.boardNo, R.content, M.id, R.good, R.bad, R.createDate, R.modifyDate
FROM B_REPLY R
JOIN MEMBER M ON(R.memberNo = M.memberNo)
WHERE R.STATUS='Y' AND boardNo= ? 
ORDER BY R.bReplyNo DESC;

#selectBoardSearch 		-- 게시판 검색
SELECT  B.boardNo, B.title, M.id, B.createDate, B.originalFileName, B.readcount, B.STATUS
FROM BOARD B JOIN MEMBER M ON(B.memberNo = M.memberNo) 
WHERE 1 = 1 
AND B.STATUS = 'Y'
AND M.id LIKE '%?%' 
AND B.title LIKE '%?%' 
AND B.content LIKE '%?%' 
ORDER BY B.boardNo DESC LIMIT 10 OFFSET 0;

#selectBoardSearchCnt 		-- 게시판 검색 수
SELECT  COUNT(*)
FROM BOARD B
JOIN MEMBER M ON(B.memberNo = M.memberNo)
WHERE 1=1
AND B.STATUS = 'Y'
AND M.id LIKE '%?%' 
AND B.title LIKE '%?%' 
AND B.content LIKE '%?%' ;




#deleteGood      -- 좋아요 삭제
DELETE FROM GOOD WHERE memberNo = ?;

#selectGood    -- 게시판 좋아요 검색
SELECT * FROM GOOD WHERE boardNo = ?;




