--마당서점의 고객이 요구하는 다음 질문에 대해 SQL 문을 작성하시오.
--  (1) 도서번호가 1인 도서의 이름
--  (2) 가격이 20,000원 이상인 도서의 이름
--  (3) 박지성의 총 구매액(박지성의 고객번호는 1번으로 놓고 작성)
--  (4) 박지성이 구매한 도서의 수(박지성의 고객번호는 1번으로 놓고 작성)
--
-- 
--마당서점의 운영자와 경영자가 요구하는 다음 질문에 대해 SQL 문을 작성하시오.
--(1) 마당서점 도서의 총 개수
--(2) 마당서점에 도서를 출고하는 출판사의 총 개수
--(3) 모든 고객의 이름, 주소
--(4) 2014년 7월 4일~7월 7일 사이에 주문 받은 도서의 주문번호
--(5) 2014년 7월 4일~7월 7일 사이에 주문 받은 도서를 제외한 도서의 주문번호
--(6) 성이 ‘김’ 씨인 고객의 이름과 주소
--(7) 성이 ‘김’ 씨이고 이름이 ‘아’로 끝나는 고객의 이름과 주소

--  (1) 도서번호가 1인 도서의 이름
SELECT * FROM BOOK b WHERE b.BOOKID  = 1

--  (2) 가격이 20,000원 이상인 도서의 이름
SELECT * FROM BOOK b WHERE b.PRICE  >= 20000
 
--  (3) 박지성의 총 구매액(박지성의 고객번호는 1번으로 놓고 작성)
SELECT sum(o.SALEPRICE) FROM ORDERS o WHERE o.CUSTID = (
	SELECT CUSTID FROM CUSTOMER WHERE name ='박지성' AND rownum = 1  
); 
  
-- (4) 박지성이 구매한 도서의 수(박지성의 고객번호는 1번으로 놓고 작성)
SELECT count(o.SALEPRICE) FROM ORDERS o WHERE o.CUSTID = (	SELECT CUSTID FROM CUSTOMER WHERE name ='박지성' AND rownum = 1); 

--(1) 마당서점 도서의 총 개수
SELECT count(b.BOOKNAME) FROM BOOK b

--(2) 마당서점에 도서를 출고하는 출판사의 총 개수
SELECT count(x.publisher)
FROM (SELECT DISTINCT b.publisher FROM BOOK b) x

--(3) 모든 고객의 이름, 주소
SELECT c.NAME, c.ADDRESS FROM CUSTOMER c

--(4) 2014년 7월 4일~7월 7일 사이에 주문 받은 도서의 주문번호
SELECT * FROM orders o WHERE TO_CHAR(o.ORDERDATE, 'YYYY-MM-DD') BETWEEN '2020-07-04' AND '2020-07-07'; 

--(5) 2014년 7월 4일~7월 7일 사이에 주문 받은 도서를 제외한 도서의 주문번호
SELECT o.*
FROM orders o
WHERE o.bookid NOT IN ( SELECT bookid 	FROM orders 
	WHERE TO_CHAR(ORDERDATE, 'YYYY-MM-DD') BETWEEN '2020-07-04' AND '2020-07-07'
);

--(6) 성이 ‘김’ 씨인 고객의 이름과 주소
SELECT c.NAME, c.ADDRESS FROM CUSTOMER c WHERE c.NAME LIKE '김%'

--(7) 성이 ‘김’ 씨이고 이름이 ‘아’로 끝나는 고객의 이름과 주소
SELECT c.NAME, c.ADDRESS FROM CUSTOMER c WHERE c.NAME LIKE '김%' AND c.NAME LIKE '%아'


