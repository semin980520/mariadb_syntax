-- 회원 테이블 생성 : 컬럼 id(pk), email(unique,not null), name(not null), pwassword(not null)
create table author(id bigint auto_increment primary key, name varchar(255) not null, email varchar(255) not null unique, password varchar(255) not null);

-- 주소 테이블
-- id, country, city, strret, author_id(fk) 
create table address(id bigint auto_increment primary key, country varchar(255) not null,  city varchar(255) not null,  street varchar(255) not null, author_id bigint not null unique, foreign key(author_id) references author(id));
-- post테이블
-- id, title(not null), contents
create table post(id bigint auto_increment primary key, title varchar(255) not null, contents varchar(3000));

-- 연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key, author_id bigint not null, post_id bigint not null, foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 복합기를 이용한 연결(junction) 테이블 
create table author_post_list(author_id bigint not null, post_id bigint not null, foreign key(author_id) references author(id), primary key(author_id, post_id), foreign key(post_id) references post(id));

-- 회원가입 및 주소생성
insert into author(id, name, email, password) values(4, '홍길동4', '홍길동4@naver.com', 544421);
insert into address(id, country, city, street, author_id) values(2, 'japen', 'osaka', 'molra', 2);
-- 글쓰기
insert into post(id, title, contents) values(4, 'hello4', 'hello4 world hello', 4);
insert into author_post_list(author_id, post_id) values(3, 2)
-- 글전체목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select쿼리 생성 
select * from post inner join author_post_list inner join author;