select *
	from classicmodels.customers;

/* 데이터 베이스 선언 */
use classicmodels;

select * from customers;

select *
	from classicmodels.customers
	limit 100;

select customerNumber, phone 
	from classicmodels.customers c 
	limit 100;

desc classicmodels.customers;

select customerNumber as "주문번호", phone 
	from classicmodels.customers c 
	limit 100;

select buyPrice * quantityInStock as "총 재고가격"
	from classicmodels.products p 
	limit 100;

select concat(productName," ","a")
	from classicmodels.products p;

select *
	from classicmodels.products p
	where buyPrice >= 10
	limit 100;

select *
	from classicmodels.products p
	where buyPrice between 10 and 100
	limit 100;

select *
	from classicmodels.employees e 
	where officeCode <> 1;

select *
	from classicmodels.products p
	where buyPrice between 10 and 100
	limit 100;

select *
	from classicmodels.customers c
	where city in ('Melbourne', 'San Francisco');


select *
	from classicmodels.orders o 
	where  shippedDate between  ('2005-01-01' and  '')
			and comments is not null;		
