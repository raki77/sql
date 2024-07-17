■ "그림 5.1::매출 계산을 하는 테이블" 생성

CREATE TABLE Sales
(company CHAR(1) NOT NULL,
 year    INTEGER NOT NULL , 
 sale    INTEGER NOT NULL , 
   CONSTRAINT pk_sales PRIMARY KEY (company, year));

INSERT INTO Sales VALUES ('A', 2002, 50);
INSERT INTO Sales VALUES ('A', 2003, 52);
INSERT INTO Sales VALUES ('A', 2004, 55);
INSERT INTO Sales VALUES ('A', 2007, 55);
INSERT INTO Sales VALUES ('B', 2001, 27);
INSERT INTO Sales VALUES ('B', 2005, 28);
INSERT INTO Sales VALUES ('B', 2006, 28);
INSERT INTO Sales VALUES ('B', 2009, 30);
INSERT INTO Sales VALUES ('C', 2001, 40);
INSERT INTO Sales VALUES ('C', 2005, 39);
INSERT INTO Sales VALUES ('C', 2006, 38);
INSERT INTO Sales VALUES ('C', 2010, 35);

CREATE TABLE Sales2
(company CHAR(1) NOT NULL,
 year    INTEGER NOT NULL , 
 sale    INTEGER NOT NULL , 
 var     CHAR(1) ,
   CONSTRAINT pk_sales2 PRIMARY KEY (company, year));


■ 코드 5.1 반복계 코드
CREATE OR REPLACE PROCEDURE PROC_INSERT_VAR
IS

  /* 커서 선언 */
  CURSOR c_sales IS
       SELECT company, year, sale
         FROM Sales
        ORDER BY company, year;

  /* 레코드 타입 선언 */
  rec_sales c_sales%ROWTYPE;

  /* 카운터 */
  i_pre_sale INTEGER := 0;
  c_company CHAR(1) := '*';
  c_var CHAR(1) := '*';

BEGIN

OPEN c_sales;

  LOOP
    /* 레코드를 패치해서 변수에 대입 */
    fetch c_sales into rec_sales;
    /* 레코드가 없다면 반복을 종료 */
    exit when c_sales%notfound;

    IF (c_company = rec_sales.company) THEN
        /* 직전 레코드가 같은 회사의 레코드 일 때 */
        /* 직전 레코드와 매상을 비교 */
        IF (i_pre_sale < rec_sales.sale) THEN
            c_var := '+';
        ELSIF (i_pre_sale > rec_sales.sale) THEN
            c_var := '-';
        ELSE
            c_var := '=';
        END IF;

    ELSE
        c_var := NULL;
    END IF;

    /* 등록 대상이 테이블에 테이블을 등록 */
    INSERT INTO Sales2 (company, year, sale, var) 
      VALUES (rec_sales.company, rec_sales.year, rec_sales.sale, c_var);

    c_company := rec_sales.company;
    i_pre_sale := rec_sales.sale;

  END LOOP;

  CLOSE c_sales;
  commit;
END;


■ 코드 5.2 엄청나게 단순한 SQL 구문
CREATE TABLE Foo 
( p_key INTEGER PRIMARY KEY,
  col_a INTEGER );

SELECT col_a FROM Foo WHERE p_key = 1;


■ 코드 5.3 윈도우 함수를 사용한 방법
INSERT INTO Sales2
SELECT company,
       year,
       sale,
       CASE SIGN(sale - MAX(sale)
                         OVER ( PARTITION BY company
                                    ORDER BY year
                                     ROWS BETWEEN 1 PRECEDING
                                              AND 1 PRECEDING) )
       WHEN 0 THEN '='
       WHEN 1 THEN '+'
       WHEN -1 THEN '-'
       ELSE NULL END AS var
　FROM Sales;


■ 코드 5.4 윈도우 함수로 '직전 회사명'과 '직전 매상'' 검색
SELECT company,
       year,
       sale,
       MAX(company)
         OVER (PARTITION BY company
                   ORDER BY year
                    ROWS BETWEEN 1 PRECEDING
                             AND 1 PRECEDING) AS pre_company,
       MAX(sale)
         OVER (PARTITION BY company
                   ORDER BY year
                    ROWS BETWEEN 1 PRECEDING
                             AND 1 PRECEDING) AS pre_sale
　FROM Sales;


■ 코드 5.5 우편번호 테이블 정의
CREATE TABLE PostalCode
(pcode CHAR(7),
 district_name VARCHAR(256),
     CONSTRAINT pk_pcode PRIMARY KEY(pcode));

INSERT INTO PostalCode VALUES ('4130001',  '시즈오카 아타미 이즈미');
INSERT INTO PostalCode VALUES ('4130002',  '시즈오카 아타미 이즈산');
INSERT INTO PostalCode VALUES ('4130103',  '시즈오카 아타미 아지로');
INSERT INTO PostalCode VALUES ('4130041',  '시즈오카 아타미 아오바초');
INSERT INTO PostalCode VALUES ('4103213',  '시즈오카 이즈 아오바네');
INSERT INTO PostalCode VALUES ('4380824',  '시즈오카 이와타 아카');

■ 코드 5.6 우편번호 순위를 매기는 쿼리
SELECT pcode,
       district_name,
       CASE WHEN pcode = '4130033' THEN 0
            WHEN pcode LIKE '413003%' THEN 1
            WHEN pcode LIKE '41300%'  THEN 2
            WHEN pcode LIKE '4130%'   THEN 3
            WHEN pcode LIKE '413%'    THEN 4
            WHEN pcode LIKE '41%'     THEN 5
            WHEN pcode LIKE '4%'      THEN 6
            ELSE NULL END AS rank
  FROM PostalCode;


■ 코드 5.7 가까운 우편번호를 구하는 쿼리
SELECT pcode,
       district_name
  FROM PostalCode
 WHERE CASE WHEN pcode = '4130033' THEN 0
            WHEN pcode LIKE '413003%' THEN 1
            WHEN pcode LIKE '41300%'  THEN 2
            WHEN pcode LIKE '4130%'   THEN 3
            WHEN pcode LIKE '413%'    THEN 4
            WHEN pcode LIKE '41%'     THEN 5
            WHEN pcode LIKE '4%'      THEN 6
            ELSE NULL END = 
                (SELECT MIN(CASE WHEN pcode = '4130033' THEN 0
                                 WHEN pcode LIKE '413003%' THEN 1
                                 WHEN pcode LIKE '41300%'  THEN 2
                                 WHEN pcode LIKE '4130%'   THEN 3
                                 WHEN pcode LIKE '413%'    THEN 4
                                 WHEN pcode LIKE '41%'     THEN 5
                                 WHEN pcode LIKE '4%'      THEN 6
                                 ELSE NULL END)
                   FROM PostalCode);

■ 코드 5.8 윈도우 함수를 사용한 방법
SELECT pcode,
       district_name
  FROM (SELECT pcode,
               district_name,
               CASE WHEN pcode = '4130033' THEN 0
                    WHEN pcode LIKE '413003%' THEN 1
                    WHEN pcode LIKE '41300%'  THEN 2
                    WHEN pcode LIKE '4130%'   THEN 3
                    WHEN pcode LIKE '413%'    THEN 4
                    WHEN pcode LIKE '41%'     THEN 5
                    WHEN pcode LIKE '4%'      THEN 6
                    ELSE NULL END AS hit_code,
               MIN(CASE WHEN pcode = '4130033' THEN 0
                        WHEN pcode LIKE '413003%' THEN 1
                        WHEN pcode LIKE '41300%'  THEN 2
                        WHEN pcode LIKE '4130%'   THEN 3
                        WHEN pcode LIKE '413%'    THEN 4
                        WHEN pcode LIKE '41%'     THEN 5
                        WHEN pcode LIKE '4%'      THEN 6
                        ELSE NULL END) 
                OVER(ORDER BY CASE WHEN pcode = '4130033' THEN 0
                                   WHEN pcode LIKE '413003%' THEN 1
                                   WHEN pcode LIKE '41300%'  THEN 2
                                   WHEN pcode LIKE '4130%'   THEN 3
                                   WHEN pcode LIKE '413%'    THEN 4
                                   WHEN pcode LIKE '41%'     THEN 5
                                   WHEN pcode LIKE '4%'      THEN 6
                                   ELSE NULL END) AS min_code
          FROM PostalCode) Foo
 WHERE hit_code = min_code;


■ 코드 5.9 우편번호 이력 테이블 정의
CREATE TABLE PostalHistory
(name  CHAR(1),
 pcode CHAR(7),
 new_pcode CHAR(7),
     CONSTRAINT pk_name_pcode PRIMARY KEY(name, pcode));

INSERT INTO PostalHistory VALUES ('A', '4130001', '4130002');
INSERT INTO PostalHistory VALUES ('A', '4130002', '4130103');
INSERT INTO PostalHistory VALUES ('A', '4130103', NULL     );
INSERT INTO PostalHistory VALUES ('B', '4130041', NULL     );
INSERT INTO PostalHistory VALUES ('C', '4103213', '4380824');
INSERT INTO PostalHistory VALUES ('C', '4380824', NULL     );


■ 코드 5.10 가장 오래된 주소 검색(PostgreSQL) 
WITH RECURSIVE Explosion (name, pcode, new_pcode, depth)
AS
(SELECT name, pcode, new_pcode, 1
   FROM PostalHistory 
  WHERE name = 'A'
    AND new_pcode IS NULL -- 검색시작
 UNION
 SELECT Child.name, Child.pcode, Child.new_pcode, depth + 1
   FROM Explosion AS Parent, PostalHistory AS Child
  WHERE Parent.pcode = Child.new_pcode
    AND Parent.name = Child.name)
-- 메인 SELECT 구문
SELECT name, pcode, new_pcode
  FROM Explosion
 WHERE depth = (SELECT MAX(depth)
                  FROM Explosion);


■ 코드 5.11 가장 오래된 주소를 검색(Oracle) 
WITH Explosion (name, pcode, new_pcode, depth)
AS
(SELECT name, pcode, new_pcode, 1
   FROM PostalHistory
  WHERE name = 'A'
    AND new_pcode IS NULL -- 검색시작
 UNION ALL
 SELECT Child.name, Child.pcode, Child.new_pcode, depth + 1
   FROM Explosion Parent, PostalHistory Child
  WHERE Parent.pcode = Child.new_pcode
    AND Parent.name = Child.name)
-- 메인 SELECT 구문
SELECT name, pcode, new_pcode
  FROM Explosion
 WHERE depth = (SELECT MAX(depth)
                  FROM Explosion);


■ 코드 5.12 우편번호의 이력 테이블(PostralHistory2) 정의
CREATE TABLE PostalHistory2
(name  CHAR(1),
 pcode CHAR(7),
 lft   REAL NOT NULL,
 rgt   REAL NOT NULL,
     CONSTRAINT pk_name_pcode2 PRIMARY KEY(name, pcode),
     CONSTRAINT uq_name_lft UNIQUE (name, lft),
     CONSTRAINT uq_name_rgt UNIQUE (name, rgt),
     CHECK(lft < rgt));

INSERT INTO PostalHistory2 VALUES ('A', '4130001', 0,   27);
INSERT INTO PostalHistory2 VALUES ('A', '4130002', 9,   18);
INSERT INTO PostalHistory2 VALUES ('A', '4130103', 12,  15);
INSERT INTO PostalHistory2 VALUES ('B', '4130041', 0,   27);
INSERT INTO PostalHistory2 VALUES ('C', '4103213', 0,   27);
INSERT INTO PostalHistory2 VALUES ('C', '4380824', 9,   18);


■ 코드 5.13 가장 외부에 있는 원 찾기
SELECT name, pcode
  FROM PostalHistory2 PH1
 WHERE name = 'A'
   AND NOT EXISTS 
        (SELECT *
           FROM PostalHistory2 PH2
          WHERE PH2.name = 'A'
            AND PH1.lft > PH2.lft);

