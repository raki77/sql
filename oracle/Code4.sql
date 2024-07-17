
■ "그림 4.1::비집약 테이블" 생성
CREATE TABLE NonAggTbl
(id VARCHAR(32) NOT NULL,
 data_type CHAR(1) NOT NULL,
 data_1 INTEGER,
 data_2 INTEGER,
 data_3 INTEGER,
 data_4 INTEGER,
 data_5 INTEGER,
 data_6 INTEGER);

DELETE FROM NonAggTbl;
INSERT INTO NonAggTbl VALUES('Jim',    'A',  100,  10,     34,  346,   54,  NULL);
INSERT INTO NonAggTbl VALUES('Jim',    'B',  45,    2,    167,   77,   90,   157);
INSERT INTO NonAggTbl VALUES('Jim',    'C',  NULL,  3,    687, 1355,  324,   457);
INSERT INTO NonAggTbl VALUES('Ken',    'A',  78,    5,    724,  457, NULL,     1);
INSERT INTO NonAggTbl VALUES('Ken',    'B',  123,  12,    178,  346,   85,   235);
INSERT INTO NonAggTbl VALUES('Ken',    'C',  45, NULL,     23,   46,  687,    33);
INSERT INTO NonAggTbl VALUES('Beth',   'A',  75,    0,    190,   25,  356,  NULL);
INSERT INTO NonAggTbl VALUES('Beth',   'B',  435,   0,    183, NULL,    4,   325);
INSERT INTO NonAggTbl VALUES('Beth',   'C',  96,  128,   NULL,    0,    0,    12);


■ 코드 4.1 데이터 타입 'A'의 레코드에 대한 쿼리
SELECT id, data_1, data_2
　FROM NonAggTbl
 WHERE id = 'Jim'
  AND data_type = 'A';

■ 코드 4.2 데이터 타입 'B'의 레코드에 대한 쿼리
SELECT id, data_3, data_4, data_5
　FROM NonAggTbl
 WHERE id = 'Jim'
　 AND data_type = 'B';

■ 코드 4.3 데이터 타입 'C'의 레코드에 대한 쿼리
SELECT id, data_6
　FROM NonAggTbl
 WHERE id = 'Jim'
　 AND data_type = 'C';


■ 코드 4.4 안타깝게도 오류가 발생하는 쿼리
SELECT id,
       CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END AS data_1,
       CASE WHEN data_type = 'A' THEN data_2 ELSE NULL END AS data_2,
       CASE WHEN data_type = 'B' THEN data_3 ELSE NULL END AS data_3,
       CASE WHEN data_type = 'B' THEN data_4 ELSE NULL END AS data_4,
       CASE WHEN data_type = 'B' THEN data_5 ELSE NULL END AS data_5,
       CASE WHEN data_type = 'C' THEN data_6 ELSE NULL END AS data_6
　FROM NonAggTbl
 GROUP BY id;

■ 코드 4.5 모든 구현에서 작동하는 정답
SELECT id,
       MAX(CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END) AS data_1,
       MAX(CASE WHEN data_type = 'A' THEN data_2 ELSE NULL END) AS data_2,
       MAX(CASE WHEN data_type = 'B' THEN data_3 ELSE NULL END) AS data_3,
       MAX(CASE WHEN data_type = 'B' THEN data_4 ELSE NULL END) AS data_4,
       MAX(CASE WHEN data_type = 'B' THEN data_5 ELSE NULL END) AS data_5,
       MAX(CASE WHEN data_type = 'C' THEN data_6 ELSE NULL END) AS data_6
　FROM NonAggTbl
 GROUP BY id;


■ "그림 4.5::年齢別価格テーブルのサンプル" 생성

CREATE TABLE PriceByAge
(product_id VARCHAR(32) NOT NULL,
 low_age    INTEGER NOT NULL,
 high_age   INTEGER NOT NULL,
 price      INTEGER NOT NULL,
 PRIMARY KEY (product_id, low_age),
   CHECK (low_age < high_age));

INSERT INTO PriceByAge VALUES('제품1',  0  ,  50  ,  2000);
INSERT INTO PriceByAge VALUES('제품1',  51 ,  100 ,  3000);
INSERT INTO PriceByAge VALUES('제품2',  0  ,  100 ,  4200);
INSERT INTO PriceByAge VALUES('제품3',  0  ,  20  ,  500);
INSERT INTO PriceByAge VALUES('제품3',  31 ,  70  ,  800);
INSERT INTO PriceByAge VALUES('제품3',  71 ,  100 ,  1000);
INSERT INTO PriceByAge VALUES('제품4',  0  ,  99  ,  8900);

■ 코드 4.6 여러 개의 레코드로 한 개의 범위를 커버
SELECT product_id
　FROM PriceByAge
 GROUP BY product_id
HAVING SUM(high_age - low_age + 1) = 101;


■ "그림 4.7::호텔 테이블" 생성
CREATE TABLE HotelRooms
(room_nbr INTEGER,
 start_date DATE,
 end_date   DATE,
     PRIMARY KEY(room_nbr, start_date));

INSERT INTO HotelRooms VALUES(101, '2008-02-01', '2008-02-06');
INSERT INTO HotelRooms VALUES(101, '2008-02-06', '2008-02-08');
INSERT INTO HotelRooms VALUES(101, '2008-02-10', '2008-02-13');
INSERT INTO HotelRooms VALUES(202, '2008-02-05', '2008-02-08');
INSERT INTO HotelRooms VALUES(202, '2008-02-08', '2008-02-11');
INSERT INTO HotelRooms VALUES(202, '2008-02-11', '2008-02-12');
INSERT INTO HotelRooms VALUES(303, '2008-02-03', '2008-02-17');


■ 코드 4.7 여러 개의 레코드에서 운영된 날을 연산
SELECT room_nbr,
       SUM(end_date - start_date) AS working_days
　FROM HotelRooms
 GROUP BY room_nbr
HAVING SUM(end_date - start_date) >= 10;


■ "그림 4.8::인물 테이블" 생성
CREATE TABLE Persons
(name   VARCHAR(8) NOT NULL,
 age    INTEGER NOT NULL,
 height FLOAT NOT NULL,
 weight FLOAT NOT NULL,
 PRIMARY KEY (name));


INSERT INTO Persons VALUES('Anderson',  30,  188,  90);
INSERT INTO Persons VALUES('Adela',    21,  167,  55);
INSERT INTO Persons VALUES('Bates',    87,  158,  48);
INSERT INTO Persons VALUES('Becky',    54,  187,  70);
INSERT INTO Persons VALUES('Bill',    39,  177,  120);
INSERT INTO Persons VALUES('Chris',    90,  175,  48);
INSERT INTO Persons VALUES('Darwin',  12,  160,  55);
INSERT INTO Persons VALUES('Dawson',  25,  182,  90);
INSERT INTO Persons VALUES('Donald',  30,  176,  53);


■ 코드 4.8 첫 문자 알파벳마다 몇 명의 사람이 존재하는지 계산
SELECT SUBSTRING(name, 1, 1) AS label,
         COUNT(*)
　FROM Persons
 GROUP BY SUBSTRING(name, 1, 1);

■ 코드 4.9 나이로 자르기
SELECT CASE WHEN age < 20 THEN '어린이'
            WHEN age BETWEEN 20 AND 69 THEN '성인'
            WHEN age >= 70 THEN '노인'
       ELSE NULL END AS age_class,
       COUNT(*)
　FROM Persons
 GROUP BY CASE WHEN age < 20 THEN '어린이'
               WHEN age BETWEEN 20 AND 69 THEN '성인'
               WHEN age >= 70 THEN '노인'
          ELSE NULL END;


■ 코드 4.10 BMI로 자르기
SELECT CASE WHEN weight / POWER(height /100, 2) < 18.5 THEN '저체중'
            WHEN 18.5 <= weight / POWER(height /100, 2)
                   AND weight / POWER(height /100, 2) < 25 THEN '정상'
            WHEN 25 <= weight / POWER(height /100, 2) THEN '과체중'
            ELSE NULL END AS bmi,
            COUNT(*)
　FROM Persons
 GROUP BY CASE WHEN weight / POWER(height /100, 2) < 18.5 THEN '저체중'
               WHEN 18.5 <= weight / POWER(height /100, 2)
                   AND weight / POWER(height /100, 2) < 25 THEN '정상'
               WHEN 25 <= weight / POWER(height /100, 2) THEN '과체중'
               ELSE NULL END;

■ 코드 4.11 PARTITION BY에 식을 지정
SELECT name,
       age,
       CASE WHEN age < 20 THEN '어린이'
            WHEN age BETWEEN 20 AND 69 THEN '성인'
            WHEN age >= 70 THEN '노인'
       ELSE NULL END AS age_class,
       RANK() OVER(PARTITION BY CASE WHEN age < 20 THEN '어린이'
                                     WHEN age BETWEEN 20 AND 69 THEN '성인'
                                     WHEN age >= 70 THEN '노인'
                                ELSE NULL END
                       ORDER BY age) AS age_rank_in_class
　FROM Persons
 ORDER BY age_class, age_rank_in_class;



