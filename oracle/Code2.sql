■ "그림 2.1::주소 테이블" 생성

CREATE TABLE Address
(name       VARCHAR(32) NOT NULL,
 phone_nbr  VARCHAR(32) ,
 address    VARCHAR(32) NOT NULL,
 sex        CHAR(4) NOT NULL,
 age        INTEGER NOT NULL,
 PRIMARY KEY (name));

INSERT INTO Address VALUES('인성',   '080-3333-XXXX', '서울시',   '남', 30);
INSERT INTO Address VALUES('하진',   '090-0000-XXXX', '서울시',   '여', 21);
INSERT INTO Address VALUES('준',     '090-2984-XXXX', '서울시',   '남', 45);
INSERT INTO Address VALUES('민',     '080-3333-XXXX', '부산시',   '남', 32);
INSERT INTO Address VALUES('하린',   'NULL,           '부산시',   '여', 55);
INSERT INTO Address VALUES('빛나래', '080-5848-XXXX', '인천시',   '여', 19);
INSERT INTO Address VALUES('인아',   'NULL,           '인천시',   '여', 20);
INSERT INTO Address VALUES('아린',   '090-1922-XXXX', '속초시',   '여', 25);
INSERT INTO Address VALUES('기주',   '090-0001-XXXX', '서귀포시', '남', 32);

■ 코드 2.1 SELECT 구문으로 테이블 전체를 선택
SELECT name, phone_nbr, address, sex, age
  FROM Address;

■ 코드 2.2 WHERE 구로 검색 내용을 압축
SELECT name, address
  FROM Address
 WHERE address = '인천시';

■ 코드 2.3 나이가 30세 이상
SELECT name, age
  FROM Address
 WHERE age >= 30;

■ 코드 2.4 주소가 서울시 이외
SELECT name, address
  FROM Address
 WHERE address <> '서울시';

■ 코드 2.5 AND는 집합의 공유 부분을 선택
SELECT name, address, age
  FROM Address
 WHERE address = '서울시'
   AND age >= 30;

■ 코드 2.6 OR은 집합의 합집합을 선택
SELECT name, address, age
　FROM Address
 WHERE address = '서울시'
    OR age >= 30;

■ 코드 2.7 OR 조건을 여러 개 지정
SELECT name, address
　FROM Address
 WHERE address = '서울시'
    OR address = '부산시'
    OR address = '인천시';

■ 코드 2.8 IN을 사용한 방법
SELECT name, address
　FROM Address
 WHERE address IN ('서울시', '부산시', '인천시');

■ 코드 2.9 제대로 실행되지 않는 SELECT 구
SELECT name, address
　FROM Address
 WHERE phone_nbr = NULL;

■ 코드 2.10 제대로 작동하는 SELECT 구문
SELECT name, phone_nbr
　FROM Address
 WHERE phone_nbr IS NULL;

■ 코드 2.11 성별 별로 사람 수를 계산
SELECT sex, COUNT(*)
　FROM Address
 GROUP BY sex;

■ 코드 2.12 주소 별로 사람 수를 계산
SELECT address, COUNT(*)
　FROM Address
 GROUP BY address;

■ 코드 2.13 전체 인원 수를 계산
SELECT COUNT(*)
　FROM Address
 GROUP BY ( );

■ GROUP BY 생략
SELECT COUNT(*)
  FROM Address;

■ 코드 2.14 한 사람밖에 없는 주소를 선택
SELECT address, COUNT(*)
　FROM Address
 GROUP BY address
HAVING COUNT(*) = 1;

■ 코드 2.15 나이가 높은 순서로 레코드를 정렬
SELECT name, phone_nbr, address, sex, age
　FROM Address
 ORDER BY age DESC;

■ 코드 2.16 뷰 생성
CREATE VIEW CountAddress (v_address, cnt)
AS
SELECT address, COUNT(*)
　FROM Address
 GROUP BY address;

■ 코드 2.17 뷰 사용
SELECT v_address, cnt
　FROM CountAddress; 

■ 코드 2.18 뷰는 SELECT 구문이 중첩되어 있는 구조
-- 뷰에서 데이터를 선택
SELECT v_address, cnt
　FROM CountAddress;

-- 뷰는 실행할 때 SELECT 구문으로 전개
SELECT v_address, cnt
　FROM (SELECT address AS v_address, COUNT(*) AS cnt
          FROM Address
         GROUP BY address) AS CountAddress;


■ "그림 2.7::Address2 테이블" 생성

CREATE TABLE Address2
(name       VARCHAR(32) NOT NULL,
 phone_nbr  VARCHAR(32) ,
 address    VARCHAR(32) NOT NULL,
 sex        CHAR(4) NOT NULL,
 age        INTEGER NOT NULL,
 PRIMARY KEY (name));

INSERT INTO Address2 VALUES('인성', '080-3333-XXXX', '서울시', '남', 30);
INSERT INTO Address2 VALUES('민',   '080-3333-XXXX', '부산시', '남', 32);
INSERT INTO Address2 VALUES('준서', NULL,            '부산시', '남', 18);
INSERT INTO Address2 VALUES('지연', '080-2367-XXXX', '인천시', '여', 19);
INSERT INTO Address2 VALUES('서준', NULL,            '인천시', '여', 20);
INSERT INTO Address2 VALUES('중진', '090-0205-XXXX', '속초시', '남', 25);


■ 코드 2.19 IN 내부에서 서브쿼리 사용
SELECT name
　FROM Address
 WHERE name IN (SELECT name -- IN 내부에서 서브쿼리 사용
                  FROM Address2);

■ 코드 2.20 서브쿼리를 전개해서 실행
SELECT name
　FROM Address
 WHERE name IN ('인성', '민', '준서', '지연', '서준', '중진');


■ 코드 2.22 시도의 이름을 큰 지역으로 구분하는 CASE 식
SELECT name, address,
       CASE WHEN address = '서울시' THEN '경기'
            WHEN address = '인천시' THEN '경기'
            WHEN address = '부산시' THEN '영남'
            WHEN address = '속초시' THEN '관동'
            WHEN address = '서귀포시' THEN '호남'
            ELSE NULL END AS district
　FROM Address;

■ 코드 2.23 UNION으로 합집합 구하기
SELECT *
　FROM Address
UNION
SELECT *
　FROM Address2;


■ 코드 2.24 INTERSECT로 교집합 구하기
SELECT *
　FROM Address
INTERSECT
SELECT *
　FROM Address2;

■ 코드 2.25 EXCEPT로 차집합 구하기
SELECT *
　FROM Address
EXCEPT
SELECT *
　FROM Address2;

■ 코드 2.27 윈도우 함수로 주소별 사람 수를 계산하는 SQL
SELECT address,
       COUNT(*) OVER(PARTITION BY address)
　FROM Address;

■ 코드 2.28 윈도우 함수로 순위 구하기
SELECT name,
       age,
       RANK() OVER(ORDER BY age DESC) AS rnk
　FROM Address;

■ 코드 2.29 윈도우 함수로 순위 구하기(건너뛰기 없음)
SELECT name,
       age,
       DENSE_RANK() OVER(ORDER BY age DESC) AS dense_rnk
　FROM Address;

■ 코드 2.30 인성을 Address 테이블에 추가
INSERT INTO Address (name, phone_nbr, address, sex, age)
             VALUES ('小川', '080-3333-XXXX', '서울시', '남', 30);


■ 코드 2.31 9개의 레코드를 한 번에 추가
INSERT INTO Address (name, phone_nbr, address, sex, age)
              VALUES('인성', '080-3333-XXXX', '서울시', '남', 30),
              ('하진', '090-0000-XXXX', '서울시', '여', 21),
              ('준', '090-2984-XXXX', '서울시', '남', 45),
              ('민', '080-3333-XXXX', '부산시', '남', 32),
              ('하린', NULL, '부산시', '여', 55),
              ('빛나래', '080-5848-XXXX', '인천시', '여', 19),
              ('인아', NULL, '인천시', '여', 20),
              ('아린', '090-1922-XXXX', '속초시', '여', 25),
              ('기주', '090-0001-XXXX', '서귀포시', '남', 32);

■ 코드 2.32 Address 테이블의 데이터를 제거
DELETE FROM Address;

■ 코드 2.33 일부 레코드만 제거
DELETE FROM Address
 WHERE address = '인천시';

■ 코드 2.34 갱신 전의 데이터
SELECT *
　FROM Address;

■ 코드 2.35 빛나래의 전화번호를 갱신
UPDATE Address
　 SET phone_nbr = '080-5849-XXXX'
 WHERE name = '빛나래';

■ 코드 2.36 갱신 후의 데이터
SELECT *
　FROM Address;

■ 코드 2.37 UPDATE 구문을 두 번 사용해서 갱신
UPDATE Address
   SET phone_nbr = '080-5848-XXXX'
 WHERE name = '빛나래';

UPDATE Address
   SET age = 20
 WHERE name = '빛나래';

■ 코드 2.38 UPDATE 구문을 한 번 사용해서 갱신
--1. 필드를 쉼표로 구분해서 나열 
UPDATE Address
   SET phone_nbr = '080-5848-XXXX',
       age = 20
 WHERE name = '빛나래';

--2. 필드를 괄호로 감싸서 나열 
UPDATE Address
   SET (phone_nbr, age) = ('080-5848-XXXX', 20)
 WHERE name = '빛나래';
