-- Order by 절

-- 상품 자료 중에서 가장 비싼 순으로 상품 100개를 상품이름, 가격으로 출력
SELECT productName, buyPrice 
	from classicmodels.products p 
	order by buyPrice DESC
	limit 100;

-- 주문자료 중에서 주문일자는 내림차순, 배송일자는 오름차순으로 정렬하여 커멘트가 있는 것 100개 출력
-- (최근 주문 중에 배송완료 먼저 된 것부터 출력)
SELECT *
	FROM classicmodels.orders o
	WHERE comments is not NULL 
	order by orderDate DESC, shippedDate ASC
	limit 100;


-- single row functions

-- now() : 오늘 날짜 출력
SELECT now(), buyPrice
	from classicmodels.products p ;

-- upper() : 대문자 변환 / lower()
SELECT upper(customerName)
	from classicmodels.customers c ;


-- Aggregate Functions(multiple-row functions)

-- Count
-- 상품자료 중 가격이 있는 것 개수
SELECT count(buyPrice)
	from classicmodels.products p ;

-- 주문자료 중 커멘트가 있는 것 개수
SELECT count(comments)
	from classicmodels.orders o ;

-- 주문자료 개수
SELECT count(*)
	from classicmodels.orders o ;

-- Sum
-- 상품자료의 재고수량 합계
SELECT sum(quantityinstock)
	from classicmodels.products p ;

-- Max / Min, AVG
-- 상품자료의 최대가격
SELECT max(buyprice)
	from classicmodels.products p ;


-- Distinct(multi to multi row function) : 고유한 값만 return

-- 배송상태의 고유값 출력
SELECT DISTINCT status
	from classicmodels.orders o ;

-- 2003년 주문에서 고객번호 출력(중복제거)
SELECT distinct customerNumber
	from classicmodels.orders o 
	WHERE orderDate >= "2003-01-01" and orderDate < "2004-01-01" ;

-- 위 결과를 count
SELECT count(distinct customerNumber)
	from classicmodels.orders o 
	WHERE orderDate >= "2003-01-01" and orderDate < "2004-01-01" ;


-- Case When
-- 상품자료에서, '등급'이라는 칼럼으로
-- 가격이 10이하인 것은 '저렴이', 10 초과 50이하인 것은 '중간이', 그 초과인 것들은 '고급이'
-- 상품코드를 '상품id'로 해서 출력
SELECT 
	productCode AS '상품id',
	CASE when buyPrice <= 10 then '저렴이'
	     when buyPrice <= 50 then '중간이'
	ELSE '고급이' END AS 등급
	from classicmodels.products p ;


-- JOIN (Inner join, Full join, Left join, Right join)

-- Inner join : table의 어느 칼럼을 기준으로 모든 컬럼을 합치되, 두 테이블에 모두 있는 행의 자료만 합침

-- 주문일자 2003년을 기준으로, 소비자 이름/주문일자를 100개 가져오기
SELECT customerName, orderdate 
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01"
	limit 100;

-- 주문일자 2003년 기준, 소비자 이름/주문일자/상품명 100개 출력
SELECT customerName, orderdate, productname 
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01"
	limit 100;

-- 주문일자 2003년 기준, 소비자 이름/주문일자/상품명 100개 출력(주문일자 내림차순)
SELECT customerName, orderdate, productname 
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01"
	ORDER by orderDate DESC 
	limit 100;

-- 주문일자 2003년 기준, 소비자 이름(미국 소비자 기준)/주문일자/상품명 100개 출력(주문일자 내림차순)
SELECT customerName, orderdate, productname, country  
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01" and c.country ='USA'
	ORDER by orderDate DESC 
	limit 100;

-- 주문일자 2003년 기준, 상품가격이 50이상인 것으로, 소비자 이름(미국 소비자 기준)/주문일자/상품명 100개 출력(주문일자 내림차순)
SELECT customerName, orderdate, productname, country, buyprice  
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01" and c.country ='USA' and p.buyPrice >= 50
	ORDER by orderDate DESC 
	limit 100;
	
-- 소비자 이름, 주문일자를 unique하게 출력
SELECT DISTINCT customerName, orderdate
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	ORDER by orderDate DESC 
	limit 100;

-- 소비자가 주문한 상품명 출력하되, 주문이 없는 소비자도 출력
SELECT customerName, productName
	FROM classicmodels.orders o 
		right join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode ;


-- left or right join을 쓴 것과 쓰지 않은 것 출력 개수 비교
-- 쓰지 않은 것
select count(*)
from(
	SELECT customerName, productName
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode) sub;
-- right join
select count(*)
	from(
		SELECT customerName, productName
		FROM classicmodels.orders o 
			right join classicmodels.customers c on o.customerNumber = c.customerNumber
			join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
			join classicmodels.products p  on o2.productCode  = p.productCode) sub;
-- left join
select count(*)
	from (
		SELECT customerName, p.productName 
		FROM 
			classicmodels.customers c 
			left join classicmodels.orders o on o.customerNumber = c.customerNumber				
			join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
			join classicmodels.products p  on o2.productCode  = p.productCode) sub;

-- 1, 2번 office에 속한 종업원의 담당 소비자 이름 개수 출력
SELECT count(*)
	from (
		select customerName
		from
			classicmodels.customers c 
			join employees e on c.salesRepEmployeeNumber = e.employeeNumber
			join offices o on e.officeCode = o.officeCode
		where o.officeCode in (1, 2)) sub;
