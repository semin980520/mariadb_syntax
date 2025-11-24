-- read uncommitted : 커밋되지 않은 데이터 read 가능 -> dirty dead 문제 발생
-- 실습 절차
-- 1) 워크벤치에서 auto_commit 해제. update 실행. commit하지 않음.(transaction1)
-- 2) 터미널을 열어 selectd했을 때 위 update 변경사항이 읽히는지 확인 (transaction2)
-- 결론 : mariadb는 기본이 repreatacble read 이므로 dirty read 발생 x

-- read committed : 커밋한 데이터만 read 가능 -> phantom read 발생 (또는 non-repeatable read)
-- 실습절차
-- 1) 워크벤치에서 아래 코드 실행
start transaction;
select count(*) from author;
do sleep*(15); 
select count(*) from author;
commit;
-- 2) 터미널을 열어 아래 코드 실행
insert into author(email) values('ggg@naver.com');
-- repeatable read : 일기의 일관성 보장 -> lost update 문제 발생 - 배타lock(배타적 잠금)으로 해결
-- lost update : select 과 update 하는 과정에 다른 사람이 select 와 update를 실행해서 발생하는 오류 
-- lost update가 발생한 상황
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id=1;
    do sleep(15);
    update author set post_count=count+1 where id=1;
    commit;
end //
DELIMITER ;
call concurrent_test1();
-- 터미널에서는 아래 코드 실행
select post_count from author where id=1;
-- 배타락을 통해 lost update 문제를 해결한 상황
-- select for update(배타락)를 하게 되면 트랜잭션이 실행하되는 동안 lock이 걸리고, 트랜잭션이 종료된 후에 lock이 풀림
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id=1 for update;
    do sleep(15);
    update author set post_count=count+1 where id=1;
    commit;
end //
DELIMITER ;
call concurrent_test2();
-- 터미널에서는 아래 코드 실행
select post_count from author where id=1 for update;
-- serializable