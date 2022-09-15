-- DDL(Data Definition Language)
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP)하는 데이터 정의 언어

/* ALTER(바꾸다, 수정하다, 변조하다)
- 테이블에서 수정할 수 있는 것
1) 제약 조건 (추가/삭제)
2) 컬럼 (추가/수정/삭제)
3) 이름 변경 (테이블명, 제약조건명, 컬럼명)
*/

--------------------------------------------------------------------------------------

-- 1. 제약조건 (추가/삭제)

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 제약조건(지정할 컬럼명)
--			[REFERENCES 테이블명(컬럼명)]; -- FK인 경우
-- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
-- * 수정은 별도 존재 X -> 삭제 후 추가

--DEPARTMENT 테이블 복사 (컬럼명, 데이터 타입, NOT NULL만 복사)
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT TITLE_U UNIQUE(DEPT_TITLE);

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT TITLE_U;

-- ** DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제 **
ALTER TABLE DEPT_COPY ADD CONSTRAINT TITLE_NN NOT NULL(DEPT_TITLE);
--> NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아닌 
--  컬럼 자체에 NULL 허용/비허용을 제어하는 성질 변경의 형태로 인식
-- MODIFY(수정하다) 구문 사용헤서 NULL 제어
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NOT NULL; --DEPT_TITLE 컬럼을 NOT NULL로 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NULL; --DEPT_TITLE 컬럼 NOT NULL 삭제


--------------------------------------------------------------------------------------

-- 2. 컬럼 (추가/수정/삭제)

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);
-- 2) 수정 : ALTER TABLE 테이블명 MODIFY 컬럼명 데이터 타입; => 데이터 타입 변경
--          ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; => DEFAULT 값 변경
--   	    ALTER TABLE 테이블명 MODIFY 컬럼명 NULL/NOT NULL; => NULL 여부 변경									
-- 3) 삭제 : ALTER TABLE 테이블명 DROP(삭제할 컬럼명);
--          ALTER TABLE 테이블명 DROP COLUMN 삭제할 컬럼명;
--    * 컬럼 삭제 시 주의 사항 *
--     테이블이란 행과 열로 이루어진 DB에 가장 기본적인 객체, 테이블에 데이터가 저장됨
--     테이블은 최소 1개 이상의 컬럼이 존재해야 되기 때문에 모든 컬럼을 삭제하는 건 불가

SELECT * FROM DEPT_COPY;

-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD(CNAME VARCHAR2(30));
SELECT * FROM DEPT_COPY;

-- LNAME 컬럼 추가(기본값 '한국')
ALTER TABLE DEPT_COPY ADD(LNAME VARCHAR2(30) DEFAULT '한국');
SELECT * FROM DEPT_COPY;
--> 컬럼이 생성되면서 DEFAULT 값이 자동 삽입됨

-- D10 개발1팀 추가
INSERT INTO DEPT_COPY VALUES('D10','개발1팀','L1', DEFAULT, DEFAULT);
-- ORA-12899: "KH_KHJ"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)
--> DEPT_ID 컬럼 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR(3);
INSERT INTO DEPT_COPY VALUES('D10','개발1팀','L1', DEFAULT, DEFAULT);
SELECT * FROM DEPT_COPY;

-- LNAME 기본값을 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
SELECT * FROM DEPT_COPY; --> 기본 값을 변경했다고 기존 데이터는 바뀌지 않음

-- LNAME '한국' -> 'KOREA'로 변경
UPDATE DEPT_COPY SET LNAME=DEFAULT WHERE LNAME='한국'; 
SELECT * FROM DEPT_COPY;
COMMIT;

-- 모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP(LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP(LOCATION_ID);
ALTER TABLE DEPT_COPY DROP(DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

SELECT * FROM DEPT_COPY;

-- 테이블 삭제
DROP TABLE DEPT_COPY;

-- DEPARTMENT 테이블 복사해서 DEPT_COPY 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
--> 컬럼명, 데이터타입, NULL여부만 복사
-- DEPT_COPY 테이블에 PK(DEPT_ID 컬럼에 D_COPY_PK) 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);

--------------------------------------------------------------------------------------

-- 3. 이름 변경 (테이블명, 제약조건명, 컬럼명)

-- 1) 컬럼명 변경 (DEPT_TITLE -> DEPT_NAME)
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
SELECT * FROM DEPT_COPY;

-- 2) 제약조건명 변경 (D_COPY_PK -> DEPT_COPY_PK)  
ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

-- 3) 테이블명 변경 (DEPT_COPY -> DCOPY)
ALTER TABLE DEPT_COPY RENAME TO D_COPY;
SELECT * FROM D_COPY;

--------------------------------------------------------------------------------------

-- 4. 테이블 삭제
-- [작성법]
-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS];

-- 1) 관걔가 형성되지 않은 테이블(DCOPY) 삭제
DROP TABLE D_COPY;

-- 2) 관계가 형성된 테이블 삭제
CREATE TABLE TB1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER
);

CREATE  TABLE TB2(	
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER REFERENCES TB1
);

--TB1에 샘플 데이터 삽입
INSERT INTO TB1 VALUES(1,100);
INSERT INTO TB1 VALUES(2,200);
INSERT INTO TB1 VALUES(3,300);
COMMIT;

--TB2에 샘플 데이터 삽입
INSERT INTO TB2 VALUES(11,1);
INSERT INTO TB2 VALUES(12,2);
INSERT INTO TB2 VALUES(13,3);

INSERT INTO TB2 VALUES(14,4); 
--ORA-02291: 무결성 제약조건(KH_KHJ.SYS_C008455)이 위배되었습니다- 부모 키가 없습니다

-- TB1 삭제
DROP TABLE TB1;
-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
--> 해결 방법
-- 1) 자식, 부모 테이블 순서로 삭제
-- 2) ALTER를 이용해서 FK 제약조건 삭제 후 TB1 삭제
-- 3) DROP TABLE 삭제 옵션 CASCADE CONSTRAINTS 사용
    --> CASCADE CONSTRAINTS : 삭제하려는 테이블과 연결된 FK 제약 조건을 모두 삭제

DROP TABLE TB1 CASCADE CONSTRAINTS; --> 삭제 성공

--------------------------------------------------------------------------

/* DDL 주의 사항 */ 
-- 1) DDL은 COMMIT, ROLLBACK 불가 => ALTER, DROP을 신중하게 진행
-- 2) DDL과 DML 구문을 섞어서 수행하면 안 됨
  --> DDL은 수행 시 존재하고 있는 트랜잭션을 모두 DB에 강제 COMMIT   
  --> DDL이 종료된 후 DML 구문을 수행할 수 있도록 권장
SELECT * FROM TB2;
COMMIT;

INSERT INTO TB2 VALUES(14,4);
INSERT INTO TB2 VALUES(15,5);
SELECT * FROM TB2;

-- 컬럼명 변경 DDL
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLCOL;
ROLLBACK;

SELECT * FROM TB2;
