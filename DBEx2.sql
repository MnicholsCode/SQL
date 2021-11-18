show databases;
drop database if exists DBEx1;
create database DBEx1; # Create the database named DBEx1
show databases;
use DBEx1; -- Use the database DBEx1 we just created
show tables;

drop table if exists employees;
create table Employees(LName varchar(20), IDN int, Salary decimal(20, 2),
Deduction decimal(20, 2));

describe employees;
insert into Employees values ('Peter', 1, 1000, 10), ('Mary', 12, 2000, 0),
('Tony', 22, 4000, 32), ('Mike', 17, 4000, 10), ('John', 93, null, null);

select * from employees;

drop table if exists IRAs;
create table IRAs(IDN int, IRA_acct varchar(12), Balance decimal(20, 2));
describe iras;

insert into IRAs values(1, 'A1', 100), (22, 'A2', 200), (22, 'A3', 400), (93, 'A4', 500);

select * from iras;

drop table if exists addresscity;
create table AddressCity(IDN int, CompanyCity varchar(22), HomeCity varchar(22) );

describe addresscity;
insert into addresscity values (1, 'Saint Louis', 'Saint Louis'), (12, 'Saint Louis',
'Chesterfield'),
(22, 'Chesterfield', 'Saint Louis'), (93, 'Chesterfield', 'Chesterfield'), (17, 'Fenton',
'Fenton');

select * from addresscity;

select LName, Sum(balance) as TotalBalance, count(IRA_Acct) as NumAccts from
employees e, iras i where e.IDN = i.IDN group by LName, i.idn;

#Example A1 before
select LName, Sum(balance) as TotalBalance,  count(IRA_Acct) as NumAccts from employees e, iras i where e.IDN = i.IDN group by LName,  e.IDN;
#Example A1 After
SELECT LName, SUM(balance) AS TotalBalance, COUNT(IRA_Acct) AS NumAccts
FROM employees e
INNER JOIN iras i
ON e.IDN = i.IDN
GROUP BY LName, e.IDN;

SELECT homecity,SUM(balance) as TotalBalance, MAX(balance) as MaxBalance
FROM iras i, addresscity a
WHERE i.IDN = a.IDN
GROUP BY homecity;

SELECT LName, SUM(balance) AS TotalBalance
FROM employees e, iras i
WHERE e.IDN = i.IDN AND balance > (SELECT AVG(balance) FROM iras)
GROUP BY LName, e.IDN;

SELECT LName, SUM(balance) AS TotalBalance
FROM employees e, iras i
WHERE e.IDN = i.IDN AND balance >= (SELECT MAX(balance) FROM iras);

-- SELECT LName, TotalBalance
-- FROM (SELECT sum(balance) AS TotalBalance FROM iras) AS t1, employees e
-- WHERE e.IDN = t1.IDN
-- AND TotalBalance >= (SELECT MAX(TotalBalance2) FROM SELECT sum(balance) AS TotalBalance2 FROM iras)t2);


select LName, TotalB
from
(select idn, sum(balance) as TotalB
from IRAs group by idn) as t1,
employees e
where e.idn = t1.idn and TotalB >=
(select max(TotalB2)
from (select sum(balance) as TotalB2 from IRAs group by idn) t2);

SELECT *
FROM employees
WHERE salary >= (SELECT avg(salary) FROM employees);  

SELECT *
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

SELECT COUNT(e.IDN), homecity
FROM employees e, addresscity a
WHERE e.IDN = a.IDN
group by homecity;

SELECT homecity,IDN
FROM addresscity, MAX((SELECT COUNT(e.IDN), homecity FROM employees e, addresscity a WHERE e.IDN = a.IDN group by homecity)) as t1
WHERE  a.homecity = t1.homecity
GROUP BY homecity;

SELECT sum(balance) as sumB, e.IDN
FROM employees e, iras i
WHERE e.IDN = i.IDN balance = (SELECT ;

select LName, TotalB, NumAccts
from
(select idn, sum(balance) as TotalB, count(IRA_acct) as NumAccts
from IRAs group by idn) as t1,
employees e
where e.idn = t1.idn and TotalB <=
(select min(TotalB2)
from (select sum(balance) as TotalB2 from IRAs group by idn) t2);

select idn, balance

from iras

where balance <= all (select min(balance) from iras);