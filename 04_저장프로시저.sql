/* *********************************************************************
프로시저
 - 특정 로직을 처리하는 재사용가능한 서브 프로그램
 - 작성후 실행되면 컴파일 되어 객체로 오라클에 저장되며 EXECUTE나 EXEC 명령어로 필요시마다 재사용가능
구문
CREATE [OR REPLACE] PROCEDURE 이름 [(파라미터 선언,..)]
IS
    [변수 선언]
BEGIN
    실행구문
[EXCEPTION
    예외처리구문]
END;

- 파라미터 선언
  - 개수 제한 없음
  - 구문 : 변수명 mode 타입 [:=초기값]
    - mode
      - IN : 기본. 호출하는 곳으로 부터 값을 전달 받아 프로시저 내에서 사용. 읽기 전용변수. 
      - OUT : 호출 하는 곳으로 전달할 값을 저장할 변수. 
      - IN OUT : IN과 OUT의 기능을 모두 하는 변수
	- 타입에 size는 지정하지 않는다. 
	- 초기값이 없는 매개변수는 호출시 반드시 값이 전달되야 한다.

실행
exec 이름[(전달값)]
execute 이름[(전달값)]

프로시저 제거
- DROP PROCEDURE 프로시저이름

*********************************************************************** */
set serveroutput on;
create or replace procedure message_sp1
is
    --변수선언
    v_message varchar2(100);
begin
    --실행구문
    v_message := 'HelloWorld';
    dbms_output.put_line(v_message);
end;
/
--control-enter: 오라클 서버에 저장

--실행
execute message_sp1;
exec message_sp1;

create or replace procedure message_sp2(p_message in varchar2:='HelloWorld') 
is  
    v_message varchar2(100);
begin
    -- in 모드 파라미터는 값 변경이 안된다. 그냥 사용만 해야한다********
    dbms_output.put_line(p_message); 
    v_message:= p_message;
    dbms_output.put_line(v_message); 
    v_message :='새 메시지';
    dbms_output.put_line(v_message); 
end;
/


exec message_sp2('안녕하세요')
exec message_sp2('Hi')
exec message_sp2


create or replace procedure message_sp3(p_message in varchar2, 
                                        p_num pls_integer)
is
begin
    dbms_output.put_line(p_message||p_num);
end;
/

exec message_sp3('안녕하세요', 20);
 --out: 반환값을 저장할 변수를 받는다.
 
create or replace procedure message_sp4(p_message out varchar2)
is    
begin
    dbms_output.put_line(p_message);
    p_message := 'message_sp4에서의 메세지';
end;
/
create or replace procedure message_sp5(p_message in out varchar2)
is    
begin
    dbms_output.put_line(p_message);
    p_message := 'message_sp4에서의 메세지';
end;
/

create or replace procedure caller_sp
is
    v_msg varchar2(100);
begin
   --message_sp4 를 호출 - 메세지를 반환하는 sp
   v_msg:='기본값';
   message_sp4(v_msg);
   dbms_output.put_line(v_msg);
   
end;
/

exec caller_sp;

--매개변수로 부서ID, 부서이름, 위치를 받아 DEPT에 부서를 추가하는 Stored Procedure 작성
create or replace procedure add_dept(p_dept_id dept.dept_id%type,
                                     p_dept_name dept.dept_name%type,
                                    p_loc dept.loc%type)
is                                         --dept테이블에 있는 dept_id의 type을 사용하겠다는 뜻
    
begin
        insert into dept values (p_dept_id, p_dept_name, p_loc);  --3개를 insert 해주는 것!!!
        commit;
end;
/

exec add_dept(3332,'기획부2','서울');

select * from dept order by 1 desc;   --삽입된 행을 확인할 수 있다. 


--매개변수로 부서ID를 파라미터로  받아 조회하는 Stored Procedure
create or replace procedure find_dept_sp(p_dept_id dept.dept_id%type)
is
    v_dept_id dept.dept_id%type;        --어차피 컬럼과 연결되는 변수니까 type사용
    v_dept_name dept.dept_name%type;       --변수의 이름과 컬럼 이름 다르게 하는 것이 편함.
    v_loc dept.loc%type;
begin
    select dept_id, dept_name, loc
    into v_dept_id, v_dept_name, v_loc
    from dept
    where dept_id=p_dept_id;    --매개변수의 값을 넣어준다. 
    
    dbms_output.put_line(v_dept_id);
end;
/

-- TODO 직원의 ID를 파라미터로  받아서 직원의 이름(emp.emp_name), 급여(emp.salary), 업무_ID (emp.job_id), 입사일(emp.hire_date)를 
--출력하는 Stored Procedure 를 구현
create or replace procedure print_emp (e_emp_id in emp.emp_id%type) --default가 IN모드이므로 생략 가능.
is                                        
     e_emp_name emp.emp_name%type;       
     e_salary emp.salary%type;       
     e_job_id emp.job_id%type;
     e_hire_date emp.hire_date%type; 
    
begin
    select emp_name, salary, job_id, hire_date
    into e_emp_name, e_salary, e_job_id, e_hire_date
    from emp
    where emp_id=e_emp_id;   --매개변수의 값을 넣어준다. 
    
    dbms_output.put_line(e_emp_name || ' ' || e_salary || ' ' || e_job_id || ' ' || e_hire_date);
end;
/
execute print_emp(100);
execute print_emp(110);


-- TODO 업무_ID(job.job_id)를 파라미터로 받아서 업무명(job.job_title)과 업무최대/최소 급여(job.max_salary, min_salary)
--를 출력하는 Stored Procedure 를 구현
create or replace procedure print_job (j_job_id job.job_id%type)
is                                        
     j_job_title job.job_title%type;       
     j_max_salary job.max_salary%type;       
     j_min_salary job.min_salary%type;
    
begin
    select job_title, max_salary, min_salary
    into j_job_title, j_max_salary, j_min_salary
    from job
    where job_id=j_job_id;   --매개변수의 값을 넣어준다. 
    
    dbms_output.put_line(j_job_title|| ' '|| j_max_salary|| ' '|| j_min_salary);
end;
/
EXEC print_job('FI_ACCOUNT');
EXEC print_job('IT_PROG');


-- TODO: 직원_ID를 파라미터로 받아서 직원의 이름(emp.emp_name), 업무 ID(emp.job_id), 업무명(job.job_title) 출력하는
--Stored Procedure 를 구현
create or replace procedure print_emp_job (e_emp_id emp.emp_id%type)
is                                        
     e_emp_name emp.emp_name%type;       
    e_job_id emp.job_id%type;       
     j_job_title job.job_title%type;
    
begin
    select e.emp_name, e.job_id, j.job_title
    into e_emp_name, e_job_id, j_job_title
    from emp e, job j
    where e.job_id=j.job_id
    and emp_id=e_emp_id;   --매개변수의 값을 넣어준다. 
    
    dbms_output.put_line(e_emp_name|| ' '|| e_job_id|| ' '|| j_job_title);
end;
/
EXEC print_emp_job(110);
EXEC print_emp_job(200);


-- TODO 직원의 ID를 파라미터로 받아서 직원의 이름(emp.emp_name), 급여(emp.salary), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를
--출력하는 Stored Procedure 를 구현
create or replace procedure print_emp_dept (e_emp_id emp.emp_id%type)
is                                        
     e_emp_name emp.emp_name%type;       
    e_salary emp.salary%type;       
     d_dept_name dept.dept_name%type;
     d_loc dept.loc%type;
    
begin
    select e.emp_name, e.salary, d.dept_name, d.loc
    into e_emp_name, e_salary, d_dept_name, d_loc
    from emp e, dept d
    where e.dept_id=d.dept_id
    and emp_id=e_emp_id;   --매개변수의 값을 넣어준다. 
    
    dbms_output.put_line(e_emp_name || ' '||e_salary|| ' '|| d_dept_name|| ' '|| d_loc);
end;
/
EXEC print_emp_dept(100);
EXEC print_emp_dept(120);



-- TODO 직원의 ID를 파라미터로 받아서 그 직원의 이름(emp.emp_name), 급여(emp.salary), 업무의 최대급여(job.max_salary), 
--업무의 최소급여(job.min_salary), 업무의 급여등급(salary_grade.grade)를 출력하는 store procedure를 구현
create or replace procedure print_emp_job_sal (e_emp_id emp.emp_id%type)
is                                        
    e_emp_name emp.emp_name%type;       
    e_salary emp.salary%type;       
     j_max_salary job.max_salary%type;
    j_min_salary job.min_salary%type;
    sg_grade salary_grade.grade%type;
    
begin
    select e.emp_name, e.salary, j.max_salary, j.min_salary, sg.grade
    into e_emp_name, e_salary, j_max_salary, j_min_salary, sg_grade
    from emp e, job j, salary_grade sg
    where e.job_id=j.job_id
    and  e.salary between sg.low_sal and sg.high_sal
    and emp_id=e_emp_id;   --매개변수의 값을 넣어준다. 
    
    dbms_output.put_line(e_emp_name || ' '||e_salary|| ' '|| j_max_salary || ' '||j_min_salary || ' '|| sg_grade);
end;
/
EXEC print_emp_job_sal(100);
EXEC print_emp_job_sal(120);


-- TODO: 직원의 ID(emp.emp_id)를 파라미터로 받아서 급여(salary)를 조회한 뒤
--급여와 급여등급을 출력하는 Stored Procedure 를 구현.
-- 업무급여 등급 기준:  급여가 $5000 미만 이면 LOW, $5000 ~ $10000 이면 MIDDLE, $10000 초과면 HIGH를 출력
create or replace procedure print_1234 (e_emp_id  in emp.emp_id%type)
is                                        
     e_salary emp.salary%type;
    sg_grade salary_grade.grade%type;
    
begin
    select e.salary, sg_grade
    into e_salary, sg_grade
    from emp e, salary_grade sg
    where e.salary between sg.low_sal and sg.high_sal
    and emp_id=e_emp_id;   --매개변수의 값을 넣어준다. 
    
   if  e_salary<5000 then
        dbms_output.put_line('LOW');
    elsif e_salary between 5000 and 10000 then
        dbms_output.put_line('MIDDLE.');
    else 
        dbms_output.put_line('HIGH');
    end if;
end; 
/

exec print_1234(100);
exec print_1234(130);






