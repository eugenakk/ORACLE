
create user scott_join identified by  tiger;
grant all privileges to scott_join;

/* ****************************************
조인(JOIN) 이란
- 2개 이상의 테이블에 있는 컬럼들을 합쳐서 가상의 테이블을 만들어 조회하는 방식을 말한다.
 	- 소스테이블 : 내가 먼저 읽어야 한다고 생각하는 테이블
	- 타겟테이블 : 소스를 읽은 후 소스에 조인할 대상이 되는 테이블
 
- 각 테이블을 어떻게 합칠지를 표현하는 것을 조인 연산이라고 한다.
-foreign key와 primary key가 같은 것들을 조인해라--->equi join.
    - 조인 연산에 따른 조인종류
        - Equi join , non-equi join
        
- 조인의 종류
    - Inner Join 
        - 양쪽 테이블에서 조인 조건을 만족하는 행들만 합친다. 
        -조건을 만족시키지 않으면 값이 추가가 안된다.
        -무조건 일치하는 것만 추가한다. 
        
    - Outer Join
        - 한쪽 테이블의 행들을 모두 사용하고 다른 쪽 테이블은 조인 조건을 만족하는 행만 합친다. 
        조인조건을 만족하는 행이 없는 경우 NULL을 합친다.
        -붙일 대상이 없으면 그냥 비워둔다. (그래도 합친다)
        
        -소스 테이블의 위치에 따라 종류가 나뉜다. right, left?
        - 종류 : Left Outer Join,  Right Outer Join, Full Outer Join
        
    - Cross Join
        - 두 테이블의 곱집합을 반환한다. 
        -어떻게 합칠 지 조건을 알려주지 않고 그냥 곱집합하는 것.
        -m행 * n행 만큼의 행이 생성. cartesian  product.
        (하나의 행이 여러 행과 결합)
        
        
- 조인 문법
    - ANSI 조인 문법
        - 표준 SQL 문법
        - 오라클은 9i 부터 지원.
    - 오라클 조인 문법
        - 오라클 전용 문법이며 다른 DBMS는 지원하지 않는다.
**************************************** */        
/* ****************************************
-- inner join : ANSI 조인 구문
FROM  테이블a INNER JOIN 테이블b ON 조인조건 

- inner는 생략 할 수 있다.
**************************************** */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
select emp_id, emp_name, hire_date, dept_name
from emp inner join dept on emp.dept_id=dept.dept_id;  --직원의 정보가 source이므로 앞에다가.

select e.emp_id, e.emp_name, e.hire_date, d.dept_name
from emp e inner join dept d on e.dept_id=d.dept_id;  -- e,d로 테이블 별칭.

-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date),
--소속부서이름(dept.dept_name)을 조회.
select emp_id, emp_name, hire_date, dept_name
from emp e join dept d on e.dept_id=d.dept_id
where e.emp_id=100;

-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title),
--소속부서이름(dept.dept_name)을 조회
select emp_id, emp_name, salary, job_title, dept_name  
from emp e inner join job j on e.job_id=j.job_id --3개의 테이블 조인 해야함.
            inner join dept d on e.dept_id=d.dept_id;

-- 부서_ID(dept.dept_id)가 30인 부서의 이름(dept.dept_name), 위치(dept.loc), 
--그 부서에 소속된 직원의 이름(emp.emp_name)을 조회.
select d.dept_name, d.loc, e.emp_name
from emp e join dept d on e.dept_id=d.dept_id
where d.dept_id=30;


--******************CONFUSING**************
--NON EQUI JOIN 
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 
--급여 등급 오름차순으로 정렬
select emp_id, emp_name, salary, grade ||'grade'
from emp e join salary_grade s on e.salary between s.low_sal and s.high_sal   --사이에 있다는 것을 보여줌
order by grade asc;                       -- between 을 썼기 때문에 non-equi join 이다.

--TODO: 200번대(200 ~ 299) 직원 ID(emp.emp_id)를 가진 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 
--급여(emp.salary), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, e.salary, dept_name, loc
from emp e join dept d on e.dept_id=d.dept_id
where e.emp_id between 200 and 300
order by emp_id;

--TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.  직원_ID의 오름차순으로 정렬.
select emp_id,emp_name,job_id,dept_name, loc
from emp e inner join dept d on e.dept_id=d.dept_id
where e.job_id='FI_ACCOUNT'
order by emp_id asc;


--TODO: 커미션비율(emp.comm_pct)이 있는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--커미션비율(emp.comm_pct), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select emp_id, emp_name, salary, comm_pct, dept_name, loc
from emp e inner join dept d on e.dept_id=d.dept_id
where e.comm_pct is not null
order by emp_id asc;

--TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
--     그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 
--부서_ID 의 오름차순으로 정렬.
select d.dept_id, d.dept_name, d.loc, e.emp_id, e.emp_name, e.job_id
from dept d join emp e on d.dept_id=e.dept_id --dept가 소스 테이블이니까 먼저 써줌. 순서를 바꿛 결과는 SAME.
where d.loc='New York'
order by dept_id asc;

--TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
select e.emp_id, e.emp_name, e.job_id, j.job_title
from emp e inner join job j on e.job_id=j.job_id;

-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--       담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
select e.emp_id, e.emp_name, e.salary, j.job_title,d.dept_name
from emp e join dept d on e.dept_id=d.dept_id
            join job j on e.job_id=j.job_id
where e.emp_id=200;

-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 소속 직원의 이름(emp.emp_name),
--업무명(job.job_title)을 조회. 
--       직원이름 내림차순으로 정렬
select d.dept_name, d.loc, e.emp_name, j.job_title
from emp e join dept d on e.dept_id=d.dept_id
            join job j on e.job_id=j.job_id
where d.dept_name='Shipping'
order by e.emp_name asc;


-- TODO:  'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 이름(emp.emp_name), 
--입사일(emp.hire_date)를 조회
--         입사일은 'yyyy-mm-dd' 형식으로 출력
select e.emp_id, e.emp_name, to_char(e.hire_date,'yyyy-mm-dd')
from emp e join dept d on e.dept_id=d.dept_id
where d.loc='San Francisco'; 

--******************CONFUSING**************
-- TODO: 부서별 급여(salary)의 평균을 조회. 
--부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬.
-- 급여는 , 단위구분자와 $ 를 붙여 출력.
select to_char(round(avg(e.salary),2),'fm$999,999')평균급여, d.dept_name 
from  emp e join dept d on e.dept_id=d.dept_id
            join salary_grade s on e.salary between s.low_sal and s.high_sal
group by d.dept_name
order by avg(e.salary) desc;  --별칭이 아닌 숫자로 정렬해야 정확. 별칭은 문자열로 비교하므로 정확하지 X

--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
--     급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
select e.emp_id, e.emp_name, j.job_title, e.salary, s.grade, d.dept_name
from emp e join job j on e.job_id=j.job_id
            join dept d on e.dept_id=d.dept_id
            join salary_grade s on e.salary between s.low_sal and s.high_sal
order by s.grade desc;


--******************CONFUSING**************
--TODO: 급여등급이(salary_grade.grade) 1인 직원이 소속된 부서명(dept.dept_name)과 등급 1인 직원의 수를 조회. 
--직원수가 많은 부서 순서대로 정렬.f
select distinct d.dept_name , count(*)
from emp e join dept d on e.dept_id=d.dept_id
            join salary_grade s on e.salary between s.low_sal and s.high_sal
where s.grade=1
group by d.dept_name
order by 2 asc;

/* ###################################################################################### 
오라클 조인 
- Join할 테이블들을 from절에 나열한다.
- Join 연산은 where절에 기술한다. 
**위와 다른 것은 from 절에도 넣고 where절에도 넣는다는 것.

###################################################################################### */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
-- 입사년도는 년도만 출력
select e.emp_id, e.emp_name, to_char(e.hire_date,'yyyy'), d.dept_name
from emp e, dept d    --from 절에는 테이블을 나열만 한다.
where e.dept_id=d.dept_id;

-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 
--소속부서이름(dept.dept_name)을 조회
-- 입사년도는 년도만 출력
select e.emp_id, e.emp_name, to_char(e.hire_date,'yyyy'), d.dept_name
from emp e, dept d    --from 절에는 테이블을 나열만 한다.
where e.dept_id = d.dept_id 
and e.emp_id=100;

-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 
--소속부서이름(dept.dept_name)을 조회
select e.emp_id, e.emp_name, e.salary, j.job_title
from emp e, dept d, job j    --조인할 테이블이 3개이므로 최소한 2개의 조인연산이 필요하다고 볼 수 있다***************
where e.dept_id=d.dept_id and e.job_id=j.job_id;


--TODO 200번대(200 ~ 299) 직원 ID(emp.emp_id)를 가진 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 
--급여(emp.salary), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select e.emp_id, e.emp_name, e.salary, d.dept_name, d.loc
from emp e, dept d
where e.dept_id=d.dept_id
and e.emp_id between 200 and 299
order by 1 asc;  

--TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.  직원_ID의 오름차순으로 정렬.
select e.emp_id, e.emp_name, e.job_id, d.dept_name, d.loc
from emp e, dept d
where e.dept_id=d.dept_id 
and e.job_id='FI_ACCOUNT'
order by 1 asc;


--TODO 커미션비율(emp.comm_pct)이 있는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary),
--커미션비율(emp.comm_pct), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select e.emp_id, e.emp_name, e.salary, e.comm_pct, d.dept_name,d.loc
from emp e, dept d
where e.dept_id=d.dept_id 
and e.comm_pct is not null
order by 1 asc;

--TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
--     그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 
--부서_ID 의 -오름차순으로 정렬.
select d.dept_id, d.dept_name, d.loc, e.emp_id, e.emp_name, e.job_id
from emp e, dept d
where e.dept_id=d.dept_id 
and d.loc='New York'
order by 1 asc; 


--TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
select e.emp_id, e.emp_name, e.job_id, j.job_title
from emp e, dept d, job j
where e.dept_id=d.dept_id 
and e.job_id=j.job_id;

             
-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--       담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
select e.emp_id, e.emp_name, e.salary, j.job_title, d.dept_name
from emp e, dept d, job j     --테이블 3개를 조인하는 것.
where e.dept_id=d.dept_id     --그래서 최소 2개의 조인연산이 들어가야한다. 
and e.job_id=j.job_id
and e.emp_id=200;


-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 소속 직원의 이름(emp.emp_name), 
--업무명(job.job_title)을 조회. 
--       직원이름 내림차순으로 정렬
select d.dept_name, d.loc, e.emp_name, j.job_title
from emp e, dept d, job j
where e.dept_id=d.dept_id 
and e.job_id= j.job_id
and d.dept_name='Shipping'
order by 3 desc;

-- TODO:  'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 이름(emp.emp_name),
--입사일(emp.hire_date)를 조회
--         입사일은 'yyyy-mm-dd' 형식으로 출력
select e.emp_id, e.emp_name, to_char(e.hire_date,'yyyy-mm-dd')
from emp e, dept d
where e.dept_id=d.dept_id 
and d.loc='San Francisco';  --합친 테이블에서 조건을 또 추가한다. 

--TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬.
-- 급여는 , 단위구분자와 $ 를 붙여 출력.
select  d.dept_name, to_char(ceil(avg(e.salary)),'$999,999')
from emp e, dept d
where e.dept_id=d.dept_id
group by d.dept_name
order by 1;

--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 
--직원 id 오름차순으로 정렬
select e.emp_id, e.emp_name, e.salary, s.grade
from emp e, salary_grade s
where e.salary between s.low_sal and s.high_sal     --non equi join***********
order by 1 asc;

--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
--     급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
select e.emp_id, e.emp_name, j.job_title, e.salary, s.grade, d.dept_name
from emp e, job j, dept d, salary_grade s   --4개의 테이블을 조인**
where e.dept_id=d.dept_id 
and e.salary between s.low_sal and s.high_sal
and e.job_id=j.job_id                      --4개의 테이블이므로 최소 3개의 조인연산
order by s.grade desc;

--TODO 급여등급이(salary_grade.grade) 1인 직원이 소속된 부서명(dept.dept_name)과 등급1인 직원의 수를 조회.
--직원수가 많은 부서 순서대로 정렬.
select d.dept_name, count(*)
from emp e, dept d, salary_grade s
where e.dept_id=d.dept_id
and  e.salary between s.low_sal and s.high_sal
and s.grade=1
group by rollup(d.dept_name)   --**********rollup으로 묶으면... 전체에 대한 묶음도~ 그래서 총계인 45도 나옴!!!
order by 2 asc;

/* ****************************************************
Self 조인
- 물리적으로 하나의 테이블을 두개의 테이블처럼 조인하는 것.
-조회할 대상이 같은 테이블에 있다.  -->논리적으로 2개를 만들어서 조인을 시킨다*** (하나의 테이블을 2개로!!!)
**************************************************** */
--직원의 ID(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name)을 조회
select e.emp_id, e.emp_name, m.emp_name    
from emp e join emp m on e.mgr_id=m.emp_id;  --employee 랑 manager 테이블을 2개 조인!!!! (논리적으로 다른 테이블로 만든다)

--*************************CONFUSING********************************
-- TODO : EMP 테이블에서 직원 ID(emp.emp_id)가 110인 직원의 급여(salary)보다 많이 받는 직원들의 id(emp.emp_id),
--이름(emp.emp_name), 급여(emp.salary)를 직원 ID(emp.emp_id) 오름차순으로 조회.
select e1.emp_id, e1.emp_name, e1.salary 
from emp e1 join emp e2 on e2.emp_id=110
and e2.salary <e1.salary
order by 1 asc;

/* ****************************************************
아우터 조인 (Outer Join)
-inner join 은 조건을 만족하는 행끼리 합치는 것.
-outer join은 불충분 조회라고도 한다.
-조인 연산자 소스 테이블의 행은 다 join 하고 타켓 테이블의 행은 조인 조건을 만족하면 붙이고, 
--없으면 null 처리. *****

-ANSI 문법
from 테이블a [LEFT | RIGHT | FULL] OUTER JOIN 테이블b ON 조인조건
- OUTER는 생략 가능.
- emp, dept 테이블이 있으면 null이 다 나올 것을 정해야함. 그것에 따라 left, right, full outer join 설정해준다. 
(소스 테이블이 어디있느냐에 따라 다름)

left outer join: 구문 상 소스 테이블이 왼쪽
right outer join: 구문 상 소스 테이블이 오른쪽
full outer join: 

-오라클 JOIN 문법
- FROM 절에 조인할 테이블을 나열
- WHERE 절에 조인 조건을 작성
    - 타겟 테이블에 (+) 를 붙인다.
    - FULL OUTER JOIN은 지원하지 않는다.************

**************************************************** */

-- 직원의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 부서명(dept.dept_name), 부서위치(dept.loc)를 조회. 
-- 부서가 없는 직원의 정보도 나오도록 조회. (부서정보는 null). dept_name의 내림차순으로 정렬한다.
select e.emp_id, e.emp_name, e.salary, d.dept_name, d.loc 
from emp e left outer join dept d on e.dept_id=d.dept_id   --*****8 left outer join은 왼쪽 테이블이 다 나오도록 설정.
order by dept_name;

--오른쪽 테이블인 dept의 모든 정보를 보고 싶기 때문에 right outer join을 사용한다.
select d.dept_id, d.dept_name, d.loc, e.emp_name, e.hire_date
from emp e right outer join dept d on e.dept_id=d.dept_id;

--*******************CONFUSING***********************
-- 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
-- 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)
select e.emp_id, e.emp_name, e.dept_id,d.dept_name, d.loc
from emp e left outer join dept d on e.dept_id=d.dept_id   
and d.dept_id=80;                              --******************* 

--오라클 연산으로!!!!!
select e.emp_id, e.emp_name, e.dept_id,d.dept_name, d.loc
from emp e, dept d
where e.dept_id=d.dept_id(+)   --조인연산. 타겟 테이블은 dept
and d.dept_id(+)=8;   --추가적으로 (+)을 붙여줘야 조인연산이 됨

--full outer join은 부서가 존재하지 않아도 직원의 정보가 나오고, 부서가 존재하지만 직원이 존재하지 않는
--경우도 다 보여준다. 
select d.dept_id, d.loc,e.emp_id, e.emp_name, e.salary
from dept d full outer join emp e on d.dept_id=e.dept_id
where e.emp_id in (100,175,178)   --right은 emp의 모든 것이 추가되므로.. 175 178도 나옴.
or d.dept_id in (260,270,10,60);


--TODO: 직원_id(emp.emp_id)가 100, 110, 120, 130, 140인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title) 을 조회. 
--      업무명이 없을 경우 '미배정' 으로 조회
select e.emp_id, e.emp_name, j.job_title
from emp e left outer join job j on e.job_id=j.job_id
where e.emp_id in (100,110,120,130,140) ;


--오라클 문법
select e.emp_id, e.emp_name,e.salary,d.dept_name,d.loc
from emp e,dept d
where e.dept_id=d.dept_id (+)  --*************target 테이블에다가 (+) 표시를 한다.**************
--그러므로 left outer join 이라 볼 수 있다.
and e.emp_id in (100,175,178);

--TODO: 부서의 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 
--      직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.
select d.dept_id, d.dept_name, count(e.emp_id) 직원수  --count(*)으로 하게 되면 그 부서에 직원 없어도 1이 나온다.
from dept d left join emp e on d.dept_id=e.dept_id --dept가 소스 테이블. 없으면 0까지 나와야하니까!!!!!!
group by d.dept_id, dept_name   -- 2개를 다 묶어야한다. 
order by 3 desc;

-- TODO: EMP 테이블에서 부서_ID(emp.dept_id)가 90 인 직원들의 id(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name), 
--입사일(emp.hire_date)을 조회. 
-- 입사일은 yyyy-mm-dd 형식으로 출력
-- 상사가가 없는 직원은 '상사 없음' 출력
select e.emp_id, e.emp_name 직원, nvl(m.emp_name, '상사없음') 매니저, to_char(e.hire_date,'yyyy-mm-dd') 입사일
from emp e, emp m
where e.mgr_id=m.emp_id(+)   --조인연산. 
and e.dept_id(+)=90;   --추가적으로 (+)을 붙여줘야 조인연산이 됨

select e.emp_id, e.emp_name, nvl(m.emp_name, '상사없음') 상사이름, e.hire_date
from emp e left join emp m on e.mgr_id=m.emp_id;

--TODO 2003년~2005년 사이에 입사한 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
--입사일(emp.hire_date),
--    상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.
-- 단 상사가 없는 직원의 경우 상사이름, 상사의입사일을 null로 출력.
-- 부서가 없는 직원의 경우 null로 조회

select e.emp_id, e.emp_name 직원, j.job_title, e.salary, e.hire_date,
        m.emp_name 매니저, m.hire_date "상사의 입사일",d.dept_name, d.loc
from emp e left join job j on e.job_id=j.job_id
        left join emp m on e.mgr_id=m.emp_id
        left join dept d on e.dept_id=d.dept_id
where to_char(e.hire_date,'yyyy') between 2003 and 2005;




