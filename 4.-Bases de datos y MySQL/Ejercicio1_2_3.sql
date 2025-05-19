/* EJERCICIOS

Nivel 1:*/


-- Tabla con los codigos de oficina y su número de teléfono
select officeCode, phone
from offices;

-- Busca los empleados con email .es

select *, email, substring(email, -3) as es
from employees
-- where substring(email,-3)='.es'
where email like '%.es';

-- Customer sin state

select *
from customers
where state is null;

-- Selecciona los pagos superiores a 20.000
select  *
from payments
where amount>20000;

-- Selecciona los pagos superiores a 20.000 y del año 2005
select  *
from payments
where amount>20000 and year(paymentDate)=2005;
-- ... and paymentDate like '2005-%';
-- ... and paymentDate between '2005-01-01' and '2005-12-31' --> Es un intervalo cerrado

-- Selecciona de la tabla orderdetails las lineas únicas por productcode
select  distinct productcode
from orderdetails;

-- Muestra una tabla con la cuenta de compras por país
select * from orders;


select * from payments p, customers c
where p.customerNumber=c.customerNumber
group by country;

select c.country, count(*) as payment_count
from payments p
inner join customers c on p.customerNumber = c.customerNumber
group by c.country;

select c.country, count(*) as payment_count
from payments p inner join customers c on p.customerNumber = c.customerNumber
group by c.country
having payment_count > 10;



select  c.country, count(*) as country_count
from customers c
left join orders o on c.customerNumber=o.customerNumber
group by c.country
order by country_count desc;

/*Nivel 2:*/

-- PorductLine con la textDescription más larga
select *
from productlines 
order by textDescription desc limit 1;

-- Numero de customers por oficina

SELECT offices.officeCode, COUNT(customers.customerNumber) AS customer_count 
FROM offices 
RIGHT JOIN employees ON offices.officeCode = employees.officeCode
RIGHT JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
GROUP BY offices.officeCode;

select o.officeCode, count(*) as customer_per_office
from customers c 
left join employees e on c.salesRepEmployeeNumber=e.employeeNumber
left join offices o on e.officeCode=o.officeCode
group by o.officeCode


-- Que dia de la semana es en el que se han vendido más coches??
select dayname(orderDate) as week_day, count(p.productName) as count_order_day, productLine
from orders o left join orderdetails d on o.orderNumber=d.orderNumber
left join products p on d.productCode=p.productCode
where productLine like '%Cars'
group by dayname(orderDate), productLine
order by productLine, count_order_day desc;

-- Corrige los valores NA de la variable territory de la tabla offices por USA, usando case when
update offices
set territory='USA'
where territory='NA';

SELECT officeCode, city, IF(territory = 'NA', 'USA', territory) AS updated_territory
FROM offices;

-- Importe medio por carrito y total de items, por año-mes, realizados en los años 2004 y 2005, por clientes asistidos por los empleados de la familia Patterson.

-- SOLUCION 2 BELTRÁN, importemedio por añomes
Select concat(year(orderDate), lpad(month(orderDate),2,'0')) as anomes, sum(details.quantityOrdered) as numOrders,
round(avg(details.priceEach * details.quantityOrdered),2) as meanPriceOrder

	from classicmodels.orders as ord
    left join classicmodels.orderDetails as details
    on ord.orderNumber = details.orderNumber
    
    left join classicmodels.customers as cust
    on ord.customerNumber = cust.customerNumber
    
    left join classicmodels.employees as empl
    on cust.salesRepEmployeeNumber = empl.employeeNumber
    
	where (year(ord.orderDate) = 2004 or year(ord.orderDate) = 2005) and empl.lastName = 'Patterson'
    group by concat(year(orderDate), lpad(month(orderDate),2,'0'));

select od.orderNumber , od.quantityOrdered, od.priceEach , orderDate, lastName, avg(quantityOrdered*priceEach) as total_amount,
concat(year(orderDate), lpad(month(orderDate),2,'0')) as year_m
from orderdetails od
left join orders o on od.orderNumber=o.orderNumber
left join customers c on o.customerNumber=c.customerNumber
left join employees e on c.salesRepEmployeeNumber=e.employeeNumber
where lastName='Patterson' and year (orderDate) in (2004, 2005)
group by od.orderNumber;

with new_order as
(select od.orderNumber , od.quantityOrdered, od.priceEach , orderDate, lastName, avg(quantityOrdered*priceEach) as total_amount,
concat(year(orderDate), lpad(month(orderDate),2,'0')) as year_m
from orderdetails od
left join orders o on od.orderNumber=o.orderNumber
left join customers c on o.customerNumber=c.customerNumber
left join employees e on c.salesRepEmployeeNumber=e.employeeNumber
where lastName='Patterson' and year (orderDate) in (2004, 2005)
group by od.orderNumber)

select *, avg(total_amount) as avg_order
from new_order
group by year_m
order by year_m desc;
 
/*Nivel 3:
- Caclula usando subqueries: Importe medio por carrito y total de items, por año-mes, realizados en los años 2004 y 2005, 
	por clientes asistidos por los empleados de la familia Patterson.
- Quiero ir personalmente a las oficinas donde haya empleados con customers con el state vacío, para regañarles. Me puedes decir a qué oficinas tengo que ir?
*/
