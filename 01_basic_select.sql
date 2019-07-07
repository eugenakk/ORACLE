/* *************************************
Select 기본 구문 - 연산자, 컬럼 별칭
select 컬럼명, 컬럼명......  -->컬럼
from
where
group by
having
order by
*************************************** */
desc emp;
--EMP 테이블의 모든 컬럼의 모든 항목을 조회.
select *
from EMP;

select emp_id, emp_name,job,mgr_id,hire_date,salary,comm_pct,dept_name
from emp;

--EMP 테이블의 직원 ID(emp_id), 직원 이름(emp_name), 업무(job) 컬럼의 값을 조회.
select emp_id, emp_name,job
from emp;

--EMP 테이블의 업무(job) 어떤 값들로 구성되었는지 조회. - 동일한 값은 하나씩만 조회되도록 처리.
select distinct job
from emp;

--EMP 테이블의 부서명(dept_name)이 어떤 값들로 구성되었는지 조회 - 동일한 값은 하나씩만 조회되도록 처리.
select distinct dept_name
from emp;

select distinct job,dept_name    --이것은 job,dept_name 따로 보는 것이 아니라 같이.
from emp;

--EMP 테이블에서 emp_id는 직원ID, emp_name은 직원이름, hire_date는 입사일, salary는 급여, dept_name은 소속부서 별칭으로 조회한다.
select emp_id as 직원ID, emp_name as 직원이름,hire_date as 입사일,salary as 급여,dept_name as 소속부서
from emp;

/* 연산자 */
select 1+1,2-1,3+5,6/4,round(10/3,2)
from dual;

select sysdate from dual;  --sysdate은 오라클에서만 지원. 쿼리문을 실행한 시점의 날짜와 시간을 알려준다. 
                            --내부적으로 시간도 있다. 

select sysdate,sysdate+10, sysdate-10
from dual;

select 10+null
from dual;

--연결연산자*** 값을 합칠 때 사용
--값+값  (붙이고 싶다) 10+10 --> 1010
-- || 을 사용한다!
select 10 || 10
from dual;

select 30 || '세'
from dual;


--EMP 테이블에서 직원의 이름(emp_name), 급여(salary) 그리고  급여 + 1000 한 값을 조회.
select emp_name, salary, salary+1000
from emp;

--EMP 테이블에서 입사일(hire_date)과 입사일에 10일을 더한 날짜를 조회.
select hire_date, hire_date+10    --date 타입이므로 + 연산을 할 수 있다. 
from emp;

--TODO: EMP 테이블에서 직원의 ID(emp_id), 
--이름(emp_name), 급여(salary), 커미션_PCT(comm_pct), 급여에 커미션_PCT를 곱한 값을 조회.
select emp_name, salary, comm_pct, comm_pct*salary  as 커미션
from emp;

--TODO:  EMP 테이블에서 급여(salary)을 연봉으로 조회. (곱하기 12)
select salary*12 연봉
from emp;

--TODO: EMP 테이블에서 직원이름(emp_name)과 급여(salary)을 조회. 급여 앞에 $를 붙여 조회.
select emp_name,
'$' || salary AS 급여
from emp;


--TODO: EMP 테이블에서 입사일(hire_date) 30일전, 입사일, 입사일 30일 후를 조회
select hire_date-30 "30일 전"
,hire_date "입사일"
,hire_date+30 "30일 후"
from emp;

/* *************************************
Where 절을 이용한 행 행 제한
************************************* */
--EMP 테이블에서 직원_ID(emp_id)가 110인 직원의 이름(emp_name)과 부서명(dept_name)을 조회
select emp_name, dept_name
from emp
where emp_id=110;

--EMP 테이블에서 'Sales' 부서에 속하지 않은 직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id,emp_name, dept_name
from emp
where  dept_name<>'Sales';

--EMP 테이블에서 급여(salary)가 $10,000를 초과인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id,emp_name,salary
from emp
where salary>10000;

--EMP 테이블에서 커미션비율(comm_pct)이 0.2~0.3 사이인 직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
 select emp_id,emp_name,comm_pct
 from emp
 where comm_pct between 0.2 and 0.3;

--EMP 테이블에서 커미션을 받는 직원들 중 커미션비율(comm_pct)이 0.2~0.3 사이가 아닌
--직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
 select emp_id,emp_name,comm_pct
 from emp
 where comm_pct not between 0.2 and 0.3;

--EMP 테이블에서 업무(job)가 'IT_PROG' 거나 'ST_MAN' 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select emp_id,emp_name,job
from emp
where job in('IT_PROG','ST_MAN');     --in 연산자의 반대는 not in

--EMP 테이블에서 업무(job)가 'IT_PROG' 나 'ST_MAN' 가 아닌 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select emp_id,emp_name,job
from emp
where job not in('IT_PROG','ST_MAN');

--EMP 테이블에서 직원 이름(emp_name)이 S로 시작하는 직원의  ID(emp_id), 이름(emp_name)
select emp_id,emp_name
from emp
where emp_name like 'S%';

--EMP 테이블에서 직원 이름(emp_name)이 S로 시작하지 않는 직원의  ID(emp_id), 이름(emp_name)
select emp_id,emp_name
from emp
where emp_name not like 'S%';

--EMP 테이블에서 직원 이름(emp_name)이 en으로 끝나는 직원의  ID(emp_id), 이름(emp_name)을 조회
select emp_id,emp_name
from emp
where emp_name like '%en';

---XXX로 시작하는: xxx%
--xxx로 끝나는 : %xxx
--xxx가 들어간 무언가를 찾고 싶다면~ : %xxx%
-- 'S_%'는 .... 최소 2글자. S로 시작하고 ~

--EMP 테이블에서 직원 이름(emp_name)의 세 번째 문자가 “e”인 모든 사원의 이름을 조회
select emp_name
from emp
where substr(emp_name,3,1)='e';  --?????????만약 100번째 문자가 "e"인것을 찾는다면..?
--where emp_name like '__e%';  

-- EMP 테이블에서 직원의 이름에 '%' 가 들어가는 직원의 ID(emp_id), 직원이름(emp_name) 조회
select emp_id, emp_name
from emp
where emp_name like '%#%%' escape '#';  --#을 써도 되고 @를 써도 된다. 

--EMP 테이블에서 부서명(dept_name)이 null인 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id,emp_name,dept_name
from emp
where dept_name is null;  -- dept_name=null 이라고 하는 것은 말이 안됨. 

--부서명(dept_name) 이 NULL이 아닌 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name) 조회
select emp_id,emp_name,dept_name
from emp
where dept_name is not null;

--TODO: EMP 테이블에서 업무(job)가 'IT_PROG'인 직원들의 모든 컬럼의 데이터를 조회. 
select *
from emp
where job='IT_PROG';

--TODO: EMP 테이블에서 업무(job)가 'IT_PROG'가 아닌 직원들의 모든 컬럼의 데이터를 조회. 
select *
from emp
where job<> 'IT_PROG';    -- <> 는 아닌 것을 의미!

--TODO: EMP 테이블에서 이름(emp_name)이 'Peter'인 직원들의 모든 컬럼의 데이터를 조회
select *
from emp
where emp_name='Peter';


--TODO: EMP 테이블에서 급여(salary)가 $10,000 이상인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id,emp_name,salary
from emp
where salary>=10000;

--TODO: EMP 테이블에서 급여(salary)가 $3,000 미만인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id,emp_name,salary
from emp
where salary<3000;

--TODO: EMP 테이블에서 급여(salary)가 $3,000 이하인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id,emp_name,salary
from emp
where salary<=3000;

--TODO: 급여(salary)가 $4,000에서 $8,000 사이에 포함된 직원들의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id,emp_name,salary
from emp
where salary between 4000 and 8000;  --between   ~ and ~

--TODO: 급여(salary)가 $4,000에서 $8,000 사이에 포함되지 않는 모든 직원들의  ID(emp_id), 이름(emp_name), 급여(salary)를 표시
select emp_id,emp_name,salary
from emp
where salary not between 4000 and 8000;

--TODO: EMP 테이블에서 2007년 이후 입사한 직원들의  ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
select emp_id,emp_name, hire_date
from emp
where to_char(hire_date,'YYYY')>=2007;     --to_char(hire_date,'YYYY' 을 이용하여 년도를 구함

--TODO: EMP 테이블에서 2004년에 입사한 직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
select emp_id,emp_name, hire_date
from emp
where to_char(hire_date,'YYYY')=2004;

--TODO: EMP 테이블에서 2005년 ~ 2007년 사이에 입사(hire_date)한 직원들의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date)을 조회.
select emp_id,emp_name, hire_date
from emp
where to_char(hire_date,'YYYY')>2004 and to_char(hire_date,'YYYY')<2008;

--TODO: EMP 테이블에서 직원의 ID(emp_id)가 110, 120, 130 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회
select emp_id,emp_name,job
from emp
where emp_id in(110,120,130);

--TODO: EMP 테이블에서 부서(dept_name)가 'IT', 
--'Finance', 'Marketing' 인 직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id,emp_name,dept_name
from emp
where dept_name in ('IT','Finance','Marketing');

--TODO: EMP 테이블에서 'Sales' 와 'IT', 'Shipping' 부서(dept_name)가 아닌
--직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id,emp_name,dept_name
from emp
where dept_name not in ('Sales','IT','Shipping');

--TODO: EMP 테이블에서 급여(salary)가 17,000, 9,000,  3,100 인
--직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select emp_id,emp_name,job, salary
from emp
where salary in (17000,9000,3100);

--TODO EMP 테이블에서 업무(job)에 'SA'가 들어간 직원의 ID(emp_id), 이름(emp_name), 업무(job)를 조회
select emp_id,emp_name,job
from emp
where job like 'SA%';

--TODO: EMP 테이블에서 업무(job)가 'MAN'로 끝나는 직원의 ID(emp_id), 이름(emp_name), 업무(job)를 조회
select emp_id,emp_name,job
from emp
where job like '%MAN';

--TODO. EMP 테이블에서 커미션이 없는(comm_pct가 null인) 
--모든 직원의 ID(emp_id), 이름(emp_name), 급여(salary) 및 커미션비율(comm_pct)을 조회
select emp_id, emp_name,salary,comm_pct
from emp
where comm_pct is NULL;
    
--TODO: EMP 테이블에서 커미션을 받는 모든 직원의 ID(emp_id), 이름(emp_name), 
--급여(salary) 및 커미션비율(comm_pct)을 조회
select emp_id, emp_name,salary,comm_pct
from emp
where comm_pct is not NULL;

--TODO: EMP 테이블에서 관리자 ID(mgr_id) 없는 직원의 ID(emp_id), 이름(emp_name), 
--업무(job), 소속부서(dept_name)를 조회
select emp_id, emp_name,job,dept_name
from emp
where mgr_id is NULL;

--TODO : EMP 테이블에서 연봉(salary * 12) 이 200,000 이상인 직원들의 모든 정보를 조회.
select *
from emp
where salary*12 >=200000;

/* *************************************
 WHERE 조건이 여러개인 경우
 AND OR
 **************************************/
-- EMP 테이블에서 업무(job)가 'SA_REP' 이고 급여(salary)가 $9,000 인 직원의 직원의 
--ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select emp_id,emp_name,job,salary
from emp
where job='SA_REP' and salary=9000;

-- EMP 테이블에서 업무(job)가 'FI_ACCOUNT' 거나 급여(salary)
--가 $8,000 이상인인 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select emp_id,emp_name,job,salary
from emp
where job='FI_ACCOUNT' or salary>=8000;

--TODO: EMP 테이블에서 부서(dept_name)가 'Sales이'고 업무(job)가 'SA_MAN' 이고 급여가 $13,000 이하인 
--      직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary), 부서(dept_name)를 조회
select emp_id,emp_name,job,salary,dept_name
from emp
where dept_name='Sales' and job='SA_MAN' and salary<=13000;

--TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서(dept_name)가 'Shipping' 이고 2005년이후 입사한 
--      직원들의  ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date), 부서(dept_name)를 조회
select emp_id,emp_name,job,salary,hire_date,dept_name
from emp
where dept_name='Shipping' and job like '%MAN%' and hire_date > '2005-01-01';
--and to_char(hire_date,'YYYY')>'2004';

--TODO: EMP 테이블에서 입사년도가 2004년인 직원들과 급여가 $20,000 이상인 
--      직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date), 급여(salary)를 조회.
select emp_id,emp_name,hire_date,salary
from emp
where salary>=10000 and to_char(hire_date,'YYYY')='2004';

--TODO : EMP 테이블에서, 부서이름(dept_name)이 
--'Executive'나 'Shipping' 이면서 급여(salary)가 6000 이상인 사원의 모든 정보 조회. 
select *
from emp
where dept_name in ('Executive','Shipping') and salary>=6000;

--TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서이름(dept_name)이 'Marketing' 이거나 'Sales'인 
--      직원의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)를 조회
select emp_id,emp_name,job,dept_name
from emp
where dept_name in ('Marketing','Sales') and job like '%MAN%' ;

--TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중 급여(salary)가 $10,000 이하이 거나 2008년 이후 입사한 
--      직원의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date), 급여(salary)를 조회
select emp_id, emp_name, job, hire_date, salary
from emp
where job like '%MAN%' and (salary<=10000 or to_char(hire_date,'YYYY')>=2008);

/* *************************************
order by를 이용한 정렬
************************************* */

-- 직원들의 전체 정보를 직원 ID(emp_id)가 큰 순서대로 정렬해 조회
select *
from emp
order by emp_id asc;

-- 직원들의 id(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 
-- 업무(job) 순서대로 (A -> Z) 조회하고 업무(job)가 같은 직원들은  급여(salary)가 높은 순서대로 2차 정렬해서 조회.


--부서명을 부서명(dept_name)의 오름차순으로 정렬해 조회하시오.
select *
from emp
order by emp_id asc;


--TODO: 급여(salary)가 $5,000을 넘는 직원의 ID(emp_id), 이름(emp_name), 급여(salary)를 급여가 높은 순서부터 조회
select emp_id,emp_name,salary
from emp
where salary>5000
order by salary asc;

--TODO: 급여(salary)가 $5,000에서 $10,000 
--사이에 포함되지 않는 모든 직원의  ID(emp_id), 이름(emp_name), 급여(salary)를 이름(emp_name)의 오름차순으로 정렬
select emp_id,emp_name,salary
from emp
where salary between 5000 and 10000
order by emp_name asc;

--TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 업무(job),
--입사일(hire_date)을 입사일(hire_date) 순(오름차순)으로 조회.
select emp_id, emp_name, job,hire_date
from emp
order by hire_date asc;

--TODO: EMP 테이블에서 ID(emp_id), 이름(emp_name), 급여(salary), 입사일(hire_date)을
--급여(salary) 오름차순으로 정렬하고 급여(salary)가 같은 경우는 입사일(hire_date)가 오래된 순서로 정렬.
select emp_id, emp_name,salary, hire_date
from emp
order by salary asc, hire_date desc;

