-- 흐름제어 : if, ifnull, case when
-- if(a,b,c) : a조건이 참이면 b 반환, 그렇지 않은면 c를 반환
select id, if(name is null, '익명사용자', name ) as name from author; 

-- ifnull(a,b) : a가 null이면 b를 반환, null이 아니면 a를 그대로 반환
select id, ifnull(name, '익명사용자',) as name from author; 

-- case when end
select id, 
case
when name is null then '익명사용자'
when name='hong1' then '홍길동1'
when name='hong2' then '홍길동2' 
else name
end as name
from author;

1.SELECT WAREHOUSE_ID,	WAREHOUSE_NAME,	ADDRESS,
case
when freezer_yn is null then 'N'
else freezer_yn
end as freenzr_yn
from food_warehouse where address like '경기%';


3.SELECT PT_NAME, PT_NO,	GEND_CD,	AGE,
case
when tlno is null then 'NONE'
else tlno 
end as tlno
from patient where age <= 12 and gend_cd='W'
order by age desc, PT_NAME;     
-- asc를 안써도 괜찮지면 column명은 써야함 order by 는 항상 문장 제일 뒤에