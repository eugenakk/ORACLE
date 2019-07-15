/* ****************************************************
집합 연산자 (결합 쿼리)
- 둘 이상의 select 결과를 하나의 결과로 합치는 연산. 

- 구문
 select문  집합연산자 select문 [집합연산자 select문 ...] [order by 정렬컬럼 정렬방식]

-연산자
  - UNION: 두 select 결과를 하나로 결합한다. 단 중복되는 행은 제거한다. (합집합)
  - UNION ALL : 두 select 결과를 하나로 결합한다. 중복되는 행을 포함한다. (합집합)
  - INTERSECT: 두 select 결과의 동일한 결과행만 결합한다. (교집합)
  - MINUS: 왼쪽 조회결과에서 오른쪽 조회결과에 없는 행만 결합한다. (차집합)
   
 - 규칙
  - 두 select 문의 컬럼 수가 같아야 한다. 
  - 두 select 문의 컬럼의 타입이 같아야 한다.
  - 결합된 테이블의 컬럼이름은 첫번째 왼쪽 select문의 것을 따른다.
  - order by 절은 구문의 마지막에 넣을 수 있다.
  - UNION ALL을 제외한 나머지 연산은 중복되는 행은 제거한다.
*******************************************************/

-- emp 테이블의 salary 최대값와 salary 최소값, salary 평균값 조회
select '최대값' as Label, max(salary) as "집계 결과"
from emp
union all
select '최소값', min(salary)           --REMEMBER: 집합연산을 하려면, 컬럼의 수가 같아야한다.****
from emp
union all
select '평균값',round(avg(salary))
from emp
order by 2;  --집합연산을 끝낸 결과에 대한 정렬.



-------------------------------------------------------
--합집합인데 중복되 것도 모두 나오도록.
select *
from emp
where dept_id in (10,20)
union all   
select *
from emp
where dept_id in (20,30);

--합집합인데 중복된 것은 X. 퍼포먼스는 위에 것이 더 좋음.
select *
from emp
where dept_id in (10,20)
union  
select *
from emp
where dept_id in (20,30);

--차집합: 첫 번 쨰 조회결과에서 두 번째 결과에 없는 것만 조회.
select *
from emp
where dept_id in (10,20)
minus   
select *
from emp
where dept_id in (20,30);

--교집합: 두 조회결과에 모두 있는 것들만 조회
select *
from emp
where dept_id in (10,20)
intersect  
select *
from emp
where dept_id in (20,30);
-------------------------------------------------------
-- emp 테이블에서 업무별(emp.job_id) 급여 합계와 전체 직원의 급여합계를 조회.
select job_id, sum(salary) "급여 합계"
from emp 
group by job_id
union
select '총급여액' ,sum(salary) from emp
order by 1 nulls first;


-- 고객중(customers)에 주문(orders)을 하지 않은 고객을 조회 
select * 
from customers
minus
select * from customers
where cust_id in (select cust_id from orders);


-- 고객중에(customers) 한번 이상 주문(orders)을 한 고객을 조회



--한국 연도별 수출 품목 랭킹
drop table export_rank;
create table export_rank(
    year char(4) not null,
    ranking number(2) not null,
    item varchar2(60) not null
);

insert into export_rank values(1990, 1, '의류');
insert into export_rank values(1990, 2, '반도체');
insert into export_rank values(1990, 3, '가구');
insert into export_rank values(1990, 4, '영상기기');
insert into export_rank values(1990, 5, '선박해양구조물및부품');
insert into export_rank values(1990, 6, '컴퓨터');
insert into export_rank values(1990, 7, '음향기기');
insert into export_rank values(1990, 8, '철강판');
insert into export_rank values(1990, 9, '인조장섬유직물');
insert into export_rank values(1990, 10, '자동차');

insert into export_rank values(2000, 1, '반도체');
insert into export_rank values(2000, 2, '컴퓨터');
insert into export_rank values(2000, 3, '자동차');
insert into export_rank values(2000, 4, '석유제품');
insert into export_rank values(2000, 5, '선박해양구조물및부품');
insert into export_rank values(2000, 6, '무선통신기기');
insert into export_rank values(2000, 7, '합성수지');
insert into export_rank values(2000, 8, '철강판');
insert into export_rank values(2000, 9, '의류');
insert into export_rank values(2000, 10, '영상기기');

insert into export_rank values(2018, 1, '반도체');
insert into export_rank values(2018, 2, '석유제품');
insert into export_rank values(2018, 3, '자동차');
insert into export_rank values(2018, 4, '평판디스플레이및센서');
insert into export_rank values(2018, 5, '합성수지');
insert into export_rank values(2018, 6, '자동차부품');
insert into export_rank values(2018, 7, '철강판');
insert into export_rank values(2018, 8, '선박해양구조물및부품');
insert into export_rank values(2018, 9, '무선통신기기');
insert into export_rank values(2018, 10, '컴퓨터');

--년도별 수입 품목 랭킹
drop table import_rank;
create table import_rank(
    year char(4) not null,
    ranking number(2) not null,
    item varchar2(60) not null
);
insert into import_rank values(1990, 1, '원유');
insert into import_rank values(1990, 2, '반도체');
insert into import_rank values(1990, 3, '석유제품');
insert into import_rank values(1990, 4, '섬유및화학기계');
insert into import_rank values(1990, 5, '가죽');
insert into import_rank values(1990, 6, '컴퓨터');
insert into import_rank values(1990, 7, '철강판');
insert into import_rank values(1990, 8, '항공기및부품');
insert into import_rank values(1990, 9, '목재류');
insert into import_rank values(1990, 10, '계측제어분석기');

insert into import_rank values(2000, 1, '원유');
insert into import_rank values(2000, 2, '반도체');
insert into import_rank values(2000, 3, '컴퓨터');
insert into import_rank values(2000, 4, '석유제품');
insert into import_rank values(2000, 5, '천연가스');
insert into import_rank values(2000, 6, '반도체제조용장비');
insert into import_rank values(2000, 7, '금은및백금');
insert into import_rank values(2000, 8, '유선통신기기');
insert into import_rank values(2000, 9, '철강판');
insert into import_rank values(2000, 10, '정밀화학원료');

insert into import_rank values(2018, 1, '원유');
insert into import_rank values(2018, 2, '반도체');
insert into import_rank values(2018, 3, '천연가스');
insert into import_rank values(2018, 4, '석유제품');
insert into import_rank values(2018, 5, '반도체제조용장비');
insert into import_rank values(2018, 6, '석탄');
insert into import_rank values(2018, 7, '컴퓨터');
insert into import_rank values(2018, 8, '정밀화학원료');
insert into import_rank values(2018, 9, '자동차');
insert into import_rank values(2018, 10, '무선통신기기');

commit;


--TODO:  2018년(year) 수출(export_rank)과 수입(import_rank)을 동시에 많이한 품목(item)을 조회
select item
from import_rank
where year=2018
intersect
select item
from export_rank
where year=2018;


--TODO:  2018년(export_rank.year) 주요 수출 품목(export_rank.item)중 2000년에는 없는 품목 조회
select item
from export_rank
where year=2018
minus
select item
from export_rank
where year=2000;

--TODO: 1990 수출(export_rank)과 수입(import_rank) 랭킹에 포함된  품목(item)들을 합쳐서 조회. 중복된 품목도 나오도록 조회
select item
from export_rank
where year=1990
union all
select item
from import_rank
where year=1990;

--TODO: 1990 수출(export_rank)과 수입(import_rank) 랭킹에 포함된  품목(item)들을 합쳐서 조회. 중복된 품목은 안나오도록 조회
select item
from export_rank
where year=1990
union
select item
from import_rank
where year=1990;


--TODO: 1990년과 2018년의 공통 주요 수출 품목(export_rank.item) 조회
select item
from export_rank
where year=1990
intersect
select item
from export_rank
where year=1990;


--TODO: 1990년 주요 수출 품목(export_rank.item)중 2018년과 2000년에는 없는 품목 조회
select item
from export_rank
where year=1990
minus
select item
from export_rank
where year in (2000,2018);

--TODO: 2000년 수입품목중(import_rank.item) 2018년에는 없는 품목을 조회.
select item
from import_rank
where year=2000
minus
select item
from export_rank
where year=2018;

