-- tinyint : 1바이트 사용 -128~127까지의 정수표현 가능 (unsigned 0~255)
-- author테이블에 age컬럼 추가
alter table author add column age tinyint unsigned;
insert into author(id, name, email, age) values(6, '홍길동', 'aa@naver.com', 200);
-- int : 4바이트 사용 대락 40억 숫자범위 표현 가능


-- bigint : 8바이트 사용 거의 무한대 표현 가능
-- author, post테이블의 id값을 nigint로 변경
alter table author modify column id bigint;
alter table post modify column author_id bigint;
alter table post modify column id bigint;

-- decimal(총자리수, 소수부자리수)
alter table author add column height decimal(4,1);
-- 정삭적으로 insert
insert into author(id, name, email, height) values(7, '홍길동3', 'sss@naver.com', 178.3);
--데이터가 잘리도록 insert
insert into author(id, name, email, height) values(8, '홍길동3', 'sss2@naver.com', 178.45);


-- 문자타입 : 고정길이(cahr), 가번길이(varchar, text)
-- char : 고정길이 
-- varchar : 가변길이, 최대길이지정, 메모리저장, 빈번히 조회되는 짧은 길이의 데이터
-- text : 가변길이, 최대길이지정불가, storage저장, 빈번히 조회되지 않는 장문의 데이터

name, email -> text or varchar
빈번히 조회가되는 사랑 -> 성능좋은 varchar
길이가 딱 정해진 짧은 단어 : char or varchar
장문의 데이터 : text or varchar
그외는 전부 varchar0

alter table author add column id_number char(16);
alter table author add column self_introduction text;

-- blob(바이너리데이터) 실습
-- 일반적으로 blob으로 저장하기 보다는, 이미지를 별도로 저장하고, 이미지경로를 varchar로 저장.
alter table author add column profile_image longblob;
insert into author(id, name, email, profile_image) values(9, 'abc', 'abc2@naver.com', LOAD_FILE('C:\\cat.jpg'));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
alter table author add column role enum('admin', 'user') not null default 'user';

-- enum에서 지정된 role을 insert
insert into author(id, name, email, role) values(11, 'add', 'ddd@naver.com', 'admin');
-- enum에서 지정되지 않은 값을 insert -> error 발생
insert into author(id, name, email, role) values(12, 'add2', 'ddd2@naver.com', 'super-admin');
-- role을 지정하지 않고 insert
    insert into author(id, name, email,) values(13, 'add2', 'ddd2@naver.com');

-- date(연월일)와 datetime(연월일시분초)
-- 날짜타입의 입력, 수정, 조회시에는 문자열 형식을 사용한다
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, contents, author_id, created_time) values(4, 'hello4', 'hello4 world', 1, '2019-01-01 14:00:30');
-- datetime과 default 현재 시간 입력은 많이 사용되는 패턴
alter table post modify column created_time datetime default current_timestamp();
insert into post(id, title, contents, author_id) values(5, 'hello5', 'hello5 world', 1);

-- 비교연산자
select * from author where 1d>=2 and id<=4;
select * from author where id in (2,3,4);
select * from author where 1d between 2 and 4;

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';
select * from post where title like '%h';
select * from post where title like '%h%';  

-- regexp : 정규표현식을 활용한 조회
select * from author where name regexp '[a-z]' -- 이름에 소문자 알파벳이 포함된 경우를 찾는식
select * from author where name regexp '[가-힣]' -- 이름에 한글이 포함된 경우를 찾는식

-- 타입변환 - cast
-- 문자 -> 숫자
select cast('12', as in unsigned);    -- int 대신 unsigned 를 쓰는게 관례
-- 숫자 -> 날짜
select cast(20251121 as date); -- 2025-11-21
-- 문자 -> 날짜
select cast('20251121' as date); -- 2025-11-21

-- 날짜타입변환에 주로 사용되는게 - date_formeat (Y, m, d, H, i, s)
select created_time from post;
select date_format(created_time, '%Y-%m-%d') from post; 
select date_format(created_time, '%Y-%m-%d') from post; 
select * from post where date_format(created_time, '%m')='01';
select * from post where cast (date_format(created_time, '%m') as unsigned) = 1;

-- 실습 : 2025-11 등록된 게시글 조회
select * from post where date_format(created_time, '%m')='01';
select * from post where created_time like '2025-11%';

-- 실습 : 2025년 11월1일부터 11월19일까지의 데이터를 조회  년월일 뒤에 00:00:00 이 자동으로 붙음 
select * from post where created_time >= '2025-11-01' and created_time < '2025-11-20';


 