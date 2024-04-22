
-- 재구매
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


--  재구매율, with절로 임시테이블 생성 t1	
with t1 as (select c.customerName, p.productName, count(*) as cnt
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
	group by c.customerName, p.productName)
select A.productName, A.a/B.b as '재구매율', B.b as '구매 유저수'
	from (select productName, count(*) as a from t1 where cnt >= 2 group by productName) as A 
			 right join (select productName, count(*) as b from t1 group by productName) as B on A.productName = B.productName ;
													
												
-- t1										
select c.customerName, p.productName, count(*) as cnt
			from classicmodels.customers c 
				join classicmodels.orders o on c.customerNumber = o.customerNumber 
				join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
				join classicmodels.products p on o2.productCode = p.productCode
			group by c.customerName, p.productName ;
		

-- 아래 2개의 쿼리 결과값은 같다
select productName, count(*)
	from (select c.customerName, p.productName, count(*) as cnt
			from classicmodels.customers c 
				join classicmodels.orders o on c.customerNumber = o.customerNumber 
				join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
				join classicmodels.products p on o2.productCode = p.productCode
			group by c.customerName, p.productName) as B
		group by B.productName ;
	
select p.productName, count(distinct c.customerName) as purchase_1
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
	group by p.productName ;
-- ----------------------------------------------------------------------------------


-- with절을 이용해서 오피스별 상품별 재구매 유저수 구하기(오피스별로 어떤 상품을 재구매한 유저수의 합)	
with t1 as (select e.officeCode, p.productName, c.customerName, count(*) as cnt
				from classicmodels.customers c 
					join classicmodels.orders o on c.customerNumber = o.customerNumber 
					join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
					join classicmodels.products p on o2.productCode = p.productCode
					join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber
				group by e.officeCode, p.productName, c.customerName)
select officeCode, count(*)
	from t1 where cnt >= 2 group by officeCode ;

-- pb) 유저별로 주문완료 (취소는 카운트 x)한 횟수를 구하여라
select c.customerName, count(*)
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
	where o.status <> 'Cancelled'
	group by c.customerName ;

-- pb_sub) 위의 문제에서 중복되는 상품을 제외하고 카운트 하여라
select c.customerName, count(distinct p.productName)
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
	where o.status <> 'Cancelled'
	group by c.customerName ;

-- pb) 국가별 도시별 상품 취소횟수 구하기
select c.country, c.city, count(p.productName) as 'Cancelled_cnt'
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
		join classicmodels.products p on o2.productCode = p.productCode 
	where o.status = 'Cancelled'
	group by c.country, c.city ;


	
