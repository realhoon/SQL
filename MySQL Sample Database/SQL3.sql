select customerName, orderDate, productName
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
		where o.orderDate >= '2003-01-01' and o.orderDate < '2004-01-01'
		limit 100;
		

	
-- Date 다루기
	
select date('2023-04-14 09:45:00');
select time('2023-04-14 09:45:00');

select now();
select CURDATE();
select CURTIME();

select DATEDIFF('2021-07-09 00:00:00', '1991-07-29 14:00:00');
select TIMEDIFF('1991-07-29 14:00:00', '1991-07-29 00:00:00'); 

select DATE_ADD('2023-04-14', INTERVAL 10 day);
select DATE_SUB('2023-04-14', INTERVAL 5 day); 


-- 오늘부터 한달전 데이터 가져오기
select *
	from classicmodels.orders o 
	where orderDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
	
-- 20년 이내에 주문한 사람들의 이름을 unique 하게 가져오세요
select distinct customerName
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		where o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 20 YEAR); 

-- 마지막 주문일
select max(orderDate)
	from classicmodels.orders o ;

-- 마지막 주문일로부터 6개월년 이내에 주문한 사람들의 이름을 가져오세요
select DISTINCT customerName 
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
	where o.orderDate >= DATE_SUB((select max(orderDate) 
		  from classicmodels.orders o), INTERVAL 6 month );

 select 
 	YEAR('2023-04-14') as year,
 	MONTH('2023-04-14') as month,
 	WEEKOFYEAR('2023-04-14') as week_of_year;

-- 최근 한달간 구매내역이 있는 유저를 출력
 select distinct customerName
 	from classicmodels.customers c 
 		join classicmodels.orders o on c.customerNumber = o.customerNumber 
	where o.orderDate >= DATE_SUB((select max(orderDate) from classicmodels.orders o), INTERVAL 1 MONTH); 
 

-- Group by

-- 유저별로 주문액의 총합을 가져오자
select customerName, sum(amount)
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber 
		group by customerName; 
		
-- 위의 결과에서 20년이내 결과만출력
select customerName, sum(amount)
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		where o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 20 YEAR) 
		group by customerName ;

-- 위의 결과에서 높은 이름순으로 출력
select customerName, sum(amount)
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		where o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 20 YEAR) 
		group by customerName 
		order by sum(amount) DESC;
	
-- 상품카테고리별로 금액이 가장높은 금액을 가져오세요
select productLine, max(buyPrice) as maxprice
	from classicmodels.products p 
	group by productLine
	order by maxprice DESC ;

-- 위 결과에서 상품명도 함께 출력 (error)
SELECT A.*, p.productName
	from(
	select productLine, max(buyPrice) as m
		from classicmodels.products p
		group by productLine
		order by m desc) A join products p on A.productLine = p.productLine and A.m = p.buyPrice ;

	
-- 다른방법 
select productLine, buyPrice, productName
	from classicmodels.products p 
	where (productLine, buyPrice) in (select productLine, max(buyPrice) from classicmodels.products p group by productLine);

-- 국가별 상품카테고리별, 주문액의 합
select c.country, p2.productLine, sum(p.amount)
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p2 on o2.productCode = p2.productCode 
	group by c.country, p2.productLine ;

-- 위의 결과에서 office code가 1,2 인 employ에 의해서 발생된결과들로 정렬
select c.country, p2.productLine, sum(p.amount), e.officeCode 
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p2 on o2.productCode = p2.productCode
		join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber 
	where e.officeCode in (1, 2)
	group by c.country, p2.productLine ;

-- 제품별로 구매된 횟수 카운트 하기
select p.productName, count(o.orderNumber)
	from classicmodels.customers c  
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode
	group by p.productName ;
	
-- 유저별로 구매한 주문수 구하기
select c.customerName, count(*)
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
	group by c.customerName ;
		
-- 유저별로 구매한 고유한 상품개수 
select c.customerName, count(distinct o2.productCode)
	from classicmodels.customers c  
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
	group by c.customerName ;


-- pb) 상품별 재구매수와 비율을 구하기 위한 여정
-- sub_pb1) 유저별 상품별 구매수 카운트 하기
select c.customerName, p.productName, count(*)  
	from classicmodels.customers c  
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode
	group by c.customerName, p.productName ;

-- sub_pb2) 위 결과에서 2이상인것만 남기기
select c.customerName, p.productName, count(*) as cnt
	from classicmodels.customers c  
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode
	group by c.customerName, p.productName
	HAVING cnt >= 2;
	
-- sub_pb3) 다시 상품별로 유저수 카운트하기 → 상품별 재구매수
select A.productName, count(A.cnt) as a
	from
		(select c.customerName, p.productName, count(*) as cnt
			from classicmodels.customers c  
				join classicmodels.orders o on c.customerNumber = o.customerNumber 
				join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
				join classicmodels.products p on o2.productCode = p.productCode
			group by c.customerName, p.productName
			HAVING cnt >= 2) A
	group by A.productName 
	order by a DESC ;

-- sub_pb4) 상품별 유저별 구매수를 이용해서 상품별 재구매율 구하기
select A.productName, purchase_2, purchase_1, purchase_2/purchase_1 as repurchase_rate
from (select A.productName, count(A.customerName) as purchase_2
from (select c.customerName, p.productName, count(*) as cnt
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
	group by c.customerName, p.productName 
	having cnt >= 2) A group by A.productName) A right join (select p.productName, count(distinct c.customerName) as purchase_1
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
	group by p.productName ) B on A.productName = B.productName ;

