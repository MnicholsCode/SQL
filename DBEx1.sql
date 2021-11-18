show databases;
drop database if exists DBEx1;  # This statement drops/deletes the database named DBEx1
create database DBEx1; # This statement creates the database named DBEx1
use DBEx1; -- Use the database DBEx1 we just created
show tables; # This statement shows the list of tables in the database DBEx1

select 'This is a query statement';
select 'This is a query statement' as Example1;
select 2+5;
select 2+5 as AdditionExample; #The as keyword is used to make a label for the entry

drop table if exists employees;
create table Employees(LName varchar(20), IDN int, Salary decimal(20, 2), Deduction decimal(20,2));
#create the emplyees table
insert into Employees values ('Peter', 1, 1000, 10), ('Mary', 12, 2000, 0), ('Tony', 22, 4000, 32);
#Insert three rows into the employees table
select * from Employees;

drop table if exists IRAs;
create table IRAs(IDN int, IRA_acct varchar(12), Balance decimal(20,2)); #Create IRAs table
describe iras;
insert into IRAs values (1,'A1',100), (12,'A2',200), (22,'A3',400), (93,'A4',500);
select * from IRAs;

drop table if exists addresscity;
create table AddressCity(IDN int, CompanyCity varchar(22), HomeCity varchar(22));
insert into addresscity values (1,'Saint Louis', 'Saint Louis'), (12,'Saint Louis','Chesterfield'),
(22,'Chesterfield','Saint Louis'), (93,'Chesterfield','Chesterfield');
select * from addresscity;

select lname, idn, salary, deduction, salary - deduction as netpay from employees;

create table NetPayTable select lname, idn, salary, deduction, 
salary - deduction as netpay from employees;
#Create a table called NetPayTable containing the query result of Example1

show tables; # Now we have the table NetPayTable in the database
select * from NetPayTable;  # Find all information from the table NetPayTable
describe netpaytable;

select * from NetPayTable order by lname; #By default ORDER BY sorts the data in ascending order
select * from NetPayTable order by lname desc; # desc is in descending order
select count(IRA_Acct) as NumofAccts from iras;	# the number of accounts in IRAs
select count(distinct homecity) as NumofDistinctHomeCities from AddressCity; #Distinct HomeCities
select * from NetPayTable order by salary desc; #desc is in descending order
select count(distinct idn) as NumofIDNs from iras;
select avg(salary) as AverageSalary from Employees;

select * from employees;
insert into Employees values ('Mike', 17, 4000, 10);
select * from employees;  # the new row has been added to the table Employees

select * from AddressCity;
insert into addresscity values (17, 'Fenton', 'Fenton');
select * from AddressCity;  # the new row has been added to the table Employees

Select * from employees where salary <= 3000;
Select * from iras where balance < 500 and balance >= 200;
select max(salary) as HighestSalary from employees; # the highest Salary
select min(salary) as LowestSalary from employees; # the lowest Salary

select count(salary) as NumofSalaryEarners from employees where Salary is not NULL;
select count(LName) as NumofSalaryEarners from employees where Salary is not NULL;
select count(*) as NumofSalaryEarners from employees where Salary is not NULL;

select sum(salary) as TotalSalary from employees; # the SUM of all salaries
select avg(Balance) as AVGBalance from IRAs; # the average balance
select Min(Balance) as Min_Balance,
Max(Balance) as Max_Balance, avg(Balance) as AverageBalance from iras;

select * from employees where LName like '%T_%';
select * from employees where LName not like '%T_%';


#Example 11 Before
Select * from iras where balance < 500 and balance >= 200;
#Example 11 After
select * from iras where balance > 300 and balance <= 600;

