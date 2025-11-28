-- view : 실제데이터를 참조만 하는 가상의 테이블. select만 가능 
-- 사용목적 1. 권한분리 2. 복잡한 쿼리를 사전생성

-- view 생성
create view author_view as select name, email from author;
create view author_view2 as select p.title, a.name, a.email from post p inner join author a on p.author_id=a.id;

-- views조회(테이블조회와 동일)
select * from author_view;

-- view에 대한 권한 부여
grant select on board.author_view to 'marketing'@'%';

-- view 삭제
drop view author_view;

-- 프로시저생성
delimiter //
create procedure hello_procedure()
begin
   select 'hello world';
end
// delimiter ;

-- 프로시저호출
call hello_procedure();
-- 프로시저 삭제
drop procedure hello_procedur;

-- 회원목록조회 프로시저생성 -> 한글명 프로시저 가능
delimiter //
create procedure 회원목록조회()
begin
   select * from author;
end
// delimiter ;

-- 회원상세조회 -> input(매개변수)값 사용 가능 -> 프로시저 호출시 순서에 맞게 매개변수 입력
delimiter //
create procedure 회원상세조회(in idinput BIGINT)
begin
   select * from author where id = idinput;
end
// delimiter ;

-- 전체회원수조회 -> 변수사용 
delimiter //
create procedure 전체회원수조회()
begin
   -- 변수 선언
   declare authorcount bigint;
   -- into를 통해 변수에 값 할당
   select count(*) into authorcount from author;
   -- 변수값 사용
   select authorcount;
end
// delimiter ;
-- 글쓰기

-- 사용자가 title, contents, 본인의 email값을 입력
   -- email로 회원 아이디 찾기 

   -- post테이블의 insert

   -- post테이블에 insert된 id 값 구하기

   -- author_post_list테이블에 insert하기(author_id, post_id 필요)
   

delimiter //

create procedure 글쓰기(in titleinput varchar(255), in contents varchar(255), in emailinput varchar(255))
begin
    declare author_id bigint;
    declare post_id bigint;
    -- 아래 declare는 변수선언과는 상관없는 예외고나련 특수문법
    declare exit handler for sqlexception
    begin
        rollback;
    start transaction;
        select id into author_id from author where email = emailinput;
        insert into post(title, contents) values(titleinput, contents);
        select id into post_id from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(author_id, post_id);
    commit;
end

// delimiter ;

-- 글삭제 -> if else문 

delimiter //
create procedure 글삭제(in postIdInput bigint, in authorIdInput bigint)
begin
    declare authorCount bigint;
    select count(*) into authorCount from author_post_list where post_id = postIdInput;
    if authorCount=1 then
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
    end if;
end
// delimiter ;

-- 대량 글쓰기 -> while문을 통한 반복문

delimiter //

create procedure 글도배(in count bigint, in emailinput varchar(255))
begin
    declare author_id bigint;
    declare post_id bigint;
    declare countvalue bigint default 0;
    while countvalue<count do
        select id into author_id from author where email = emailinput;
        insert into post(title) values('안녕하세요');
        select id into post_id from post order by id desc limit 1;
        insert into author_post_list(author_id, post_id) values(author_id, post_id);
        set countvalue = countvalue+1;
    end while;
end
// delimiter ;

-- innoDB는 트랜잭션 지원, 조회성능은느림 <  대부분 사용 
-- myisam은 트랜잭션 지원x, 조회성능빠름
-- 클러스터링 : 여러 서버를 묶는다
-- 레플리카 : 복제 서버
-- 샤딩 : 나눈다