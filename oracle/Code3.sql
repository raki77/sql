■ "그림 3.1::상품 테이블" 생성

CREATE TABLE Items
(   item_id     INTEGER  NOT NULL, 
       year     INTEGER  NOT NULL, 
  item_name     CHAR(32) NOT NULL, 
  price_tax_ex  INTEGER  NOT NULL, 
  price_tax_in  INTEGER  NOT NULL, 
  PRIMARY KEY (item_id, year));

INSERT INTO Items VALUES(100, 2000, '머그컵' ,500, 525);
INSERT INTO Items VALUES(100, 2001, '머그컵' ,520, 546);
INSERT INTO Items VALUES(100, 2002, '머그컵' ,600, 630);
INSERT INTO Items VALUES(100, 2003, '머그컵' ,600, 630);
INSERT INTO Items VALUES(101, 2000, '티스푼' ,500, 525);
INSERT INTO Items VALUES(101, 2001, '티스푼' ,500, 525);
INSERT INTO Items VALUES(101, 2002, '티스푼' ,500, 525);
INSERT INTO Items VALUES(101, 2003, '티스푼' ,500, 525);
INSERT INTO Items VALUES(102, 2000, '나이프' ,600, 630);
INSERT INTO Items VALUES(102, 2001, '나이프' ,550, 577);
INSERT INTO Items VALUES(102, 2002, '나이프' ,550, 577);
INSERT INTO Items VALUES(102, 2003, '나이프' ,400, 420);

■ 코드 3.1 UNION을 사용한 조건 분기
SELECT item_name, year, price_tax_ex AS price
　FROM Items
 WHERE year <= 2001
UNION ALL
SELECT item_name, year, price_tax_in AS price
　FROM Items
 WHERE year >= 2002;

■ 코드 3.2 SELECT 구문에서 CASE 식을 사용한 조건 분기
SELECT item_name, year,
       CASE WHEN year <= 2001 THEN price_tax_ex
            WHEN year >= 2002 THEN price_tax_in END AS price
　FROM Items;


■ "그림 3.7::인구 테이블" 생성
CREATE TABLE Population
(prefecture VARCHAR(32),
 sex        CHAR(1),
 pop        INTEGER,
     CONSTRAINT pk_pop PRIMARY KEY(prefecture, sex));

INSERT INTO Population VALUES('성남', '1', 60);
INSERT INTO Population VALUES('성남', '2', 40);
INSERT INTO Population VALUES('수원', '1', 90);
INSERT INTO Population VALUES('수원', '2',100);
INSERT INTO Population VALUES('광명', '1',100);
INSERT INTO Population VALUES('광명', '2', 50);
INSERT INTO Population VALUES('일산', '1',100);
INSERT INTO Population VALUES('일산', '2',100);
INSERT INTO Population VALUES('용인', '1', 20);
INSERT INTO Population VALUES('용인', '2',200);


■ 코드 3.3 UNION을 사용한 방법
SELECT prefecture, SUM(pop_men) AS pop_men, SUM(pop_wom) AS pop_wom
　FROM ( SELECT prefecture, pop AS pop_men, null AS pop_wom
           FROM Population
          WHERE sex = '1' --남성
         UNION
         SELECT prefecture, NULL AS pop_men, pop AS pop_wom
           FROM Population
          WHERE sex = '2') TMP --여성
 GROUP BY prefecture;

■ 코드 3.4 CASE 식을 사용한 방법
SELECT prefecture,
       SUM(CASE WHEN sex = '1' THEN pop ELSE 0 END) AS pop_men,
       SUM(CASE WHEN sex = '2' THEN pop ELSE 0 END) AS pop_wom
　FROM Population
 GROUP BY prefecture;


■ "그림 3.12::직원 테이블" 생성
CREATE TABLE Employees
(emp_id    CHAR(3)  NOT NULL,
 team_id   INTEGER  NOT NULL,
 emp_name  CHAR(16) NOT NULL,
 team      CHAR(16) NOT NULL,
    PRIMARY KEY(emp_id, team_id));

INSERT INTO Employees VALUES('201', 1, 'Joe', '상품기획');
INSERT INTO Employees VALUES('201', 2, 'Joe', '개발');
INSERT INTO Employees VALUES('201', 3, 'Joe', '영업');
INSERT INTO Employees VALUES('202', 2, 'Jim', '개발');
INSERT INTO Employees VALUES('203', 3, 'Carl', '영업');
INSERT INTO Employees VALUES('204', 1, 'Bree', '상품기획');
INSERT INTO Employees VALUES('204', 2, 'Bree', '개발');
INSERT INTO Employees VALUES('204', 3, 'Bree', '영업');
INSERT INTO Employees VALUES('204', 4, 'Bree', '관리');
INSERT INTO Employees VALUES('205', 1, 'Kim', '상품기획');
INSERT INTO Employees VALUES('205', 2, 'Kim', '개발');


■ 코드 3.5 UNION으로 조건 분기한 코드
SELECT emp_name,
       MAX(team) AS team
　FROM Employees 
 GROUP BY emp_name
HAVING COUNT(*) = 1
UNION
SELECT emp_name,
       '2개를 겸무' AS team
　FROM Employees 
 GROUP BY emp_name
HAVING COUNT(*) = 2
UNION
SELECT emp_name,
       '3개 이상을 겸무' AS team
　FROM Employees 
 GROUP BY emp_name
HAVING COUNT(*) >= 3;


■ 코드 3.6 SELECT 구와 CASE 식을 사용
SELECT emp_name,
       CASE WHEN COUNT(*) = 1 THEN MAX(team)
            WHEN COUNT(*) = 2 THEN '2개를 겸무'
            WHEN COUNT(*) >= 3 THEN '3개 이상을 겸무'
        END AS team
　FROM Employees
 GROUP BY emp_name;


■ "그림 3.16::ThreeElements 테이블" 생성
CREATE TABLE ThreeElements
(key    CHAR(8),
 name   VARCHAR(32),
 date_1 DATE,
 flg_1  CHAR(1),
 date_2 DATE,
 flg_2  CHAR(1),
 date_3 DATE,
 flg_3  CHAR(1),
    PRIMARY KEY(key));

INSERT INTO ThreeElements VALUES ('1', 'a', '2013-11-01', 'T', NULL, NULL, NULL, NULL);
INSERT INTO ThreeElements VALUES ('2', 'b', NULL, NULL, '2013-11-01', 'T', NULL, NULL);
INSERT INTO ThreeElements VALUES ('3', 'c', NULL, NULL, '2013-11-01', 'F', NULL, NULL);
INSERT INTO ThreeElements VALUES ('4', 'd', NULL, NULL, '2013-12-30', 'T', NULL, NULL);
INSERT INTO ThreeElements VALUES ('5', 'e', NULL, NULL, NULL, NULL, '2013-11-01', 'T');
INSERT INTO ThreeElements VALUES ('6', 'f', NULL, NULL, NULL, NULL, '2013-12-01', 'F');

CREATE INDEX IDX_1 ON ThreeElements (date_1, flg_1) ;
CREATE INDEX IDX_2 ON ThreeElements (date_2, flg_2) ;
CREATE INDEX IDX_3 ON ThreeElements (date_3, flg_3) ;

■ 코드 3.8 UNION을 사용한 방법
SELECT key, name,
       date_1, flg_1,
       date_2, flg_2,
       date_3, flg_3
　FROM ThreeElements
 WHERE date_1 = '2013-11-01'
   AND flg_1 = 'T'
UNION
SELECT key, name,
       date_1, flg_1,
       date_2, flg_2,
       date_3, flg_3
　FROM ThreeElements
 WHERE date_2 = '2013-11-01'
   AND flg_2 = 'T'
UNION
SELECT key, name,
       date_1, flg_1,
       date_2, flg_2,
       date_3, flg_3
　FROM ThreeElements
 WHERE date_3 = '2013-11-01'
　 AND flg_3 = 'T';

■ 코드 3.9 OR를 사용한 방법
SELECT key, name,
       date_1, flg_1,
       date_2, flg_2,
       date_3, flg_3
　FROM ThreeElements
 WHERE (date_1 = '2013-11-01' AND flg_1 = 'T')
    OR (date_2 = '2013-11-01' AND flg_2 = 'T')
    OR (date_3 = '2013-11-01' AND flg_3 = 'T');


■ 코드 3.10 IN을 사용한 방법
SELECT key, name,
       date_1, flg_1,
       date_2, flg_2,
       date_3, flg_3
　FROM ThreeElements
 WHERE ('2013-11-01', 'T')
         IN ((date_1, flg_1),
             (date_2, flg_2),
             (date_3, flg_3));


■ 코드 3.11 CASE 식을 사용한 방법
SELECT key, name,
       date_1, flg_1,
       date_2, flg_2,
       date_3, flg_3
　FROM ThreeElements
 WHERE CASE WHEN date_1 = '2013-11-01' THEN flg_1
            WHEN date_2 = '2013-11-01' THEN flg_2
            WHEN date_3 = '2013-11-01' THEN flg_3
       ELSE NULL END = 'T';

■ 연습문제 3의 추가 데이터
INSERT INTO ThreeElements VALUES ('7', 'g', '2013-11-01', 'F', NULL, NULL, '2013-11-01', 'T');


