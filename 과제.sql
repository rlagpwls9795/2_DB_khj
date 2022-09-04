-- BASIC
-- 1. 춘 기술대학교의 학과 이름과 계열을 표시하시요. 단, 출력 헤더는 "학과 명", "계열" 으로 표시하도록 한다.
SELECT DEPARTMENT_NAME "학과 명", CATEGORY "계열"
FROM TB_DEPARTMENT;

-- 2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다. 
SELECT DEPARTMENT_NAME || '의 정원은 ' ||  CAPACITY || '명 입니다.' AS "학과별 정원"
FROM TB_DEPARTMENT;

-- 3. "국어국문학과"에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다 누구인가?
-- (국문학과의 '학과코드'는 학과 테이블을 조회해서 찾아 내도록 하자)
SELECT STUDENT_NAME
FROM TB_STUDENT
NATURAL JOIN TB_DEPARTMENT
WHERE DEPARTMENT_NAME='국어국문학과'
AND ABSENCE_YN='Y'
AND SUBSTR(STUDENT_SSN, 8,1)='2';

-- 4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 
-- 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오

-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY >=20 AND CAPACITY <=30

-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다.
-- 그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오. 
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
-- 어떠한 SQL문장을 사용하면 될 것인지 작성하시오.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO='';

-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회하시오.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9. 춘 대학에는 어떤 계열들이 있는지 조회해보시오.
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;

-- 10. 02학번 전주 거주자들의 모임을 만들려고 한다. 
-- 휴학한 사람을 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE STUDENT_NO LIKE 'A2%'
AND STUDENT_ADDRESS LIKE '%전주%'
AND ABSENCE_YN ='N';

-- FUNCTION
-- 1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학년도를 입학년도가 빠른 순으로 표시하는
-- SQL 문장 작성 (단, 헤더는 "학번","이름","입학년도")
SELECT STUDENT_NO "학번", STUDENT_NAME "이름", TO_CHAR(ENTRANCE_DATE,'YYYY-MM-DD') "입학년도"
FROM TB_STUDENT
NATURAL JOIN TB_DEPARTMENT
WHERE DEPARTMENT_NO='002'
ORDER BY ENTRANCE_DATE ;

---------------*********-----------------
-- 2. 춘 기술대학교의 교수 중 이름이 세글자가 아닌 교수가 한 명 있다고 한다. 그 교수의 이름과 주민번호 출력
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE INSTR(PROFESSOR_NAME, ' ')

--------------*******-------------------
-- 3. 
SELECT PROFESSOR_NAME "교수이름", 
CEIL(MONTHS_BETWEEN(TO_DATE(SUBSTR(PROFESSOR_SSN,1,6)),SYSDATE)/12) "나이"
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1)='1' 
ORDER BY PROFESSOR_SSN;

-- 4. 
SELECT SUBSTR(PROFESSOR_NAME,2,2) "이름"
FROM TB_PROFESSOR;

-- 5. 
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT

-- 6. 2020년 크리스마스는 무슨 요일인가?
SELECT TO_CHAR(TO_DATE('2020-12-25'), 'DY"요일"')
FROM DUAL;

-- 7. 
SELECT TO_DATE('99/10/11','YY/MM/DD') FROM DUAL; --2099년
SELECT TO_DATE('49/10/11','YY/MM/DD') FROM DUAL; --2049년

SELECT TO_DATE('99/10/11','RR/MM/DD') FROM DUAL; --1999년
SELECT TO_DATE('49/10/11','RR/MM/DD') FROM DUAL; --2049년

-- 8. 
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_NO,1,1) <> 'A'

-- 9.
SELECT ROUND(AVG(G.POINT),1) "평점"
FROM TB_STUDENT S
NATURAL JOIN TB_GRADE G
WHERE S.STUDENT_NAME='한아름';

-- 10.
SELECT DEPARTMENT_NO "학과번호", COUNT(*) "학생수(명)"
FROM TB_STUDENT 
GROUP BY DEPARTMENT_NO
ORDER BY 1;

-- 11.
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12.
SELECT SUBSTR(TERM_NO,1,4) "년도", ROUND(AVG(POINT),1) "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO ='A112113'
GROUP BY SUBSTR(TERM_NO,1,4)
ORDER BY 1;

----------------*****-----------------------------
-- 13.
SELECT DEPARTMENT_NO, COUNT(*)
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
WHERE  ABSENCE_YN  ='Y'
GROUP BY DEPATMENT_NO;

-----------------*****----------------------------
-- 14.
SELECT STUDENT_NAME
FROM TB_STUDENT T1
JOIN TB_STUDENT T2 ON(T1.STUDENT_NO=T2.STUDENT_NO)
WHERE T1.STUDENT_NAME=T2.STUDENT_NAME;

-----------------*****----------------------------
-- 15. 
SELECT SUBSTR(TERM_NO,5,2), AVG(POINT)
FROM TB_GRADE
GROUP BY SUBSTR(TERM_NO,5,2)
WHERE STUDENT_NO ='A112113';
