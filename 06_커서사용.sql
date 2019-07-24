/* *********************************************************************************************************************************************
커서(Cursor)
 - 커서는 컴퓨터에서 현재 위치를 가리키는 것을 말한다.
 - 오라클에서 커서
    - 임의의 SQL문이 처리된 결과를 가리키는 것으로 커서를 이용해 처리된 결과 집합의 정보를 얻을 수 있다.
 - 조회결과가 한행 이상인 경우 반드시 커서를 사용해야 한다.
	- select into 로는 한행의 결과만 조회가능하다.

- 커서의 진행 단계
    - 커서 선언
    - 커서 열기(open)  --실제 쿼리 문을 실행
    - 패치 (fetch)  --쿼리 결과를 가져옴
    - 커서 닫기 (close)  --쿼리 문 그만.
    
 - 묵시적 커서, 명시적 커서
    - 묵시적 커서 
        - 오라클 내부에서 자동으로 생성되어 사용되는 커서로 PL/SQL 블록에서 
		  실행하는 문장(INSERT,UPDATE,DELETE, SELECT INTO)이 실행될 때마다 자동으로 생성됨.
        - 위의 진행 단계가 자동으로 처리된다.
        
    - 명시적 커서 
        - 사용자가 직접 정의해서 사용하는 커서로 select 결과를 조회할 때 사용한다.
        - 위의 세가지 진행 단계를 명시적으로 처리해야 한다. (커서 선언, open, fetch,close)

- 커서 속성
    - 커서가 제공하는 결과에대한 정보들.
      - 커서이름%FOUND      : 결과 집합에서 조회가능한 행이 있는지 여부 반환.
                            1행 이상 있으면 참(True) 없으면 거짓(False) 반환
      - 커서이름%NOTFOUND   :  %FOUND의 반대.
                            Cursor 로 부터 마지막으로 얻은 커서의 결과 set에 레코드가 없으면 참(True)
      - 커서이름%ROWCOUNT   :  SQL문에 영향 받은 행의 수를 반환
      - 커서이름%ISOPEN     : 현재 커서가 OPEN 상태이면 참(True), CLOSE 상태이면 거짓(False)
      - 커서이름 
        - 묵시적 커서 :  SQL 지정. (예: SQL%FOUND)
        - 명시적 커서 :  커서이름 지정 (예: my_cursor%FOUND)
*********************************************************************************************************************************************  */    
SET SERVEROUTPUT ON;

-- 묵시적 커서의 예 (update 개수 출력)
begin
    update emp
    set emp_name =emp_name
    where emp_id>150;
    dbms_output.put_line(sql%rowcount); --sql%rowcount --> 묵시적 커서 사용해서 정보 조회가능.
end;
/

-- 묵시적 커서의 예(select 조회결과 행수)
declare
    v_name emp.emp_name%type;
    
begin
    select emp_name
    into v_name
    from emp
    where emp_id = 100; 
    if sql%found then   --조회 가능한 행이 남아있으면....
        dbms_output.put_line(sql%rowcount);
    end if; --select의 영향을 받은 애가 1개. 결과가 1이므로.
end;
/


--TODO
/* *********************************************************************
--Database에서 DML이 실행되면 그 기록을 저장할 테이블
	- log_no: 번호
	- category : 어떤 구문이 실행되었는지 구분 
		- 'I' - insert, 'U' - update, 'D' - delete
	- exec_datetime : DML구문 실행 일시
	- table_name : 실행된 테이블
	- row_count : 구문이 적용된 행의 개수 
********************************************************************* */
create sequence dml_log_no_seq; 
drop table dml_log;
create table dml_log(
    log_no number primary key,
    category char not null constraint ck_dml_log_category check(category in ('I', 'D', 'U')),
    exec_datetime date default sysdate not null,
    table_name varchar2(100) not null,
    row_count number not null
);

/* *********************************************************************
 dml_log_no_seq 테이블의 log_no 컬럼의 값을 생성할 sequence.
*********************************************************************** */
drop table emp_copy;
create table emp_copy as select * from emp;

-- TODO: 파라미터로 dept_id를 받아서 그 부서에 소속된 직원들을 삭제하고 dml_log에 기록을 남기는 stored procedure를 생성
--emp_copy에서 실행
create or replace procedure delete_emp_by_dept_id_sp (p_dept_id in dept.dept_id%type) --default가 IN모드이므로 생략 가능.
is                                        
     v_del_cnt binary_integer;  --삭제 행수를 저장할 변수.   
    
begin
    delete
    from emp_copy
    where dept_id=p_dept_id;   
    
    v_del_cnt := sql%rowcount;    --sql%rowcount을 사용
    
    insert into dml_log values (dml_log_no_seq.nextval,
                                'D',sysdate,'EMP_COPY',v_del_cnt);
   commit;
end;
/

exec delete_emp_by_dept_id_sp(110);

/* ************************************************************ 
- 명시적 커서 사용 문법
1. 커서 정의
    - CURSOR 커서이름 [(파라미터이름 datatype[:=기본값], ...)] IS 
            select 구문;
    
	- 파라미터
        - 커서 열때 전달받을 값이 있는 경우 선언(없으면 생략) 
		- 변수명 데이터타입 [:= 기본값] 
		- 기본값이 있는 경우 호출시 값 전달을 생략할 수 있다.
		
2. 커서열기
    - OPEN 커서이름 [(전달값1, 전달값2,..);
    - 커서에 파라미터가 선언된 경우 전달할 값을 ( ) 에 지정. 없으면 () 생략
	
3. 커서로부터 조회 결과 데이터 읽기
    - FETCH 커서이름 INTO 변수 [,..]
	- 변수 : 커서가 반환하는 조회 결과값을 받을 변수. select 절의 컬럼 개수만큼의 변수를 선언한다. 
	
4. 커서 닫기
    CLOSE 커서이름;
    
- 커서 정의는 선언부에서 작성
- 커서 열기 ~ 닫기는 구현부에서 작성
************************************************************ */
-- DEPT_ID 가 100 인 직원의 정보 조회

declare
    rec_emp emp%rowtype; --조회결과 한 행을 저장할 변수
    --커서를 정의: 어떤 sql문의 실행 결과의 연결될 커서인지 정의.
    cursor emp_cur is   --쿼리문과 커서를 연결*********** \
    --emp_cur 로 서버에서 커서를 다룰 수 있다. 
    select *
    from emp
    where dept_id=100;
    
    
begin
    --2: 커서 열기 (open) : 1에서 정의한 sql문이 실행되고 그 실행 결과의 커서와 연결된다. 
    open emp_cur;  --실행결과가 서버에 실행된다. 
    
    --3: 조회 결과 가져오기
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    
    --4:습관처럼 닫기 하기.
    close emp_cur;
end;
/

-- ******************** 파라미터가 있는 CURSOR  ************************

declare
    rec_emp emp%rowtype; --조회결과 한 행을 저장할 변수
    --커서를 정의: 어떤 sql문의 실행 결과의 연결될 커서인지 정의.
    cursor emp_cur (cp_dept_id dept.dept_id%type) is  
        select *
        from emp
        where dept_id=cp_dept_id ;
    
begin
    --2: 커서 열기 (open) : 1에서 정의한 sql문이 실행되고 그 실행 결과의 커서와 연결된다. 
    open emp_cur(110);  --실행결과가 서버에 실행된다. 
    
    
    --3: 조회 결과 가져오기
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    
    --4:커서를 닫기
    close emp_cur;
        
    open emp_cur(110);
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
      dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
      close emp_cur;
end;
/

/* *********************************************************************************************
- LOOP 반복문을 이용해 조회한 모든 결과 조회
    - cursor 의 fetch 구문을 loop 내에서 반복한다. 
    - 조회 가능한 행이 없으면 LOOP 를 빠져 나온다. 
********************************************************************************************* */
declare 
    cursor dept_cur(cp_loc dept.loc%type) is
        select * 
        from dept
        where loc=cp_loc;
        
        rec_dept dept%rowtype;   --dept의 모든 정보를 조회가능하도록.
        
begin
    open dept_cur('New York');
    --LOOP문을 이용해서 fetch를 한다. 
    loop
        fetch dept_cur into rec_dept; 
        exit when dept_cur%notfound;   --dept_cur에서 더 이상 가져올 값이 없으면... EXIT!!!!!!!!!******************************8
        dbms_output.put_line(rec_dept.dept_id || ' '|| rec_dept.dept_name || ' '|| 
                                rec_dept.loc);
    end loop;
    close dept_cur; 
end;
/


-- TODO: EMP테이블에서 커미션(comm_pct)이 NULL이 직원의 ID(emp_id), 이름(emp_name) , 
--급여(salary), 커미션(comm_pct)를 이름 오름차순으로 정렬한 결과를 출력
한번 
--LOOP하고 For문 사용
declare 
    rec_emp emp%rowtype;  --한행의 값을 저장할 변수.
    
    cursor emp_cur is
        select emp_id, emp_name, salary, comm_pct
        from emp
        where comm_pct is null
        order by emp_name desc;
begin
    open emp_cur;
    --LOOP문을 이용해서 fetch를 한다. 
    loop
        fetch emp_cur into rec_emp.emp_id, rec_emp.emp_name,
                            rec_emp.salary, rec_emp.comm_pct;  --한 행의 결과를 넣어준다. 
                            
        exit when emp_cur%notfound; --커서가 더이상 X일때 loop문을 나간다. 
        dbms_output.put_line(rec_emp.emp_name || ' '|| rec_emp.comm_pct);
    end loop;
    close emp_cur; 
end;
/


-- TODO: DEPT 테이블에서 위치가 'New York' 인 부서들의 부서ID, 부서명 출력
declare 
    cursor dept_cur(cp_loc dept.loc%type) is
        select * 
        from dept
        where loc=cp_loc;
        
        rec_dept dept%rowtype;   --dept의 모든 정보를 조회가능하도록.
        
begin
    open dept_cur('New York');
    --LOOP문을 이용해서 fetch를 한다. 
    loop
        fetch dept_cur into rec_dept; 
        exit when dept_cur%notfound;   --dept_cur에서 더 이상 가져올 값이 없으면... EXIT!!!!!!!!!******************************8
        dbms_output.put_line(rec_dept.dept_id || ' '|| rec_dept.dept_name || ' '|| 
                                rec_dept.loc);
    end loop;
    close dept_cur; 
end;
/




/* *********************************************************************************************
FOR 문을 이용한 CURSOR 결과 조회
FOR 레코드 IN 커서명 [(전달값1, 전달값2,..)]
LOOP
    처리 구문
END LOOP;    

--위와 달리 OPEN 작업할 필요가X.\

********************************************************************************************* */
declare
    cursor dept_cur (cp_loc dept.loc%type) is
                    select * from dept 
                    where loc= cp_loc;
begin
    for dept_row in dept_cur('Seattle') --for문에서 커서를 연다, 
     
    loop
      dbms_output.put_line(dept_row.dept_name || ' '|| dept_row.loc);
    end loop;  --반복문 나오면서 자동으로 CLOSE.
    
    if dept_cur%isopen then --현재 커서의 open 상태 조회
        dbms_output.put_line('열려있음');
    else
        dbms_output.put_line('닫혀있음');
    end if;
end;
/

-- TODO: EMP테이블에서 커미션(comm_pct)이 NULL이 직원의 ID(emp_id), 이름(emp_name) , 급여(salary), 커미션(comm_pct)를 이름 오름차순으로 정렬한 결과를 출력


-- TODO: DEPT 테이블에서 위치가 'New York' 인 부서들의 부서ID, 부서명 출력



DROP TABLE dept_copy;
CREATE TABLE dept_copy AS select * from dept;
-- TODO: EMP 테이블에서 salary가 13000 이상인 직원들이 
--소속된 부서(DEPT_COPY테이블)의 loc을 '서울'으로 변경하시오.
declare 
    v_dept_id dept.dept_id%type;
    
    cursor dept_id_cur is
        select dept_id
        from emp
        where salary>=130000;
begin 
    open dept_id_cur;
    
    loop
        fetch dept_id_cur into v_dept_id;   --id를 다 v_dept_id 변수 안에 저장
        exit when dept_id_cur%notfound;  --더 이상 조회 할 것이 없으면 빠져나온다.
        update dept_copy
        set loc='서울'
        where dept_id=v_dept_id;
        
    end loop;
    
end;
/
select * from dept_copy;


/* *********************************************************************************************
FOR문에 직접 커서의 내용 정의

FOR 레코드 IN (SELECT 문)
LOOP
   처리구문
END LOOP;
********************************************************************************************* */
begin 
      for d_row in (select * from dept)  --for문 안에서만 사용하는 커서!
                                            --하지만 커서이름이 없기 때문에,.. 속성은 조회 X. **단순 조회를 위해 사용***
      loop
        dbms_output.put_line(d_row.dept_id|| ' '|| d_row.dept_name);
      --  if d_row.loc ='New York' then
           -- insert into dept_copy values d_row;
       -- end if;
      end loop;
end;
/

-- TODO: 업무 ID (job.job_id)와 급여 인상률(0~1)를 파라미터로 받아서 그 업무를 담당하는 직원들의 급여(emp.salary)를 
--       업무의 max_salary(job.max_salary) * 인상률 만큼 인상처리하는 stored procdure를 구현.
create or replace procedure job_rate (p_job_id job.job_id%type, 
                                      p_rate binary_double)
is
        v_max_salary job.max_salary%type; --업무의 max_salary를 저장한 변수.
        
        cursor emp_cur is 
            select emp_id
            from emp
            where job_id= p_job_id;
begin
        --max salary 
        select max_salary 
        into v_max_salary
        from job
        where job_id=p_job_id;
        
        --salary 업데이터 
        for e_row in emp_cur  --반복문을 돌려가면서 하나씩 업데이트해준다. 
        
        loop
            update emp
            set salary=salary+v_max_salary*p_rate
            where emp_id=e_row.emp_id;
        end loop;
        commit;
end;
/
exec job_rate('AD_PRES',0.2);
select * from emp where job_id='IT_PROG';

-- TODO: EMP테이블에서 커미션(comm_pct)이 NULL이 직원의 ID(emp_id), 이름(emp_name) , 급여(salary), 
--커미션(comm_pct)를 이름 오름차순으로 정렬한 결과를 출력하는 stored Procedure를 구현


-- TODO: DEPT 테이블에서 위치가 'New York' 인 부서들의 부서ID, 부서명 출력




-- TODO: 년도를 파라미터로 받아 그해 입사한 직원들의 ID, 이름, 급여, 입사일을 출력하는 Procedure 구현
create or replace procedure EX_06_01 (p_year varchar2)
is

begin
    for e_row in (select emp_id, emp_name, salary, hire_date
                        from emp
                        where to_char(hire_date,'yyyy')=p_year)
    loop
        dbms_output.put_line(e_row.emp_id || ' '|| e_row.emp_name || ' '|| e_row.hire_date);
    end loop;
end;
/

EXEC EX_06_01('2005');
EXEC EX_06_01('2006');


--TODO: 부서의 이름(dept.dept_name)을 파라미터로 받아서 
--그 부서에 속한 직원의 ID(emp.emp_id), 직원이름(emp.emp_name), 
--급여(emup.salary)를 급여가 많은 순으로 출력하는 stored Procedure를 구현.  
create or replace procedure EX_06_03 (p_dept_name dept.dept_name%type)
is
    cursor emp_dept_cursor  is
        select e.emp_id, e.emp_name, e.salary
        from emp e, dept d
        where e.dept_id=d.dept_id (+)
        and d.dept_name= p_dept_name;
begin
    for e_row in emp_dept_cursor
    loop
        dbms_output.put_line(e_row.emp_id || ' '|| e_row.emp_name || ' '|| e_row.salary );
    end loop;
end;
/

EXEC EX_06_03('IT');
EXEC EX_06_03('Purchasing');



--TODO: 정수를  파라미터로 받아서 그 숫자 이상의 직원을 가지는
--부서의 ID(dept.dept_id), 부서이름(dept.dept_name)을 출력하는 stored Procedure를 구현.

create or replace procedure ex_06_04(p_num binary_integer)
is
    cursor dept_id_cur is
     select dept_id
        from emp
        group by dept_id
        having count(*) > p_num
begin 
        for d_row in dept_id_cur
        loop
            
        end loop;
end;
/

select dept_id, dept_name
from dept
where dept_id in (         --묵시적인 커서
        select dept_id
        from emp
        group by dept_id
        having count(*) > 3);

EXEC EX_06_04(3);
EXEC EX_06_04(10);


/* **********************************
커미션 내역 테이블
********************************** */
create table commission_trans(
    emp_id number(6), 
    commission number,
    comm_date date
);
-- TODO: EMP 테이블에서 COMM_PCT 가 있는(not null) 직원의 커미션(salary * comm_pct)을 
--commission_trans 테이블에 저장하는 stored Procedure를 구현.
-- comm_date는 실행 일시를 넣는다.
declare
    --커서 정의
    cursor emp_cur is
        select emp_id, salary, comm_pct
        from emp
        where comm_pct is not null;
        
begin
    for e_row in emp_cur
    loop
        insert into commission_trans
        values (e_row.emp_id, e_row.salary* e_row.comm_pct, sysdate);
        
    end loop;
    commit;
     
end;
/

SELECT * FROM commission_trans;



