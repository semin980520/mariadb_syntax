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
insert into author(name, email, password) values('홍길동4', '홍길동4@naver.com', 544421);
insert into address(country, city, street, author_id) values('japen', 'osaka', 'molra', 2);
-- 글쓰기
insert into post(title, contents) values('hello4', 'hello4 world hello', 4);
insert into author_post_list(author_id, post_id) values(1, (select id from post order by id desc limit 1));
-- 추후 참여자
-- update ...
-- insert into author_post_list... values(3, 2);
-- 글전체목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select쿼리 생성 
select p.id, p.title, p.contents, a.name from post p inner join  author_post_list ap on p.id=ap.post_id inner join author; a on a.id=ap.author_id;


-- 실습) - (실습)주문(order) ERD 설계 및 DB 구축
    - 서비스 요구사항
        - 회원가입
            - 판매자, 일반사용자 구분 필요
        - 상품 등록
            - 재고 컬럼은 필수, 판매자가 누군지 기록 필요
        - 주문하기
            - 한번에 여러상품을 여러개 주문할수 있는 일반적인 주문서비스
            - 한 주문을 조회했을때 어떤 상품들을 주문했는지 조회 가능해야함
        - 그외
            - 상품정보 조회, 주문상세조회 등
    - 주의사항
        - user테이블(사용자), order테이블(주문), product테이블(상품) 등 컬럼, 테이블 설계 추가 자유
        - 실제 웹서비스를 제공한다 가정하고 추가(insert), 조회(select) 값에 적절한 테스트 필요
        - 각 서비스 단계별로 테스트 쿼리 생성 필요

-- 1. 회원
CREATE TABLE user (id BIGINT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL, role VARCHAR(255) NOT NULL);

-- 2. 상품
CREATE TABLE product (id BIGINT AUTO_INCREMENT PRIMARY KEY, product_name VARCHAR(255) NOT NULL, stock INT NOT NULL, product_price INT NOT NULL);

-- 3. 주문
CREATE TABLE orders (id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id BIGINT NOT NULL, order_time DATETIME NOT NULL, FOREIGN KEY (user_id) REFERENCES user(id));

-- 4. 주문 상세 
CREATE TABLE order_product (id BIGINT AUTO_INCREMENT PRIMARY KEY, product_id BIGINT NOT NULL, order_id BIGINT NOT NULL, order_quantity INT NOT NULL, FOREIGN KEY (product_id) REFERENCES product(id), FOREIGN KEY (order_id) REFERENCES orders(id));


-- 5. 회원가입
insert into user(id, name, email, password, role) values(1, '홍길동', '홍길동1@naver.com', 1234, 'seller');

-- 6. 상품등록 
insert into product(id, product_name, stock, product_price) values(1, '사과', 13, 1000);


-- 7. 주문하기
insert into orders(id, user_id, order_time) values(1, 1, now());
insert into order_product(id, product_id, order_id, order_quantity) values(1, 1, 1, 1);

update product set stock = stock - 1 where id = 1;

-- 8. 상품정보조회
select * from produck;

-- 9. 주문정보조회
select * from order_product p left join orders o on p.order_id=o.id where o.id=1;