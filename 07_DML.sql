/* *********************************************************************
INSERT 문 - 행 추가
구문
 - 한행추가 :
   - INSERT INTO 테이블명 (컬럼 [, 컬럼]) VALUES (값 [, 값[])
   - 모든 컬럼에 값을 넣을 경우 컬럼 지정구문은 생략 할 수 있다.

 - 조회결과를 INSERT 하기 (subquery 이용)
   - INSERT INTO 테이블명 (컬럼 [, 컬럼])  SELECT 구문
	- INSERT할 컬럼과 조회한(subquery) 컬럼의 개수와 타입이 맞아야 한다.
	- 모든 컬럼에 다 넣을 경우 컬럼 설정은 생략할 수 있다. -->단, 값의 순서느 테이블 생성 시 지정한 컬럼순**
    
    -NULL: null값
    -DATE: '년/월/일' 이외의 조합은 to_date()변환 , sysdate (실행시점의 일시를 표현해줌)
    
************************************************************************ */
insert into emp (emp_id, emp_name,job_id, mgr_id, hire_date, salary, comm_pct, dept_id)
values (1100,'박철수', NULL,120,to_date('2013/03','yyyy/mm'),5000,0.1,NULL);    --값을 넣지 않을 것이면 NULL로 설정한다****ㄴ

insert into emp (emp_id, emp_name,job_id, mgr_id, hire_date, salary, comm_pct, dept_id)
values (1200,'박철수', NULL,120,sysdate,5000,0.1,NULL);    --값을 넣지 않을 것이면 NULL로 설정한다****ㄴ

select *
from emp
order by emp_id desc;

--**************************************에러 나는 것들**********************************
insert into emp (emp_id, emp_name, hire_date)  --salary: NOT NULL 제약 조건--> 반드시 값이 들어가야 한다. 
values (1300,'yoojin','2019/10/30');

--salary의 정수부: 5자리. --->7자리 (데이터 크기가 컬럼의 크기보다 크면 에러난다!!!!)
insert into emp (emp_id, emp_name, hire_date, salary)   
values (1400,'이순신','2019/11/30',1000000);  --salary의 정수부는 5자리까지만 가능! (제약 조건) 

--제약조건: primary key (기본키) 컬럼에 같은 값을 insert 못함. 
insert into emp (emp_id, emp_name, hire_date, salary)   
values (1400,'이순신이순신','2019/11/30',10000);  

--외래키 컬럼에는 반드시 부모테이블의 primary key 컬럼에 있는 값들만 넣을 수 있다.**

--table emp2 생성
create table emp2(
emp_id number(6),
emp_name varchar2(20),
salary number(7,2)
);

--emp에서 조회한 값을 emp2에 insert
insert into emp2 (emp_id, emp_name, salary)
select emp_id, emp_name, salary from emp
where dept_id=10;

select *
from emp2;


--***************************************************************************************************
--TODO: 부서별 직원의 급여에 대한 통계 테이블 생성. 
--      조회결과를 insert. 집계: 합계, 평균, 최대, 최소, 분산, 표준편차
drop table salary_stat;
create table salary_stat(
dept_id number(6),
salary_sum number(15,2),
salary_avg number(10,2), --실수형ㅇ 나올 수 있기 때문
salary_max number(7,2),
salary_min number(7,2),
salary_var number(20,2),
salary_stddev number(7,2)
);

insert into salary_stat
select 
    sum(salary),
    round(avg(salary),2),
    max(salary),
    min(salary),
    round(variance(salary),2),
    round(stddev(salary),2)
from emp
group by dept_id
order by 1;

/* *********************************************************************
UPDATE : 테이블의 컬럼의 값을 수정
UPDATE 테이블명
SET    변경할 컬럼 = 변경할 값  [, 변경할 컬럼 = 변경할 값]
[WHERE 제약조건]


--**********UPDATE 는 테이블 하나씩만 가능. 

 - UPDATE: 변경할 테이블 지정
 - SET: 변경할 컬럼과 값을 지정
 - WHERE: 변경할 행을 선택. 
************************************************************************ */

-- 직원 ID가 200인 직원의 급여를 5000으로 변경
select *
from emp
where emp_id=200;

update emp 
set salary=5000;   -- 5000으로 다 변경하였다.  (행에 대한 제약이 없으므로 전체적으로 바꿈)

commit;        --select는 데이터를 바꾸지 않지만, update, insert 은 데이터를 바꾸는 것! 
               --이 과정에서 발생하는 실수를 rollback 사용하고, commit을 사용하면 더이상 rollback이 안되도록!!!
rollback;   -- UNDO

update emp 
set salary=5000
where emp_id=200;  --제약조건을 줌으로써 원하는 행만 수정가능. 

-- 직원 ID가 200인 직원의 급여를 10% 인상한 값으로 변경.

select *
from emp
where emp_id=200;

update emp
set salary=salary*1.1
where emp_id=200;

-- 부서 ID가 100인 직원의 커미션 비율을 0.2로 salary는 3000을 더한 값으로 변경.
select *
from emp
where dept_id=100;

update emp
set comm_pct=0.2, salary=salary+300   --쉼표를 사용하여 두 개이상의 수정을 할 수 있다****
where dept_it=100;

rollback;
-- TODO: 부서 ID가 100인 직원들의 급여를 100% 인상
select *
from emp
where dept_id=100;

update emp
set salary=salary*2
where dept_id=100;

rollback;

-- TODO: IT 부서의 직원들의 급여를 3배 인상
select *
from emp e join dept d on e.dept_id=d.dept_id
where dept_name='IT';

update emp
set salary=salary*3
where dept_name='IT';

rollback;

-- TODO: EMP2 테이블의 모든 데이터를 MGR_ID는 NULL로 HIRE_DATE 는 현재일시로 COMM_PCT는 0.5로 수정.
select *
from emp;

update emp
set mgr_id=null, hire_date=sysdate, comm_pct=0.5;
rollback;
/* *********************************************************************
DELETE : 테이블의 행을 삭제
구문 
 - DELETE FROM 테이블명 [WHERE 제약조건]
   - WHERE: 삭제할 행을 선택
   
   --자식 테이블에서 참조하고 있는 테이블은 삭제가 안된다.
   --->참조하고 있는 값들을 다 NULL로 바꾸거나 직원을 다 삭제.   x  ccxccvx
   ---->자동으로 삭제할 수 있도록 하는 키워드 -->cascade, 
************************************************************************ */

delete from emp 
where dept_id=100;
rollback;
-- TODO: 부서 ID가 없는 직원들을 삭제
delete 
from emp
where dept_id is null;

-- TODO: 담당 업무(emp.job_id)가 'SA_MAN'이고 급여(emp.salary) 가 12000 미만인 직원들을 삭제.
delete
from emp
where job_id='SA_MAN' and salary<12000;    --참조가 되고 있는 자식 테이블이 존재하므로..함부로 삭제X -->값들을 null로 바꿔주던가 해야함.


-- TODO: comm_pct 가 null이고 job_id 가 IT_PROG인 직원들을 삭제
delete 
from emp
where comm_pct is null and job_id='IT_PROG';

