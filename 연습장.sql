-- 0914 연습

-- [08_SUBQUERY]

-- 부서코드가 노옹철사원과 같은 소속의 직원의 
-- 이름, 부서코드 조회하기
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE= (
SELECT DEPT_CODE 
FROM EMPLOYEE 
WHERE EMP_NAME='노옹철'
);

-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 
-- 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY> 
(SELECT AVG(SALARY) FROM EMPLOYEE);

-- 전 직원의 급여 평균보다 많은 급여를 받는 직원의 
-- 이름, 직급, 부서, 급여를 직급 순으로 정렬하여 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE SALARY> 
(SELECT AVG(SALARY) FROM EMPLOYEE)
ORDER BY JOB_NAME;

-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급, 부서코드, 급여, 입사일을 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY=
(SELECT MIN(SALARY) FROM EMPLOYEE);

-- 노옹철 사원의 급여보다 많이 받는 직원의 
-- 사번, 이름, 부서, 직급, 급여를 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID=DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE SALARY> 
(SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME='노옹철');

-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의
-- 부서명, 급여 합계를 조회 
SELECT NVL(DEPT_TITLE, '부서없음') 부서명, SUM(SALARY) 급여합
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY)=
(SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);

-- 부서별 최고 급여를 받는 직원의 
-- 이름, 직급, 부서코드, 급여를 부서 순으로 정렬하여 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY IN (SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- 사수에 해당하는 직원에 대해 조회 
--  사번, 이름, 부서명, 직급명, 구분(사수 / 직원)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, 
	   CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
							FROM EMPLOYEE
							WHERE MANAGER_ID IS NOT NULL)
		 	THEN '사수'
		 	ELSE '사번'
	   END 구분
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID=DEPT_CODE)
JOIN JOB USING(JOB_CODE);

-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='대리'
AND SALARY >
(SELECT MIN(SALARY) 
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='과장');
-- 단, > ANY 혹은 < ANY 연산자를 사용하세요
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='대리'
AND SALARY >ANY 
(SELECT SALARY 
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='과장');

-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE='KO'; --단일행
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가 
SELECT DEPT_ID 
FROM DEPARTMENT 
WHERE LOCATION_ID =
(SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE='KO'); --다중행
-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN
(SELECT DEPT_ID FROM DEPARTMENT 
WHERE LOCATION_ID =
(SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE='KO'));

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회     
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE 
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) =
(SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)='2'
AND ENT_YN='Y');

-- 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회하시오
--    사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE)=
(SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE)='2000');

-- 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID )=
(SELECT DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2)='77'
AND SUBSTR(EMP_NO,8,1)='2');

-- 본인 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원단위로 계산하세요 TRUNC(컬럼명, -4)   
SELECT EMP_ID, EMP_NAME, JOB_CODE, TRUNC(SALARY,-4)
FROM EMPLOYEE
WHERE (JOB_CODE,TRUNC(SALARY,-4)) IN
(SELECT JOB_CODE, TRUNC(AVG(SALARY),-4)
FROM EMPLOYEE
GROUP BY JOB_CODE)

-- 사수가 있는 직원의 사번, 이름, 부서명, 사수사번 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON(DEPT_ID=DEPT_CODE)
WHERE MANAGER_ID =
(SELECT EMP_ID
FROM EMPLOYEE SUB
WHERE SUB.EMP_ID=MAIN.MANAGER_ID);

-- 직급별 급여 평균보다 급여를 많이 받는 직원의 
-- 이름, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE MAIN
WHERE SALARY >
(SELECT AVG(SALARY)
FROM EMPLOYEE SUB
WHERE SUB.JOB_CODE=MAIN.JOB_CODE)

-- 부서별 입사일이 가장 빠른 사원의
--    사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
--    입사일이 빠른 순으로 조회하세요
--    단, 퇴사한 직원은 제외하고 조회하세요
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE,'소속없음') 부서명, JOB_NAME, HIRE_DATE
FROM EMPLOYEE MAIN
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_ID=DEPT_CODE)
WHERE ENT_YN='N'
AND HIRE_DATE=(
SELECT MIN(HIRE_DATE)
FROM EMPLOYEE SUB
WHERE MAIN.DEPT_CODE=SUB.DEPT_CODE)
ORDER BY HIRE_DATE;

-- 모든 직원의 이름, 직급, 전체 사원 중 가장 높은 급여와의 차
SELECT EMP_NAME, JOB_CODE, SALARY,
(SELECT MAX(SALARY) FROM EMPLOYEE)-SALARY
FROM EMPLOYEE;

-- 각 직원들이 속한 직급의 급여 평균 조회
SELECT EMP_NAME, JOB_CODE, SALARY,
(SELECT AVG(SALARY) 
FROM EMPLOYEE SUB
WHERE SUB.JOB_CODE=MAIN.JOB_CODE)
FROM EMPLOYEE MAIN;

-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회
-- 단 관리자가 없는 경우 '없음'으로 표시
-- (스칼라 + 상관 쿼리)
SELECT EMP_ID, EMP_NAME, MANAGER_ID, 
NVL((SELECT EMP_NAME
FROM EMPLOYEE SUB
WHERE SUB.EMP_ID=MAIN.MANAGER_ID),'없음')
FROM EMPLOYEE MAIN;

-- 인라인뷰를 활용한 TOP-N분석
-- 전 직원 중 급여가 높은 상위 5명의
-- 순위, 이름, 급여 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
		FROM EMPLOYEE
		ORDER BY SALARY DESC)
WHERE ROWNUM<=5;

-- 급여 평균이 3위 안에 드는 부서의 부서코드와 부서명, 평균급여를 조회
-- 별칭이 아니면 오류 남 질문하기
SELECT ROWNUM, DEPT_CODE, DEPT_TITLE, AVG(SALARY)
FROM (SELECT DEPT_CODE, DEPT_TITLE, AVG(SALARY) 평균급여
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID=DEPT_CODE)
GROUP BY DEPT_CODE, DEPT_TITLE
ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM<=3;







