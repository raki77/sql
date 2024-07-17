■ "코드 6.1::크로스 결합을 위한 사원 테이블과 부서 테이블" 생성

CREATE TABLE Employees
(emp_id CHAR(8),
 emp_name VARCHAR(32),
 dept_id CHAR(2),
     CONSTRAINT pk_emp PRIMARY KEY(emp_id));

CREATE TABLE Departments
(dept_id CHAR(2),
 dept_name VARCHAR(32),
     CONSTRAINT pk_dep PRIMARY KEY(dept_id));

CREATE INDEX idx_dept_id ON Employees(dept_id);

INSERT INTO Employees VALUES('001', '하린',   '10');
INSERT INTO Employees VALUES('002', '한미루', '11');
INSERT INTO Employees VALUES('003', '사라',   '11');
INSERT INTO Employees VALUES('004', '중민',   '12');
INSERT INTO Employees VALUES('005', '웅식',   '12');
INSERT INTO Employees VALUES('006', '주아',   '12');

INSERT INTO Departments VALUES('10', '총무');
INSERT INTO Departments VALUES('11', '인사');
INSERT INTO Departments VALUES('12', '개발');
INSERT INTO Departments VALUES('13', '영업');


■ 코드 6.2 크로스 결합
SELECT *
　FROM Employees
         CROSS JOIN
           Departments;

■ 코드 6.3 실수로 사용한 크로스 결합 : WHERE 구로 결합 조건을 지정하지 않음
SELECT *
　FROM Employees, Departments;

■ 코드 6.4 내부 결합을 실행
SELECT E.emp_id, E.emp_name, E.dept_id, D.dept_name
　FROM Employees E INNER JOIN Departments D
    ON E.dept_id = D.dept_id;

■ 코드 6.5 코드 6-4를 상관 서브쿼리로 작성
SELECT E.emp_id, E.emp_name, E.dept_id,
       (SELECT D.dept_name
          FROM Departments D
         WHERE E.dept_id = D.dept_id) AS dept_name
  FROM Employees E;

■ 코드 6.6 왼쪽 외부 결합과 오른쪽 외부 결합
-- 왼쪽 외부 결합(왼쪽 테이블이 마스터)
SELECT E.emp_id, E.emp_name, E.dept_id, D.dept_name
　FROM Departments D LEFT OUTER JOIN Employees E
    ON D.dept_id = E.dept_id;

--  오른쪽 외부 결합(오른쪽 테이블이 마스터)
SELECT E.emp_id, E.emp_name, D.dept_id, D.dept_name
　FROM Employees E RIGHT OUTER JOIN Departments D
    ON E.dept_id = D.dept_id;


■ "그림 6.5::자기 결합을 위한 숫자 테이블" 생성

CREATE TABLE Digits
(digit INTEGER PRIMARY KEY);

INSERT INTO Digits VALUES(0);
INSERT INTO Digits VALUES(1);
INSERT INTO Digits VALUES(2);
INSERT INTO Digits VALUES(3);
INSERT INTO Digits VALUES(4);
INSERT INTO Digits VALUES(5);
INSERT INTO Digits VALUES(6);
INSERT INTO Digits VALUES(7);
INSERT INTO Digits VALUES(8);
INSERT INTO Digits VALUES(9);


■ 코드 6.7 자기 결합 + 크로스 결합
SELECT D1.digit + (D2.digit * 10) AS seq
　FROM Digits D1 CROSS JOIN Digits D2;


■ "삼각 결합과 관련된 예제의 테이블" 생성

CREATE TABLE Table_A
(col_a CHAR(1));

CREATE TABLE Table_B
(col_b CHAR(1));

CREATE TABLE Table_C
(col_c CHAR(1));

■ 코드 6.9 삼각 결합의 예
SELECT A.col_a, B.col_b, C.col_c
　FROM Table_A A
         INNER JOIN Table_B B
            ON A.col_a = B.col_b
              INNER JOIN Table_C C
                 ON A.col_a = C.col_c;

■ 코드 6.10 불필요한 결합 조건을 추가
SELECT A.col_a, B.col_b, C.col_c
　FROM Table_A A
         INNER JOIN Table_B B
            ON A.col_a = B.col_b
               INNER JOIN Table_C C
                  ON A.col_a = C.col_c
                 AND C.col_c = B.col_b; 


■ 코드 6.11 EXISTS 샘플
SELECT dept_id, dept_name
　FROM Departments D
 WHERE EXISTS (SELECT *
                 FROM Employees E
                WHERE E.dept_id = D.dept_id);

■ 코드 6.12 NOT EXISTS 샘플
SELECT dept_id, dept_name
　FROM Departments D
 WHERE NOT EXISTS (SELECT *
                     FROM Employees E
                    WHERE E.dept_id = D.dept_id);


■ 코드 6.13 통계 정보 수집
--PostgreSQL
Aanlyze Departments;
Aanlyze Employees;

--Oracle
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>'TEST', TABNAME =>'Departments');
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>'TEST', TABNAME =>'Employees');
※OWNNAME은 자신의 환경에 맞게 변경해주세요!

