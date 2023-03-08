DROP SCHEMA IF EXISTS muse;
CREATE SCHEMA MUSE;
USE MUSE;

-- 외래키 설정 -----------------------
#SET foreign_key_checks = 0;
#SET foreign_key_checks = 1;

-- 테이블 전체 확인 -------------------------

select * from MEMBER;
SELECT * FROM backup_member;
select * from BOARD;
select * from B_REPLY;
select * from ANTIQUITY LIMIT 1000;
SELECT COUNT(*) FROM ANTIQUITY;
select * from bookmark_ant;
select * from A_REPLY;
select * from MUSEUM;
SELECT COUNT(*) FROM MUSEUM;
select * from M_REPLY;
select * from EXHIBITION;
select * from GOOD;


-- 테이블 또는 trigger 삭제 --------------------------------------------------------------------------------

drop table if exists MEMBER;
drop table if exists BOARD;
drop table if exists B_REPLY;
drop table if exists ANTIQUITY;
drop table if exists A_REPLY;
drop table if exists MUSEUM;
drop table if exists M_REPLY;
drop table if exists EXHIBITION;
drop table if exists bookmark_ant;
drop table if exists bookmark_muse;
drop table if exists GOOD;



--------------- MEMBER 관련 테이블 ------------------

CREATE TABLE MEMBER (
    memberNo INT  PRIMARY KEY AUTO_INCREMENT,
    id VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(10) DEFAULT 'ROLE_USER',
    name VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(100),
    kakaoToken	VARCHAR(1000),
    originalImageName VARCHAR(100),
    renamedImageName VARCHAR(100),
    status VARCHAR(1) DEFAULT 'Y' CHECK(STATUS IN('Y', 'N')),
    enrollDate DATETIME  DEFAULT CURRENT_TIMESTAMP,
    modifyDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BACKUP_MEMBER (
    memberNo INT ,
    id VARCHAR(30) ,
    password VARCHAR(100) ,
    role VARCHAR(10) ,
    name VARCHAR(15) ,
    email VARCHAR(100),
    address VARCHAR(100),
    kakaoToken	VARCHAR(1000),
    originalImageName VARCHAR(100),
    renamedImageName VARCHAR(100),
   status VARCHAR(1) DEFAULT 'Y' CHECK(STATUS IN('Y', 'N')),
    enrollDate DATETIME,
    modifyDate DATETIME,
    deleteDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

#drop trigger if exists BACKUP_MEMBER;
delimiter $$
create trigger BACKUP_MEMBER
	after update
    on MEMBER
    for each row
begin
	insert into BACKUP_MEMBER(
    memberNo, id, password, role, name, email, address, kakaoToken, 
    originalImageName, renamedImageName, enrollDate, modifyDate
    ) 
    values(
    OLD.memberNo, OLD.id, OLD.password, OLD.role, OLD.name, OLD.email, OLD.address, OLD.kakaoToken, 
    OLD.originalImageName, OLD.renamedImageName, OLD.enrollDate, OLD.modifyDate
    );
end $$
delimiter ;
#select * from backupUpdateCustomers;

COMMIT;

--------------- BOARD 관련 테이블 ------------------

CREATE TABLE BOARD (	
    boardNo INT AUTO_INCREMENT,
    memberNo INT, 
	title VARCHAR(50), 
	content VARCHAR(2000), 
    good INT,
	type VARCHAR(100), 
	originalFileName VARCHAR(100), 
	renamedFileName VARCHAR(100), 
	readcount INT DEFAULT 0, 
    STATUS VARCHAR(1) DEFAULT 'Y' CHECK (STATUS IN('Y', 'N')),
    createDate DATETIME  DEFAULT CURRENT_TIMESTAMP, 
    modifyDate DATETIME  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_BOARD_NO PRIMARY KEY(boardNo),
    CONSTRAINT FK_BOARD_WRITER FOREIGN KEY(memberNo) REFERENCES MEMBER(memberNo) ON DELETE SET NULL
);

-- INSERT INTO BOARD VALUES(0, 1, '신라시대유물 질문있습니다.', '~~~~~~~~', 'b1',
-- 	'원본파일명.txt', '변경된파일명.txt', DEFAULT, DEFAULT, DEFAULT, 'Y');
-- INSERT INTO BOARD VALUES(0, 1, '신라시대유물 질문있습니다',  '~~~~~~~~', 'B1', '원본파일명.txt', '변경된파일명.txt', DEFAULT, 'Y', DEFAULT, DEFAULT);
--
COMMIT;


------------------ Good 게시판 좋아요 테이블----------------
CREATE TABLE GOOD (	
    goodNo INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    boardNo INT,
    memberNo INT,
    FOREIGN KEY (boardNo) REFERENCES BOARD(boardNo),
    FOREIGN KEY (memberNo) REFERENCES MEMBER(memberNo)
);


--------------- BOARD_REPLY 관련 테이블 ------------------

CREATE TABLE B_REPLY(
  bReplyNo INT PRIMARY KEY AUTO_INCREMENT,
  boardNo INT,
  memberNo INT,
  content VARCHAR(400),
  good INT,
  bad INT,
  STATUS VARCHAR(1) DEFAULT 'Y' CHECK (STATUS IN ('Y', 'N')),
  createDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  modifyDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (boardNo) REFERENCES BOARD(boardNo),
  FOREIGN KEY (memberNo) REFERENCES MEMBER(memberNo)
);

-- INSERT INTO REPLY VALUES(0, 1, 1, '안녕하세요.', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
--
COMMIT;


--------------- ANTIQUITY 관련 테이블 ------------------

CREATE TABLE ANTIQUITY (
	antNo				 int PRIMARY KEY AUTO_INCREMENT,	
	antId	             varchar(100) UNIQUE,     -- 단일 소장품의 고유 키
	antName	             varchar(100),     				-- 통합검색용 명칭
	antNameKr	         varchar(100),     -- 한글명칭에서 검색
	antNameCn	         varchar(100),     -- 중문명칭에서 검색
	antAuthor	         varchar(100),     -- 소장품의 원작자 검색
	antIndexWord		 varchar(100),     -- 태그와 같은 개념으로 특정인물, 시대와 같은 키워드
	antMuseumName1		 varchar(100),     -- 박물관 구분 명칭(대분류)
	antMuseumName2		 varchar(100),     -- 박물관 구분 명칭(중분류)
	antMuseumName3		 varchar(100),     -- 박물관 구분 명칭(소분류)
	antImgUri	         varchar(1000),    -- 원본크기의 이미지경로
	antImgThumUriS	     varchar(1000),    -- 75px 크기의 썸네일 이미지 경로
	antImgThumUriM	     varchar(1000),    -- 200px 크기의 썸네일 이미지 경로
	antImgThumUriL	     varchar(1000),    -- 700px 크기의 썸네일 이미지 경로
	antNationalityName1  varchar(100),     -- 국적 명칭
	antNationalityName2  varchar(100),     -- 시대 명칭
	antMaterialName1	 varchar(100),     -- 재질 명칭 1단계
	antMaterialName2	 varchar(100),     -- 재질 명칭 2단계
	antPurposeName1	     varchar(100),     -- 용도/기능 분류 명칭 1단계
	antPurposeName2	     varchar(100),     -- 용도/기능 분류 명칭 2단계
	antPurposeName3	     varchar(100),     -- 용도/기능 분류 명칭 3단계
	antPurposeName4	     varchar(100),     -- 용도/기능 분류 명칭 4단계
	antSizeRangeName	 varchar(100),     -- 크기 범위 명칭
	antPlaceLandName1	 varchar(100),     -- 출토지 명칭 1단계
	antPlaceLandName2	 varchar(100),     -- 출토지 명칭 2단계
	antDesignationName1	 varchar(100),     -- 지정문화재 명칭 1단계
	antDesignationCode1	 varchar(100),     -- view_code_list의 지정문화재 코드(PS12의 level3)
	antSizeInfo		     varchar(1000),    -- 소장품의 여러 크기정보를 “,” 구분자를 이용하여 요약
	antDesc	             varchar(4000)     -- 소장품의 설명
);

-- INSERT INTO ANTIQUITY VALUES();
--
-- COMMIT;

--------------- ANTI_REPLY 관련 테이블 ------------------

CREATE TABLE A_REPLY(
  aReplyNo INT PRIMARY KEY AUTO_INCREMENT,
  antNo INT,
  memberNo INT,
  content VARCHAR(400),
  good INT,
  bad INT,
  STATUS VARCHAR(1) DEFAULT 'Y' CHECK (STATUS IN ('Y', 'N')),
  createDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  modifyDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (antNo) REFERENCES ANTIQUITY(antNo),
  FOREIGN KEY (memberNo) REFERENCES MEMBER(memberNo)
);

-- INSERT INTO REPLY VALUES(0, 1, 1, '안녕하세요.', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
--
COMMIT;

CREATE TABLE bookmark_ant(
	bookmarkAntNo INT AUTO_INCREMENT PRIMARY KEY,
	antNo	INT,
    memberNo INT,
    FOREIGN KEY (antNo) REFERENCES ANTIQUITY(antNo),
    FOREIGN KEY (memberNo) REFERENCES MEMBER(memberNo)
);
-- INSERT INTO bookmark_ant VALUES(1, 3);

--------------- MUSEUM 관련 테이블 ------------------

CREATE TABLE MUSEUM (
	museNo					int PRIMARY KEY AUTO_INCREMENT,	
	museName				varchar(300) UNIQUE,	 -- 시설명
	museType				varchar(30),	 -- 박물관미술관구분
	museRdnmadr				varchar(200),	 -- 소재지도로명주소
	museLnmadr				varchar(200),	 -- 소재지지번주소
	museLatitude			varchar(50),	 -- 위도
	museLongitude			varchar(50),	 -- 경도
	musePhone				varchar(15),	 -- 운영기관전화번호
	museInsName				varchar(300),	 -- 운영기관명
	museUrl					varchar(200),	 -- 운영홈페이지
	fcltyInfo				varchar(1000),	 -- 편의시설정보
	museWeekOpen			varchar(20),	 -- 평일관람시작시각
	museWeekClose			varchar(20),	 -- 평일관람종료시각
	museHolidayOpen			varchar(20),	 -- 공휴일관람시작시각
	museHolidayClose		varchar(20),	 -- 공휴일관람종료시각
	rstdeInfo				varchar(1000),	 -- 휴관정보
	museCharge				varchar(100),	 -- 어른관람료
	museIntro				varchar(1000),	 -- 박물관미술관소개
	museTransport			varchar(1000)	 -- 교통안내정보
);

-- INSERT INTO MUSEUM VALUES();
--
-- COMMIT;

--------------- MUSE_REPLY 관련 테이블 ------------------

CREATE TABLE M_REPLY(
  mReplyNo INT PRIMARY KEY AUTO_INCREMENT,
  museNo INT,
  memberNo INT,
  content VARCHAR(400),
  good INT,
  bad INT,
  STATUS VARCHAR(1) DEFAULT 'Y' CHECK (STATUS IN ('Y', 'N')),
  createDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  modifyDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  star INT,
  FOREIGN KEY (museNo) REFERENCES MUSEUM(museNo),
  FOREIGN KEY (memberNo) REFERENCES MEMBER(memberNo)
);

-- INSERT INTO REPLY VALUES(0, 1, 1, '안녕하세요.', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
--

CREATE TABLE bookmark_muse(
	bookmarkMuseNo INT AUTO_INCREMENT PRIMARY KEY,
	museNo	INT,
    memberNo INT,
    FOREIGN KEY (museNo) REFERENCES MUSEUM(museNo),
    FOREIGN KEY (memberNo) REFERENCES MEMBER(memberNo)
);
COMMIT;

--------------- EXHIBITION 관련 테이블 ------------------

CREATE TABLE EXHIBITION (
	exNo            	int PRIMARY KEY AUTO_INCREMENT,     -- 특별전시 고유 키
	exName	        	varchar(100),	-- 특별전시 이름
	exMuseName			varchar(100),	-- 전시 박물관 
	exStartDate	        DATETIME,		-- 특별전시 시작일 
	exEndDate			DATETIME,		-- 특별전시 종료일 
	exWeekOpen		 	varchar(100),	-- 평일 관람 시작 시간 
	exWeekClose			varchar(100),	-- 평일 관람 종료 시간 
	exHolidayOpen	    varchar(100),	-- 주말, 공휴일 관람시간
	exHolidayClose		varchar(100),	-- 주말, 공휴일 관람 종료 시간 
	exContactNum	    varchar(100),	-- 문의 전화번호
	exCharge			varchar(100),	-- 관람료
	exDesc	         	varchar(4000),	-- 전시 설명
    exUrl				VARCHAR(1000)	-- 전시 이미지 경로
);

-- INSERT INTO EXHIBITION VALUES();
-- COMMIT;
----------------------------------- DDL 끝-------------------------------------------
