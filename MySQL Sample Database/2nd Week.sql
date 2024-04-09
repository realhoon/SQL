# 2024-04-05
	
SELECT productName, buyPrice 
	from classicmodels.products p 
	order by buyPrice DESC
	limit 100;
	
SELECT *
	FROM classicmodels.orders o
	WHERE comments is not NULL 
	order by orderDate DESC, shippedDate ASC
	limit 100;
	
SELECT now(), buyPrice
	from classicmodels.products p ;

SELECT upper(customerName)
	from classicmodels.customers c ;

SELECT count(buyPrice)
	from classicmodels.products p ;

SELECT count(comments)
	from classicmodels.orders o ;

SELECT count(*)
	from classicmodels.orders o ;

SELECT sum(quantityinstock)
	from classicmodels.products p ;

SELECT max(buyprice)
	from classicmodels.products p ;

SELECT DISTINCT status
	from classicmodels.orders o ;
	
SELECT distinct customerNumber
	from classicmodels.orders o 
	WHERE orderDate >= "2003-01-01" and orderDate < "2004-01-01" ;
	
SELECT count(distinct customerNumber)
	from classicmodels.orders o 
	WHERE orderDate >= "2003-01-01" and orderDate < "2004-01-01" ;
	
SELECT 
	productCode AS '상품id',
	CASE when buyPrice <= 10 then '저렴이'
		 when buyPrice <= 50 then '중간이'
	ELSE '고급이' END AS 등급
	from classicmodels.products p ;

SELECT customerName, orderdate 
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01"
	limit 100;

SELECT customerName, orderdate, productname 
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01"
	limit 100;

SELECT customerName, orderdate, productname 
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01"
	ORDER by orderDate DESC 
	limit 100;
	
SELECT customerName, orderdate, productname, country  
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01" and c.country ='USA'
	ORDER by orderDate DESC 
	limit 100;
	
SELECT customerName, orderdate, productname, country, buyprice  
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	WHERE o.orderDate >= "2003-01-01" and o.orderDate < "2004-01-01" and c.country ='USA' and p.buyPrice >= 50
	ORDER by orderDate DESC 
	limit 100;
	

SELECT DISTINCT customerName, orderdate
	FROM classicmodels.orders o 
		join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode 
	ORDER by orderDate DESC 
	limit 100;
	
SELECT customerName, productName
	FROM classicmodels.orders o 
		right join classicmodels.customers c on o.customerNumber = c.customerNumber
		join classicmodels.orderdetails o2  on o.orderNumber  = o2.orderNumber 
		join classicmodels.products p  on o2.productCode  = p.productCode ;
	

SELECT count(*)
	from (
		select customerName
		from
			classicmodels.customers c 
			join employees e on c.salesRepEmployeeNumber = e.employeeNumber
			join offices o on e.officeCode = o.officeCode
		where o.officeCode in (1, 2)) sub;
