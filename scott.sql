/*
테이블:customer
컬럼: id: varchar2(10)
    name: nvarchar2(10)
    age: number(3)
    gender: char(1)  여성: F, 남성: M
    join_date: Date
*/
create table customer(
    id varchar2(10),
    name nvarchar2(10),
    age number(3),
    gender char(1),
    join_date date
);
--테이블에 한 행의 데이터 추가
/*
    insert into 테이블이름 (컬럼명, 컬럼명,...) values (값,값,....)
*/
insert into customer (id,name,age,gender,join_date)
    values ('my-id','홍길동',20,'M','2000-10-05');

insert into customer
    values ('id-10','홍길동',20,'M','2000-10-05');

insert into customer (id,name,age)
    values ('my-id2','김유진',20);

--조회
select *
from customer;

--테이블을 제거.(데이터까지 다 날라간다)
drop table customer;

--테이블을 제약조건을 정해서 다시 생성!
create table customer(
    id varchar2(10) PRIMARY KEY,  --primary key 컬럼 (not null이면서 고유값을 갖는 속성)
    name nvarchar2(10) not null,   --null을 가질 수 없는 컬럼
    age number(3) not null,   
    gender char(1),
    join_date date
);
--제약조건: 들어가는 값들에 대해 제약을 줄 수 있음.
--필수적인 속성 제약/ 기본키 제약/ 

insert into customer 
    values ('my-id10','김재현',24,'M','2018-10-05');
    
 insert into customer (id)
    values ('my-id3');
    

insert into customer (id,name,age)
    values ('my-id11','박영희',22);
    

    
    