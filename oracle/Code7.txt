■ "코드7.1::구입 명세 테이블 정의" 생성
CREATE TABLE Receipts
(cust_id   CHAR(1) NOT NULL, 
 seq   INTEGER NOT NULL, 
 price   INTEGER NOT NULL, 
     PRIMARY KEY (cust_id, seq));

INSERT INTO Receipts VALUES ('A',   1   ,500    );
INSERT INTO Receipts VALUES ('A',   2   ,1000   );
INSERT INTO Receipts VALUES ('A',   3   ,700    );
INSERT INTO Receipts VALUES ('B',   5   ,100    );
INSERT INTO Receipts VALUES ('B',   6   ,5000   );
INSERT INTO Receipts VALUES ('B',   7   ,300    );
INSERT INTO Receipts VALUES ('B',   9   ,200    );
INSERT INTO Receipts VALUES ('B',   12  ,1000   );
INSERT INTO Receipts VALUES ('C',   10  ,600    );
INSERT INTO Receipts VALUES ('C',   20  ,100    );
INSERT INTO Receipts VALUES ('C',   45  ,200    );
INSERT INTO Receipts VALUES ('C',   70  ,50     );
INSERT INTO Receipts VALUES ('D',   3   ,2000   );


■ 코드7.2 서브쿼리를 사용한 방법
SELECT R1.cust_id, R1.seq, R1.price
　FROM Receipts R1
         INNER JOIN
           (SELECT cust_id, MIN(seq) AS min_seq
              FROM Receipts
             GROUP BY cust_id) R2
    ON R1.cust_id = R2.cust_id
　 AND R1.seq = R2.min_seq;


■ 코드7.3 상관 서브쿼리를 사용한 방법
SELECT cust_id, seq, price
　FROM Receipts R1
 WHERE seq = (SELECT MIN(seq)
                FROM Receipts R2
               WHERE R1.cust_id = R2.cust_id);


■ 코드7.4 윈도우 함수를 사용한 방법
SELECT cust_id, seq, price
　FROM (SELECT cust_id, seq, price,
               ROW_NUMBER()
                 OVER (PARTITION BY cust_id
                           ORDER BY seq) AS row_seq
          FROM Receipts ) WORK
 WHERE WORK.row_seq = 1;

■ 코드7.5 서브쿼리 의존증 환자 2호
SELECT TMP_MIN.cust_id,
       TMP_MIN.price - TMP_MAX.price AS diff
　FROM (SELECT R1.cust_id, R1.seq, R1.price
          FROM Receipts R1
                 INNER JOIN
                  (SELECT cust_id, MIN(seq) AS min_seq
                     FROM Receipts
                    GROUP BY cust_id) R2
            ON R1.cust_id = R2.cust_id
           AND R1.seq = R2.min_seq) TMP_MIN
       INNER JOIN
       (SELECT R3.cust_id, R3.seq, R3.price
          FROM Receipts R3
                 INNER JOIN
                  (SELECT cust_id, MAX(seq) AS min_seq
                     FROM Receipts
                    GROUP BY cust_id) R4
            ON R3.cust_id = R4.cust_id
           AND R3.seq = R4.min_seq) TMP_MAX
    ON TMP_MIN.cust_id = TMP_MAX.cust_id;


■ 코드7.6 윈도우 함수와 CASE 식
SELECT cust_id,
       SUM(CASE WHEN min_seq = 1 THEN price ELSE 0 END)
         - SUM(CASE WHEN max_seq = 1 THEN price ELSE 0 END) AS diff
　FROM (SELECT cust_id, price,
               ROW_NUMBER() OVER (PARTITION BY cust_id
                                      ORDER BY seq) AS min_seq,
               ROW_NUMBER() OVER (PARTITION BY cust_id
                                      ORDER BY seq DESC) AS max_seq
          FROM Receipts ) WORK
 WHERE WORK.min_seq = 1
    OR WORK.max_seq = 1
 GROUP BY cust_id;


■ 코드7.7 회사 테이블 정의
CREATE TABLE Companies
(co_cd      CHAR(3) NOT NULL, 
 district   CHAR(1) NOT NULL, 
     CONSTRAINT pk_Companies PRIMARY KEY (co_cd));

INSERT INTO Companies VALUES('001', 'A'); 
INSERT INTO Companies VALUES('002', 'B'); 
INSERT INTO Companies VALUES('003', 'C'); 
INSERT INTO Companies VALUES('004', 'D'); 

■ 코드7.8 사업소 테이블 정의
CREATE TABLE Shops
(co_cd      CHAR(3) NOT NULL, 
 shop_id    CHAR(3) NOT NULL, 
 emp_nbr    INTEGER NOT NULL, 
 main_flg   CHAR(1) NOT NULL, 
     PRIMARY KEY (co_cd, shop_id));

INSERT INTO Shops VALUES('001', '1',   300,  'Y');
INSERT INTO Shops VALUES('001', '2',   400,  'N');
INSERT INTO Shops VALUES('001', '3',   250,  'Y');
INSERT INTO Shops VALUES('002', '1',   100,  'Y');
INSERT INTO Shops VALUES('002', '2',    20,  'N');
INSERT INTO Shops VALUES('003', '1',   400,  'Y');
INSERT INTO Shops VALUES('003', '2',   500,  'Y');
INSERT INTO Shops VALUES('003', '3',   300,  'N');
INSERT INTO Shops VALUES('003', '4',   200,  'Y');
INSERT INTO Shops VALUES('004', '1',   999,  'Y');

■ 코드7.9 첫 번째 방법 : 결합을 먼저 수행
SELECT C.co_cd, C.district,
       SUM(emp_nbr) AS sum_emp
　FROM Companies C
         INNER JOIN
           Shops S
    ON C.co_cd = S.co_cd
 WHERE main_flg = 'Y'
 GROUP BY C.co_cd;


■ 코드7.10 두 번째 방법 : 집약을 먼저 수행
SELECT C.co_cd, C.district, sum_emp
　FROM Companies C
         INNER JOIN
          (SELECT co_cd,
                  SUM(emp_nbr) AS sum_emp
             FROM Shops
            WHERE main_flg = 'Y'
            GROUP BY co_cd) CSUM
    ON C.co_cd = CSUM.co_cd;
