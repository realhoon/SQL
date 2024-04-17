/* 데이터 베이스 선언 */
use classicmodels

-- 기본 Select문
-- select 칼럼 from 스키마.테이블
select *
	from classicmodels.customers;

select * from customers;


-- Limit
select *
	from classicmodels.customers
	limit 100;

select customerNumber, phone 
	from classicmodels.customers c 
	limit 100;


-- DESC(테이블 걸럼 정보)
desc classicmodels.customers;


-- Alias
select customerNumber as "주문번호", phone 
	from classicmodels.customers c 
	limit 100;


-- 기본 산술 연산
select buyPrice * quantityInStock as "총 재고가격"
	from classicmodels.products p 
	limit 100;


-- Concat
select concat(productName," ","a")
	from classicmodels.products p;


-- Where절

-- 상품가격이 10 이상인 상품 자료 100개 출력(논리 연산자)
select *
	from classicmodels.products p
	where buyPrice >= 10
	limit 100;

-- 상품가격이 10 이상 100 이하인 상품 자료 100개 출력(비교 연산자)
select *
	from classicmodels.products p
	where buyPrice between 10 and 100
	limit 100;

-- 오피스코드가 1이 아닌 종업원 자료 출력
select *
	from classicmodels.employees e 
	where officeCode <> 1;

-- 소비자 도시가 멜버른, 센프란시스코인 소비자 자료 출력
select *
	from classicmodels.customers c
	where city in ('Melbourne', 'San Francisco');

-- 2005년 배송된 것 중 커멘트가 있는 주문자료 출력
select *
	from classicmodels.orders o 
	where  shippedDate between  ('2005-01-01' and  '')
			and comments is not null;		
