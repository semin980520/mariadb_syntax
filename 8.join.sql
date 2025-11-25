
-- case1 : author inner join post
-- 글쓴적이 있는 글쓴이와 그 글쓴이가 쓴 글의 목록 출력
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
select a.*, p.* from author a inner join post p on a.id=p.author_id;

-- case2 : post inner join author
-- 글쓴이가 있는 글과 해당 글의 글쓴이를 조회
select * from post p inner join author a on p.author_id=a.id;
-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*, a.email from post p inner join author a on post.author_id=author.id;

-- case3 : author left join post
-- 글쓴이는 모두 조회하되, 만약 쓴글이 있다면 글도 함께 조회
select * from author a left join post p on a.id=p.author_id;
-- case4 : post left join author
-- 글을 모두 조회하되, 글쓴이가 있다면 글쓴이도 함께 조회
select * from post p left join author a on p.author_id=a.id;

-- 글쓴이가 있는 글 중에서 글의 제목과 저자의 email, 저자의 나이를 출력하되, 저자의 나이가 30세 이상인글만 출력
select p.title, a.email, a.age from post p inner join author a on p.author_id=a.id where a.age>=30;
-- 실습2)글의 저자의 이름이 빈값(null)이 아닌 글목록만을 출력
select p.* from post p inner join author a on a.id=p.autohr_id where a.name is not null;
-- 조건에 맞는 도서와 저자 리스트 출력

-- 없어진 기록 찾기 
select from out o left join ins i on o.id=i.id where i.id is null;

-- union : 두 테이블의 select 결과를 횡으로 결합
-- union시킬 때 컬럼의 개수와 컬럼의 타입이 같아야함
select name, email from author union select title, contents from post; 
-- union은 기본적으로 distinct 적용. 중복허용하려면 union all 사용.

select name, email from author union all select title, contents from post; 

-- 서브쿼리 : select문 안에 또다른 select문을 서브쿼리라함 join보다 성능이 떨어짐
-- where절 안에 서브쿼리
-- 한 번이라도 글을 쓴 author의 목록조회(중복제거)
select distinct a.* from author a inner join post p on a.id=p.author_id;
-- null값은 in조건절에서 자동으로 제외
select a.* from author a where id in(select author_id from post p);
-- 컬럼 위치에 서브쿼리
-- 회원별로 본인의 쓴 글의 개수를 출력. ex)email, post_conut
select email, (select count(*) from post p where p.author_id=a.id ) as post_count from author a;
-- join
select 
-- from절 위치에 서브쿼리
select a.* from (select * from author) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여, 하나의 행(row)처럼 취급 
select author_id from post group by author_id;
select author_id, count(*) from post group by author_id;
-- 회원별로 본인의 쓴 글의 개수를 출력 ex)email, post_conut (left join로 풀이)
select email, count(p.author_id) from author a left join post p on a.id=p.author_id group by a.id;

-- 집계함수 
select count(*) from author; 
select sum(age) from author; 
select avg(age) from author; 
-- 소수점 3번째 자리에서 반올림
select round(avg(age), 3) from author; 

-- group by와 집계함수 
-- 회원의 이름별 회원숫자를 출력하고, 이름별 나이의 평균값을 출력하라.
select name, count(*) as count, avg(age) as age from author a group by a.name;

-- where와 group by 
-- 날짜값이 null인 데이터는 제외하고, 날짜별 post 글의 개수 출력
select date_format(created_time, '%Y-%m-%d') as created_time, count(*) from post where created_time is not null group by date_format(created_time, '%Y-%m-%d');

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- 코드를 입력하세요
SELECT car_type, count(*) as cars from CAR_RENTAL_COMPANY_CAR
 where options like '%가죽시트%' or options like '%열선시트%' or options like '%통풍시트%' group by car_type order by car_type;
-- 입양 시각 구하기(1)
1. SELECT date_format(datetime, '%H') as HOUR, count(*) as COUNT -- 숫자열로  
from ANIMAL_OUTS 
where date_format(datetime, '%H')>='09' and date_format(datetime, '%H')<'20' 
group by date_format(datetime, '%H') 
order by date_format(datetime, '%H');

2. SELECT cast(date_format(datetime, '%H')as UNSIGNED) as HOUR, count(*) as COUNT -- cast해서 문자열로
from ANIMAL_OUTS 
where date_format(datetime, '%H')>=9 and date_format(datetime, '%H')<20 
group by date_format(datetime, '%H') 
order by date_format(datetime, '%H');

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건 
-- 글을 3번 이상  쓴 사람 author_ID찾기

select author_id from post group by author_id having count(*) >=3;

-- 동명 동물 수 찾기 -> having
SELECT NAME AS NAME, COUNT(NAME) AS COUNT 
FROM ANIMAL_INS 
GROUP BY NAME 
HAVING COUNT(NAME) >=2 
ORDER BY NAME;
-- 카테고리 별 도서 판매량 집계하기 -> join까지
SELECT b.CATEGORY,
       SUM(s.SALES) AS TOTAL_SALES
FROM BOOK b
INNER JOIN BOOK_SALES s ON b.BOOK_ID = s.BOOK_ID
WHERE s.SALES_DATE>='2022-01-01' AND s.SALES_DATE<='2022-01-31'
GROUP BY b.CATEGORY
ORDER BY b.CATEGORY;
-- 조건에 맞는 사용자와 총 거래금액 조회하기 -> join까지
SELECT u.USER_ID, u.NICKNAME, SUM(b.PRICE) AS TOTAL_SALES 
FROM USED_GOODS_USER u 
INNER JOIN USED_GOODS_BOARD b ON u.USER_ID=b.WRITER_ID
WHERE b.STATUS ='DONE'
GROUP BY u.USER_ID
HAVING SUM(b.PRICE) >=700000
ORDER BY TOTAL_SALES;
