■ 코드10.1 주문 테이블 정의
CREATE TABLE Orders
(order_id  CHAR(8) NOT NULL,
 shop_id   CHAR(4) NOT NULL,
 shop_name VARCHAR(256) NOT NULL,
 receive_date DATE NOT NULL,
 process_flg CHAR(1) NOT NULL,
    CONSTRAINT pk_Orders PRIMARY KEY(order_id));

■ 코드10.2 경우1 : 압축 조건이 존재하지 않음
  SELECT order_id, receive_date
    FROM Orders;

■ 코드10.3 경우2 : 레코드를 제대로 압축하지 못하는 경우
SELECT order_id, receive_date
　FROM Orders
 WHERE process_flg = '5';


■ 코드10.4 경우2-1 : 입력 매개변수에 따라 선택률이 변동
SELECT order_id
　FROM Orders
 WHERE receive_date BETWEEN :start_date AND :end_date;

■ 코드10.5 경우2-2 : 입력 매개변수에 따라 선택률이 변동
SELECT COUNT(*)
　FROM Orders
 WHERE shop_id = :sid;


■ 코드10.6 경우3 : 압축은 되지만 인덱스를 사용할 수 없는 검색 조건
SELECT order_id
　FROM Orders
 WHERE shop_name LIKE '%대공원%';


■ 코드10.11 데이터 마트
CREATE TABLE OrderMart
(order_id     CHAR(4) NOT NULL,
 receive_date DATE NOT NULL);

■ 코드10.12 경우1 : 압축 조건이 존재하지 않는 경우에도 성능 보장
SELECT order_id, receive_date
　FROM OrderMart;

■ 코드10.14 커버링 인덱스
CREATE INDEX CoveringIndex ON Orders (order_id, receive_date);

■ 코드10.17 코드 10-15에 대한 커버링 인덱스 생성
CREATE INDEX CoveringIndex_1 ON Orders (process_flg, order_id, receive_date);

■ 코드10.18 코드 10-16에 대한 커버링 인덱스 생성
CREATE INDEX CoveringIndex_2 ON Orders (receive_shop, order_id, receive_date);

