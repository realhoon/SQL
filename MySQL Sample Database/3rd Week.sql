select sum(USA)
	from(
	select amount as USA
	from classicmodels.customers c 
		join payments p on c.customerNumber = p.customerNumber 
	where p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country ='USA')sub;

select sum(Germany)
	from(
	select amount as Germany
	from classicmodels.customers c 
		join payments p on c.customerNumber = p.customerNumber 
	where p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country ='Germany')sub;

select
(select sum(USA)
	from(
	select amount as USA
	from classicmodels.customers c 
		join payments p on c.customerNumber = p.customerNumber 
	where p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country ='USA')sub)
- (select sum(Germany)
	from(
	select amount as Germany
	from classicmodels.customers c 
		join payments p on c.customerNumber = p.customerNumber 
	where p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country ='Germany')sub) sub;


select sum(USA)
	from(
	select amount as USA
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber 
	where p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country ='USA')sub;

select *
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber
		join classicmodels.orders o on c.customerNumber = o.customerNumber ;

select (
select sum(USA)
	from(
	select amount USA
		from classicmodels.customers c 
			join classicmodels.payments p on c.customerNumber = p.customerNumber
			join classicmodels.orders o on c.customerNumber = o.customerNumber
		where o.status = 'Cancelled' and p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country = 'USA')sub)
-
(select sum(Germany)
	from(
select amount as Germany
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber
		join classicmodels.orders o on c.customerNumber = o.customerNumber
	where o.status = 'Cancelled' and p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country = 'Germany')sub) sub;

select if (sum(GermanySum) is null, 0, 1)
from(
select sum(Germany) as GermanySum
	from(
select amount as Germany
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber
		join classicmodels.orders o on c.customerNumber = o.customerNumber
	where o.status = 'Cancelled' and p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country = 'Germany')sub)sub;
	

select (
select sum(USA)
	from(
	select amount as USA
		from classicmodels.customers c 
			join classicmodels.payments p on c.customerNumber = p.customerNumber
			join classicmodels.orders o on c.customerNumber = o.customerNumber
		where o.status = 'Cancelled' and p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country = 'USA')sub)
-
(select if (sum(GermanySum) = 'NULL', 1, 0)
from(
select sum(Germany) as GermanySum
	from(
select amount as Germany
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber
		join classicmodels.orders o on c.customerNumber = o.customerNumber
	where o.status = 'Cancelled' and p.paymentDate >= '2003-01-01' and p.paymentDate <'2004-01-01' and c.country = 'Germany')sub)sub) sub;
	

select productName, orderDate, amount
	from classicmodels.customers c 
		join classicmodels.orders o on c.customerNumber = o.customerNumber 
		join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber
		join classicmodels.payments p on c.customerNumber = p.customerNumber
		join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber
		join classicmodels.products p2 on o2.productCode = p2.productCode
	where p.amount >= 70 and o.orderDate > '2003-01-01' and o.orderDate < '2004-01-01' and e.officeCode in (1, 2, 3)
	order by o.orderDate ASC ;


select customerName, phone, addressLine1, amount
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber
	order by p.amount DESC
	limit 100;

select distinct concat(firstName, ' ', lastName), jobTitle, email, o.country as '종업원소속', c.country as '고객소속'
	from classicmodels.customers c 
		join classicmodels.payments p on c.customerNumber = p.customerNumber 
		join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber
		join classicmodels.offices o on e.officeCode = o.officeCode
	order by p.amount DESC ;

select distinct productName, p.productLine, textDescription
	from classicmodels.products p 
		join classicmodels.productlines p2 on p.productLine = p2.productLine 
		join classicmodels.orderdetails o on p.productCode = o.productCode
		join classicmodels.orders o2 on o.orderNumber = o2.orderNumber
	where o2.orderDate >= '2003-01-01' and o2.orderDate < '2004-01-01'
	order by quantityOrdered DESC
	limit 5;

SELECT customerName, orderdate, productname 
	FROM classicmodels.orders o 
	join classicmodels.customers c on o.customerNumber = c.customerNumber
	join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
	join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01"
	limit 100;
	

SELECT distinct customerName 
	from classicmodels.customers c 
	join classicmodels.orders o on c.customerNumber = o.customerNumber 
	WHERE o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 20 YEAR);

select max(orderDate)
	from classicmodels.orders o ;

SELECT distinct customerName 
	from classicmodels.customers c 
	join classicmodels.orders o on c.customerNumber = o.customerNumber 
	WHERE o.orderDate >= DATE_SUB((select max(orderDate)
	from classicmodels.orders o), INTERVAL 6 MONTH);
	
SELECT customerName, sum(amount)
	from classicmodels.customers c 
	join classicmodels.payments p on c.customerNumber = p.customerNumber
	group by customerName ;
	
SELECT customerName, sum(amount)
	from classicmodels.customers c 
	join classicmodels.payments p on c.customerNumber = p.customerNumber 
	where p.paymentDate >= DATE_SUB(CURDATE(), INTERVAL 20 YEAR) 
	group by customerName ;
	
SELECT customerName, sum(amount)
	from classicmodels.customers c 
	join classicmodels.payments p on c.customerNumber = p.customerNumber 
	where p.paymentDate >= DATE_SUB(CURDATE(), INTERVAL 20 YEAR) 
	group by customerName
	ORDER by sum(amount) DESC ;

SELECT productLine, max(buyPrice) as m
	from classicmodels.products p 
	group by productLine 
	ORDER by m DESC  ;
	
SELECT productName, productLine
	from classicmodels.products p 
	group by productLine  ;

SELECT productLine, max(buyPrice) as maxprice
	from classicmodels.products p 
	group by productLine 
	ORDER by maxprice DESC ;
	
select A.*, p.productName
from 
(SELECT productLine, max(buyPrice) as m
	from classicmodels.products p 
	group by productLine 
	ORDER by m desc) A join products p on A.productLine = p.productLine and A.m = p.buyPrice;
	
select c.country, p.productLine, sum(amount) 
	from classicmodels.customers c 
	join classicmodels.orders o on c.customerNumber = o.customerNumber 
	join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
	join classicmodels.products p on o2.productCode = p.productCode
	join classicmodels.payments p2 on c.customerNumber = p2.customerNumber 
	GROUP by c.country, p.productLine ;
	
select c.country, p.productLine, sum(amount), e.officeCode 
	from classicmodels.customers c 
	join classicmodels.orders o on c.customerNumber = o.customerNumber 
	join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
	join classicmodels.products p on o2.productCode = p.productCode
	join classicmodels.payments p2 on c.customerNumber = p2.customerNumber 
	join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber
	where e.officeCode in (1, 2)
	GROUP by c.country, p.productLine ;
	
select p.productName, count(o.orderNumber)
	from classicmodels.customers c 
	join classicmodels.orders o on c.customerNumber = o.customerNumber 
	join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
	join classicmodels.products p on o2.productCode = p.productCode
	join classicmodels.payments p2 on c.customerNumber = p2.customerNumber 
	GROUP by p.productName;
	
SELECT c.customerName, count(*)
	from classicmodels.customers c 
	join classicmodels.orders o on c.customerNumber = o.customerNumber 
	join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
	GROUP by customerName ;
	
SELECT c.customerName, count(DISTINCT o2.productCode)
	from classicmodels.customers c 
	join classicmodels.orders o on c.customerNumber = o.customerNumber 
	join classicmodels.orderdetails o2 on o.orderNumber = o2.orderNumber 
	GROUP by customerName ;
