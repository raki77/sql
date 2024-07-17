■ 코드 8.1 체중 테이블의 정의
CREATE TABLE Weights
(student_id CHAR(4) PRIMARY KEY,
 weight     INTEGER);

INSERT INTO Weights VALUES('A100', 50);
INSERT INTO Weights VALUES('A101', 55);
INSERT INTO Weights VALUES('A124', 55);
INSERT INTO Weights VALUES('B343', 60);
INSERT INTO Weights VALUES('B346', 72);
INSERT INTO Weights VALUES('C563', 72);
INSERT INTO Weights VALUES('C345', 72);


■ 코드 8.2 기본 키가 한 개의 필드일 경우(ROW_NUMBER) 
SELECT student_id,
       ROW_NUMBER() OVER (ORDER BY student_id) AS seq
  FROM Weights;

■ 코드 8.3 기본 키가 한 개의 필드일 경우(상관 서브쿼리) 
SELECT student_id,
       (SELECT COUNT(*)
          FROM Weights W2
         WHERE W2.student_id <= W1.student_id) AS seq
　FROM Weights W1


■ 코드 8.4 체중 테이블2 정의
CREATE TABLE Weights2
(class      INTEGER NOT NULL,
 student_id CHAR(4) NOT NULL,
 weight INTEGER     NOT NULL,
 PRIMARY KEY(class, student_id));

INSERT INTO Weights2 VALUES(1, '100', 50);
INSERT INTO Weights2 VALUES(1, '101', 55);
INSERT INTO Weights2 VALUES(1, '102', 56);
INSERT INTO Weights2 VALUES(2, '100', 60);
INSERT INTO Weights2 VALUES(2, '101', 72);
INSERT INTO Weights2 VALUES(2, '102', 73);
INSERT INTO Weights2 VALUES(2, '103', 73);


■ 코드 8.5 기본 키가 여러 개의 필드로 구성되는 경우(ROW_NUMBER) 
SELECT class, student_id,
       ROW_NUMBER() OVER (ORDER BY class, student_id) AS seq
　FROM Weights2;

■ 코드 8.6 기본 키가 여러 개의 필드로 구성되는 경우(상관 서브쿼리 : 다중 필드 비교) 
SELECT class, student_id,
       (SELECT COUNT(*)
          FROM Weights2 W2
         WHERE (W2.class, W2.student_id)
                 <= (W1.class, W1.student_id) ) AS seq
　FROM Weights2 W1;

■ 코드 8.7 학급마다 순번 붙이기(ROW_NUMBER) 
SELECT class, student_id,
       ROW_NUMBER() OVER (PARTITION BY class ORDER BY student_id) AS seq
　FROM Weights2;


■ 코드 8.8 학급마다 순번 붙이기(상관 서브쿼리) 
SELECT class, student_id,
       (SELECT COUNT(*)
          FROM Weights2 W2
         WHERE W2.class = W1.class
           AND W2.student_id <= W1.student_id) AS seq
　FROM Weights2 W1;


■ 코드 8.9 체중 테이블3 정의

CREATE TABLE Weights3
(class      INTEGER NOT NULL,
 student_id CHAR(4) NOT NULL,
 weight INTEGER     NOT NULL,
 seq    INTEGER     NULL,
     PRIMARY KEY(class, student_id));

INSERT INTO Weights3 VALUES(1, '100', 50, NULL);
INSERT INTO Weights3 VALUES(1, '101', 55, NULL);
INSERT INTO Weights3 VALUES(1, '102', 56, NULL);
INSERT INTO Weights3 VALUES(2, '100', 60, NULL);
INSERT INTO Weights3 VALUES(2, '101', 72, NULL);
INSERT INTO Weights3 VALUES(2, '102', 73, NULL);
INSERT INTO Weights3 VALUES(2, '103', 73, NULL);

■ 코드 8.10 순번 갱신(ROW_NUMBER) 
UPDATE Weights3
   SET seq = (SELECT seq
                FROM (SELECT class, student_id,
                             ROW_NUMBER()
                               OVER (PARTITION BY class
                                         ORDER BY student_id) AS seq
                        FROM Weights3) SeqTbl
             -- SeqTbl라는 서브쿼리를 만들어야 함
               WHERE Weights3.class = SeqTbl.class
                 AND Weights3.student_id = SeqTbl.student_id);

■ 코드 8.11 순번 갱신(상관 서브쿼리)
UPDATE Weights3
　 SET seq = (SELECT COUNT(*)
                FROM Weights3 W2
               WHERE W2.class = Weights3.class
                 AND W2.student_id <= Weights3.student_id);


■ 코드 8.12 중앙값 구하기(집합 지향적 방법) : 모집합을 상위와 하위로 분할
SELECT AVG(weight)
　FROM (SELECT W1.weight
          FROM Weights W1, Weights W2
         GROUP BY W1.weight
            -- S1(하위 집합)의 조건
        HAVING SUM(CASE WHEN W2.weight >= W1.weight THEN 1 ELSE 0 END)
                  >= COUNT(*) / 2
            -- S2(상위 집합)의 조건
           AND SUM(CASE WHEN W2.weight <= W1.weight THEN 1 ELSE 0 END)
                  >= COUNT(*) / 2 ) TMP;


■ 코드 8.13 중앙값 구하기(절차 지향형) : 양쪽 끝에서 레코드 하나씩 세어 중간을 찾음
SELECT AVG(weight) AS median
　FROM (SELECT weight,
               ROW_NUMBER() OVER (ORDER BY weight ASC, student_id ASC) AS hi,
               ROW_NUMBER() OVER (ORDER BY weight DESC, student_id DESC) AS lo
          FROM Weights) TMP
 WHERE hi IN (lo, lo +1 , lo -1);

■ 코드 8.14 중앙값 구하기(절차 지향형 방법) : 반환점 발견
SELECT AVG(weight)
　FROM (SELECT weight,
               2 * ROW_NUMBER() OVER(ORDER BY weight)
                   - COUNT(*) OVER() AS diff
          FROM Weights) TMP
 WHERE diff BETWEEN 0 AND 2;


■ 코드 8.15 순번 테이블 정의
CREATE TABLE Numbers( num INTEGER PRIMARY KEY);

INSERT INTO Numbers VALUES(1);
INSERT INTO Numbers VALUES(3); 
INSERT INTO Numbers VALUES(4); 
INSERT INTO Numbers VALUES(7); 
INSERT INTO Numbers VALUES(8); 
INSERT INTO Numbers VALUES(9); 
INSERT INTO Numbers VALUES(12);

■ 코드 8.16 비어있는 숫자 모음을 표시
SELECT (N1.num + 1) AS gap_start,
       '～',
       (MIN(N2.num) - 1) AS gap_end
　FROM Numbers N1 INNER JOIN Numbers N2
    ON N2.num > N1.num
 GROUP BY N1.num
HAVING (N1.num + 1) < MIN(N2.num);

■ 코드 8.17 다음 레코드와 비교
SELECT num + 1 AS gap_start,
       '～',
       (num + diff - 1) AS gap_end
　FROM (SELECT num,
               MAX(num)
                 OVER(ORDER BY num
                       ROWS BETWEEN 1 FOLLOWING
                                AND 1 FOLLOWING) - num
          FROM Numbers) TMP(num, diff)
 WHERE diff <> 1;

■ 코드 8.18 서브쿼리 부분
SELECT num,
       MAX(num)
         OVER(ORDER BY num
               ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS next_num
　FROM Numbers;


■ 코드 8.19 시퀀스 구하기(집합 지향적) 
SELECT MIN(num) AS low,
       '～',
       MAX(num) AS high
　FROM (SELECT N1.num,
               COUNT(N2.num) - N1.num
          FROM Numbers N1 INNER JOIN Numbers N2
            ON N2.num <= N1.num
         GROUP BY N1.num) N(num, gp)
 GROUP BY gp;


■ 코드 8.20 시퀀스 구하기(절자지향형) 
SELECT low, high
　FROM (SELECT low,
               CASE WHEN high IS NULL
                    THEN MIN(high)
                           OVER (ORDER BY seq
                                  ROWS BETWEEN CURRENT ROW
                                           AND UNBOUNDED FOLLOWING)
                    ELSE high END AS high
          FROM (SELECT CASE WHEN COALESCE(prev_diff, 0) <> 1
                            THEN num ELSE NULL END AS low,
                       CASE WHEN COALESCE(next_diff, 0) <> 1
                            THEN num ELSE NULL END AS high,
                       seq
                  FROM (SELECT num,
                               MAX(num)
                                 OVER(ORDER BY num
                                       ROWS BETWEEN 1 FOLLOWING
                                                AND 1 FOLLOWING) - num AS next_diff,
                               num - MAX(num)
                                       OVER(ORDER BY num
                                             ROWS BETWEEN 1 PRECEDING
                                                      AND 1 PRECEDING) AS prev_diff,
                               ROW_NUMBER() OVER (ORDER BY num) AS seq
                          FROM Numbers) TMP1 ) TMP2) TMP3
 WHERE low IS NOT NULL;

■ 코드 8.21 시퀀스 객체 정의 예
CREATE SEQUENCE testseq
START WITH 1
INCREMENT BY 1
MAXVALUE 100000
MINVALUE 1
CYCLE;


■ 코드 8.23 student_id를 제외하면 동작하지 않음
SELECT AVG(weight) AS median
　FROM (SELECT weight,
               ROW_NUMBER() OVER (ORDER BY weight ASC) AS hi,
               ROW_NUMBER() OVER (ORDER BY weight DESC) AS lo
          FROM Weights) TMP
 WHERE hi IN (lo, lo +1 , lo -1);

■ 코드 8.24 샘플 테이블
DELETE FROM Weights;
INSERT INTO Weights VALUES('B346', 80);
INSERT INTO Weights VALUES('C563', 70);
INSERT INTO Weights VALUES('A100', 70);
INSERT INTO Weights VALUES('A124', 60);
INSERT INTO Weights VALUES('B343', 60);
INSERT INTO Weights VALUES('C345', 60);
