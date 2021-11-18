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
'Chesterfield'), (22, 'Chesterfield', 'Saint Louis'), (93, 'Chesterfield', 'Chesterfield'), (17, 'Fenton','Fenton');
select * from addresscity;

select * from employees;
select * from iras;
select * from addresscity;
show tables;

select LName, Salary, IRA_acct, Balance # including those who may no longer have salaries
from employees left join iras on employees.IDN = iras.IDN;

select LName, Salary, IRA_acct, Balance
from employees join iras on employees.IDN = iras.IDN where Salary is not NULL;

select LName, Salary, IRA_acct, Balance
from employees, iras where employees.IDN = iras.IDN and salary is not NULL;

select LName, Salary, IRA_acct, Balance from employees, iras;

select LName, Salary from employees union select IRA_acct, Balance from iras;

select LName, Salary, IRA_acct, Balance from employees, iras
where Salary >= 1000 and Salary <= 2000 and employees.IDN = iras.IDN;

select LName, Salary, IRA_acct, Balance from employees, iras
where (Balance between 150 and 450) and employees.IDN = iras.IDN;

select Lname, Homecity, Salary-Deduction as netpay, 100*(Deduction/Salary) as
SavingPercent from employees, addresscity where (employees.IDN = addresscity.IDN) and
Salary is not null order by Lname desc;
# may use order by lname; may omit order by lname desc

select count(Salary) as NumofPaidWorkers from Employees; # null = 0

select distinct Homecity, count(Salary) as NumofPaidEmployees from Employees,
Addresscity where employees.idn = addresscity.idn group by Homecity;

select sum(Balance) as TotalIraBalance from iras;

select distinct Homecity, sum(Balance) as TotalIraBalance from iras, addresscity
where addresscity.IDN = iras.IDN group by Homecity; /* distinct is optional */

select LName, Sum(Balance) as Total_Balance, count(ira_acct) as NumofAccts from
employees, iras where employees.idn = iras.idn group by LName, iras.idn;

select LName, Sum(Balance) as Total_Balance, count(ira_acct) as NumofAccts from
employees, iras where employees.idn = iras.idn group by LName, iras.idn having
NumofAccts > 1;

select LName, Sum(Balance) as Total_Balance, count(ira_acct) as NumofAccts from
employees, iras where employees.idn = iras.idn group by LName, iras.idn having
Total_Balance >= 150;

select Homecity, 100*(sum(Deduction)/sum(Salary) ) as SavingRate from employees,
addresscity where addresscity.IDN = employees.IDN group by Homecity; 

select homecity, sum(salary) as TotalSalary from employees, addresscity
where addresscity.IDN = employees.IDN group by homecity;

select Lname, Sum(balance) as Total_Balance, count(IRA_Acct) as Num_of_Accts,
homecity from employees e, iras i, addresscity a
where e.idn = i.idn and i.idn = a.idn group by LName, e.IDN; 

select homecity, sum(salary) as TotalSalary, count(Salary) as NumofPaidEmployees
from employees e, addresscity a where e.IDN = a.IDN group by homecity; 

select homecity, sum(salary) as TotalSalary, count(Salary) as NumofPaidEmployees
from employees e, addresscity a
where e.IDN = a.IDN and salary is not null group by homecity; 



#Example C4 Beofre
select LName, Sum(balance) as TotalBalance, count(IRA_Acct) as TotalAccts
from Employees e left join IRAs i on e.IDN = i.IDN group by LName, i.IDN having
TotalAccts >= 1;
#Example C4 After
select LName, balance, Sum(salary) as TotalSalary, count(IRA_Acct) as TotalAccts
from Employees e right join IRAs i on e.IDN = i.IDN group by i.IDN with rollup;



select IDN, Sum(balance) as TotalBalance from iras group by IDN;

select LName, TotalBalance from employees e,
(select IDN, Sum(balance) as TotalBalance from iras group by IDN) t
Where e.idn = t.idn;

select lname, salary, balance, homecity
from employees,iras,addresscity 
where salary >= 2000 and employees.idn = iras.idn and iras.idn = addresscity.idn;

select sum(deduction) as totaldeduction, companycity
from employees e,addresscity a
where e.idn = a.idn and deduction is not null group by companycity;

select lname, deduction, balance
from employees e, iras i
where e.idn = i.idn and balance >= 300 group by e.idn;

select lname, salary, balance, homecity
from employees e, iras i, addresscity a
where e.idn = i.idn and i.idn = a.idn and salary >= 2000 group by e.idn;

select lname, salary, balance, homecity
from employees e, iras i, addresscity a
where e.idn = a.idn and (balance between 100 and 400) and salary < 3000 group by e.idn;

select lname, deduction, sum(balance) as totalbalance
from employees e, iras i
where e.idn = i.idn group by e.idn;

#Insert/delete/update table examples
select LName, e.IDN, Salary, homecity
from employees e, AddressCity a where e.IDN = a.IDN and salary < 3000;

Create table TempTable1 select LName, e.IDN, Salary, homecity 
from employees e, AddressCity a where e.IDN = a.IDN and salary < 3000;
select * from TempTable1;

insert into TempTable1 values ('Smith', 51, 3000, 'Fenton'); # Insert 1 row into a table
select * from TempTable1;

insert into TempTable1 values ('Smith1', 52, 3000, 'Fenton1'), ('Smith2', 53, 3500,
'Fenton2'), ('Smith3', 54, 3800, 'Fenton3'); # Insert 3 rows into a table
select * from TempTable1;

insert into TempTable1 (LName, Salary) values ('Adam', 7000);
/* partial row with right column order */
select * from TempTable1;

insert into TempTable1 (LName, Salary) values ('Adam1', 7000), ('Adam2', 7700),
('Adam3', 7900); /* partial rows with right column order */
select * from TempTable1;

insert into TempTable1 (Salary, LName) values (9000, 'Abe'); /* partial row with mixed
column order */
select * from TempTable1;

#Insery existing data into different tables
select IDN, LName, Deduction from employees where salary < 2500;
create table TempTable2
select IDN, LName, Deduction from employees where salary < 2500;
select * from TempTable2; 

SELECT * FROM IRAs WHERE balance >= 400; /* the subquery of the example */

INSERT INTO TempTable2 SELECT * FROM IRAs WHERE balance >= 400;
select * from TempTable2; # More subquery examples are covered in session4

INSERT INTO TempTable1 (LName, Salary, homecity) select LName, Salary, homecity
from employees e, AddressCity a where e.IDN = a.IDN and Salary < 3000;
select * from TempTable1; # check each Result Grid

#Updating tables
update TempTable1 set salary = salary*(1.2) where salary < 3000 and salary is not null;
# “salary is not null” is optional
select * from TempTable1; # salaries below 3000 has been increased 20%
update TempTable1 set salary = salary+70 where salary is not null;
/* the above query is the same as the following query*/
select * from TempTable1;

#Deleting from tables
delete from TempTable1 where homecity is null;
select * from TempTable1;

delete from TempTable1 where salary between 2000 and 3500;
select * from TempTable1;

select IDN from IRAs; /* the subquery of the solution statement of this example */


#example c4 before
delete from TempTable2 where IDN not in (select IDN from IRAs);
select * from TempTable2;
#example c4 after
delete from TempTable2 where IDN in (select IDN from IRAs);
select * from TempTable2;



delete from TempTable1; # delete all rows
select * from TempTable1;

select count(IDN) as NumofEmployees from employees where salary is not null; 
select homecity, count(IDN) as NumofEmployees from addresscity group by homecity; 

select homecity, count(a.IDN) as NumofEmployees from employees e, addresscity a
where e.idn = a.idn and salary is not null group by homecity;

Create table TEmployees select * from employees;
select * from TEmployees;