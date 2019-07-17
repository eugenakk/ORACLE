/* *****************************************
뷰 (View)
- 하나 또는 여러 테이블로 부터 데이터의 부분 집합을 논리적으로 표현하는 것.
- 실제 데이터를 가지고 있는 것이 아니라 해당 데이터의 조회 SELECT 쿼리를 가지고 있는 것.
- 뷰를 이용해 조회뿐만 아니라 데이터 수정(insert/update/delete)도 가능하다.

- 목적
  - 복잡한 select문을 간결하게 처리 가능
  - 사용자의 데이터 접근을 제한  (하나의 데이터를 가지고 여러개의 조회 사항을 만들 수 있다)

- 뷰의 종류
  - 단순뷰 
	- 하나의 테이블에서 데이터를 조회함
    - 함수를 사용하지 않는다.  

  - 복합뷰
	- 여러 테이블에서 데이터를 조회한다.
	- 함수나 group by를 이용해 조회한다.
	
- 뷰를 이용한 DML(INSERT/DELETE/UPDATE) 작업이 안되는 경우
	- 다음 항목이 포함되 있는 뷰는 insert/delete/update 할 수 없다.
		- 그룹함수
		- group by 절
		- distinct 
		- rownum 
		- SELECT 절에 표현식이 있는 경우
		- View와 연결된 행에 NOT NULL 열이 있는 경우
		

- 구문
CREATE [OR REPLACE] VIEW 뷰이름    --REPLACE는 이미 같은 이름을 가진 테이블이 있으면 REPLACE를 해주도록 한다. 
AS
SELECT 문
[WITH CHECK OPTION]                
[WITH READ ONLY]          


- OR REPLACE
	- 같은 이름의 뷰가 있을 경우 삭제하고 새로 생성한다.
	
- WITH CHECK OPTION
	- View에서 조회될 수 있는 값만 insert또는 update할 수 있다.
    

- WITH READ ONLY
	- 읽기 전용 View로 설정. INSERT/DELETE/UPDATE를 할 수 없다.
	
View 제거
DROP VIEW VIEW이름;	
**************************************** */
--예제:
create view emp_view 
as
select * from emp where dept_id=60;

select * from emp_view;

select *
from (select * from emp where dept_id=60);     --inline view******** (이 쿼리문 안에서만 사용가능)

select e.emp_name,d .dept_name       --뷰 테이블과 d 테이블을 조인한 것.
from emp_view e, dept d
where d.dept_id=d.dept_id;

update emp_view 
set comm_pct =0.5
where emp_id=104;
select * from emp_view;  --update 된 행을 볼 수 있다.

select *
from emp
where emp_id=104;   --emp 테이블에서 comm_pct값이 바뀌는 것을 볼 수 있다.
--실제로 뷰에는 값이 존재하지 않기 떄문에, 수정하면 --->원본 테이블의 값(실제 데이터)이 바뀐다***********

create or replace view emp_view            --똑같은 이름의 뷰가 있으면 기존 것을 지워버리고 지금 만든 것으로 대체.*****
as
select emp_id, emp_name, dept_id
from emp;

select *
from emp_view;
select emp_id, emp_name, salary     --오류가 난다. emp_view에 있는 컬럼들만 가지고 조회할 수 있다.
from emp_view;

insert into emp_view
values (5000,'새이름',60);   --emp에 insert되므로 hire_date등 NOT NULL 컬럼 때문에 에러****************

--dept_view 뷰 테이블 생성.
create view dept_view
as
select * from dept where loc='New York';

select * from dept_view;
insert into  dept_view 
values (300,'새부서','서울');  --한 행이 삽입.

select * from dept_view;     -- 실제 조회해보면.. 조회가 안된다.  WHY? 뷰는 New YorK인것만 조회하므로..

select * from dept;   --삽입된 행을 볼 수 있다.

create view dept_view2
as
select * from dept where loc='New York'
with check option;                       --with check option 추가

insert into dept_view2
values (303,'서울부서','서울');          --오류! ---> '서울'은 뷰의 New York 조건과 맞지 않으므로 아예 insert 되지 않음.
                                      --with check option: 지금 뷰의 테이블로 조회될 수 있는 값이 아니면 오류**************************

update dept_view2
set dept_name='aaa'
where dept_id=10;    --0개의 행이 업데이트된다. 뷰에 없는 데이터이기 때문이다.!!!  (에러는 X, 그냥 없어서 X)

select * 
from dept
where dept_id=10;


create view dept_view3
as
select * from dept where loc='New York'
with read only;          --with read only: 

select * from dept_view3;
insert into dept_view3
values (500,'ㅁㅁ','ㅁ');       --read only이므로 insert 못한다는 오류 메시지가 뜬다. 
delete from dept_view3;--read only이므로 insert 못한다는 오류 메시지가 뜬다. 

create view emp_name_view
as
select emp_name, length(emp_name)as 길이        --length()함수를 사용하였다. 함수를 쓰면 에러가 난다. 별칭도 정해줘야한다. 
from emp;

select * 
from emp_name_view;

create view emp_view2
as
select dept_id, max(salary) 최대급여 , min(salary) 최소급여
from emp
group by dept_id;    --dept_id 로 group by 를 해서 집계함수를 사용! (별칭과 함께 사용해야함)

select * 
from emp_view2;

update emp
set salary=20000
where emp_id=108;    --emp 테이블에 있는 값을 update 하면 뷰도 함꼐 변경!!!!!!!!!!

create view emp_dept_view
as
select e.emp_id, e.emp_name, e.salary, e.job_id, e.hire_date, 
        d.dept_id, d.dept_name, d.loc --*를 사용하여 테이블의 모든 항목 조회가능.
from emp e left join dept d on e.dept_id=d.dept_id; 

select * from emp_dept_view;        --미리 조인한 것을 뷰 테이블로 만들어놓았다!!!!!!!!!!!!!!!!!!!!!!!

select * from emp_dept_view
where loc='Seattle';

-----------------------------------------------------------------------------
--TODO: 급여(salary)가 10000 이상인 직원들의 모든 컬럼들을 조회하는 View 생성
create or replace view ex01_view
as
select * from emp where salary>=10000
order by salary;

select * 
from ex01_view;

--TODO: 부서위치(dept.loc) 가 'Seattle'인 부서의 모든 컬럼들을 조회하는 View 생성
create view ex02_view
as
select * from dept
where loc='Seattle';

select *
from dept_view4;

--TODO: JOB_ID가 'FI_ACCOUNT', 'FI_MGR' 인 직원들의 직원_ID(emp.emp_id), 직원이름(emp.emp_name), 업무_ID(emp.job_id), 
-- 업무명(job.job_title), 업무최대급여(job.max_salary), 최소급여(job.min_salary)를 조회하는 View를 생성
create view ex03_view
as
select e.emp_id, e.emp_name, e.job_id, j.job_title, j.max_salary, j.min_salary
from emp e , job j 
where e.job_id=j.job_id(+)   --job 이 not null인 것도 있으므로 (+)추가
and j.job_id in ('FI_ACCOUNT', 'FI_MGR');

select *
from ex03_view;


--CONFUSING*********
--TODO: 직원들의 정보와 직원의 급여 등급(salary_grade.grade)을 조회하는 View를 생성
create view ex05_view
as
select e.*, sg.*
from emp e, salary_grade sg 
where e.salary between sg.low_sal and sg.high_sal;

select * from ex05_view;

--TODO: 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 입사일(emp.hire_date),
--   상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회하는 View를 생성
-- 상사가 없는 직원의 경우 상사이름, 상사의입사일을 null로 출력.
-- 부서가 없는 직원의 경우 '미배치'로 출력
-- 업무가 없는 직원의 경우 '없무없음' 으로 출력
create or replace view ex06_view
as
select e.emp_id, e.emp_name, nvl(j.job_title,'업무없음')jobtitle, e.salary, e.hire_date, 
        m.emp_name as 상사이름, m.hire_date 상사입사일,  --컬럼명이 똑같은 것은 alias 줘야한다*** (duplicat columns)
        nvl(d.dept_name,'미배치') dept_name,
        nvl(d.loc,'미배치')loc
from emp e left join emp m on e.mgr_id=m.emp_id
            left join dept d on e.dept_id=d.dept_id
            left join job j on e.job_id=j.job_id;

--TODO: 업무별 급여의 통계값을 조회하는 View 생성.
--출력 컬럼 업무명, 급여의 합계, 평균, 최대, 최소값을 조회하는 View를 생성 
create or replace view ex07_view
as
select j.job_title, sum(salary) 급여합계, avg(salary) 급여평균, max(salary) 최대급여, min(salary) 최소급여
from emp e, job j
where e.job_id=j.job_id
group  by job_title;

select *
from ex07_view;

--TODO: 직원수, 부서개수, 업무의 개수를  조회하는 View를 생성
create view ex08_view
as
select '직원수' label, count(*) cnt from emp
union all
select '부서수',count(*) from dept
union all
select '업무수',count(*) from job;

select *
from ex08_view;

/* **************************************************************************************************************
시퀀스 : SEQUENCE
- 자동증가하는 숫자를 제공하는 오라클 객체
- 테이블 컬럼이 자동증가하는 고유번호를 가질때 사용한다.
	- 하나의 시퀀스를 여러 테이블이 공유하면 중간이 빈 값들이 들어갈 수 있다.

생성 구문
CREATE SEQUENCE sequence이름
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE]    
	[MINVALUE n | NOMINVALUE]	--default가 NOMINVALUE
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]		  

- INCREMENT BY n: 증가치 설정. 생략시 1

- START WITH n: 시작 값 설정. 생략시 0
	- 시작값 설정시
	 - 증가: MINVALUE 보다 크커나 같은 값이어야 한다.
	 - 감소: MAXVALUE 보다 작거나 같은 값이어야 한다.
     
- MAXVALUE n: 시퀀스가 생성할 수 있는 최대값을 지정
- NOMAXVALUE : 시퀀스가 생성할 수 있는 최대값을 오름차순의 경우 10^27 의 값. 내림차순의 경우 -1을 자동으로 설정. 
- MINVALUE n :최소 시퀀스 값을 지정
- NOMINVALUE :시퀀스가 생성하는 최소값을 오름차순의 경우 1, 내림차순의 경우 -(10^26)으로 설정

- CYCLE 또는 NOCYCLE : 최대/최소값까지 갔을때 순환할 지 여부. NOCYCLE이 기본값(순환반복하지 않는다.)

- CACHE|NOCACHE : 캐쉬 사용여부 지정.
(오라클 서버가 시퀀스가 제공할 값을 미리 조회해 메모리에 저장) 
NOCACHE가 기본값(CACHE를 사용하지 않는다. )


시퀀스 자동증가값 조회
 - sequence이름.nextval  : 다음 증감치 조회
 - sequence이름.currval  : 현재 시퀀스값 조회


시퀀스 수정
ALTER SEQUENCE 수정할 시퀀스이름           --뷰는 수정 못하지만 SEQUENE는 수정 가능.
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]	

수정후 생성되는 값들이 영향을 받는다. (그래서 start with 절은 수정대상이 아니다.)	  


시퀀스 제거
DROP SEQUENCE sequence이름
	
************************************************************************************************************** */

-- 1부터 1씩 자동증가하는 시퀀스
create sequence ex01_seq;

select *
from user_sequences; 

select ex01_seq.nextval
from dual;

-- 1부터 50까지 10씩 자동증가 하는 시퀀스
drop sequence ex02_seq;
create sequence ex02_seq
    increment by 10
    maxvalue 50;

select ex02_seq.nextval
from dual;

alter sequence ex02_seq
    cycle
    nocache; 

-- 100 부터 150까지 10씩 자동증가하는 시퀀스
create sequence ex03_seq
    increment by 10
    start with 100
    maxvalue  150;
    
select ex03_seq.currval
from dual;


-- 100 부터 150까지 2씩 자동증가하되 최대값에 다다르면 순환하는 시퀀스
drop sequence ex04_seq;
create sequence ex04_seq
    increment by 2
    start with 100
    maxvalue  150
    cycle;       --cycle 은 시퀀스가 생성하는 수자의 개수가 cache size보다 커야 한다. 
    --25개를 생성할 건데 cache 사이즈가 20이므로 따로 지정할 필요X.

select ex04_seq.nextval
from dual;

create sequence ex05_seq
    increment by 10
    start with 100
    maxvalue 150
    minvalue 100
    cycle
    cache 3;
    
select ex05_seq.nextval
from dual;
    
-- -1부터 자동 감소하는 시퀀스
create sequence ex06_seq
    increment by -1;
    
select *
from user_sequences;

select ex06_seq.nextval
from dual;

-- -1부터 -50까지 -10씩 자동 감소하는 시퀀스
create sequence ex07_seq
    increment by -10
    minvalue -50
    maxvalue -1;
    
select *
from user_sequences;

select ex07_seq.nextval
from dual;

-- 100 부터 -100까지 -100씩 자동 감소하는 시퀀스
drop sequence ex08_seq;   
create sequence ex08_seq   --감소하는 시퀀스일때는... 시퀀스가 만드는 값은 절대 maxvalue보다 클 수가 X.
    increment by -100
    start with 100
    minvalue -100
    maxvalue 100;
    
select *
from user_sequences;

select ex08_seq.nextval
from dual;


-- 15에서 -15까지 1씩 감소하는 시퀀스 작성
drop sequence ex09_seq;
create sequence ex09_seq
    increment by -1
    start with 15
    minvalue -15
    maxvalue 15;
    
select *
from user_sequences;

select ex09_seq.nextval
from dual;


-- -10 부터 1씩 증가하는 시퀀스 작성
drop sequence ex10_seq;     --증가: 시퀀스가 생성하는 값이 minvalue보다 작아서는 안된다. 
create sequence ex10_seq
    start with -10
    increment by 1
    minvalue -10;
    
select *
from user_sequences;

select ex10_seq.nextval
from dual;

-- Sequence를 이용한 값 insert



-- TODO: 부서ID(dept.dept_id)의 값을 자동증가 시키는 sequence를 생성. 10 부터 10씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해서  dept_copy에 5개의 행을 insert.

create table items          --테이블 생성
(   
    no number primary key,
    name varchar2(100) not null
);
--1번 아이템, 2번,,3번...등 1씩 자동증가하는 값으로 no를 처리하고 싶음!!!!!!!!!!
insert into items
values (item_no_seq.nextval, 'item이름' || ex01_seq.nextval);

drop sequence item_no_seq;
create sequence item_no_seq     --item 테이블을 위한 시퀀스.
    start with 10
    increment by 10
    minvalue 10;

select *
from items;

rollback;   --지금까지 넣은 데이터 취소.
--다시 insert 하면... 이미 증가한 만큼 이상값으로 입력된다. 
--시퀀스는 rollback대상이 아니다**********************************************

create table dept_copy 
as
select * from dept where 1=0;   --틀만 가져옴

select *
from dept_copy;

-- TODO: 직원ID(emp.emp_id)의 값을 자동증가 시키는 sequence를 생성. 
--10 부터 1씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해 emp_copy에 값을 5행 insert
drop table emp_copy;
create table emp_copy
as
select emp_id, emp_name, salary from emp;

select *
from emp_copy;

insert into emp_copy
values (item_no_seq2.nextval, 'item이름');

drop sequence item_no_seq2;
create sequence item_no_seq2    --item 테이블을 위한 시퀀스.
    start with 10
    increment by 1
    minvalue 10;

select *
from items;



