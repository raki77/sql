■ 코드 B.1::남녀별 연령 랭킹을 내림차순으로 구하는 SELECT 구문
SELECT name,
       sex,
       age,
       RANK() OVER(PARTITION BY sex ORDER BY age DESC) rnk_desc
  FROM Address;

■ 코드 B.2::상관 서브쿼리를 사용한 방법 
INSERT INTO Sales2
SELECT company,
       year,
       sale,
       CASE SIGN(sale - (SELECT sale  -- 직전 연도의 매상 선택
                           FROM Sales SL2
                         WHERE SL1.company = SL2.company
                             AND SL2.year =
                                (SELECT MAX(year)   -- 직전 연도 선택
                                     FROM Sales SL3
                                   WHERE SL1.company = SL3.company
                                       AND SL1.year  >  SL3.year )))
       WHEN 0  THEN ‘=’
       WHEN 1  THEN ‘+’
       WHEN -1 THEN ‘-’
       ELSE NULL END AS var
  FROM Sales SL1;

■ 코드 B.3::오름차순과 내림차순으로 정렬한 ROW_NUMBER 결과
SELECT student_id,
       weight, 
       ROW_NUMBER() OVER (ORDER BY weight ASC)  AS hi,
       ROW_NUMBER() OVER (ORDER BY weight DESC) AS lo
  FROM Weights;

■ 코드 B.4::NOT NULL 제약의 필드도 갱신 가능한 UPDATE 구문 : 첫 번째
UPDATE ScoreRowsNN
   SET score = (SELECT COALESCE(CASE ScoreRowsNN.subject 
                                     WHEN '영어' THEN score_en
                                     WHEN '국어' THEN score_nl
                                     WHEN '수학' THEN score_mt
                                     ELSE NULL
                                 END, 0)
                  FROM ScoreCols
                 WHERE student_id = ScoreRowsNN.student_id);

■ 코드 B.5::NOT NULL 제약의 필드도 갱신 가능한 UPDATE 구문 : 두 번째
UPDATE ScoreRowsNN
   SET score = COALESCE((SELECT CASE ScoreRowsNN.subject 
                                     WHEN '영어' THEN score_en
                                     WHEN '국어' THEN score_nl
                                     WHEN '수학' THEN score_mt
                                     ELSE NULL
                                 END
                  FROM ScoreCols
                 WHERE student_id = ScoreRowsNN.student_id), 0);

