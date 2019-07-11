/* 고객 */
DROP TABLE CUSTOMERS 
	CASCADE CONSTRAINTS;

/* 주문 */
DROP TABLE ORDERS 
	CASCADE CONSTRAINTS;

/* 주문_제품 */
DROP TABLE ORDER_ITEMS 
	CASCADE CONSTRAINTS;

/* 제품 */
DROP TABLE PRODUCTS 
	CASCADE CONSTRAINTS;

/* 고객 */
CREATE TABLE CUSTOMERS (
	CUST_ID NUMBER(3) NOT NULL, /* 고객_ID */
	CUST_NAME VARCHAR2(20) NOT NULL, /* 고객_이름 */
	ADDRESS VARCHAR2(40) NOT NULL, /* 주소 */
	POSTAL_CODE VARCHAR2(10) NOT NULL, /* 우편번호 */
	CUST_EMAIL VARCHAR2(30) NOT NULL, /* 고객_이메일주소 */
	PHONE_NUMBER VARCHAR2(15), /* 전화번호 */
	GENDER CHAR(1), /* 성별 */
	JOIN_DATE DATE NOT NULL /* 가입일 */
);

ALTER TABLE CUSTOMERS
	ADD
		CONSTRAINT CUSTOMERS_PK_CUSTID
		PRIMARY KEY (
			CUST_ID
		);

/* 주문 */
CREATE TABLE ORDERS (
	ORDER_ID NUMBER NOT NULL, /* 주문_ID */
	ORDER_DATE DATE NOT NULL, /* 주문일 */
	CUST_ID NUMBER(3) NOT NULL, /* 고객_ID */
	ORDER_STATUS VARCHAR2(20) NOT NULL, /* 주문상태 */
	ORDER_TOTAL NUMBER /* 총금액 */
);

ALTER TABLE ORDERS
	ADD
		CONSTRAINT ORDERS_PK_ORDERID
		PRIMARY KEY (
			ORDER_ID
		);

/* 주문_제품 */
CREATE TABLE ORDER_ITEMS (
	ORDERE_ITEM_ID NUMBER NOT NULL, /* 주문상세_ID */
	SELL_PRICE NUMBER(8) NOT NULL, /* 판매가격 */
	QUANTITY NUMBER(8) NOT NULL, /* 수량 */
	PRODUCT_ID NUMBER(3), /* 제품_ID */
	ORDER_ID NUMBER /* 주문_ID */
);

ALTER TABLE ORDER_ITEMS
	ADD
		CONSTRAINT ORDITEMS_PK
		PRIMARY KEY (
			ORDERE_ITEM_ID
		);

/* 제품 */
CREATE TABLE PRODUCTS (
	PRODUCT_ID NUMBER(3) NOT NULL, /* 제품_ID */
	PRODUCT_NAME VARCHAR2(125) NOT NULL, /* 제품_이름 */
	CATEGORY VARCHAR2(30) NOT NULL, /* 제품분류 */
	MAKER VARCHAR2(50) NOT NULL, /* 제조사 */
	PRICE NUMBER(8) NOT NULL /* 제품가격 */
);

ALTER TABLE PRODUCTS
	ADD
		CONSTRAINT PRODUCTS_PK_PRODID
		PRIMARY KEY (
			PRODUCT_ID
		);

ALTER TABLE ORDERS
	ADD
		CONSTRAINT ORDERS_FK_CUSTID
		FOREIGN KEY (
			CUST_ID
		)
		REFERENCES CUSTOMERS (
			CUST_ID
		);

ALTER TABLE ORDER_ITEMS
	ADD
		CONSTRAINT FK_PRODUCTS_TO_ORDER_ITEMS
		FOREIGN KEY (
			PRODUCT_ID
		)
		REFERENCES PRODUCTS (
			PRODUCT_ID
		);

ALTER TABLE ORDER_ITEMS
	ADD
		CONSTRAINT FK_ORDERS_TO_ORDER_ITEMS
		FOREIGN KEY (
			ORDER_ID
		)
		REFERENCES ORDERS (
			ORDER_ID
		);
        
/*customers*/       
INSERT INTO CUSTOMERS VALUES(100, '김고객', '서울시 종로구 동숭동', '03084', 'kys@abc.com', '010-3232-5423', 'M', '2010/10/22');
INSERT INTO CUSTOMERS VALUES(110, '이고객', '서울시 강남구 논현동', '06038', 'ljh@abc.com', '010-7623-1328', 'F', '2011/11/02');
INSERT INTO CUSTOMERS VALUES(120, '박고객', '경기도 광명시 광명동', '14204', 'lhj@abc.com', '010-3232-5423', 'M', '2016/03/07');
INSERT INTO CUSTOMERS VALUES(130, '장고객', '경기도 군포시 광정동', '15843', 'oym@abc.com', '010-939-2000', 'F', '2014/08/22');
INSERT INTO CUSTOMERS VALUES(140, '주고객', '서울시 노원구 공릉동', '01796', 'jjy@abc.com', '010-510-5500', 'F', '2010/02/12');
INSERT INTO CUSTOMERS VALUES(150, '최고객', '경상남도 거제시 거제면', '53285', 'cmr@abc.com', '010-3258-6800', 'F', '2011/10/21');
INSERT INTO CUSTOMERS VALUES(160, '오고객', '전라북도 남원시 금동', '55769', 'kwj@abc.com', '010-9832-5522', 'M', '2009/06/28');
INSERT INTO CUSTOMERS VALUES(170, '우고객', '서울시 광진구 광장동', '04965', 'bsp@abc.com', '010-3001-1177', 'M', '2004/05/03');
INSERT INTO CUSTOMERS VALUES(180, '조고객', '서울시 구로구 고척동', '08240', 'luj@abc.com', '010-4123-9876', 'M', '2002/05/29');

/*products*/
INSERT INTO PRODUCTS VALUES(200, '모카골드', '커피', '동서식품', 20000);
INSERT INTO PRODUCTS VALUES(210, '프랜치카페', '커피', '남양유업', 20000);
INSERT INTO PRODUCTS VALUES(220, '카누', '커피', '동서식품', 18000);
INSERT INTO PRODUCTS VALUES(230, '맥스웰 하우스', '커피', '동서식품', 10000);
INSERT INTO PRODUCTS VALUES(300, '복숭아 홍차', '차', '담터', 9000);
INSERT INTO PRODUCTS VALUES(310, '얼그레이', '차', '트와이닝', 15000);
INSERT INTO PRODUCTS VALUES(320, '율무차', '차', '다농원', 13000);
INSERT INTO PRODUCTS VALUES(400, '마카다미아 쇼콜라', '초콜렛', '삼광식품', 10000);
INSERT INTO PRODUCTS VALUES(410, 'ABC 초콜렛', '초콜렛', '롯데', 15000);
INSERT INTO PRODUCTS VALUES(420, '킨더 조이 보이', '초콜렛', '킨더', 1000);
INSERT INTO PRODUCTS VALUES(430, '오레오', '쿠키', '동서식품', 2000);
INSERT INTO PRODUCTS VALUES(440, '촉촉한 초코칩', '쿠키', '오리온', 3000);     

/*orders*/
insert into orders values(1, '2017/10/10', 110, '구매확정', 77500);
insert into orders values(2, '2017/10/10', 120, '구매확정', 140000);
insert into orders values(3, '2017/10/10', 170, '구매확정', 122000);
insert into orders values(4, '2017/10/15', 110, '구매확정', 54750);
insert into orders values(5, '2017/10/17', 110, '구매확정', 53000);
insert into orders values(6, '2017/11/03', 120, '구매확정', 96000);
insert into orders values(7, '2017/11/08', 140, '구매확정', 54750);
insert into orders values(8, '2017/11/13', 130, '구매확정', 53000);
insert into orders values(9, '2017/11/13', 180, '구매확정', 20000);

/*order_items*/
insert into order_items values(1, 8000, 5, 300, 1);
insert into order_items values(2, 15000, 2, 410, 1);
insert into order_items values(3, 2500, 3, 440, 1);
insert into order_items values(4, 14000, 10, 310, 2);
insert into order_items values(5, 19000, 2, 210, 3);
insert into order_items values(6, 15000, 5, 410, 3);
insert into order_items values(7, 3000, 10, 440, 3);

insert into order_items values(8, 990, 25, 420, 4);
insert into order_items values(9, 3000, 10, 440, 4);

insert into order_items values(10, 19000, 1, 200, 5);
insert into order_items values(11, 9000, 1, 300, 5);
insert into order_items values(12, 12500, 2, 320, 5);

insert into order_items values(13, 20000, 3, 200, 6);
insert into order_items values(14, 18000, 2, 220, 6);

insert into order_items values(15, 990, 25, 420, 7);
insert into order_items values(16, 3000, 10, 440, 7);

insert into order_items values(17, 19000, 1, 200, 8);
insert into order_items values(18, 9000, 1, 300, 8);
insert into order_items values(19, 12500, 2, 320, 8);

insert into order_items values(20, 20000, 1, 200, 9);

COMMIT;