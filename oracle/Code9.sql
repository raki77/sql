■ 코드 9.1 OmitTbl 테이블 정의
CREATE TABLE OmitTbl
(keycol CHAR(8) NOT NULL,
 seq    INTEGER NOT NULL,
 val    INTEGER ,
  CONSTRAINT pk_OmitTbl PRIMARY KEY (keycol, seq));

INSERT INTO OmitTbl VALUES ('A', 1, 50);
INSERT INTO OmitTbl VALUES ('A', 2, NULL);
INSERT INTO OmitTbl VALUES ('A', 3, NULL);
INSERT INTO OmitTbl VALUES ('A', 4, 70);
INSERT INTO OmitTbl VALUES ('A', 5, NULL);
INSERT INTO OmitTbl VALUES ('A', 6, 900);
INSERT INTO OmitTbl VALUES ('B', 1, 10);
INSERT INTO OmitTbl VALUES ('B', 2, 20);
INSERT INTO OmitTbl VALUES ('B', 3, NULL);
INSERT INTO OmitTbl VALUES ('B', 4, 3);
INSERT INTO OmitTbl VALUES ('B', 5, NULL);
INSERT INTO OmitTbl VALUES ('B', 6, NULL);

■ 코드 9.2 OmitTbl의 UPDATE 구문
UPDATE OmitTbl
   SET val = (SELECT val
                FROM OmitTbl O1
               WHERE O1.keycol = OmitTbl.keycol    
                 AND O1.seq = (SELECT MAX(seq)
                                FROM OmitTbl O2
                               WHERE O2.keycol = OmitTbl.keycol
                                 AND O2.seq < OmitTbl.seq    
                                 AND O2.val IS NOT NULL))   
 WHERE val IS NULL;

■ 코드 9.3 채우기 역연산 SQL(UPDATE 구문) 
UPDATE OmitTbl
　 SET val = CASE WHEN val
                   = (SELECT val
                        FROM OmitTbl O1 
                       WHERE O1.keycol = OmitTbl.keycol
                         AND O1.seq
                                 = (SELECT MAX(seq)
                                      FROM OmitTbl O2
                                     WHERE O2.keycol = OmitTbl.keycol
                                       AND O2.seq < OmitTbl.seq))
             THEN NULL
             ELSE val END;


■ 코드 9.4 점수를 레코드로 갖는 테이블 정의
CREATE TABLE ScoreRows
(student_id CHAR(4)    NOT NULL,
 subject    VARCHAR(8) NOT NULL,
 score      INTEGER ,
  CONSTRAINT pk_ScoreRows PRIMARY KEY(student_id, subject));

CREATE TABLE ScoreCols
(student_id CHAR(4)    NOT NULL,
 score_en      INTEGER ,
 score_nl      INTEGER ,
 score_mt      INTEGER ,
  CONSTRAINT pk_ScoreCols PRIMARY KEY (student_id));

INSERT INTO ScoreRows VALUES ('A001', '영어', 100);
INSERT INTO ScoreRows VALUES ('A001', '국어', 58);
INSERT INTO ScoreRows VALUES ('A001', '수학', 90);
INSERT INTO ScoreRows VALUES ('B002', '영어', 77);
INSERT INTO ScoreRows VALUES ('B002', '국어', 60);
INSERT INTO ScoreRows VALUES ('C003', '영어', 52);
INSERT INTO ScoreRows VALUES ('C003', '국어', 49);
INSERT INTO ScoreRows VALUES ('C003', '사회', 100);

INSERT INTO ScoreCols VALUES ('A001', NULL, NULL, NULL);
INSERT INTO ScoreCols VALUES ('B002', NULL, NULL, NULL);
INSERT INTO ScoreCols VALUES ('C003', NULL, NULL, NULL);
INSERT INTO ScoreCols VALUES ('D004', NULL, NULL, NULL);


■ 코드 9.6 레코드 → 필드 갱신 SQL : 명확하지만 비효율적
UPDATE ScoreCols
　 SET score_en = (SELECT score
                     FROM ScoreRows SR
                    WHERE SR.student_id = ScoreCols.student_id
                      AND subject = '영어'),
       score_nl = (SELECT score
                     FROM ScoreRows SR
                    WHERE SR.student_id = ScoreCols.student_id
                      AND subject = '국어'),
       score_mt = (SELECT score
                     FROM ScoreRows SR
                    WHERE SR.student_id = ScoreCols.student_id
                      AND subject = '수학');


■ 코드 9.7 보다 효율적인 SQL : 리스트 기능 사용
UPDATE ScoreCols
　 SET (score_en, score_nl, score_mt) -- 여러 개의 필드를 리스트화 해서 한꺼번에 갱신
     = (SELECT MAX(CASE WHEN subject = '영어'
                        THEN score
                        ELSE NULL END) AS score_en,
               MAX(CASE WHEN subject = '국어'
                        THEN score
                        ELSE NULL END) AS score_nl,
               MAX(CASE WHEN subject = '수학'
                        THEN score
                        ELSE NULL END) AS score_mt
          FROM ScoreRows SR
          WHERE SR.student_id = ScoreCols.student_id);


■ 코드 9.8 ScoreColsNN 테이블 정의
CREATE TABLE ScoreColsNN
(student_id CHAR(4) NOT NULL,
 score_en INTEGER NOT NULL,
 score_nl INTEGER NOT NULL,
 score_mt INTEGER NOT NULL,
　  CONSTRAINT pk_ScoreColsNN PRIMARY KEY (student_id));

INSERT INTO ScoreColsNN VALUES ('A001', 0, 0, 0);
INSERT INTO ScoreColsNN VALUES ('B002', 0, 0, 0);
INSERT INTO ScoreColsNN VALUES ('C003', 0, 0, 0);
INSERT INTO ScoreColsNN VALUES ('D004', 0, 0, 0);

■ 코드 9.9 코드 9-6의 NOT NULL 제약 대응
UPDATE ScoreColsNN
　 SET score_en = COALESCE((SELECT score 
                              FROM ScoreRows
                             WHERE student_id = ScoreColsNN.student_id
                               AND subject = '영어'), 0),
       score_nl = COALESCE((SELECT score
                              FROM ScoreRows
                             WHERE student_id = ScoreColsNN.student_id
                               AND subject = '국어'), 0),
       score_mt = COALESCE((SELECT score
                              FROM ScoreRows
                             WHERE student_id = ScoreColsNN.student_id
                               AND subject = '수학'), 0)
 WHERE EXISTS (SELECT * 
                 FROM ScoreRows
                WHERE student_id = ScoreColsNN.student_id);

■ 코드 9.10 코드 9-7의 NOT NULL 제약 대응
UPDATE ScoreColsNN 
　 SET (score_en, score_nl, score_mt)
          = (SELECT COALESCE(MAX(CASE WHEN subject = '영어'
                                      THEN score
                                      ELSE NULL END), 0) AS score_en,
                    COALESCE(MAX(CASE WHEN subject = '국어'
                                      THEN score
                                      ELSE NULL END), 0) AS score_nl,
                    COALESCE(MAX(CASE WHEN subject = '수학'
                                      THEN score
                                      ELSE NULL END), 0) AS score_mt
               FROM ScoreRows SR
              WHERE SR.student_id = ScoreColsNN.student_id)
 WHERE EXISTS (SELECT * 
                 FROM ScoreRows
                WHERE student_id = ScoreColsNN.student_id);


■ 코드 9.11 MERGE 구문을 사용한 여러 개의 필드 갱신
MERGE INTO ScoreColsNN
　 USING (SELECT student_id,
                 COALESCE(MAX(CASE WHEN subject = '영어'
                                   THEN score
                                   ELSE NULL END), 0) AS score_en,
                 COALESCE(MAX(CASE WHEN subject = '국어'
                                   THEN score
                                   ELSE NULL END), 0) AS score_nl,
                 COALESCE(MAX(CASE WHEN subject = '수학'
                                   THEN score
                                   ELSE NULL END), 0) AS score_mt
            FROM ScoreRows
           GROUP BY student_id) SR
      ON (ScoreColsNN.student_id = SR.student_id) 
　  WHEN MATCHED THEN
         UPDATE SET ScoreColsNN.score_en = SR.score_en,
                    ScoreColsNN.score_nl = SR.score_nl,
                    ScoreColsNN.score_mt = SR.score_mt;


■ 코드 9.12 ScoreCols 테이블 정의
DELETE FROM ScoreCols;
INSERT INTO ScoreCols VALUES ('A001',100, 58, 90);
INSERT INTO ScoreCols VALUES ('B002', 77, 60, NULL);
INSERT INTO ScoreCols VALUES ('C003', 52, 49, NULL);
INSERT INTO ScoreCols VALUES ('D004', 10, 70, 100);

■ 코드 9.13 ScoreRows 테이블 정의
DELETE FROM ScoreRows;
INSERT INTO ScoreRows VALUES ('A001', '영어', NULL);
INSERT INTO ScoreRows VALUES ('A001', '국어', NULL);
INSERT INTO ScoreRows VALUES ('A001', '수학', NULL);
INSERT INTO ScoreRows VALUES ('B002', '영어', NULL);
INSERT INTO ScoreRows VALUES ('B002', '국어', NULL);
INSERT INTO ScoreRows VALUES ('C003', '영어', NULL);
INSERT INTO ScoreRows VALUES ('C003', '국어', NULL);
INSERT INTO ScoreRows VALUES ('C003', '사회', NULL);


■ 코드 9.14 필드 → 레코드 갱신 SQL
UPDATE ScoreRows
　 SET score = (SELECT CASE ScoreRows.subject
                       WHEN '영어' THEN score_en
                       WHEN '국어' THEN score_nl
                       WHEN '수학' THEN score_mt
                       ELSE NULL END
                  FROM ScoreCols
                 WHERE student_id = ScoreRows.student_id);


■ 코드 9.15 참조 대상 주가 테이블의 정의
CREATE TABLE Stocks
(brand      VARCHAR(8) NOT NULL,
 sale_date  DATE       NOT NULL,
 price      INTEGER    NOT NULL,
    CONSTRAINT pk_Stocks PRIMARY KEY (brand, sale_date));

INSERT INTO Stocks VALUES ('A철강', '2008-07-01', 1000);
INSERT INTO Stocks VALUES ('A철강', '2008-07-04', 1200);
INSERT INTO Stocks VALUES ('A철강', '2008-08-12', 800);
INSERT INTO Stocks VALUES ('B상사', '2008-06-04', 3000);
INSERT INTO Stocks VALUES ('B상사', '2008-09-11', 3000);
INSERT INTO Stocks VALUES ('C전기', '2008-07-01', 9000);
INSERT INTO Stocks VALUES ('D산업', '2008-06-04', 5000);
INSERT INTO Stocks VALUES ('D산업', '2008-06-05', 5000);
INSERT INTO Stocks VALUES ('D산업', '2008-06-06', 4800);
INSERT INTO Stocks VALUES ('D산업', '2008-12-01', 5100);


■ 코드 9.16 갱신 대상 주가 테이블의 정의
CREATE TABLE Stocks2
(brand      VARCHAR(8) NOT NULL,
 sale_date  DATE       NOT NULL,
 price      INTEGER    NOT NULL,
 trend      CHAR(3)    ,
    CONSTRAINT pk_Stocks2 PRIMARY KEY (brand, sale_date));

■ 코드 9.17 trend 필드를 연산해서 INSERT(상관 서브쿼리) 
INSERT INTO Stocks2
SELECT brand, sale_date, price,
       CASE SIGN(price -
                   (SELECT price
                      FROM Stocks S1
                     WHERE brand = Stocks.brand
                       AND sale_date =
                            (SELECT MAX(sale_date)
                               FROM Stocks S2
                              WHERE brand = Stocks.brand
                                AND sale_date < Stocks.sale_date)))
            WHEN -1 THEN '↓'
            WHEN 0 THEN '→'
            WHEN 1 THEN '↑'
            ELSE NULL
       END
　FROM Stocks;


■ 코드 9.18 trend 필드를 연산해서 INSERT(윈도우 함수)
INSERT INTO Stocks2
SELECT brand, sale_date, price,
       CASE SIGN(price -
                   MAX(price) OVER (PARTITION BY brand
                                        ORDER BY sale_date
                                    ROWS BETWEEN 1 PRECEDING
                                             AND 1 PRECEDING))
            WHEN -1 THEN '↓'
            WHEN 0 THEN '→'
            WHEN 1 THEN '↑'
            ELSE NULL
        END
　FROM Stocks S2;


■ 코드 9.19 Orders 테이블 정의
CREATE TABLE Orders
( order_id INTEGER NOT NULL,
　order_shop VARCHAR(32) NOT NULL,
　order_name VARCHAR(32) NOT NULL,
　order_date DATE,
　PRIMARY KEY (order_id));

INSERT INTO Orders VALUES (10000, '서울', '윤인성',     '2011/8/22');
INSERT INTO Orders VALUES (10001, '인천', '연하진',     '2011/9/1');
INSERT INTO Orders VALUES (10002, '인천', '패밀리마트', '2011/9/20');
INSERT INTO Orders VALUES (10003, '부천', '한빛미디어', '2011/8/5');
INSERT INTO Orders VALUES (10004, '수원', '동네슈퍼',   '2011/8/22');
INSERT INTO Orders VALUES (10005, '성남', '야근카페',   '2011/8/29');

■ 코드 9.20 OrderReceipts 테이블 정의
CREATE TABLE OrderReceipts
( order_id INTEGER NOT NULL,
　order_receipt_id INTEGER NOT NULL,
　item_group VARCHAR(32) NOT NULL,
　delivery_date DATE NOT NULL,
　PRIMARY KEY (order_id, order_receipt_id));

INSERT INTO OrderReceipts VALUES (10000, 1, '식기',         '2011/8/24');
INSERT INTO OrderReceipts VALUES (10000, 2, '과자',         '2011/8/25');
INSERT INTO OrderReceipts VALUES (10000, 3, '소고기',       '2011/8/26');
INSERT INTO OrderReceipts VALUES (10001, 1, '어패류',       '2011/9/4');
INSERT INTO OrderReceipts VALUES (10002, 1, '과자',         '2011/9/22');
INSERT INTO OrderReceipts VALUES (10002, 2, '조미료 세트',  '2011/9/22');
INSERT INTO OrderReceipts VALUES (10003, 1, '쌀',           '2011/8/6');
INSERT INTO OrderReceipts VALUES (10003, 2, '소고기',       '2011/8/10');
INSERT INTO OrderReceipts VALUES (10003, 3, '식기',         '2011/8/10');
INSERT INTO OrderReceipts VALUES (10004, 1, '야채',         '2011/8/23');
INSERT INTO OrderReceipts VALUES (10005, 1, '음료수',       '2011/8/30');
INSERT INTO OrderReceipts VALUES (10005, 2, '과자',          '2011/8/30');

■ 코드 9.21 주문일과 배송 예정일의 차이
SELECT O.order_id,
       O.order_name,
       ORC.delivery_date - O.order_date AS diff_days
　FROM Orders O
         INNER JOIN OrderReceipts ORC
            ON O.order_id = ORC.order_id
 WHERE ORC.delivery_date - O.order_date >= 3;


■ 코드 9.22 주문 단위로 집약
SELECT O.order_id,
       MAX(O.order_name),
       MAX(ORC.delivery_date - O.order_date) AS max_diff_days
　FROM Orders O
         INNER JOIN OrderReceipts ORC
            ON O.order_id = ORC.order_id
 WHERE ORC.delivery_date - O.order_date >= 3
 GROUP BY O.order_id;


■ 코드 9.23 집약 함수를 사용
SELECT O.order_id,
       MAX(O.order_name) AS order_name,
       MAX(O.order_date) AS order_date,
       COUNT(*) AS item_count
　FROM Orders O
        INNER JOIN OrderReceipts ORC
           ON O.order_id = ORC.order_id
 GROUP BY O.order_id;


■ 코드 9.24 윈도우 함수를 사용
SELECT O.order_id,
       O.order_name,
       O.order_date,
       COUNT(*) OVER (PARTITION BY O.order_id) AS item_count
　FROM Orders O
       INNER JOIN OrderReceipts ORC
          ON O.order_id = ORC.order_id;


■ 코드 9.25 score 필드에 NOT NULL 제약을 추가한 테이블 정의
CREATE TABLE ScoreRowsNN
(student_id CHAR(4)    NOT NULL,
 subject    VARCHAR(8) NOT NULL,
 score      INTEGER    NOT NULL,
  CONSTRAINT pk_ScoreRowsNN PRIMARY KEY(student_id, subject));

INSERT INTO ScoreRowsNN VALUES ('A001', '영어', 0);
INSERT INTO ScoreRowsNN VALUES ('A001', '국어', 0);
INSERT INTO ScoreRowsNN VALUES ('A001', '수학', 0);
INSERT INTO ScoreRowsNN VALUES ('B002', '영어', 0);
INSERT INTO ScoreRowsNN VALUES ('B002', '국어', 0);
INSERT INTO ScoreRowsNN VALUES ('C003', '영어', 0);
INSERT INTO ScoreRowsNN VALUES ('C003', '국어', 0);
INSERT INTO ScoreRowsNN VALUES ('C003', '사회', 0);



