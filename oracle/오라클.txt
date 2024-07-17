	[사용자 생성과 권한 부여]
CREATE USER C##DBTEST IDENTIFIED BY dbgood
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

GRANT CONNECT, RESOURCE TO C##DBTEST;

	

	[예제 7-1]
CREATE TABLE 고객 (
	고객아이디  VARCHAR(20)	 NOT NULL,
	고객이름    VARCHAR(10)	 NOT NULL,
	나이	    INT,
	등급	    VARCHAR(10)	 NOT NULL,
	직업	    VARCHAR(20),
	적립금	    INT   DEFAULT 0,
	PRIMARY KEY(고객아이디)
);


	[예제 7-2]
CREATE TABLE  제품 (
	제품번호   CHAR(3)   NOT NULL,
	제품명      VARCHAR(20),
	재고량      INT,
	단가         INT,
	제조업체    VARCHAR(20),
	PRIMARY KEY(제품번호),
	CHECK (재고량 >= 0 AND 재고량 <=10000)
);


	[예제 7-3]
CREATE TABLE  주문 (
	주문번호   CHAR(3) NOT NULL,
	주문고객   VARCHAR(20),
	주문제품   CHAR(3),
	수량        INT,
	배송지     VARCHAR(30),
	주문일자  DATE,
	PRIMARY KEY(주문번호),
	FOREIGN KEY(주문고객)   REFERENCES   고객(고객아이디),
	FOREIGN KEY(주문제품)   REFERENCES   제품(제품번호)
);

	[예제 7-4]
CREATE TABLE  배송업체 (
	업체번호   CHAR(3) NOT NULL,
	업체명   VARCHAR(20),
	주소  VARCHAR(100),
	전화번호  VARCHAR(20),
	PRIMARY KEY(업체번호)
);


	[예제 7-5]
ALTER TABLE 고객 ADD 가입날짜 DATE; 


	[예제 7-6]
ALTER TABLE 고객 DROP COLUMN 가입날짜;


	[예제 7-7]
ALTER TABLE 고객 ADD CONSTRAINT CHK_AGE CHECK(나이 >= 20); 

	[예제 7-8]
ALTER TABLE 고객 DROP CONSTRAINT CHK_AGE; 


	[예제 7-9]
DROP TABLE 배송업체; 


	[예제 7-10 전]
[고객 테이블에 튜플 삽입]
INSERT INTO 고객 VALUES ('apple', '정소화', 20, 'gold', '학생', 1000);
INSERT INTO 고객 VALUES ('banana', '김선우', 25, 'vip', '간호사', 2500);
INSERT INTO 고객 VALUES ('carrot', '고명석', 28, 'gold', '교사', 4500);
INSERT INTO 고객 VALUES ('orange', '김용욱', 22, 'silver', '학생', 0);
INSERT INTO 고객 VALUES ('melon', '성원용', 35, 'gold', '회사원', 5000);
INSERT INTO 고객 VALUES ('peach', '오형준', NULL, 'silver', '의사', 300);
INSERT INTO 고객 VALUES ('pear', '채광주', 31, 'silver', '회사원', 500);

[제품 테이블에 튜플 삽입]
INSERT INTO 제품 VALUES ('p01', '그냥만두', 5000, 4500, '대한식품');
INSERT INTO 제품 VALUES ('p02', '매운쫄면', 2500, 5500, '민국푸드');
INSERT INTO 제품 VALUES ('p03', '쿵떡파이', 3600, 2600, '한빛제과');
INSERT INTO 제품 VALUES ('p04', '맛난초콜릿', 1250, 2500, '한빛제과');
INSERT INTO 제품 VALUES ('p05', '얼큰라면', 2200, 1200, '대한식품');
INSERT INTO 제품 VALUES ('p06', '통통우동', 1000, 1550, '민국푸드');
INSERT INTO 제품 VALUES ('p07', '달콤비스킷', 1650, 1500, '한빛제과');

[주문 테이블에 튜플 삽입]
INSERT INTO 주문 VALUES ('o01', 'apple', 'p03', 10, '서울시 마포구', '19/01/01');
INSERT INTO 주문 VALUES ('o02', 'melon', 'p01', 5, '인천시 계양구', '19/01/10');
INSERT INTO 주문 VALUES ('o03', 'banana', 'p06', 45, '경기도 부천시', '19/01/11');
INSERT INTO 주문 VALUES ('o04', 'carrot', 'p02', 8, '부산시 금정구', '19/02/01');
INSERT INTO 주문 VALUES ('o05', 'melon', 'p06', 36, '경기도 용인시', '19/02/20');
INSERT INTO 주문 VALUES ('o06', 'banana', 'p01', 19, '충청북도 보은군', '19/03/02');
INSERT INTO 주문 VALUES ('o07', 'apple', 'p03', 22, '서울시 영등포구', '19/03/15');
INSERT INTO 주문 VALUES ('o08', 'pear', 'p02', 50, '강원도 춘천시', '19/04/10');
INSERT INTO 주문 VALUES ('o09', 'banana', 'p04', 15, '전라남도 목포시', '19/04/11');
INSERT INTO 주문 VALUES ('o10', 'carrot', 'p03', 20, '경기도 안양시', '19/05/22');


	[예제 7-10]
SELECT	고객아이디, 고객이름, 등급
FROM	고객;

	[예제 7-11]
SELECT	고객아이디, 고객이름, 나이, 등급, 직업, 적립금
FROM	고객;

	[예제 7-12]
SELECT	*
FROM	고객;

	[예제 7-13]
SELECT	제조업체
FROM	제품;

	[예제 7-14]
SELECT	ALL   제조업체
FROM　　제품;


	[예제 7-15]
SELECT	DISTINCT   제조업체
FROM	제품;

	[예제 7-16]
SELECT	제품명, 단가 AS 가격
FROM	제품;

	[예제 7-17]
SELECT	제품명, 단가 + 500 AS "조정 단가"
FROM	제품;


	[예제 7-18]
SELECT	제품명, 재고량, 단가
FROM	제품
WHERE 	제조업체 = '한빛제과'; 


	[예제 7-19]
SELECT	주문제품, 수량, 주문일자
FROM	주문
WHERE	주문고객 = 'apple'  AND  수량 >= 15;


	[예제 7-20]
SELECT  주문제품, 수량, 주문일자, 주문고객
FROM    주문
WHERE   주문고객 = 'apple'  OR  수량 >= 15;


	[예제 7-21]
SELECT	제품명, 단가, 제조업체
FROM	제품
WHERE	단가 >= 2000  AND  단가 <= 3000;


	[예제 7-22]
SELECT	고객이름, 나이, 등급, 적립금
FROM	고객
WHERE	고객이름 LIKE '김%';


	[예제 7-23]
SELECT	고객아이디, 고객이름, 등급
FROM	고객
WHERE	고객아이디 LIKE '_____';


	[예제 7-24]
SELECT	고객이름
FROM	고객
WHERE	나이 IS NULL;

	[예제 7-25]
SELECT	고객이름
FROM	고객
WHERE	나이 IS NOT NULL;

	[예제 7-26]
SELECT	고객이름, 등급, 나이
FROM	고객
ORDER BY   나이  DESC;


	[예제 7-27]
SELECT	주문고객, 주문제품, 수량, 주문일자
FROM	주문
WHERE	수량 >= 10
ORDER BY  주문제품 ASC, 수량 DESC;


	[예제 7-28]
SELECT	AVG(단가)
FROM	제품;


	[예제 7-29]
SELECT	SUM(재고량)  AS  "재고량 합계"
FROM	제품
WHERE	제조업체 = '한빛제과';


	[예제 7-30]
SELECT	COUNT(고객아이디) AS 고객수
FROM	고객;

SELECT	COUNT(나이) AS 고객수
FROM	고객;

SELECT	COUNT(*) AS 고객수
FROM	고객;


	[예제 7-31]
SELECT	COUNT(DISTINCT 제조업체) AS "제조업체 수"
FROM	제품;


	[예제 7-32]
SELECT	주문제품, SUM(수량) AS 총주문수량
FROM	주문
GROUP BY   주문제품;

SELECT	SUM(수량) AS 총주문수량
FROM	주문
GROUP BY   주문제품;


	[예제 7-33]
SELECT	제조업체, COUNT(*) AS 제품수, MAX(단가) AS 최고가
FROM	제품
GROUP BY   제조업체;


	[예제 7-34]
SELECT	제조업체, COUNT(*) AS 제품수, MAX(단가) AS 최고가
FROM	제품
GROUP BY  제조업체  HAVING COUNT(*) >= 3;


	[예제 7-35]
SELECT	등급, COUNT(*) AS 고객수, AVG(적립금) AS 평균적립금
FROM	고객
GROUP BY  등급  HAVING AVG(적립금) >= 1000;


	[예제 7-36]
SELECT	주문제품, 주문고객, SUM(수량) AS 총주문수량
FROM	주문
GROUP BY  주문제품, 주문고객; 


	[예제 7-37]
SELECT	제품.제품명
FROM	제품, 주문
WHERE	주문.주문고객 = 'banana'  AND  제품.제품번호 = 주문.주문제품; 

	[예제 7-38]
SELECT	주문.주문제품, 주문.주문일자
FROM	고객, 주문
WHERE	고객.나이 >= 30  AND  고객.고객아이디 = 주문.주문고객; 


SELECT	주문제품, 주문일자
FROM	고객  AS c, 주문 AS o
WHERE	c.나이 >= 30  AND  c.고객아이디 = o.주문고객; 


	[예제 7-39]
SELECT	제품.제품명
FROM	고객, 제품, 주문
WHERE	고객.고객이름 = '고명석' AND  고객.고객아이디 = 주문.주문고객 
		AND  제품.제품번호 = 주문.주문제품; 

	[예제 7-40]
SELECT	제품명, 단가
FROM	제품
WHERE	제조업체 = (SELECT   제조업체
                    	    FROM    제품
                    	    WHERE  제품명 = '달콤비스킷');

SELECT	제품명, 단가
FROM	제품
WHERE	제조업체 = '한빛제과';


	[예제 7-41]
SELECT	고객이름, 적립금
FROM	고객
WHERE	적립금 = (SELECT  MAX(적립금)  FROM  고객); 


SELECT	고객이름, 적립금
FROM	고객
WHERE	적립금 =5000; 


	[예제 7-42]
SELECT	제품명, 제조업체
FROM	제품
WHERE	제품번호  IN (SELECT  주문제품   
		      FROM   주문
		      WHERE  주문고객  = 'banana'); 


SELECT	제품명, 제조업체
FROM	제품
WHERE	제품번호  IN  ('p01', 'p04', 'p06'); 



	[예제 7-43]
SELECT	제품명, 제조업체
FROM	제품
WHERE	제품번호  NOT  IN (SELECT	  주문제품   
			  FROM	  주문
			  WHERE	  주문고객  = 'banana'); 


	[예제 7-44]
SELECT	제품명, 단가, 제조업체
FROM	제품
WHERE	단가  > ALL (SELECT   단가   
		     FROM     제품
		     WHERE    제조업체  = '대한식품'); 

	[예제 7-45]
SELECT	고객이름
FROM	고객
WHERE	EXISTS (SELECT  *   
		FROM    주문
		WHERE   주문일자 = '2019-03-15' 
		        AND  주문.주문고객 = 고객.고객아이디); 


	[예제 7-46]
SELECT	고객이름
FROM	고객
WHERE	NOT  EXISTS (SELECT  *   
		     FROM    주문
		     WHERE   주문일자 = '2019-03-15' 
  	       	             AND  주문.주문고객 = 고객.고객아이디); 


	[예제 7-47]
INSERT  
INTO	고객(고객아이디, 고객이름, 나이, 등급, 직업, 적립금)
VALUES ('strawberry', '최유경', 30, 'vip', '공무원', 100);

SELECT  *  FROM  고객;  



	[예제 7-48]
INSERT  
INTO    고객(고객아이디, 고객이름, 나이, 등급, 적립금)
VALUES ('tomato', '정은심', 36, 'gold', 4000);

SELECT  *  FROM  고객;  


INSERT  
INTO    한빛제품(제품명, 재고량, 단가)
SELECT  제품명, 재고량, 단가
FROM    제품
WHERE   제조업체 = '한빛제과';

SELECT  *  FROM  한빛제품;  


	[예제 7-49]
UPDATE	제품  
SET	제품명 = '통큰파이'
WHERE	제품번호 = 'p03';

SELECT  *  FROM  제품;  

	[예제 7-50]
UPDATE	제품  
SET	단가 = 단가 * 1.1;

SELECT  *  FROM  제품;  


	[예제 7-51]
UPDATE	주문  
SET	수량 = 5
WHERE   주문고객 IN (SELECT	고객아이디
 		     FROM	고객
		     WHERE	고객이름 = '정소화');

SELECT  *  FROM	주문; 



	[예제 7-52]
DELETE
FROM	주문  
WHERE	주문일자 = '2019-05-22';

SELECT  *  FROM  주문; 


	[예제 7-53]
DELETE     
FROM	주문
WHERE	주문고객 IN (SELECT   고객아이디
 	                FROM    고객
		     WHERE   고객이름 = '정소화');

SELECT  *  FROM  주문;  


	[예제 7-54]
DELETE
FROM	 주문;

SELECT  *  FROM  주문; 



	[예제 7-55]
CREATE VIEW	우수고객(고객아이디, 고객이름, 나이)
AS SELECT	고객아이디, 고객이름, 나이
	FROM	고객
	WHERE	등급 = 'vip'
WITH CHECK OPTION;

SELECT * FROM	우수고객;



CREATE VIEW	우수고객
AS SELECT	고객아이디, 고객이름, 나이
	FROM	고객
	WHERE	등급 = 'vip'
WITH CHECK OPTION;


	[예제 7-56]
CREATE  VIEW	   업체별제품수(제조업체, 제품수)
AS  SELECT	   제조업체, COUNT(*)
	FROM	   제품
	GROUP BY  제조업체
WITH CHECK OPTION;

SELECT  *  FROM	   업체별제품수;


	[예제 7-57]
SELECT  *  FROM  우수고객  WHERE  나이 >= 25;


CREATE VIEW	제품1
AS SELECT	제품번호, 재고량, 제조업체
	FROM	제품
WITH CHECK OPTION;

SELECT * FROM	제품1;



CREATE VIEW	제품2
AS SELECT	제품명, 재고량, 제조업체
	FROM	제품
WITH CHECK OPTION;

SELECT * FROM	제품2;


	[예제 7-58]
INSERT INTO	제품1	VALUES ('p08', 1000, '신선식품');
SELECT * FROM	제품1; 


SELECT * FROM	제품;



	[예제 7-59]
DROP VIEW 우수고객;