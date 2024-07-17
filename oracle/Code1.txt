
■ "그림 1.8::점포 테이블" 생성
CREATE TABLE Shops (
 shop_id    CHAR(5) NOT NULL,
 shop_name  VARCHAR(64),
 rating     INTEGER,
 area       VARCHAR(64),
   CONSTRAINT pk_shops PRIMARY KEY (shop_id));

INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00001', '○○상점', 3, '서울');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00002', '△△상점', 5, '속초');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00003', '××상점', 4, '부산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00004', '□□상점', 5, '순천');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00005', 'A상점', 5, '구미');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00006', 'B상점', 4, '양양');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00007', 'C상점', 3, '군산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00008', 'D상점', 1, '진주');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00009', 'E상점', 3, '창원');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00010', 'F상점', 4, '목포');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00011', 'G상점', 2, '나주');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00012', 'H상점', 3, '인천');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00013', 'I상점', 4, '대전');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00014', 'J상점', 1, '광양');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00015', 'K상점', 5, '세종');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00016', 'L상점', 2, '일산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00017', 'M상점', 5, '대구');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00018', 'N상점', 4, '울산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00019', 'O상점', 4, '마산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00020', 'P상점', 1, '고양');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00021', 'Q상점', 1, '평택');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00022', 'R상점', 3, '오산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00023', 'S상점', 3, '과천');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00024', 'T상점', 4, '구리');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00025', 'U상점', 5, '김천');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00026', 'V상점', 4, '영천');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00027', 'W상점', 5, '상주');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00028', 'X상점', 1, '거제');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00029', 'Y상점', 5, '밀양');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00030', 'Z상점', 5, '통영');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00031', 'AA상점', 5, '여수');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00032', 'BB상점', 5, '동해');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00033', 'CC상점', 2, '원주');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00034', 'DD상점', 4, '포항');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00035', 'EE상점', 3, '시흥');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00036', 'FF상점', 3, '태백');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00037', 'GG상점', 2, '강릉');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00038', 'HH상점', 4, '삼척');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00039', 'II상점', 3, '익산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00040', 'JJ상점', 1, '남원');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00041', 'KK상점', 4, '정읍');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00042', 'LL상점', 3, '안동');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00043', 'MM상점', 5, '김제');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00044', 'NN상점', 1, '광주');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00045', 'OO상점', 3, '하남');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00046', 'PP상점', 4, '화성');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00047', 'QQ상점', 4, '여수');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00048', 'RR상점', 3, '서울');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00049', 'SS상점', 5, '속초');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00050', 'TT상점', 5, '부산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00051', 'UU상점', 5, '순천');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00052', 'VV상점', 3, '구미');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00053', 'WW상점', 2, '양양');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00054', 'XX상점', 1, '군산');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00055', 'YY상점', 5, '진주');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00056', 'ZZ상점', 2, '창원');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00057', 'AAA상점', 4, '목포');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00058', 'BBB상점', 3, '나주');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00059', 'CCC상점', 4, '인천');
INSERT INTO Shops (shop_id, shop_name, rating, area) VALUES ('00060', '☆☆상점', 1, '대전');

■ 테이블 스캔
SELECT *
　FROM Shops;

■ 인덱스 스캔
SELECT *
  FROM Shops
  WHERE shop_id = '00050';

■ "그림 1.14::예약 관리 테이블" 생성
CREATE TABLE Reservations (
 reserve_id    INTEGER  NOT NULL,
 shop_id       CHAR(5),
 reserve_name  VARCHAR(64),
   CONSTRAINT pk_reservations PRIMARY KEY (reserve_id));

INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (1, '00001', 'A씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (2, '00002', 'B씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (3, '00003', 'C씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (4, '00004', 'D씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (5, '00005', 'E씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (6, '00005', 'F씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (7, '00006', 'G씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (8, '00006', 'H씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (9, '00007', 'I씨');
INSERT INTO Reservations (reserve_id, shop_id, reserve_name) VALUES (10,'00010', 'J씨');

■ 결합
SELECT shop_name
  FROM Shops S INNER JOIN Reservations R
    ON S.shop_id = R.shop_id;

■ 통계 정보 수집(Oracle)
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>'<스키마 이름>', TABNAME =>'Shops');
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME =>'<스키마 이름>', TABNAME =>'Reservations');

■ 통계 정보 수집(PostgreSQL)
ANALYZE Shops;
ANALYZE Reservations;
