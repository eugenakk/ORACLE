/* *************************************
함수 - 문자열관련 함수
 UPPER()/ LOWER() : 대문자/소문자 로 변환
 INITCAP(): 단어 첫글자만 대문자 나머진 소문자로 변환
 LENGTH() : 글자수 조회
 LPAD(값, 크기, 채울값) : "값"을 지정한 "크기"의 고정길이 문자열로 만들고 모자라는 것은 왼쪽부터 "채울값"으로 채운다.
 RPAD(값, 크기, 채울값) : "값"을 지정한 "크기"의 고정길이 문자열로 만들고 모자라는 것은 오른쪽부터 "채울값"으로 채운다.
 SUBSTR(값, 시작index, 글자수) - "값"에서 "시작index"번째 글자부터 지정한 "글자수" 만큼의 문자열을 추출. 글자수 생략시 끝까지. 
 REPLACE(값, 찾을문자열, 변경할문자열) - "값"에서 "찾을문자열"을 "변경할문자열"로 바꾼다.
 LTRIM(값): 왼공백 제거
 RTRIM(값): 오른공백 제거
 TRIM(값): 양쪽 공백 제거
 ************************************* */
 
select 'abc', upper('abc'), lower('ABC'), initcap('abc def_ghi')
from dual;

select length('alala')
from dual;

select * 
from emp
where length(emp_name) >=7;

select lpad('test',10,'-')
from dual;

select replace('A--B--C','-','#')
from dual;


--EMP 테이블에서 직원의 이름(emp_name)을 모두 대문자, 소문자, 첫글자 대문자, 이름 글자수를 조회



-- TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 부서(dept_name)를 조회. 
--단 직원이름(emp_name)은 모두 대문자, 부서(dept_name)는 모두 소문자로 출력.
-- UPPER/LOWER
select emp_id, upper(emp_name), salary, lower(dept_name)
from emp;


--(아래 2개는 비교값의 대소문자를 확실히 모르는 가정)
--TODO: EMP 테이블에서 직원의 이름(emp_name)이 PETER인 직원의 모든 정보를 조회하시오.
select emp_name
from emp
where upper(emp_name)='PETER';


--TODO: EMP 테이블에서 업무(job)가 'Sh_Clerk' 인 직원의의  
--ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회
select emp_id, emp_name, job, salary
from emp
where initcap(job)='Sh_Clerk';


--TODO: 직원 이름(emp_name) 의 자릿수를 15자리로 맞추고 글자수가 모자랄 경우 공백을 앞에 붙여 조회. 끝이 맞도록 조회
select lpad(emp_name,15,' ')
from emp;
    
--TODO: EMP 테이블에서 모든 직원의 이름(emp_name)과 급여(salary)를 조회.
--(단, "급여(salary)" 열을 길이가 7인 문자열로 만들고, 길이가 7이 안될 경우 왼쪽부터 빈 칸을 '_'로 채우시오. EX) ______5000) -LPAD() 이용
select emp_name,
    lpad(salary,7,'_')salary
    from emp;


-- TODO: EMP 테이블에서 이름(emp_name)이 10글자 이상인 직원들의 이름(emp_name)과 이름의 글자수 조회
select emp_name, length(emp_name)
from emp
where length(emp_name)>=10;



/* *************************************
함수 - 숫자관련 함수
 round(값, 자릿수) : 자릿수에서 반올림 (양수 - 실수부, 음수 - 정수부)
 trunc(값, 자릿수) : 자릿수에서 절삭(양수 - 실수부, 음수 - 정수부)
 ceil(값) : 올림
 floor(값) : 내림
 mod(나뉘는수, 나누는수) : 나눗셈의 나머지 연산

************************************* */
select ceil(50.123) --정수로 올림.
from dual;

--ceil과 flooor의 결과는 정수.

select round(50.123),
        round(50.79),
        round(50.1234,2)   --소수점 2자리 이하 반올림.
        from dual;
        
select round(12345, -1),  --10단위 이하에서 반올림
        round(12378,-2)   --100단위 이하에사 반올림
    from dual;
    
--자릿수: 0 (단단위), 음수-->실수부, 양수-->정수부

select trunc(1234.56,-2), -- -2인 2 이하에서 잘라버리니까 1200
trunc(1234.56,-1), --1230
trunc(1234.56,0), --1234
trunc(1234.56,1),  --1234.5
trunc(1234.56,2)    --1234.56
from dual;

select mod(10,3)   --10나누기 3의 나머지.
from dual;

--TODO: EMP 테이블에서 각 직원에 대해 직원ID(emp_id), 이름(emp_name), 급여(salary) 
--그리고 15% 인상된 급여(salary)를 조회하는 질의를 작성하시오.
--(단, 15% 인상된 급여는 올림해서 정수로 표시하고, 별칭을 "SAL_RAISE"로 지정.)
select emp_id,emp_name,salary, ceil(salary*1.15) as SAL_RAISE
from emp;


--TODO: 위의 SQL문에서 인상 급여(sal_raise)와 급여(salary) 
--간의 차액을 추가로 조회 (직원ID(emp_id), 이름(emp_name), 15% 인상급여, 인상된 급여와 기존 급여(salary)와 차액)
select emp_id,emp_name,salary, ceil(salary*1.15) as SAL_RAISE, 
ceil(salary*1.15)-salary 
from emp;


-- TODO: EMP 테이블에서 커미션이 있는 직원들의 직원_ID(emp_id), 이름(emp_name), 
--커미션비율(comm_pct), 커미션비율(comm_pct)을 8% 인상한 결과를 조회.
--(단 커미션을 8% 인상한 결과는 소숫점 이하 2자리에서 반올림하고 별칭은 comm_raise로 지정)

select emp_id,emp_name,comm_pct,
round(comm_pct*1.08,2) comm_raise
from emp
where comm_pct is not null;


/* *************************************
함수 - 날짜관련 계산 및 함수
Date +- 정수 : 날짜 계산.
sysdate --전달인자가 없으니까 ()를 쓰지 않는다. (실행시점의 일시)
systimestamp: 실행시점의 일시. timestamp.
months_between(d1, d2) -경과한 개월수(d1이 최근, d2가 과거)
add_months(d1, 정수) - 정수개월 지난 날짜. 마지막 날짜의 1개월 후는 달의 마지막 날이 된다. 
next_day(d1, '요일') - d1에서 첫번째 지정한 요일의 날짜. 요일은 한글(locale)로 지정한다.
last_day(d) - d 달의 마지막날.
extract(year|month|day from date) - date에서 year/month/day만 추출
************************************* */

select sysdate
from dual;

select systimestamp
from dual;

select to_char(sysdate,'yyyy/mm/dd hh24:mi:ss')  --hh24는 24시간제로 보여달라는 것.
from dual;

select sysdate-10
from dual;

select add_months(sysdate,10),
        add_months(sysdate,12*3)  --3년 후.
from dual;

select months_between (sysdate,'2015-07-05')
from dual;

select months_between (sysdate,'2015-07-01')
from dual;

select next_day(sysdate,'일요일')
from dual;

select last_day(sysdate)
from dual;

select hire_date, last_day(hire_date)
from emp;

select extract(year from hire_date),
extract(month from hire_date),
extract(day from hire_date)
from emp;


select * 
from emp
where extract (year from hire_date)=2004;

--TODO: EMP 테이블에서 부서이름(dept_name)이 'IT'인 직원들의 '입사일(hire_date)로 부터 10일전',
--입사일과 '입사일로 부터 10일후',  의 날짜를 조회. 
select hire_date-10, hire_date, hire_date+10
from emp;

--TODO: 부서가 'Purchasing' 인 직원의 이름(emp_name), 입사 6개월전과 입사일(hire_date), 6개월후 날짜를 조회.
select add_months(hire_date,-6), hire_date, add_months(hire_date,+6)
from emp
where dept_name='Purchasing';

--TODO: EMP 테이블에서 입사일과 입사일 2달 후, 입사일 2달 전 날짜를 조회.
select add_months(hire_date,-2), hire_date, add_months(hire_date,+2)
from emp;

-- TODO: 각 직원의 이름(emp_name), 근무 개월수 (입사일에서 현재까지의 달 수)를 계산하여 조회.
--(단 근무 개월수가 실수 일 경우 정수로 반올림. 근무개월수 내림차순으로 정렬.)
select emp_name,
    round(months_between(sysdate,hire_date))
from emp
order by 2 desc;


--TODO: 직원 ID(emp_id)가 100 인 직원의 입사일 이후 첫번째 금요일의 날짜를 구하시오.
select hire_date,next_day(hire_date,'금요일')
from emp
where emp_id=100;
/* *************************************
함수 - 변환 함수

to_char() : 숫자형, 날짜형을 문자형으로 변환
to_char(대상, 대상의 형태) : 어떤 형태로 바꾸고 싶은지 알려줘야한다. 
to_number() : 문자형을 숫자형으로 변환 
to_number('2,000','0,000') --->어떤 형태의 숫자인지 알려줘야함
to_date() : 문자형을 날짜형으로 변환
to_date('10','yy')   -- 연도라는 형태 알려줌.
형식문자 

***format 문자***
숫자 
0, 9: 숫자의 자릿수 지정 (9:남는 자리를 공백으로 채우고, 0은 0으로 채운다.)
                      (fm으로 시작하면 9일 경우 공백을 제거)
. : 정수/실수부 구분자
',': 정수부 단위구분자. 
'L','$':통화표시. L:로컬 통화기호. (우리는 원화)

일시 
yyyy :연도 4자리. yy: 연도 2자리 -->대신 무조건 2000년대.
      rr: 연도 2자리인데, 50이상은 90년대, 50미만은 2000년대.
mm: 월 2자리 
dd: 일 2자리
hh24: 24시간제 시산. 00시~23시까지 표현.
hh: 1~12시까지.
mi:분 2자리
ss;: 초 2자리
day(요일)
am 또는 pm : 둘 중에 아무거나 써도 됨. 오전인지 오후 인지 표현. am,pm써도 결과는 똑같이 나옴.

************************************* */
select '10'    --10은 여기서 숫자가 아니라 문자다. 문자 10은 계산 불가.
from dual;

--이 아래 식은 계산이 된다. 오라클은 자동적으로 '10'을 알아서 숫자로 바꿔준다. 
select '10'+10    
from dual;

--오라클이 자동적으로 형변환 해준다. ('2010'을 의도했다 -->'10'을 )
select '10'-10
from dual;

--명시적 변환
select to_date('10','yy')-10
from dual;

select to_char(1234567,'9,999,999')
from dual;

select to_char(12345,'9,999,999')a,
to_char(12345,'fm9,999,999')a1,
to_char(12345,'0,000,000')a2,
to_char(1234567,'9,999')a3,

--소수점 이하 두자리까지만 쳐리
to_char(12345.6789, '99999.99')  ,
to_char(5000,'$9,999'),
to_char(5000,'L9,999'),
to_char(5000,'9,999')|| '원'
from dual;

select to_number('4,000','0,000') +10,
to_number('$5,000','$9,999')+50
from dual;

select sysdate,
    to_char(sysdate,'yyyy-mm-dd'),
    to_char(sysdate,'yyyy-mm-dd hh24:mi')
from dual;

select to_char(sysdate, 'hh24'),
to_char(sysdate, 'hh24am mi')||'분'
from dual;

--연/월/일 
select to_char(sysdate, 'yyyy"년" mm"월" dd"일"' )
from dual;

--몇 번째 주***
select to_char(sysdate, 'w')
from dual;

--1년 중에 몇 번째 주인지 알려준다. 
select to_char(sysdate, 'ww')
from dual;

--4분기 중에 몇 번째 분기 인지 알려준다. 
select to_char(sysdate, 'q')
from dual;

--요일을 숫자로 표현 (일요일이 1, 토욜일이 7)
select to_char(sysdate, 'd')
from dual;

select to_date('20191010','yyyymmdd')-10,
        to_date('201005','yyyymm')
        -- 만약 지정이 안되어 있으면 모든 것을 디폴트로 00 으로 . 
from dual; 

-- EMP 테이블에서 업무(job)에 "CLERK"가 들어가는 직원들의 ID(emp_id), 이름(name), 업무(job), 급여(salary)를 조회
--(급여는 단위 구분자 , 를 사용하고 앞에 $를 붙여서 출력.)
select emp_id, emp_name, job, salary,
        to_char(salary,'fm$99,999.99') sal
from emp
where job like '%CLERK%';
desc emp;

-- 문자열 '20030503' 를 2003년 05월 03일 로 출력.
--********이것은 char-->char를 바꿔줘야 하는 것*************
--format만 바꿔줘야한다.  그러기 위해서는..
--char 를 date으로 바꾼 후 다시 char로 바꿔줘야한다.
select to_char(to_date('20030503','yyyymmdd'),'yyyy"년" mm"월" dd"일"' )as today
from dual;

-- TODO: 부서명(dept_name)이 'Finance'인 직원들의 ID(emp_id), 이름(emp_name)과 입사년도(hire_date) 
--4자리만 출력하시오. (ex: 2004);
--to_char()
select emp_id, emp_name, to_char(hire_date,'yyyy"년"') 입사년도
from emp
where dept_name='Finance'
order by 3;

--TODO: 직원들중 11월에 입사한 직원들의 직원ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회
--to_char()
select emp_id, emp_name, hire_date
from emp
where to_char(hire_date,'mm')=11;
--where extract (month from hire_date)='11';

--TODO: 2006년에 입사한 모든 직원의 이름(emp_name)과 입사일(yyyy-mm-dd 형식)을 입사일(hire_date)의 오름차순으로 조회
--to_char()
select emp_name, to_char(hire_date,'yyyy-mm-dd')
from emp
where to_char(hire_date,'yyyy')=2006
--where extract (year from hire_date)=2006;
order by 2;

--TODO: 2004년 01월 이후 입사한 직원 조회의 이름(emp_name)과 입사일(hire_date) 조회
select emp_name, hire_date
from emp
where to_char(hire_date,'yyyy')>=2004 and to_char(hire_date,'mm')>=1;
--where to_char(hire_date,'yyyymm')>='200401';

-- 문자열 '20100107232215' 를 2010년 01월 07일 23시 22분 15초 로 출력. (dual 테입블 사용)
select to_char(to_date('20100107232215','yyyymmddhh24miss'),'yyyy"년" mm"월" dd"일" hh24"시" mi"분"ss"초"')
from dual;

/* *************************************
함수 - null 관련 함수 
NVL(expr1,expr2) : expr1이 not null이면 expr1 반환, null이면 expr2 반환.
NVL2(expr, nn, null) - expr이 null이 아니면 nn, 널이면 세번째
nullif(ex1, ex2) 둘이 같으면 null, 다르면 ex1.
 coalesce (ex1,ex2,ex3,.....) ex=exn 중 null이 아닌 첫번째 값을 반환!
************************************* */

select nvl(null,0) 
from dual;

select nullif(10,10), nullif(10,20) 
from dual;

select emp_id, comm_pct, mgr_id, dept_name,
    coalesce(comm_pct, mgr_id)
from emp
where emp_id in (150,100,101);

-- EMP 테이블에서 직원 ID(emp_id), 이름(emp_name), 급여(salary),
--커미션비율(comm_pct)을 조회. 단 커미션비율이 NULL인 직원은 0이 출력되도록 한다..
select emp_id, emp_name,salary, nvl(comm_pct,0)
from emp;

--TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)을 조회. 
--부서가 없는 경우 '부서미배치'를 출력.
select emp_id, emp_name, job, nvl(dept_name,'부서미배치')
from emp
where dept_name is null;

--TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 커미션 (salary * comm_pct)을 조회. 
--커미션이 없는 직원은 0이 조회되록 한다.
select emp_id, salary, 
    to_char(nvl(salary*comm_pct,0),'$9999')
from emp;

/* *************************************
DECODE함수와 CASE 문
decode(컬럼, [비교값, 출력값, ...] , else출력) 

case문 동등비교
case 컬럼 when 비교값 then 출력값
              [when 비교값 then 출력값]
              [else 출력값]
              end 
              
case문 조건문
case when 조건 then 출력값
       [when 조건 then 출력값]
       [else 출력값]
       end

************************************* */
select decode(dept_name,null,'부서없음')
from emp
where dept_name is null;

select 
--case dept_name when null then '부서없음' end
    case when dept_name is null then '부서없음' end
from emp
where dept_name is null;

--EMP테이블에서 급여와 급여의 등급을 조회하는데 급여 등급은 10000이상이면 '1등급', 
--10000미만이면 '2등급' 으로 나오도록 조회
-- ********범위는 decode랑 case 컬럼 when 으로 표현 X
select salary, case when salary>=10000 then '1등급'
               else '2등급'
                end as 등급
from emp;

--TODO: EMP 테이블에서 업무(job)이 'AD_PRES'거나 'FI_ACCOUNT'거나 'PU_CLERK'인 직원들의 ID(emp_id),
--이름(emp_name), 업무(job)을 조회. 
-- 업무(job)가 'AD_PRES'는 '대표', 'FI_ACCOUNT'는 '회계', 'PU_CLERK'의 경우 '구매'가 출력되도록 조회
select emp_id, emp_name, decode(job, 'AD_PRES','대표',
                                        'FI_ACCOUNT','회계',
                                        'PU_CLERK','구매','기타')
from emp
where job in ('AD_PRES','FI_ACCOUNT','PU_CLERK');

---------------------------------------------------------------------------
select emp_id, emp_name, case job when 'AD_PRES' then'대표'
                                    when 'FI_ACCOUNT' then '회계'
                                    when 'PU_CLERK' then '구매'
                                    else '기타'
                                    end as job2
from emp
where job in ('AD_PRES','FI_ACCOUNT','PU_CLERK');


--TODO: EMP 테이블에서 부서이름(dept_name)과 급여 인상분을 조회. 급여 인상분은 부서이름이 'IT' 이면
--급여(salary)에 10%를 'Shipping' 이면 급여(salary)의 20%를 'Finance'이면 30%를 나머지는 0을 출력
-- decode 와 case문을 이용해 조회
select dept_name,case dept_name when 'IT' then salary*1.1
                                when 'Shipping' then salary*1.2
                                when 'Finance' then salary*1.3
                                else '0'
                                end
from emp;

--TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 인상된 급여를 조회한다. 
--단 급여 인상율은 급여가 5000 미만은 30%, 5000이상 10000 미만는 20% 10000 이상은 10% 로 한다.
select emp_id, emp_name, salary, 
    case when salary<5000 then salary*1.3
            when salary between 5000 and 10000 then salary*1.2
            else
            salary*1.1
            end as "인상된 급여"
from emp;

--decode()/case 를 이용한 정렬
-- 직원들의 모든 정보를 조회한다. 단 정렬은 업무(job)가 'ST_CLERK', 'IT_PROG',S
--'PU_CLERK', 'SA_MAN' 순서대로 먼저나오도록 한다. (나머지 JOB은 상관없음)
select*
from emp
order by decode (job, 'ST_CLERK',1,
                    'IT_PROG',2,
                    'PU_CLERK',3,
                    'SA_MAN',4);

